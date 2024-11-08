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

local ButtonStyles = {
    Invite = {
        backdrop = {
            bgFile = "Interface\\Buttons\\GoldGradiant",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        },
        colors = {
            normal = {
                bg = { r = 0.1, g = 0.1, b = 0.1, a = 0.8 },
                border = { r = 0.3, g = 0.3, b = 0.3, a = 0.8 }
            },
            hover = {
                bg = { r = 0.2, g = 0.2, b = 0.2, a = 0.7 },
                border = { r = 0.4, g = 0.4, b = 0.4, a = 0.7 }
            },
            pressed = {
                bg = { r = 0.15, g = 0.15, b = 0.15, a = 1.0 },
                border = { r = 0.3, g = 0.3, b = 0.3, a = 1.0 }
            }
        }
    },
    Default = {
        backdrop = {
            bgFile = "Interface\\Buttons\\GoldGradiant",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        },
        colors = {
            normal = {
                bg = { r = 0.2, g = 0.2, b = 0.2, a = 0.8 },
                border = { r = 0.3, g = 0.3, b = 0.3, a = 0.8 }
            },
            hover = {
                bg = { r = 0.3, g = 0.3, b = 0.3, a = 0.9 },
                border = { r = 0.4, g = 0.4, b = 0.4, a = 0.9 }
            },
            pressed = {
                bg = { r = 0.15, g = 0.15, b = 0.15, a = 1.0 },
                border = { r = 0.3, g = 0.3, b = 0.3, a = 1.0 }
            }
        }
    }
}

local ROLE_ICONS = {
    TANK = "Interface\\Addons\\NemesisChat\\Media\\Icons\\TankRoleIcon",
    HEALER = "Interface\\Addons\\NemesisChat\\Media\\Icons\\HealerRoleIcon",
    DAMAGER = "Interface\\Addons\\NemesisChat\\Media\\Icons\\DPSRoleIcon"
}

local MAX_BATCH_SIZE = 10
local BATCH_COOLDOWN = 1.0

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

local filterReasons = {
    Config.FILTERS.REALM,           -- "Filtered Realm"
    Config.FILTERS.CLASS,           -- "Filtered Class"
    Config.FILTERS.SPEC,            -- "Filtered Specialization"
    Config.FILTERS.ITEM_LEVEL,      -- "Below Item Level Requirement"
    Config.FILTERS.DUNGEON_SCORE    -- "Below Score Requirement"
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
            localizedClass,
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

-- Helper function to color IO scores (if not already defined)
local function GetScoreColor(score)
    -- Ensure score is a number
    score = tonumber(score) or 0

    -- Check if RaiderIO exists and has the GetScoreColor function
    if _G.RaiderIO and type(_G.RaiderIO.GetScoreColor) == "function" then
        -- RaiderIO.GetScoreColor returns r, g, b values
        local r, g, b = _G.RaiderIO.GetScoreColor(score)
        -- Convert RGB values (0-1) to hex color code
        return string.format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, score)
    end

    -- Fallback colors if RaiderIO isn't available
    if score >= 3000 then return string.format("|cffff8000%s|r", score)      -- Orange/Gold
    elseif score >= 2400 then return string.format("|cffff80ff%s|r", score)  -- Pink
    elseif score >= 1800 then return string.format("|cff0070dd%s|r", score)  -- Blue
    elseif score >= 1200 then return string.format("|cff1eff00%s|r", score)  -- Green
    else return string.format("|cffffffff%s|r", score) end                   -- White
end

local function ApplyButtonStyle(button, style, state)
    local colors = style.colors[state]
    button:SetBackdropColor(colors.bg.r, colors.bg.g, colors.bg.b, colors.bg.a)
    button:SetBackdropBorderColor(colors.border.r, colors.border.g, colors.border.b, colors.border.a)
end

function CreateStyledButton(parent, text)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate, BackdropTemplate")
    button:SetSize(80, 24)
    button:SetText(text)
    button:SetNormalFontObject("GameFontNormal")
    button:SetHighlightFontObject("GameFontHighlight")

    local style = ButtonStyles[text] or ButtonStyles.Default
    button:SetBackdrop(style.backdrop)

    -- Initial state
    ApplyButtonStyle(button, style, "normal")

    -- Set custom colors for different states
    button:SetScript("OnEnter", function(self)
        ApplyButtonStyle(self, style, "hover")
    end)

    button:SetScript("OnLeave", function(self)
        ApplyButtonStyle(self, style, "normal")
    end)

    button:SetScript("OnMouseDown", function(self)
        ApplyButtonStyle(self, style, "pressed")
    end)

    button:SetScript("OnMouseUp", function(self)
        if self:IsMouseOver() then
            ApplyButtonStyle(self, style, "hover")
        else
            ApplyButtonStyle(self, style, "normal")
        end
    end)

    return button
end

local function CreateApplicantEntry(parent, index)
    local entry = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    local yOffset = ((index - 1) * 65)
    entry:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, -yOffset)
    entry:SetPoint("RIGHT", parent, "RIGHT", -5, 0)
    entry:SetHeight(65)

    -- Add translucent background
    entry:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    entry:SetBackdropColor(0.1, 0.1, 0.1, 0.6)
    entry:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)

    -- Role icon (left side)
    entry.roleIcon = entry:CreateTexture(nil, "ARTWORK")
    entry.roleIcon:SetPoint("LEFT", entry, "LEFT", 8, 0)
    entry.roleIcon:SetSize(48, 48)

    -- Primary info text (item level + spec + class)
    entry.primaryInfo = entry:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    entry.primaryInfo:SetPoint("LEFT", entry.roleIcon, "RIGHT", 12, 20)
    entry.primaryInfo:SetPoint("RIGHT", entry, "RIGHT", -8, 20)
    entry.primaryInfo:SetJustifyH("LEFT")
    entry.primaryInfo:SetWordWrap(false)

    -- Secondary info (IO + realm)
    entry.secondaryInfo = entry:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    entry.secondaryInfo:SetPoint("TOPLEFT", entry.primaryInfo, "BOTTOMLEFT", 0, -4)
    entry.secondaryInfo:SetPoint("RIGHT", entry, "RIGHT", -8, 0)
    entry.secondaryInfo:SetJustifyH("LEFT")
    entry.secondaryInfo:SetWordWrap(false)

    -- Filter reason (new)
    entry.reasonInfo = entry:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    entry.reasonInfo:SetPoint("TOPLEFT", entry.secondaryInfo, "BOTTOMLEFT", 0, -4)
    entry.reasonInfo:SetPoint("RIGHT", entry, "RIGHT", -8, -20)
    entry.reasonInfo:SetJustifyH("LEFT")
    entry.reasonInfo:SetWordWrap(false)
    entry.reasonInfo:SetTextColor(0.9, 0.3, 0.3) -- Softer red

    -- Buttons using the styled template (now stacked vertically)
    entry.inviteButton = CreateStyledButton(entry, "Invite")
    entry.inviteButton:SetPoint("TOPRIGHT", entry, "TOPRIGHT", -8, -8)
    entry.inviteButton:SetScript("OnClick", function()
        if entry.applicantData then
            C_LFGList.InviteApplicant(entry.applicantData.applicantID)
        end
    end)

    entry.declineButton = CreateStyledButton(entry, "Decline")
    entry.declineButton:SetPoint("BOTTOMRIGHT", entry, "BOTTOMRIGHT", -8, 8)
    entry.declineButton:SetScript("OnClick", function()
        if entry.applicantData then
            StaticPopup_Show(Config.STATIC_POPUPS.DECLINE_SINGLE, "applicant", nil, {
                applicantID = entry.applicantData.applicantID,
                handler = LFGHandler
            })
        end
    end)

    -- Enable mouse interaction for tooltip
    entry:EnableMouse(true)
    entry:SetScript("OnEnter", function(self)
        if self.applicantData and self.applicantData.applicantID then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(self.applicantData.info.primary.class, 1, 1, 1)

            -- Add spec and item level
            GameTooltip:AddLine(string.format("%s - %d",
                self.applicantData.info.primary.spec,
                self.applicantData.info.primary.itemLevel
            ))

            -- Add dungeon score if available
            if self.applicantData.info.secondary.dungeonScore then
                GameTooltip:AddLine(string.format("M+ Score: %d",
                    self.applicantData.info.secondary.dungeonScore
                ))
            end

            -- Add realm
            GameTooltip:AddLine(self.applicantData.info.secondary.realm)

            -- Add filter reason
            GameTooltip:AddLine(LFGHandler:GetIgnoreReasonText(self.applicantData.reason), 1, 0.5, 0.5)

            GameTooltip:Show()
        end
    end)
    entry:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    function entry:UpdateDisplay(applicant)
        if not applicant then return end

        self.applicantData = applicant
        self.roleIcon:SetTexture(applicant.role.texture)

        -- Color the spec and class text with class color
        local primaryText = string.format("%d %s %s",
            applicant.info.primary.itemLevel,
            NCColors.ClassColor(applicant.info.primary.classFile, applicant.info.primary.spec),
            NCColors.ClassColor(applicant.info.primary.classFile, applicant.info.primary.class))
        self.primaryInfo:SetText(primaryText)

        -- IO and realm on middle line
        local secondaryText = string.format("%s IO - %s",
            GetScoreColor(applicant.info.secondary.dungeonScore),
            applicant.info.secondary.realm)
        self.secondaryInfo:SetText(secondaryText)

        -- Reason on bottom line
        self.reasonInfo:SetText(LFGHandler:GetIgnoreReasonText(applicant.reason))
    end

    return entry
end

local function CreateGroupEntry(parent, index)
    local entry = CreateFrame("Frame", nil, parent, "BackdropTemplate")

    -- Anchor first entry to top, subsequent entries below previous
    if index > 1 and parent.entries and parent.entries[index-1] then
        entry:SetPoint("TOPLEFT", parent.entries[index-1], "BOTTOMLEFT", 0, -10)
        entry:SetPoint("TOPRIGHT", parent.entries[index-1], "BOTTOMRIGHT", 0, -10)
    else
        entry:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -10)
        entry:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -10, -10)
    end

    -- Set initial height (will be updated based on content)
    entry:SetHeight(65)

    -- Blue border and translucent background for group
    entry:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    entry:SetBackdropColor(0.1, 0.1, 0.2, 0.6)
    entry:SetBackdropBorderColor(0.5, 0.7, 1.0, 0.8)

    -- Group header
    entry.header = CreateFrame("Frame", nil, entry)
    entry.header:SetPoint("TOPLEFT", entry, "TOPLEFT", 5, -5)
    entry.header:SetPoint("TOPRIGHT", entry, "TOPRIGHT", -5, -5)
    entry.header:SetHeight(30)

    -- Group text
    entry.groupText = entry.header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    entry.groupText:SetPoint("LEFT", 5, 0)
    entry.groupText:SetPoint("RIGHT", -150, 0) -- Make room for buttons
    entry.groupText:SetText("Group")

    -- Group buttons (in header)
    entry.declineButton = CreateStyledButton(entry.header, "Decline")
    entry.declineButton:SetPoint("RIGHT", entry.header, "RIGHT", -5, 0)
    entry.declineButton:SetScript("OnClick", function()
        if entry.groupData and entry.groupData[1] then
            StaticPopup_Show(Config.STATIC_POPUPS.DECLINE_SINGLE, "group", nil, {
                applicantID = entry.groupData[1].applicantID,
                handler = LFGHandler
            })
        end
    end)

    entry.inviteButton = CreateStyledButton(entry.header, "Invite")
    entry.inviteButton:SetPoint("RIGHT", entry.declineButton, "LEFT", -5, 0)
    entry.inviteButton:SetScript("OnClick", function()
        if entry.groupData and entry.groupData[1] then
            C_LFGList.InviteApplicant(entry.groupData[1].applicantID)
        end
    end)

    -- Container for applicant entries
    entry.applicantContainer = CreateFrame("Frame", nil, entry)
    entry.applicantContainer:SetPoint("TOPLEFT", entry.header, "BOTTOMLEFT", 0, -5)
    entry.applicantContainer:SetPoint("BOTTOMRIGHT", entry, "BOTTOMRIGHT", -5, 5)

    function entry:UpdateDisplay(group)
        if not group or #group == 0 then return end

        -- Store group data for button callbacks
        self.groupData = group

        -- Update group text
        self.groupText:SetText(format("Group (%d members)", #group))

        -- Create/update applicant entries
        local containerHeight = 0
        for i, applicant in ipairs(group) do
            local applicantEntry = self.applicantContainer["applicant"..i] or
                                 CreateApplicantEntry(self.applicantContainer, i)
            self.applicantContainer["applicant"..i] = applicantEntry

            -- Remove individual buttons for group members
            if applicantEntry.inviteButton then applicantEntry.inviteButton:Hide() end
            if applicantEntry.declineButton then applicantEntry.declineButton:Hide() end

            -- Allow text to use full width since there are no buttons
            applicantEntry.primaryInfo:SetPoint("RIGHT", applicantEntry, "RIGHT", -8, 12)
            applicantEntry.secondaryInfo:SetPoint("RIGHT", applicantEntry, "RIGHT", -8, -4)

            applicantEntry:UpdateDisplay(applicant)
            applicantEntry:Show()
            containerHeight = containerHeight + applicantEntry:GetHeight() + 2
        end

        -- Hide unused applicant entries
        local i = #group + 1
        while self.applicantContainer["applicant"..i] do
            self.applicantContainer["applicant"..i]:Hide()
            i = i + 1
        end

        -- Update heights with proper padding
        self.applicantContainer:SetHeight(containerHeight + 10) -- Add padding at bottom
        self:SetHeight(40 + containerHeight + 15) -- header(30) + padding(10) + container + bottom padding(15)
    end

    return entry
end

local function CreateIgnoredPopup()
    if IsBlocked() then return end

    local popup = CreateFrame("Frame", Config.UI.POPUP_NAME, UIParent, "BackdropTemplate")
    popup:SetSize(450, 300)
    popup:SetPoint("CENTER")
    popup:SetMovable(true)
    popup:SetResizable(true)
    popup:SetClampedToScreen(true)
    popup:SetUserPlaced(true)
    popup:SetFrameStrata("DIALOG")
    popup:SetResizeBounds(400, 220) -- Increased minimum width for better readability

    -- Register with config system
    NemesisChat:RegisterConfig(popup, "NemesisChatFilteredApplicantsDB")
    NemesisChat:RestorePosition(popup)

    -- Set backdrop to match Info frame
    popup:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 2,
        edgeSize = 2,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    popup:SetBackdropColor(0, 0, 0, 0.4)
    popup:SetBackdropBorderColor(0, 0, 0, 1)

    -- Title
    popup.title = popup:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    popup.title:SetPoint("TOPLEFT", popup, "TOPLEFT", 8, -8)
    popup.title:SetPoint("TOPRIGHT", popup, "TOPRIGHT", -8, -8)
    popup.title:SetText("Filtered Applicants")
    popup.title:SetTextColor(0.50, 0.60, 1)
    popup.title:SetJustifyH("CENTER")

    -- Make title draggable
    popup.title:EnableMouse(true)
    popup.title:SetScript("OnMouseDown", function(_, button)
        if button == "LeftButton" then
            popup:StartMoving()
        end
    end)
    popup.title:SetScript("OnMouseUp", function()
        popup:StopMovingOrSizing()
    end)

    -- Close Button
    popup.closeButton = CreateFrame("Button", nil, popup, "UIPanelCloseButton")
    popup.closeButton:SetPoint("TOPRIGHT", popup, "TOPRIGHT", -5, -5)
    popup.closeButton:SetSize(16, 16)

    -- Scroll Frame with padding
    popup.scrollFrame = CreateFrame("ScrollFrame", nil, popup, "UIPanelScrollFrameTemplate")
    popup.scrollFrame:SetPoint("TOPLEFT", popup, "TOPLEFT", 6, -32)
    popup.scrollFrame:SetPoint("BOTTOMRIGHT", popup, "BOTTOMRIGHT", -30, 24)

    -- Content Frame setup
    popup.content = CreateFrame("Frame", nil, popup.scrollFrame)
    popup.content:SetPoint("TOPLEFT", popup.scrollFrame, "TOPLEFT", 0, 0)
    popup.content:SetPoint("TOPRIGHT", popup.scrollFrame, "TOPRIGHT", -20, 0)  -- Account for scrollbar
    popup.content:SetHeight(1)  -- Initial height
    popup.scrollFrame:SetScrollChild(popup.content)
    popup.entries = {}

    -- Force initial layout
    popup:SetScript("OnShow", function(self)
        self:GetScript("OnSizeChanged")(self, self:GetWidth(), self:GetHeight())
    end)

    -- Update content width when popup is resized
    popup:SetScript("OnSizeChanged", function(self, width, height)
        popup.content:SetWidth(width - 42)
        for _, entry in ipairs(popup.entries) do
            if entry:IsShown() then
                entry:SetWidth(popup.content:GetWidth() - 20)
            end
        end
        NemesisChat:SavePosition(popup)
    end)

    -- Footer Frame with backdrop (update existing)
    popup.footerFrame = CreateFrame("Frame", nil, popup, "BackdropTemplate")
    popup.footerFrame:SetPoint("BOTTOMLEFT", popup, "BOTTOMLEFT", 0, 0)
    popup.footerFrame:SetPoint("BOTTOMRIGHT", popup, "BOTTOMRIGHT", 0, 0)
    popup.footerFrame:SetHeight(24)
    popup.footerFrame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 2,
        edgeSize = 2,
        insets = { left = 0, right = 0, top = 1, bottom = 0 }
    })
    popup.footerFrame:SetBackdropColor(0, 0, 0, 0.15)
    popup.footerFrame:SetBackdropBorderColor(0, 0, 0, 1)

    -- Status Bar
    popup.statusBar = CreateFrame("StatusBar", nil, popup.footerFrame)
    popup.statusBar:SetPoint("TOPLEFT", popup.footerFrame, "TOPLEFT", 8, -4)
    popup.statusBar:SetPoint("BOTTOMRIGHT", popup.footerFrame, "BOTTOMRIGHT", -8, 4)
    popup.statusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    popup.statusBar:SetStatusBarColor(0.1, 0.5, 1.0)
    popup.statusBar:SetMinMaxValues(0, 1)
    popup.statusBar:SetValue(0)
    popup.statusBar:Hide()

    -- Status Text
    popup.statusText = popup.statusBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    popup.statusText:SetPoint("CENTER")
    popup.statusText:SetTextColor(1, 1, 1)

    -- Batch Decline Button
    popup.batchDeclineButton = CreateStyledButton(popup.footerFrame, "Decline")
    popup.batchDeclineButton:SetSize(120, 20)
    popup.batchDeclineButton:SetPoint("LEFT", popup.footerFrame, "LEFT", 8, 0)
    popup.batchDeclineButton:SetEnabled(not IsBlocked())

    -- Update batch decline button text
    local function UpdateBatchButtonText()
        local count = #Cache.ignoredQueue
        local batchSize = math.min(count, MAX_BATCH_SIZE)
        popup.batchDeclineButton:SetText(format("Decline %d", batchSize))
        popup.batchDeclineButton:SetEnabled(count > 0 and not IsBlocked())
    end

    local function StartBatchDecline()
        if IsBlocked() then return end

        local count = #Cache.ignoredQueue
        if count == 0 then return end

        local batchSize = math.min(count, MAX_BATCH_SIZE)
        local processed = 0

        -- Disable all decline buttons
        popup.batchDeclineButton:SetEnabled(false)
        for _, entry in ipairs(popup.entries) do
            entry.declineButton:SetEnabled(false)
            entry.inviteButton:SetEnabled(false)
        end

        -- Show and setup status bar
        popup.statusBar:Show()
        popup.statusBar:SetMinMaxValues(0, batchSize)
        popup.statusBar:SetValue(0)

        -- Process batch
        for i = 1, batchSize do
            local applicant = Cache.ignoredQueue[1]
            if applicant then
                if not applicant.isTest then
                    C_LFGList.DeclineApplicant(applicant.applicantID)
                end
                tremove(Cache.ignoredQueue, 1)
                processed = processed + 1

                popup.statusBar:SetValue(processed)
                popup.statusText:SetText(format("Declining %d/%d", processed, batchSize))
            end
        end

        -- Re-enable buttons after cooldown
        C_Timer.After(BATCH_COOLDOWN, function()
            popup.batchDeclineButton:SetEnabled(true)
            for _, entry in ipairs(popup.entries) do
                entry.declineButton:SetEnabled(true)
                entry.inviteButton:SetEnabled(true)
            end
            popup.statusBar:Hide()
            UpdateBatchButtonText()

            -- Refresh display
            LFGHandler:ShowIgnoredPopup()
        end)
    end

    popup.batchDeclineButton:SetScript("OnClick", StartBatchDecline)

    -- Initial button text
    UpdateBatchButtonText()

    -- Resize Button
    popup.resizeButton = CreateFrame("Button", nil, popup)
    popup.resizeButton:SetPoint("BOTTOMRIGHT", popup, "BOTTOMRIGHT", -2, 2)
    popup.resizeButton:SetSize(16, 16)
    popup.resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    popup.resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    popup.resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

    popup.resizeButton:SetScript("OnMouseDown", function(_, button)
        if button == "LeftButton" then
            popup:StartSizing("BOTTOMRIGHT")
        end
    end)
    popup.resizeButton:SetScript("OnMouseUp", function()
        popup:StopMovingOrSizing()
    end)

    popup:Hide()
    return popup
end

local function CleanupApplicantCache()
    -- Clear the applicant cache every 5 minutes
    C_Timer.NewTicker(300, function()
        Cache.applicantIds = setmetatable({}, { __mode = "k" })
    end)
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
    Cache.lastUpdate = 0
    Cache.lastPermissionCheck = 0
    Cache.ignoredPopup = nil  -- Reset popup reference on initialize

    -- Update notification settings
    self:UpdateConfigCache()

    -- Initialize the cache cleanup
    CleanupApplicantCache()

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
                -- Also set chat settings if chat messages are enabled for this role
                if NCConfig:IsRoleChatEnabled(role) then
                    chatSettings = bor(chatSettings, flag)
                end
            end
        end
    end

    Cache.notificationSettings = notifySettings
    Cache.chatMessageSettings = chatSettings
end

function LFGHandler:OnApplicantListUpdated()
    -- Clear out any applicants that are no longer in the list
    local currentApplicants = C_LFGList.GetApplications()
    local applicantMap = {}
    local statusMap = {}

    -- Build a map of current applicants and their statuses
    for _, applicantID in ipairs(currentApplicants) do
        local applicantInfo = C_LFGList.GetApplicantInfo(applicantID)
        applicantMap[applicantID] = true
        if applicantInfo then
            statusMap[applicantID] = applicantInfo.applicationStatus
        end
    end

    -- Remove entries from ignoredQueue if they're no longer in the list
    -- or if they've been invited
    if Cache.ignoredQueue then
        for i = #Cache.ignoredQueue, 1, -1 do
            local applicantID = Cache.ignoredQueue[i].applicantID
            if not applicantMap[applicantID] or
               (statusMap[applicantID] and statusMap[applicantID] == "invited") then
                table.remove(Cache.ignoredQueue, i)
            end
        end
    end

    -- Update the popup if it's showing
    local popup = _G[Config.UI.POPUP_NAME]
    if popup and popup:IsShown() then
        self:ShowIgnoredPopup()
    end
end

function LFGHandler:OnApplicantUpdated(applicantID)
    if not NCConfig or not applicantID or (Cache.notificationSettings == 0 and Cache.chatMessageSettings == 0 and
        not NCConfig:IsPopupOnIgnoredApplicants()) then return end

    local applicantInfo = C_LFGList.GetApplicantInfo(applicantID)
    if not applicantInfo or not applicantInfo.numMembers then return end

    -- Skip if we've already processed this applicant in the last 5 minutes
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
                -- Only add to ignoredMembers if we have decline permission
                if HasDeclinePermission() and NCConfig and NCConfig:IsPopupOnIgnoredApplicants() then
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
    if HasDeclinePermission() and #ignoredMembers > 0 then
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
    if not class or not itemLevel or itemLevel <= 0 then
        Cache.applicantIds[applicantID] = nil
        C_Timer.After(0.1, function()
            self:OnApplicantUpdated(applicantID)
        end)
        return nil
    end

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
        -- Check if popups are enabled before processing
        if NCConfig and NCConfig:IsPopupOnIgnoredApplicants() then
            local applicantData = self:FormatIgnoredApplicant(name, class, localizedClass, specName, itemLevel, dungeonScore, realm,
                specID, filterReason, applicantID)

            -- Only show notification if it's not a class/spec filter
            if filterReason ~= Config.FILTERS.CLASS and filterReason ~= Config.FILTERS.SPEC then
                NemesisChat:Print(string.format("Filtered applicant: %s (%s)",
                    name,
                    self:GetIgnoreReasonText(filterReason)))
            end

            return applicantData
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

function LFGHandler:FormatIgnoredApplicant(name, class, localizedClass, specName, itemLevel, dungeonScore, realm, specID, reason, applicantID)
    if not name or not class or not specID or not reason or not applicantID then return nil end

    -- Get role and spec info
    local _, _, role, _, _, _, specIcon = GetSpecializationInfoByID(specID)

    return {
        info = {
            primary = {
                itemLevel = floor(itemLevel or 0),
                spec = specName or "Unknown",
                class = localizedClass or "Unknown",
                classFile = class,
                specIcon = specIcon
            },
            secondary = {
                dungeonScore = floor(dungeonScore or 0),
                realm = realm or "Unknown Realm"
            }
        },
        role = {
            type = role or "DAMAGER",
            texture = ROLE_ICONS[role or "DAMAGER"]
        },
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
            table.concat(plainEntries, ", "))

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

    -- Initialize or validate the queue
    if not Cache.ignoredQueue then
        Cache.ignoredQueue = {}
        return
    end

    -- Check if we should show popups
    if not NCConfig or not NCConfig:IsPopupOnIgnoredApplicants() then
        return
    end

    -- Cleanup stale entries
    self:CleanupIgnoredQueue()

    if #Cache.ignoredQueue == 0 then
        if Cache.ignoredPopup then
            Cache.ignoredPopup:Hide()
        end
        return
    end

    -- Create popup if it doesn't exist
    if not Cache.ignoredPopup then
        Cache.ignoredPopup = CreateIgnoredPopup()
    end
    local popup = Cache.ignoredPopup
    if not popup then
        NemesisChat:HandleError("ShowIgnoredPopup: Failed to create popup")
        return
    end

    -- Group entries by groupID (but keep singles separate)
    local groupedEntries = {}
    local singleEntries = {}

    for _, entry in ipairs(Cache.ignoredQueue) do
        if entry and entry.applicantID then
            if entry.groupID then
                groupedEntries[entry.groupID] = groupedEntries[entry.groupID] or {}
                table.insert(groupedEntries[entry.groupID], entry)
            else
                table.insert(singleEntries, entry)
            end
        end
    end

    -- Sort groups by size (larger groups first)
    local sortedGroups = {}
    for groupID, entries in pairs(groupedEntries) do
        if entries and #entries > 0 then
            table.insert(sortedGroups, entries)
        end
    end

    table.sort(sortedGroups, function(a, b)
        return (a[1].groupSize or 1) > (b[1].groupSize or 1)
    end)

    -- Reset all existing entries to hidden
    for _, entry in ipairs(popup.entries) do
        entry:Hide()
    end

    -- Create or update entries
    local yOffset = 0
    local entryIndex = 1

    -- First, handle grouped entries
    for _, group in ipairs(sortedGroups) do
        -- Create or reuse entry
        if not popup.entries[entryIndex] then
            popup.entries[entryIndex] = CreateGroupEntry(popup.content, entryIndex)
        end
        local entry = popup.entries[entryIndex]

        entry:ClearAllPoints()
        entry:SetPoint("TOPLEFT", popup.content, "TOPLEFT", 10, -yOffset)
        entry:SetPoint("TOPRIGHT", popup.content, "TOPRIGHT", -10, -yOffset)

        entry:UpdateDisplay(group)
        entry:Show()

        yOffset = yOffset + entry:GetHeight() + 10
        entryIndex = entryIndex + 1
    end

    -- Then, handle single entries
    for _, applicant in ipairs(singleEntries) do
        -- Create or reuse entry
        if not popup.entries[entryIndex] then
            popup.entries[entryIndex] = CreateApplicantEntry(popup.content, entryIndex)
        end
        local entry = popup.entries[entryIndex]

        entry:ClearAllPoints()
        entry:SetPoint("TOPLEFT", popup.content, "TOPLEFT", 10, -yOffset)
        entry:SetPoint("TOPRIGHT", popup.content, "TOPRIGHT", -10, -yOffset)

        entry:UpdateDisplay(applicant)
        entry:Show()

        yOffset = yOffset + entry:GetHeight() + 5
        entryIndex = entryIndex + 1
    end

    -- Update content height
    popup.content:SetHeight(math.max(yOffset, 1))
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
            (not applicant.isTest and not C_LFGList.GetApplicantInfo(applicant.applicantID)) then
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
