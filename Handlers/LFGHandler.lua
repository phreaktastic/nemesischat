local _, core = ...
local LFGHandler = {}
core.LFGHandler = LFGHandler

-- Local references for performance
local C_LFGList = C_LFGList
local C_Timer = C_Timer
local floor = math.floor
local format = string.format
local tinsert = table.insert
local tremove = table.remove
local tContains = tContains
local bor, band = bit.bor, bit.band
local IsInGroup = IsInGroup
local GetRealmName = GetRealmName
local GetSpecializationInfoByID = GetSpecializationInfoByID
local PlaySound = PlaySound
local SendChatMessage = SendChatMessage
local StaticPopup_Show = StaticPopup_Show
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsUnit = UnitIsUnit
local CreateFrame = CreateFrame
local GetTime = GetTime

-- Configuration
local Config = {
    FEATURES = {
        NOTIFY_TANK = 1,
        NOTIFY_HEALER = 2,
        NOTIFY_DPS = 4,
        SHOW_IGNORED_POPUP = "IsPopupOnIgnoredApplicants"
    },

    FILTERS = {
        REALM = 1,
        CLASS = 2,
        SPEC = 3,
        ITEM_LEVEL = 4,
        DUNGEON_SCORE = 5
    },

    UI = {
        POPUP_NAME = "NemesisChatIgnoredApplicantPopup",
        MAX_MESSAGE_LENGTH = 255,
        UPDATE_THROTTLE = 0.1,
        COMBAT_CHECK_DELAY = 0.5
    },

    STATIC_POPUPS = {
        DECLINE_SINGLE = "NEMESISCHAT_DECLINE_APPLICANT",
        DECLINE_ALL = "NEMESISCHAT_DECLINE_ALL_APPLICANTS"
    },

    PERMISSIONS = {
        CHECK_INTERVAL = 0.25, -- Reduced from 0.5 for more responsive permission checks
    }
}

local Cache = {
    applicantIds = setmetatable({}, { __mode = "k" }),
    notificationSettings = 0,
    chatMessageSettings = 0,
    ignoredPopup = nil,
    ignoredQueue = setmetatable({}, { __mode = "v" }),
    lastUpdate = 0,
    hasDeclinePermission = false,
    lastPermissionCheck = 0,
}

local function HasDeclinePermission()
    local currentTime = GetTime()

    if currentTime - Cache.lastPermissionCheck < Config.PERMISSIONS.CHECK_INTERVAL then
        return Cache.hasDeclinePermission
    end

    Cache.lastPermissionCheck = currentTime

    local activeEntryInfo = C_LFGList.GetActiveEntryInfo()
    if not activeEntryInfo then
        Cache.hasDeclinePermission = false
        return false
    end

    -- You can decline if:
    -- 1. You're the listing creator
    -- 2. You're the group leader
    -- 3. You're an assist and have permission via group settings
    if UnitGUID("player") == activeEntryInfo.creatorGUI or
        UnitIsGroupLeader("player") or
        UnitIsGroupAssistant("player") then
        Cache.hasDeclinePermission = true
        return true
    end

    Cache.hasDeclinePermission = false
    return false
end

local function IsBlocked()
    return NCCombat:IsActive() or not HasDeclinePermission()
end

local function SafeDeclineApplicant(applicantID)
    if not applicantID then return false end

    -- Verify applicant still exists before attempting decline
    if not C_LFGList.GetApplicantInfo(applicantID) then
        return false
    end

    local success = pcall(function()
        C_LFGList.DeclineApplicant(applicantID)
    end)

    return success
end

-- Improved static popup definitions
StaticPopupDialogs[Config.STATIC_POPUPS.DECLINE_SINGLE] = {
    text = "Decline %s?",
    button1 = YES,
    button2 = NO,
    OnShow = function(self)
        if IsBlocked() then
            self:Hide()
            return
        end
    end,
    OnAccept = function(self)
        if IsBlocked() then return end
        if not self.data or not self.data.applicantID then return end

        local applicantInfo = C_LFGList.GetApplicantInfo(self.data.applicantID)
        if not applicantInfo then
            self:Hide()
            return
        end

        if not SafeDeclineApplicant(self.data.applicantID) then
            NemesisChat:HandleError("Failed to decline applicant")
            return
        end

        if Cache.ignoredQueue then
            for i, applicant in ipairs(Cache.ignoredQueue) do
                if applicant.applicantID == self.data.applicantID then
                    tremove(Cache.ignoredQueue, i)
                    break
                end
            end
        end

        if Cache.ignoredPopup then
            if not Cache.ignoredQueue or #Cache.ignoredQueue == 0 then
                Cache.ignoredPopup:Hide()
            else
                self.data.handler:ShowIgnoredPopup()
            end
        end
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

StaticPopupDialogs[Config.STATIC_POPUPS.DECLINE_ALL] = {
    text = "Decline all filtered applicants?",
    button1 = YES,
    button2 = NO,
    OnShow = function(self)
        if IsBlocked() then
            self:Hide()
            return
        end
    end,
    OnAccept = function(self)
        if IsBlocked() then return end
        if not Cache.ignoredQueue or #Cache.ignoredQueue == 0 then return end

        local applicantIDs = {}
        for _, applicant in ipairs(Cache.ignoredQueue) do
            if C_LFGList.GetApplicantInfo(applicant.applicantID) then
                tinsert(applicantIDs, applicant.applicantID)
            end
        end

        local function DeclineNext()
            if IsBlocked() then
                C_Timer.After(Config.UI.COMBAT_CHECK_DELAY, DeclineNext)
                return
            end

            local id = tremove(applicantIDs)
            if id then
                local popup = StaticPopup_Show(Config.STATIC_POPUPS.DECLINE_SINGLE, "applicant")
                if popup then
                    popup.data = {
                        applicantID = id,
                        handler = LFGHandler -- Changed from self.data.handler to LFGHandler
                    }
                    popup.OnAccept = StaticPopupDialogs[Config.STATIC_POPUPS.DECLINE_SINGLE].OnAccept
                    popup.OnAccept(popup)
                end
                if #applicantIDs > 0 then
                    C_Timer.After(Config.UI.UPDATE_THROTTLE, DeclineNext)
                end
            end
        end

        DeclineNext()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

-- Helper functions
local function GetRoleSound(roleFlag)
    if band(Cache.notificationSettings, roleFlag) ~= 0 then
        if roleFlag == Config.FEATURES.NOTIFY_TANK then
            return NCConfig:GetRoleSound("tank")
        elseif roleFlag == Config.FEATURES.NOTIFY_HEALER then
            return NCConfig:GetRoleSound("healer")
        elseif roleFlag == Config.FEATURES.NOTIFY_DPS then
            return NCConfig:GetRoleSound("dps") -- Fix: Was "healer" before
        end
    end
end

local function FormatMemberInfo(name, class, localizedClass, specName, itemLevel, dungeonScore, serverName, icon)
    local roleIcon = icon and format("|T%s:16:16:0:0:64:64:5:59:5:59|t", icon) or ""
    local ioString = dungeonScore and format(" (%s IO)", NCColors.Emphasize(dungeonScore)) or ""

    return {
        formatted = format("%s %s %s %s%s - %s",
            NCColors.Emphasize(itemLevel),
            NCColors.ClassColor(class, specName),
            NCColors.ClassColor(class, localizedClass),
            roleIcon,
            ioString,
            NCColors.Emphasize(serverName)),
        plain = format("%d %s %s%s - %s",
            itemLevel,
            specName,
            class,
            dungeonScore and format(" (%s IO)", dungeonScore) or "",
            serverName)
    }
end

local function MeetsItemLevelRequirement(role, itemLevel)
    local roleSpecificSetting = NCConfig:GetRoleMinItemLevel(string.lower(role)) or 0
    local globalSetting = NCConfig:GetApplicantMinItemLevel() or 0
    return itemLevel >= (roleSpecificSetting > 0 and roleSpecificSetting or globalSetting)
end

local function MeetsRankingRequirement(role, dungeonScore)
    local roleSpecificSetting = NCConfig:GetRoleMinDungeonScore(string.lower(role)) or 0
    local globalSetting = NCConfig:GetApplicantMinDungeonScore() or 0
    return dungeonScore >= (roleSpecificSetting > 0 and roleSpecificSetting or globalSetting)
end

local function IsAllowedRealm(realm)
    local allowedRealms = NCConfig:GetAllowedRealms() or {}
    return #allowedRealms == 0 or tContains(allowedRealms, realm)
end

local function IsIgnoredRealm(realm)
    local ignoredRealms = NCConfig:GetIgnoredRealms() or {}
    return tContains(ignoredRealms, realm)
end

local function IsAllowedClass(class)
    if not class then return false end
    local allowedClasses = NCConfig:GetAllowedClasses() or {}
    local ignoredClasses = NCConfig:GetIgnoredClasses() or {}
    return (#allowedClasses == 0 or tContains(allowedClasses, class)) and not tContains(ignoredClasses, class)
end

local function IsAllowedSpec(spec)
    if not spec then return false end
    local allowedSpecs = NCConfig:GetAllowedSpecs() or {}
    local ignoredSpecs = NCConfig:GetIgnoredSpecs() or {}
    return (#allowedSpecs == 0 or tContains(allowedSpecs, spec)) and not tContains(ignoredSpecs, spec)
end

local function CreateIgnoredPopup()
    if IsBlocked() then return end

    local popup = CreateFrame("Frame", Config.UI.POPUP_NAME, UIParent, "ButtonFrameTemplate")
    popup:SetSize(450, 300)
    popup:SetPoint("CENTER")
    popup:SetFrameStrata("DIALOG")

    -- Set the portrait texture
    if popup.PortraitContainer and popup.PortraitContainer.portrait then
        popup.PortraitContainer.portrait:SetTexture("Interface\\AddOns\\NemesisChat\\Media\\Logo")
    end

    -- Title
    if popup.TitleContainer and popup.TitleContainer.TitleText then
        popup.TitleContainer.TitleText:SetText("Filtered Applicants")
    else
        popup.title = popup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        popup.title:SetPoint("TOP", 0, -5)
        popup.title:SetText("Filtered Applicants")
    end

    popup.scrollFrame = CreateFrame("ScrollFrame", nil, popup, "UIPanelScrollFrameTemplate")
    popup.scrollFrame:SetPoint("TOPLEFT", 12, -32)
    popup.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 60)

    popup.content = CreateFrame("Frame", nil, popup.scrollFrame)
    popup.content:SetSize(400, 200)
    popup.scrollFrame:SetScrollChild(popup.content)

    popup.applicants = {}

    popup.declineAllButton = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
    popup.declineAllButton:SetSize(120, 22)
    popup.declineAllButton:SetPoint("BOTTOMLEFT", 20, 20)
    popup.declineAllButton:SetText("Decline All")
    popup.declineAllButton:SetEnabled(not IsBlocked())
    popup.declineAllButton:SetScript("OnClick", function()
        if IsBlocked() then return end
        StaticPopup_Show(Config.STATIC_POPUPS.DECLINE_ALL)
    end)

    popup.closeButton = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
    popup.closeButton:SetSize(100, 22)
    popup.closeButton:SetPoint("BOTTOMRIGHT", -20, 20)
    popup.closeButton:SetText("Close")
    popup.closeButton:SetScript("OnClick", function()
        popup:Hide()
    end)

    -- Add event handler for permission/combat state changes
    popup:RegisterEvent("GROUP_ROSTER_UPDATE")
    popup:RegisterEvent("PLAYER_REGEN_DISABLED")
    popup:RegisterEvent("PLAYER_REGEN_ENABLED")
    popup:SetScript("OnEvent", function(self, event)
        local isBlocked = IsBlocked()
        self.declineAllButton:SetEnabled(not isBlocked)

        if event == "PLAYER_REGEN_DISABLED" or isBlocked then
            self:Hide()
        end
    end)

    popup:Hide()
    return popup
end

local function CreateApplicantEntry(parent, index)
    if not parent or not index then return end

    local entry = CreateFrame("Frame", nil, parent)
    entry:SetSize(380, 50)
    entry:SetPoint("TOPLEFT", 10, -((index - 1) * 55))

    entry.bg = entry:CreateTexture(nil, "BACKGROUND")
    entry.bg:SetAllPoints()
    entry.bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)

    entry.text = entry:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    entry.text:SetPoint("TOPLEFT", 10, -8)
    entry.text:SetPoint("TOPRIGHT", -10, -8)
    entry.text:SetJustifyH("LEFT")

    entry.reason = entry:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    entry.reason:SetPoint("TOPLEFT", 10, -26)
    entry.reason:SetPoint("TOPRIGHT", -70, -26)
    entry.reason:SetTextColor(1, 0.7, 0)

    entry.declineButton = CreateFrame("Button", nil, entry, "UIPanelButtonTemplate")
    entry.declineButton:SetSize(60, 20)
    entry.declineButton:SetPoint("BOTTOMRIGHT", -5, 5)
    entry.declineButton:SetText("Decline")
    entry.declineButton:SetEnabled(not IsBlocked())

    entry:SetScript("OnShow", function(self)
        self.declineButton:SetEnabled(not IsBlocked())
    end)

    return entry
end

-- Core functionality
function LFGHandler:Initialize()
    if not NCConfig then
        NemesisChat:HandleError("LFGHandler:Initialize - NCConfig not available")
        return
    end

    if type(Cache) ~= "table" then
        NemesisChat:HandleError("Cache not properly initialized")
        return
    end

    -- Ensure all required Cache tables exist
    Cache.applicantIds = Cache.applicantIds or setmetatable({}, { __mode = "k" })
    Cache.ignoredQueue = Cache.ignoredQueue or {}
    Cache.notificationSettings = 0
    Cache.chatMessageSettings = 0

    -- Update notification settings
    self:UpdateConfigCache()

    -- Initial permission check
    HasDeclinePermission()
end

function LFGHandler:UpdateConfigCache()
    if not NCConfig then
        NemesisChat:HandleError("UpdateConfigCache: NCConfig not available")
        return
    end

    local notifySettings, chatSettings = 0, 0
    local roles = { "tank", "healer", "dps" }

    for _, role in ipairs(roles) do
        if NCConfig:IsRoleEnabled(role) then
            local flag = Config.FEATURES["NOTIFY_" .. string.upper(role)]
            if flag then
                notifySettings = bor(notifySettings, flag)
            end
        end
    end

    Cache.notificationSettings = notifySettings
    Cache.chatMessageSettings = chatSettings
end

function LFGHandler:OnApplicantUpdated(applicantID)
    if not NCConfig or not applicantID or Cache.notificationSettings == 0 then return end

    local applicantInfo = C_LFGList.GetApplicantInfo(applicantID)
    if not applicantInfo or not applicantInfo.applicationStatus then return end

    -- Skip if we've already processed this applicant
    if Cache.applicantIds[applicantID] then return end
    Cache.applicantIds[applicantID] = true

    local groupMembers = {}
    local ignoredMembers = {}
    local highestPrioritySound

    -- Process all members first
    for i = 1, applicantInfo.numMembers do
        local memberInfo = self:ProcessApplicantMember(applicantID, i)
        if memberInfo then
            if memberInfo.reason then
                if NCConfig and NCConfig:IsPopupOnIgnoredApplicants() then
                    tinsert(ignoredMembers, memberInfo)
                end
            else
                tinsert(groupMembers, memberInfo)
                if memberInfo.sound and (not highestPrioritySound or memberInfo.sound > highestPrioritySound) then
                    highestPrioritySound = memberInfo.sound
                end
            end
        end
    end

    -- Handle valid applicants as a single group
    if #groupMembers > 0 then
        self:SendNotification(groupMembers, highestPrioritySound)
    end

    -- Handle ignored applicants
    if #ignoredMembers > 0 then
        for _, member in ipairs(ignoredMembers) do
            tinsert(Cache.ignoredQueue, member)
        end
        self:ShowIgnoredPopup()
    end
end

function LFGHandler:ProcessApplicantMember(applicantID, memberIndex)
    if not applicantID or not memberIndex then return nil end

    local name, class, localizedClass, _, itemLevel, _, tank, healer, damage, _, _, dungeonScore, _, _, _, specID =
        C_LFGList.GetApplicantMemberInfo(applicantID, memberIndex)

    -- Skip if we don't have complete member info
    if not name or not class or not itemLevel or itemLevel <= 0 then return nil end

    -- Ensure valid itemLevel and dungeonScore
    itemLevel = floor(itemLevel)
    dungeonScore = (dungeonScore and dungeonScore > 0) and dungeonScore or nil

    local realm = select(2, strsplit("-", name)) or GetRealmName()
    local _, specName = GetSpecializationInfoByID(specID)
    local roleName = (healer and "Healer") or (tank and "Tank") or (damage and "DPS") or ""

    if not specName or not roleName then return nil end

    -- First perform filtering checks
    local filterReason
    if not IsAllowedRealm(realm) or IsIgnoredRealm(realm) then
        filterReason = Config.FILTERS.REALM
    elseif not IsAllowedClass(class) then
        filterReason = Config.FILTERS.CLASS
    elseif not IsAllowedSpec(specName) then
        filterReason = Config.FILTERS.SPEC
    elseif not MeetsItemLevelRequirement(roleName, itemLevel) then
        filterReason = Config.FILTERS.ITEM_LEVEL
    elseif not MeetsRankingRequirement(roleName, dungeonScore or 0) then
        filterReason = Config.FILTERS.DUNGEON_SCORE
    end

    -- Handle filtered applicants
    if filterReason then
        if NCConfig and NCConfig:IsPopupOnIgnoredApplicants() then
            return self:FormatIgnoredApplicant(name, class, localizedClass, specName, itemLevel, dungeonScore, realm,
                specID, filterReason, applicantID)
        end
        return nil
    end

    local roleFlag = (healer and Config.FEATURES.NOTIFY_HEALER) or (tank and Config.FEATURES.NOTIFY_TANK) or
        (damage and Config.FEATURES.NOTIFY_DPS) or 0
    if band(Cache.notificationSettings, roleFlag) == 0 then return nil end

    local _, _, _, icon = GetSpecializationInfoByID(specID)

    return {
        info = FormatMemberInfo(name, class, localizedClass, specName, itemLevel, dungeonScore, realm, icon),
        sound = GetRoleSound(roleFlag),
        roleFlag = roleFlag
    }
end

function LFGHandler:FormatIgnoredApplicant(name, class, localizedClass, specName, itemLevel, dungeonScore, realm, specID,
                                           reason, applicantID)
    if not name or not class or not specID or not reason or not applicantID then return nil end

    local _, _, _, icon = GetSpecializationInfoByID(specID)
    local formattedInfo = FormatMemberInfo(name, class, localizedClass, specName, floor(itemLevel), dungeonScore, realm,
        icon)

    if not formattedInfo then return nil end

    return {
        info = formattedInfo,
        reason = reason,
        applicantID = applicantID
    }
end

function LFGHandler:SendNotification(groupMembers, sound)
    if not groupMembers or type(groupMembers) ~= "table" then
        NemesisChat:HandleError("SendNotification: groupMembers must be a table")
        return
    end

    if #groupMembers == 0 then return end

    -- Create formatted entries for each member
    local formattedEntries = {}
    local plainEntries = {}
    for _, member in ipairs(groupMembers) do
        if not member.info then
            NemesisChat:HandleError("SendNotification: invalid member data structure")
            return
        end
        tinsert(formattedEntries, member.info.formatted)
        tinsert(plainEntries, member.info.plain)
    end

    -- Determine if any member should trigger a chat message
    local shouldSendChat = IsInGroup(LE_PARTY_CATEGORY_HOME) and
        groupMembers[1] and
        band(Cache.chatMessageSettings, groupMembers[1].roleFlag) ~= 0 and
        NCConfig:IsMessageSystemEnabled()

    -- Create messages
    local formattedMessage = #groupMembers == 1
        and format("New applicant: %s", formattedEntries[1])
        or format("A group of %d has applied:\n%s",
            #groupMembers,
            table.concat(formattedEntries, "\n"))

    local plainMessage = #groupMembers == 1
        and format("New applicant: %s", plainEntries[1])
        or format("A group of %d has applied: %s",
            #groupMembers,
            table.concat(plainEntries, " | "))

    -- Print to addon chat
    NemesisChat:Print(formattedMessage)

    -- Send to group chat if needed
    if shouldSendChat then
        self:SendGroupMessage(plainMessage)
    end

    if sound and type(sound) == "number" then
        PlaySound(sound, "Master")
    end
end

function LFGHandler:SendGroupMessage(message)
    if not message or type(message) ~= "string" then
        NemesisChat:HandleError("SendGroupMessage: message is required")
        return
    end

    while #message > 0 do
        local chunk = message:sub(1, Config.UI.MAX_MESSAGE_LENGTH)
        local lastSpace = chunk:find("%s[^%s]*$")

        if #message > Config.UI.MAX_MESSAGE_LENGTH and lastSpace then
            chunk = message:sub(1, lastSpace - 1)
        end

        -- Ensure we actually have content to send
        if chunk and #chunk > 0 then
            SendChatMessage("NemesisChat: " .. chunk, "PARTY")
        end

        message = message:sub(#chunk + 1):gsub("^%s*", "")
    end
end

function LFGHandler:ShowIgnoredPopup()
    if IsBlocked() then return end

    -- Check if we should show popups
    if not NCConfig or not NCConfig:IsPopupOnIgnoredApplicants() then
        return
    end

    -- Cleanup stale entries
    self:CleanupIgnoredQueue()

    if not Cache.ignoredQueue or #Cache.ignoredQueue == 0 then
        if Cache.ignoredPopup then
            Cache.ignoredPopup:Hide()
        end
        return
    end

    -- Throttle updates
    local currentTime = GetTime()
    if currentTime - Cache.lastUpdate < Config.UI.UPDATE_THROTTLE then
        C_Timer.After(Config.UI.UPDATE_THROTTLE, function()
            self:ShowIgnoredPopup()
        end)
        return
    end
    Cache.lastUpdate = currentTime

    if not Cache.ignoredPopup then
        Cache.ignoredPopup = CreateIgnoredPopup()
        if not Cache.ignoredPopup then
            NemesisChat:HandleError("ShowIgnoredPopup: Failed to create popup frame")
            return
        end
    end

    local popup = Cache.ignoredPopup

    -- Clear existing entries
    for _, entry in ipairs(popup.applicants) do
        entry:Hide()
    end

    -- Create or update entries for each ignored applicant
    for i, applicant in ipairs(Cache.ignoredQueue) do
        if not popup.applicants[i] then
            popup.applicants[i] = CreateApplicantEntry(popup.content, i)
        end

        local entry = popup.applicants[i]
        if entry then
            entry.text:SetText(applicant.info.formatted)
            entry.reason:SetText(self:GetIgnoreReasonText(applicant.reason))
            entry.declineButton:SetScript("OnClick", function()
                if IsBlocked() then return end
                local name = strsplit("-", applicant.info.plain)
                local popup = StaticPopup_Show(Config.STATIC_POPUPS.DECLINE_SINGLE, name)
                if popup then
                    popup.data = {
                        applicantID = applicant.applicantID,
                        index = i,
                        handler = self
                    }
                end
            end)
            entry:Show()
        end
    end

    -- Update content height
    popup.content:SetHeight(#Cache.ignoredQueue * 55 + 10)
    popup:Show()
end

function LFGHandler:GetIgnoreReasonText(reason)
    if not reason then return "Unknown Filter" end

    local reasons = {
        [Config.FILTERS.REALM] = "Filtered Realm",
        [Config.FILTERS.CLASS] = "Filtered Class",
        [Config.FILTERS.SPEC] = "Filtered Specialization",
        [Config.FILTERS.ITEM_LEVEL] = "Below Item Level Requirement",
        [Config.FILTERS.DUNGEON_SCORE] = "Below Score Requirement"
    }
    return reasons[reason] or "Unknown Filter"
end

function LFGHandler:ProcessNextIgnoredRealmApplicant()
    if NCConfig:IsPopupOnIgnoredApplicants() and Cache.ignoredRealmQueue and #Cache.ignoredRealmQueue > 0 then
        local nextApplicant = tremove(Cache.ignoredRealmQueue, 1)
        self:ShowIgnoredRealmPopup(nextApplicant.applicantID, nextApplicant.realm, nextApplicant.message)
    end
end

function LFGHandler:CleanupIgnoredQueue()
    if not NCConfig then return end
    if not Cache.ignoredQueue then
        Cache.ignoredQueue = {}
        return
    end

    local i = 1
    while i <= #Cache.ignoredQueue do
        local applicant = Cache.ignoredQueue[i]
        if not applicant or
            not applicant.applicantID or
            not C_LFGList.GetApplicantInfo(applicant.applicantID) then
            tremove(Cache.ignoredQueue, i)
        else
            i = i + 1
        end
    end
end

function LFGHandler:OnConfigChanged()
    if not NCConfig then return end

    self:UpdateConfigCache()

    -- Ensure queue exists
    if not Cache.ignoredQueue then
        Cache.ignoredQueue = {}
    end

    -- Update popup if visible
    if Cache.ignoredPopup and Cache.ignoredPopup:IsShown() then
        self:ShowIgnoredPopup()
    end
end

function LFGHandler:UpdatePermissions()
    -- This will update our cached permission state
    HasDeclinePermission()

    -- If we lost permissions, hide the popup
    if not Cache.hasDeclinePermission and Cache.ignoredPopup then
        Cache.ignoredPopup:Hide()
    end
end
