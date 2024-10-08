-----------------------------------------------------
-- INFO                                             -
-----------------------------------------------------
-- Retrieves, stores, and presents info which would -
-- be relevant to the user during M+ dungeons.      -
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Core info frame logic
-----------------------------------------------------

-- Models/Info.lua

NCInfo = {
    -- Configuration tables
    METRIC_REPLACEMENTS = {
        ["AvoidableDamage"] = "Avoidable Damage",
        ["CrowdControl"] = "CC Score",
        ["Affixes"] = "Affix Score",
        ["Pulls"] = "Unsafe Pulls",
    },

    ROLE_REPLACEMENTS = {
        ["DAMAGER"] = "DPS",
        ["HEALER"] = "Healer",
        ["TANK"] = "Tank",
        ["OTHER"] = "Other",
    },

    DropdownWidth = 150,

    -- State variables
    CurrentPlayer = UnitName("player"),
    SelectedChannel = nil,
    CustomWhisperTarget = nil,
    PreviousSelectedChannel = nil,
    MetricKeys = {}, -- Will be initialized as a sorted clone of NCRankings.METRICS's keys
    IsMinimized = false,

    -- Main frame
    StatsFrame = nil,

    -- Initialization function
    Initialize = function(self)
        if not IsNCEnabled() then return end

        self:_SetMetricKeys()

        -- Set default selected channel
        if not self.SelectedChannel then
            if IsInGroup(LE_PARTY_CATEGORY_HOME) then
                self.SelectedChannel = "PARTY"
            else
                self.SelectedChannel = "SAY"
            end
        end

        -- Create the main frame
        self:CreateMainFrame()

        -- Initial Update
        self:Update()
    end,

    CreateMainFrame = function(self)
        if not IsNCEnabled() or self.StatsFrame then return end

        local f = CreateFrame("Frame", "NemesisChatStatsFrame", UIParent, "BackdropTemplate")
        self.StatsFrame = f

        f:SetPoint("CENTER", UIParent, "CENTER")
        f:SetSize(400, 300)  -- Initial size

        f:SetMovable(true)
        f:SetResizable(true)
        f:SetClampedToScreen(true)
        f:SetUserPlaced(true)
        f:SetFrameStrata("MEDIUM")
        f:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 2,
            edgeSize = 2,
            insets = { left = 0, right = 0, top = 0, bottom = 0 }
        })
        f:SetBackdropColor(0, 0, 0, 0.4)
        f:SetBackdropBorderColor(0, 0, 0, 1)

        -- Title
        f.title = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        f.title:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -8)
        f.title:SetPoint("TOPRIGHT", f, "TOPRIGHT", -8, -8)
        f.title:SetText("NemesisChat")
        f.title:SetTextColor(0.50, 0.60, 1)
        f.title:SetJustifyH("CENTER")
        f.title:SetScript("OnMouseDown", function(_, button)
            if button == "LeftButton" then
                f:StartMoving()
            end
        end)
        f.title:SetScript("OnMouseUp", function()
            f:StopMovingOrSizing()
        end)

        -- Close Button
        f.closeButton = CreateFrame("Button", nil, f, "UIPanelCloseButton")
        f.closeButton:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)
        f.closeButton:SetSize(16, 16)
        f.closeButton:SetScript("OnClick", function()
            NCConfig:SetShowInfoFrame(false)
            f:Hide()
        end)

        -- Minimize Button
        f.minimizeButton = CreateFrame("Button", nil, f)
        f.minimizeButton:SetSize(16, 16)
        f.minimizeButton:SetPoint("RIGHT", f.closeButton, "LEFT", -5, 0)
        f.minimizeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-CollapseButton-Up")
        f.minimizeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-CollapseButton-Down")
        f.minimizeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
        f.minimizeButton:SetScript("OnClick", function()
            NCInfo:ToggleMinimize()
        end)

        -- Header Frame
        f.headerFrame = CreateFrame("Frame", nil, f)
        f.headerFrame:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -5)
        f.headerFrame:SetPoint("TOPRIGHT", f.title, "BOTTOMRIGHT", 0, -5)
        f.headerFrame:SetHeight(24)

        -- Header Text
        f.header = f.headerFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        f.header:SetAllPoints()
        f.header:SetTextColor(1, 0.60, 0)
        f.header:SetJustifyH("CENTER")

        -- Dropdown Frame
        f.dropdownFrame = CreateFrame("Frame", nil, f)
        f.dropdownFrame:SetPoint("TOPLEFT", f.headerFrame, "BOTTOMLEFT", 0, -5)
        f.dropdownFrame:SetPoint("TOPRIGHT", f.headerFrame, "BOTTOMRIGHT", 0, -5)
        f.dropdownFrame:SetHeight(24)

        -- Player Dropdown
        f.playerDropdown = CreateFrame("Frame", "NemesisChatStatsFramePlayerDropdown", f.dropdownFrame, "UIDropDownMenuTemplate")
        UIDropDownMenu_SetWidth(f.playerDropdown, self.DropdownWidth)
        UIDropDownMenu_SetText(f.playerDropdown, self.CurrentPlayer)
        UIDropDownMenu_Initialize(f.playerDropdown, function(self, level, menuList)
            NCInfo:UpdatePlayerDropdown()
        end)

        -- Center the player dropdown
        f.playerDropdown:SetPoint("CENTER", f.dropdownFrame, "CENTER", 0, 0)

        -- Previous Player Button
        f.prevPlayerButton = CreateFrame("Button", nil, f.dropdownFrame, "UIPanelButtonTemplate")
        f.prevPlayerButton:SetSize(24, 24)
        f.prevPlayerButton:SetPoint("RIGHT", f.playerDropdown, "LEFT", -2, 0)
        f.prevPlayerButton:SetText("<")
        f.prevPlayerButton:SetScript("OnClick", function()
            NCInfo:SelectPreviousPlayer()
        end)

        -- Next Player Button
        f.nextPlayerButton = CreateFrame("Button", nil, f.dropdownFrame, "UIPanelButtonTemplate")
        f.nextPlayerButton:SetSize(24, 24)
        f.nextPlayerButton:SetPoint("LEFT", f.playerDropdown, "RIGHT", 2, 0)
        f.nextPlayerButton:SetText(">")
        f.nextPlayerButton:SetScript("OnClick", function()
            NCInfo:SelectNextPlayer()
        end)

        -- Footer Frame
        f.footerFrame = CreateFrame("Frame", nil, f, "BackdropTemplate")
        f.footerFrame:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)
        f.footerFrame:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
        f.footerFrame:SetHeight(24)
        f.footerFrame:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 2,
            edgeSize = 2,
            insets = { left = 0, right = 0, top = 1, bottom = 0 }
        })
        f.footerFrame:SetBackdropColor(0, 0, 0, 0.15)
        f.footerFrame:SetBackdropBorderColor(0, 0, 0, 1)

        -- Channel Dropdown
        f.channelDropdown = CreateFrame("Frame", "NCInfoFooterChannelDropdown", f.footerFrame, "UIDropDownMenuTemplate")
        f.channelDropdown:SetPoint("LEFT", f.footerFrame, "LEFT", 4, 0)
        UIDropDownMenu_SetWidth(f.channelDropdown, 150)
        UIDropDownMenu_SetText(f.channelDropdown, "Channel: " .. (self:GetChannelDisplayName(self.SelectedChannel) or "Select Channel"))

        -- Initialize the channel dropdown
        self:InitializeChannelDropdown()

        -- Customize the dropdown appearance
        local dropdownName = f.channelDropdown:GetName()
        _G[dropdownName .. "Left"]:SetAlpha(0)
        _G[dropdownName .. "Middle"]:SetAlpha(0)
        _G[dropdownName .. "Right"]:SetAlpha(0)
        local button = _G[dropdownName .. "Button"]
        button:ClearAllPoints()
        button:SetPoint("LEFT", f.channelDropdown, "LEFT", 5, 0)
        button:SetSize(16, 16)
        local text = _G[dropdownName .. "Text"]
        text:ClearAllPoints()
        text:SetPoint("LEFT", button, "RIGHT", 2, 0)
        text:SetPoint("RIGHT", f.channelDropdown, "RIGHT", -2, 0)
        text:SetJustifyH("LEFT")
        text:SetTextColor(1, 0.82, 0)
        text:SetFontObject("GameFontWhiteSmall")
        f.channelDropdown:SetHeight(16)

        -- Clear Button
        f.clearButton = CreateFrame("Button", nil, f.footerFrame)
        f.clearButton:SetSize(16, 16)
        f.clearButton:SetPoint("RIGHT", f.footerFrame, "RIGHT", -24, 0)
        f.clearButton:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
        f.clearButton:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
        f.clearButton:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
        f.clearButton:SetScript("OnClick", function()
            NemesisChat:ClearAllData()
        end)
        f.clearButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
            GameTooltip:AddLine("Clear all data")
            GameTooltip:Show()
        end)
        f.clearButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        -- Resize Button
        f.resizeButton = CreateFrame("Button", nil, f)
        f.resizeButton:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
        f.resizeButton:SetSize(16, 16)
        f.resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        f.resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        f.resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
        f.resizeButton:SetScript("OnMouseDown", function(_, button)
            if button == "LeftButton" then
                f:StartSizing("BOTTOMRIGHT")
            end
        end)
        f.resizeButton:SetScript("OnMouseUp", function()
            f:StopMovingOrSizing()
        end)

        -- Scroll Frame
        f.scrollFrame = CreateFrame("ScrollFrame", "NCInfoScrollFrame", f, "UIPanelScrollFrameTemplate")
        f.scrollFrame:SetPoint("TOPLEFT", f.dropdownFrame, "BOTTOMLEFT", 0, -5)
        f.scrollFrame:SetPoint("BOTTOMRIGHT", f.footerFrame, "TOPRIGHT", -22, 5)

        -- Scroll Frame Content
        f.scrollFrame.scrollChild = CreateFrame("Frame", nil, f.scrollFrame)
        f.scrollFrame.scrollChild:SetSize(f.scrollFrame:GetWidth(), f.scrollFrame:GetHeight())
        f.scrollFrame:SetScrollChild(f.scrollFrame.scrollChild)

        -- Player Info Frame
        f.infoFrame = CreateFrame("Frame", nil, f.scrollFrame.scrollChild)
        f.infoFrame:SetPoint("TOPLEFT", f.scrollFrame.scrollChild, "TOPLEFT", 0, 0)
        f.infoFrame:SetPoint("TOPRIGHT", f.scrollFrame.scrollChild, "TOPRIGHT", 0, 0)
        f.infoFrame:SetHeight(20)

        f.infoFrame.text = f.infoFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        f.infoFrame.text:SetAllPoints()
        f.infoFrame.text:SetJustifyH("CENTER")

        f:SetPassThroughButtons("RightButton")
        f.title:SetPassThroughButtons("RightButton")
        f.headerFrame:SetPassThroughButtons("RightButton")
        f.footerFrame:SetPassThroughButtons("RightButton")
        f.scrollFrame:SetPassThroughButtons("RightButton")
        f.scrollFrame.scrollChild:SetPassThroughButtons("RightButton")
        f.infoFrame:SetPassThroughButtons("RightButton")
        f.clearButton:SetPassThroughButtons("RightButton")
        f.resizeButton:SetPassThroughButtons("RightButton")
        f.playerDropdown:SetPassThroughButtons("RightButton")
        f.prevPlayerButton:SetPassThroughButtons("RightButton")
        f.nextPlayerButton:SetPassThroughButtons("RightButton")
        f.channelDropdown:SetPassThroughButtons("RightButton")

        -- Initialize rows table
        f.scrollFrame.scrollChild.rows = f.scrollFrame.scrollChild.rows or {}

        if not f.resizeTimer then
            f.resizeTimer = C_Timer.NewTimer(0.1, function() end)
        end
        f:SetScript("OnSizeChanged", function()
            f.resizeTimer:Cancel()
            f.resizeTimer = C_Timer.NewTimer(0.1, function()
                NCInfo:OnResize()
            end)
        end)

        -- OnHide handler
        f:SetScript("OnHide", function()
            if IsNCEnabled() then
                f:StopMovingOrSizing()
            end
        end)
    end,

    -- OnResize function
    OnResize = function(self)
        if not IsNCEnabled() then return end
        if self.IsMinimized then return end

        local f = self.StatsFrame
        local scrollFrame = f.scrollFrame
        scrollFrame.scrollChild:SetWidth(scrollFrame:GetWidth())

        self:Update()
    end,

    -- Update function
    Update = function(self)
        if not IsNCEnabled() or not self.StatsFrame then return end

        local f = self.StatsFrame
        local content = f.scrollFrame.scrollChild
        local leftColWidth = 128

        local red = {0.85, 0.6, 0.5}
        local green = {0.5, 0.85, 0.6}
        local neutral = {0.5, 0.6, 0.85}
        local disabledColor = {0.25, 0.25, 0.25}

        local currentRoster = NCRuntime:GetGroupRoster()
        local mergedRoster = setmetatable({}, {__mode = "kv"})

        for player, rosterData in pairs(currentRoster) do
            mergedRoster[player] = rosterData
        end

        for player, snapshotData in pairs(NCDungeon.RosterSnapshot) do
            if not mergedRoster[player] then
                mergedRoster[player] = snapshotData
            else
                for key, value in pairs(snapshotData) do
                    if mergedRoster[player][key] == nil then
                        mergedRoster[player][key] = value
                    end
                end
            end
        end

        local playerInfo = mergedRoster[self.CurrentPlayer] or setmetatable({}, {__mode = "kv"})
        local race = playerInfo.race or UnitRace(self.CurrentPlayer) or ""
        local class = playerInfo.class or UnitClass(self.CurrentPlayer) or ""
        local rawClass = playerInfo.rawClass or select(2, UnitClass(self.CurrentPlayer)) or ""

        -- Update header
        if NCDungeon:GetIdentifier() == "" or NCDungeon:GetIdentifier() == "DUNGEON" then
            f.header:SetText(NemesisChat.CurrentPlayerLocation or "Dungeon Info & Stats")
        else
            if NCDungeon:GetLevel() == 0 then
                f.header:SetText(NCDungeon:GetIdentifier())
            else
                f.header:SetText(NCDungeon:GetIdentifier() .. " +" .. NCDungeon:GetLevel())
            end
        end

        -- Update player info text
        f.infoFrame.text:SetText(NCColors.ClassColor(rawClass, race .. " " .. class))

        -- Set player info text color to their class color
        local colorized = NCColors.ClassColor(rawClass, self.CurrentPlayer)

        -- Positioning variables
        local yOffset = -5  -- Start below the infoFrame
        local rowHeight = 20

        -- Adjust the position of infoFrame
        f.infoFrame:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
        f.infoFrame:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, 0)

        yOffset = yOffset - f.infoFrame:GetHeight() - 5

        -- Compare checkbox
        if not content.compareCheckbox then
            local checkbox = CreateFrame("CheckButton", nil, content, "ChatConfigCheckButtonTemplate")
            checkbox:SetSize(14, 14)
            checkbox:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
            checkbox:SetChecked(core.db.profile.infoClickCompare)
            checkbox:SetScript("OnClick", function(self)
                core.db.profile.infoClickCompare = self:GetChecked()
                NCInfo:Update()
            end)
            checkbox.text = checkbox:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            checkbox.text:SetPoint("LEFT", checkbox, "RIGHT", 2, 0)
            checkbox.text:SetText("Compare metrics")
            checkbox.text:SetTextColor(0.5, 0.6, 0.85)
            checkbox.text:SetJustifyH("LEFT")
            content.compareCheckbox = checkbox
        end
        local checkbox = content.compareCheckbox
        checkbox:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
        checkbox:Show()
        yOffset = yOffset - checkbox:GetHeight() - 5

        local isInGroup = IsInGroup()

        -- Update metric rows
        for _, key in ipairs(self.MetricKeys) do
            local metric = key
            local positive = NCRankings.METRICS[key]
            local greaterColor = positive and green or red
            local lesserColor = positive and red or green

            if not content.rows[metric] then
                local row = CreateFrame("Button", nil, content)
                row:SetHeight(rowHeight)
                row.columns = {}
                row.columns[1] = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
                row.columns[1]:SetPoint("LEFT", row, "LEFT", 0, 0)
                row.columns[1]:SetWidth(leftColWidth)
                row.columns[1]:SetJustifyH("LEFT")
                row.columns[1]:SetTextColor(0.5, 0.6, 0.85)
                row.columns[1].desiredColor = {0.5, 0.6, 0.85}

                row.columns[2] = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
                row.columns[2]:SetPoint("LEFT", row.columns[1], "RIGHT", 0, 0)
                row.columns[2]:SetPoint("RIGHT", row, "RIGHT", 0, 0)
                row.columns[2]:SetJustifyH("RIGHT")
                row.columns[2]:SetTextColor(0.5, 0.6, 0.85)
                row.columns[2].desiredColor = {0.5, 0.6, 0.85}

                content.rows[metric] = row

                row:SetScript("OnEnter", function(self)
                    self.columns[1]:SetTextColor(1, 1, 1)
                    self.columns[2]:SetTextColor(1, 1, 1)
                    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
                    GameTooltip:AddLine("Left click: Report to selected channel")
                    GameTooltip:Show()
                end)
                row:SetScript("OnLeave", function(self)
                    self.columns[1]:SetTextColor(unpack(self.columns[1].desiredColor))
                    self.columns[2]:SetTextColor(unpack(self.columns[2].desiredColor))
                    GameTooltip:Hide()
                end)
                row:SetScript("OnClick", function()
                    NCInfo:ReportMetric(metric, self.CurrentPlayer)
                end)
                row:SetPassThroughButtons("RightButton")
            end

            local row = content.rows[metric]
            row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
            row:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, yOffset)

            row.columns[1]:SetText(self.METRIC_REPLACEMENTS[metric] or metric)

            local playerStat = NCDungeon:GetStats(self.CurrentPlayer, metric)
            local myStat = NCDungeon:GetStats(UnitName("player"), metric)
            local delta = playerStat - myStat

            if core.db.profile.infoClickCompare and self.CurrentPlayer ~= UnitName("player") then
                if delta > 0 then
                    row.columns[2]:SetText(NemesisChat:FormatNumber(playerStat) .. " (+" .. NemesisChat:FormatNumber(delta) .. ")")
                    row.columns[2]:SetTextColor(unpack(greaterColor))
                    row.columns[2].desiredColor = greaterColor
                elseif delta < 0 then
                    row.columns[2]:SetText(NemesisChat:FormatNumber(playerStat) .. " (-" .. NemesisChat:FormatNumber(math.abs(delta)) .. ")")
                    row.columns[2]:SetTextColor(unpack(lesserColor))
                    row.columns[2].desiredColor = lesserColor
                else
                    row.columns[2]:SetText(NemesisChat:FormatNumber(playerStat))
                    row.columns[2]:SetTextColor(unpack(neutral))
                    row.columns[2].desiredColor = neutral
                end
            else
                row.columns[2]:SetText(NemesisChat:FormatNumber(playerStat))
                row.columns[2]:SetTextColor(unpack(neutral))
                row.columns[2].desiredColor = neutral
            end

            yOffset = yOffset - rowHeight

            if isInGroup and not NCRankings:IsMetricApplicable(metric, self.CurrentPlayer) then
                row.columns[1]:SetTextColor(unpack(disabledColor))
                row.columns[1].desiredColor = disabledColor
                row.columns[2]:SetTextColor(unpack(disabledColor))
                row.columns[2].desiredColor = disabledColor

                row:SetScript("OnEnter", function(self)
                    self.columns[1]:SetTextColor(1, 1, 1)
                    self.columns[1].desiredColor = disabledColor
                    self.columns[2]:SetTextColor(1, 1, 1)
                    self.columns[2].desiredColor = disabledColor
                    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
                    GameTooltip:AddLine("Left click: Report to selected channel.\n\nNOTE: This metric is likely not ideal for this player.")
                    GameTooltip:Show()
                end)
            else
                row.columns[1]:SetTextColor(0.5, 0.6, 0.85)
                row.columns[1].desiredColor = {0.5, 0.6, 0.85}
                row.columns[2]:SetTextColor(0.5, 0.6, 0.85)
                row.columns[2].desiredColor = {0.5, 0.6, 0.85}

                row:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
                    GameTooltip:AddLine("Left click: Report to selected channel")
                    GameTooltip:Show()
                end)
            end
        end

        -- Adjust the scrollChild height
        content:SetHeight(math.abs(yOffset))

        -- Calculate minimum height components
        local f = self.StatsFrame
        local titleHeight = f.title:GetHeight() + 8  -- Include top padding
        local headerFrameHeight = f.headerFrame:GetHeight() + 5  -- Include spacing
        local dropdownFrameHeight = f.dropdownFrame:GetHeight() + 5  -- Include spacing
        local infoFrameHeight = f.infoFrame:GetHeight() + 5  -- Include spacing
        local compareCheckboxHeight = 0
        if content.compareCheckbox and content.compareCheckbox:IsShown() then
            compareCheckboxHeight = content.compareCheckbox:GetHeight() + 5  -- Include spacing
        end
        local contentHeight = math.abs(yOffset)
        local footerFrameHeight = f.footerFrame:GetHeight() + 5  -- Include bottom padding

        -- Calculate total minimum height
        local minHeight = titleHeight + headerFrameHeight + dropdownFrameHeight + infoFrameHeight + compareCheckboxHeight + contentHeight + footerFrameHeight

        -- Set a reasonable minimum width
        local minWidth = 48 + 8 + self.DropdownWidth + 8 + 48

        -- Set the minimum size of the frame
        if not self.IsMinimized then
            -- Set the minimum size while expanded
            f:SetResizeBounds(minWidth, minHeight)
        else
            -- Set minimum size to current minimized size
            local minimizedHeight = f:GetHeight()
            f:SetResizeBounds(minWidth, minimizedHeight)
        end

        if minWidth > f:GetWidth() then
            f:SetWidth(minWidth)
        end

        if minHeight > f:GetHeight() then
            f:SetHeight(minHeight)
        end

        if self.IsMinimized then
            f.footerFrame:Hide()
            f.scrollFrame:Hide()
            f.dropdownFrame:Hide()
            f.resizeButton:Hide()
        else
            f.footerFrame:Show()
            f.scrollFrame:Show()
            f.dropdownFrame:Show()
            f.resizeButton:Show()
        end

        -- Update player dropdown text
        UIDropDownMenu_SetText(f.playerDropdown, self.CurrentPlayer)

        -- Update previous/next buttons
        self:UpdatePrevNextButtons()
    end,

    -- Update player dropdown
    UpdatePlayerDropdown = function(self)
        if not self.StatsFrame then
            return
        end

        UIDropDownMenu_SetText(self.StatsFrame.playerDropdown, self.CurrentPlayer)
        UIDropDownMenu_Initialize(self.StatsFrame.playerDropdown, function(dropdown, level, menuList)
        local roster = NCRuntime:GetGroupRoster()
        local snapshot = NCDungeon.RosterSnapshot
        local mergedData = MapMerge(snapshot, roster)

        for name, player in pairs(mergedData) do
            local info = UIDropDownMenu_CreateInfo()
            local class = player.class or UnitClass(name) or "Unknown"
            local rawClass = player.rawClass or select(2, UnitClass(name)) or "Unknown"
            local role = player.role or UnitGroupRolesAssigned(name) or "OTHER"
            local replacedRole = self.ROLE_REPLACEMENTS[role] or "Other"
            local infoString = class .. " " .. replacedRole
            local colorized = NCColors.ClassColor(rawClass, name .. " (" .. infoString .. ")")

            if name == UnitName("player") then
                colorized = NCColors.Emphasize(name)
            end

            info.text = colorized
            info.value = name
            info.checked = (name == self.CurrentPlayer)
            info.func = function(self)
                NCInfo.CurrentPlayer = self.value
                NCInfo:Update()
            end
            UIDropDownMenu_AddButton(info)
        end
        end)
    end,

    -- Initialize channel dropdown
    InitializeChannelDropdown = function(self)
        if not IsNCEnabled() or not self.StatsFrame then return end

        local f = self.StatsFrame
        if not f then return end

        -- Set up the dropdown menu if it hasn't been set up already
        if not self.channelDropdownInitialized then
            UIDropDownMenu_SetInitializeFunction(f.channelDropdown, function(dropdown, level, menuList)
                NCInfo:RefreshChannelDropdown(dropdown, level, menuList)
            end)
            -- UIDropDownMenu_SetDisplayMode(f.channelDropdown, "MENU")
            self.channelDropdownInitialized = true
        end
    end,

    RefreshChannelDropdown = function(self, dropdown, level, menuList)
        if not IsNCEnabled() or not self.StatsFrame then return end

        local channels = self:_GetAvailableChannels()
        dropdown = dropdown or self.StatsFrame.channelDropdown

        -- Check if the currently selected channel is still available
        local selectedChannelAvailable = false
        for _, channelInfo in ipairs(channels) do
            if channelInfo.value == self.SelectedChannel then
                selectedChannelAvailable = true
                break
            end
        end

        -- If not available, reset to default channel
        if not selectedChannelAvailable then
            self.SelectedChannel = self:GetDefaultChannel()
        end

        -- Clear existing menu items
        UIDropDownMenu_ClearAll(dropdown)

        -- Create new menu items
        for _, channelInfo in ipairs(channels) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = channelInfo.text
            info.value = channelInfo.value
            info.func = function(itemSelf)
                if itemSelf.value == "WHISPER_CUSTOM" then
                    NCInfo.PreviousSelectedChannel = NCInfo.SelectedChannel
                    StaticPopup_Show("NCINFO_CUSTOM_WHISPER")
                else
                    NCInfo.SelectedChannel = itemSelf.value
                    local displayText = NCInfo:GetChannelDisplayName(itemSelf.value)
                    UIDropDownMenu_SetText(dropdown, "Channel: " .. displayText)
                end
            end
            info.checked = (self.SelectedChannel == channelInfo.value)
            UIDropDownMenu_AddButton(info, level)
        end

        -- Update the displayed text
        local displayText = self:GetChannelDisplayName(self.SelectedChannel)
        UIDropDownMenu_SetText(dropdown, "Channel: " .. displayText)
    end,

    -- Get channel display name
    GetChannelDisplayName = function(self, channelValue)
        if not channelValue then return "Select Channel" end
        if string.find(channelValue, "WHISPER_") then
            local name = string.sub(channelValue, 9)
            if name == "CUSTOM" then
                return "Whisper: " .. (self.CustomWhisperTarget or "Custom")
            elseif name == "TARGET" then
                return "Whisper: Targeted Player"
            else
                return "Whisper: " .. name
            end
        end

        local channelNames = {
            ["SAY"] = "Say",
            ["PARTY"] = "Party",
            ["INSTANCE_CHAT"] = "Instance",
            ["RAID"] = "Raid",
            ["GUILD"] = "Guild",
            ["OFFICER"] = "Officer",
        }
        return channelNames[channelValue] or channelValue
    end,

    -- Get default channel
    GetDefaultChannel = function(self)
        if IsInGroup(LE_PARTY_CATEGORY_HOME) then
            return "PARTY"
        else
            return "SAY"
        end
    end,

    -- Report the clicked metric to the preferred channel
    ReportMetric = function(self, metric, player)
        if not IsNCEnabled() then return end

        local channel = self.SelectedChannel or NemesisChat:GetActualChannel("GROUP")
        local message = ""

        -- Handle whisper target
        if channel == "WHISPER_TARGET" then
            if not UnitExists("target") or not UnitIsPlayer("target") then
                NemesisChat:Print("You must target a player to whisper, or change the channel.")
                return
            else
                local targetName = GetUnitName("target", true)
                self.WhisperTarget = targetName
                channel = "WHISPER"
            end
        elseif string.find(channel, "WHISPER_") then
            local target = string.sub(channel, 9)
            if target == "CUSTOM" then
                if not self.CustomWhisperTarget or self.CustomWhisperTarget == "" then
                    NemesisChat:Print("No custom whisper target set.")
                    return
                else
                    self.WhisperTarget = self.CustomWhisperTarget
                    channel = "WHISPER"
                end
            else
                self.WhisperTarget = target
                channel = "WHISPER"
            end
        else
            -- Validate channel availability
            if channel == "PARTY" and not IsInGroup(LE_PARTY_CATEGORY_HOME) then
                NemesisChat:Print("You are not in a party.")
                return
            elseif channel == "RAID" and not IsInRaid(LE_PARTY_CATEGORY_HOME) then
                NemesisChat:Print("You are not in a raid.")
                return
            elseif channel == "INSTANCE_CHAT" and not IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
                NemesisChat:Print("You are not in an instance group.")
                return
            elseif channel == "GUILD" and not IsInGuild() then
                NemesisChat:Print("You are not in a guild.")
                return
            elseif channel == "OFFICER" and not (C_GuildInfo and C_GuildInfo.CanSpeakInOfficerChat and C_GuildInfo.CanSpeakInOfficerChat()) then
                NemesisChat:Print("You do not have permission to speak in the officer channel.")
                return
            end
        end

        -- Construct the message
        if player == UnitName("player") then
            message = string.format("My %s (Dungeon): %s", (self.METRIC_REPLACEMENTS[metric] or metric), NemesisChat:FormatNumber(NCDungeon:GetStats(player, metric)))
        else
            message = string.format("%s for %s (Dungeon): %s", (self.METRIC_REPLACEMENTS[metric] or metric), player, NemesisChat:FormatNumber(NCDungeon:GetStats(player, metric)))
            if core.db.profile.infoClickCompare then
                local delta = NCDungeon:GetStats(player, metric) - NCDungeon:GetStats(UnitName("player"), metric)
                if delta > 0 then
                    message = message .. string.format(" (%s higher than mine)", NemesisChat:FormatNumber(delta))
                elseif delta < 0 then
                    message = message .. string.format(" (%s lower than mine)", NemesisChat:FormatNumber(math.abs(delta)))
                else
                    message = message .. " (same as mine)"
                end
            end
        end

        -- Send the message
        if channel == "WHISPER" then
            SendChatMessage(message, channel, nil, self.WhisperTarget)
        else
            SendChatMessage(message, channel)
        end
    end,

    -- Update previous/next buttons
    UpdatePrevNextButtons = function(self)
        if not IsNCEnabled() then return end

        local f = self.StatsFrame
        local roster = NCRuntime:GetGroupRoster()
        local snapshot = NCDungeon.RosterSnapshot
        local mergedData = MapMerge(snapshot, roster)
        local playerList = {}
        for name in pairs(mergedData) do
            table.insert(playerList, name)
        end
        table.sort(playerList)

        -- Disable buttons if not in a party
        if #playerList <= 1 then
            f.prevPlayerButton:Disable()
            f.nextPlayerButton:Disable()
            return
        else
            f.prevPlayerButton:Enable()
            f.nextPlayerButton:Enable()
        end
    end,

    -- Select previous player
    SelectPreviousPlayer = function(self)
        if not IsNCEnabled() then return end

        local roster = NCRuntime:GetGroupRoster()
        local snapshot = NCDungeon.RosterSnapshot
        local mergedData = MapMerge(snapshot, roster)
        local playerList = {}
        for name in pairs(mergedData) do
            table.insert(playerList, name)
        end
        --table.sort(playerList)

        local currentIndex = nil
        for index, name in ipairs(playerList) do
            if name == self.CurrentPlayer then
                currentIndex = index
                break
            end
        end

        if currentIndex then
            local prevIndex = currentIndex - 1
            if prevIndex < 1 then
                prevIndex = #playerList
            end
            self.CurrentPlayer = playerList[prevIndex]
            self:Update()
        end
    end,

    -- Select next player
    SelectNextPlayer = function(self)
        if not IsNCEnabled() then return end

        local roster = NCRuntime:GetGroupRoster()
        local snapshot = NCDungeon.RosterSnapshot
        local mergedData = MapMerge(snapshot, roster)
        local playerList = {}
        for name in pairs(mergedData) do
            table.insert(playerList, name)
        end
        --table.sort(playerList)

        local currentIndex = nil
        for index, name in ipairs(playerList) do
            if name == self.CurrentPlayer then
                currentIndex = index
                break
            end
        end

        if currentIndex then
            local nextIndex = currentIndex + 1
            if nextIndex > #playerList then
                nextIndex = 1
            end
            self.CurrentPlayer = playerList[nextIndex]
            self:Update()
        end
    end,

    ToggleMinimize = function(self)
        if not IsNCEnabled() or not self.StatsFrame then return end

        local f = self.StatsFrame
        if self.IsMinimized then
            -- Expand the frame
            self.IsMinimized = false
            f.minimizeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-CollapseButton-Up")
            f.minimizeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-CollapseButton-Down")
            f.minimizeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-CollapseButton-Highlight")

            -- Show all elements
            f:SetHeight(self.ExpandedHeight or 300)  -- Restore previous height or default
            f:SetResizable(true)
            f.resizeButton:Show()
            f.footerFrame:Show()
            f.scrollFrame:Show()
            f.dropdownFrame:Show()
            f.resizeButton:Show()
            self:Update()
        else
            -- Minimize the frame
            self.IsMinimized = true
            f.minimizeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-ExpandButton-Up")
            f.minimizeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-ExpandButton-Down")
            f.minimizeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-ExpandButton-Highlight")

            -- Save current height
            self.ExpandedHeight = f:GetHeight()

            self:ShowMinimized()
        end
    end,

    -- Called when the group composition changes
    OnGroupChanged = function(self)
        if not IsNCEnabled() or not self.StatsFrame or not self.StatsFrame:IsShown() then return end

        if self.StatsFrame and self.StatsFrame:IsShown() then
            -- Refresh the dropdown menu
            UIDropDownMenu_Refresh(self.StatsFrame.channelDropdown)
        end
    end,

    Enable = function(self)
        if not self.StatsFrame then
            self:Initialize()
        else
            self.StatsFrame:Show()
        end
        self:Update()
    end,

    Disable = function(self)
        if self.StatsFrame then
            self.StatsFrame:Hide()
        end
    end,

    ShowMinimized = function(self)
        if not IsNCEnabled() or not self.StatsFrame then return end

        local f = self.StatsFrame
        local titleHeight = f.title:GetHeight() + 8  -- Include top padding
        local headerFrameHeight = f.headerFrame:GetHeight() + 5  -- Include spacing
        local newHeight = titleHeight + headerFrameHeight + 10  -- Add extra padding

        f:SetHeight(newHeight)
        f:SetResizable(false)
        f.resizeButton:Hide()
        f.footerFrame:Hide()
        f.scrollFrame:Hide()
        f.dropdownFrame:Hide()
        f.resizeButton:Hide()
    end,

    _SetMetricKeys = function(self)
        local keys = NemesisChat:GetKeys(NCRankings.METRICS)
        table.sort(keys)
        self.MetricKeys = keys
    end,

    -- Generate the list of available channels based on current group state
    _GetAvailableChannels = function(self)
        local channels = {}

        -- Always available channels
        table.insert(channels, { text = "Say", value = "SAY" })
        if IsInGuild() then
            table.insert(channels, { text = "Guild", value = "GUILD" })
        end

        -- "Whisper: Targeted Player" option
        table.insert(channels, { text = "Whisper: Targeted Player", value = "WHISPER_TARGET" })

        -- Context-sensitive channels
        if IsInGroup(LE_PARTY_CATEGORY_HOME) then
            table.insert(channels, { text = "Party", value = "PARTY" })
        end
        if IsInRaid(LE_PARTY_CATEGORY_HOME) then
            table.insert(channels, { text = "Raid", value = "RAID" })
        end
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            table.insert(channels, { text = "Instance", value = "INSTANCE_CHAT" })
        end
        if C_GuildInfo and C_GuildInfo.CanSpeakInOfficerChat and C_GuildInfo.CanSpeakInOfficerChat() then
            table.insert(channels, { text = "Officer", value = "OFFICER" })
        end

        -- Whisper options
        if IsInGroup() then
            local numGroupMembers = GetNumGroupMembers()
            local unitPrefix = IsInRaid() and "raid" or "party"
            local startIndex = IsInRaid() and 1 or 0
            for i = startIndex, numGroupMembers do
                local unit = i == 0 and "player" or unitPrefix .. i
                if UnitExists(unit) then
                    local name, realm = UnitName(unit)
                    if realm and realm ~= "" then
                        name = name .. "-" .. realm
                    end
                    table.insert(channels, { text = "Whisper: " .. name, value = "WHISPER_" .. name })
                end
            end
        else
            -- Add player (self) for completeness
            local myName = GetUnitName("player", true)
            table.insert(channels, { text = "Whisper: " .. myName, value = "WHISPER_" .. myName })
        end

        -- Custom whisper option
        table.insert(channels, { text = "Whisper: Custom", value = "WHISPER_CUSTOM" })

        return channels
    end,
}

-- Static Popup Dialog for Custom Whisper Target
StaticPopupDialogs["NCINFO_CUSTOM_WHISPER"] = {
    text = "Enter the name of the player to whisper:",
    button1 = "OK",
    button2 = "Cancel",
    OnAccept = function(self)
        local text = self.editBox:GetText()
        if text and text ~= "" then
            NCInfo.CustomWhisperTarget = text
            NCInfo.SelectedChannel = "WHISPER_CUSTOM"
            local displayText = "Channel: Whisper: " .. text
            UIDropDownMenu_SetText(NCInfo.StatsFrame.channelDropdown, displayText)
        else
            -- Restore the previous channel selection
            NCInfo.SelectedChannel = NCInfo.PreviousSelectedChannel or NCInfo:GetDefaultChannel()
            local displayText = "Channel: " .. (NCInfo:GetChannelDisplayName(NCInfo.SelectedChannel) or "Select Channel")
            UIDropDownMenu_SetText(NCInfo.StatsFrame.channelDropdown, displayText)
        end
        -- Clear the stored previous channel
        NCInfo.PreviousSelectedChannel = nil
    end,
    OnCancel = function(self)
        -- Restore the previous channel selection
        NCInfo.SelectedChannel = NCInfo.PreviousSelectedChannel or NCInfo:GetDefaultChannel()
        local displayText = "Channel: " .. (NCInfo:GetChannelDisplayName(NCInfo.SelectedChannel) or "Select Channel")
        UIDropDownMenu_SetText(NCInfo.StatsFrame.channelDropdown, displayText)
        -- Clear the stored previous channel
        NCInfo.PreviousSelectedChannel = nil
    end,
    hasEditBox = true,
    editBoxWidth = 200,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

function NCInfo:OnEnableStateChanged(enabled)
    if enabled then
        self:Enable()
    else
        self:Disable()
    end
end
