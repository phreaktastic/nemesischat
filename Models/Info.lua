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

local function TruncateName(name, maxLength)
    if #name > maxLength then
        return name:sub(1, maxLength - 3) .. "..."
    end
    return name
end

local function GetMaxChannelTextLength(frame)
    local width = frame:GetWidth()

    local baseLength = 18
    local widthPerChar = 6
    local additionalWidth = width - 200 -- 200 is our minimum width
    local additionalChars = math.floor(additionalWidth / widthPerChar)
    return baseLength + additionalChars
end

local function GetMaxDropdownTextLength(frame)
    local width = frame:GetWidth()
    local baseLength = 12
    local widthPerChar = 6
    local additionalWidth = (width - NCInfo.DropdownWidth) or (width - 150)
    local additionalChars = math.floor(additionalWidth / widthPerChar)
    return baseLength + additionalChars
end

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

    DropdownWidth = 120,

    -- State variables
    CurrentPlayer = UnitName("player"),
    SelectedChannel = nil,
    CustomWhisperTarget = nil,
    PreviousSelectedChannel = nil,
    MetricKeys = {}, -- Will be initialized as a sorted clone of NCRankings.METRICS's keys
    IsMinimized = false,
    hasBeenExpanded = false,
    ExpandedHeight = 300,  -- Default height

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

        -- Only update if the frame was successfully created
        if self.StatsFrame then
            self:Update()
        end
    end,

    CreateMainFrame = function(self)
        if not IsNCEnabled() or self.StatsFrame then return end

        local f = CreateFrame("Frame", "NemesisChatStatsFrame", UIParent, "BackdropTemplate")
        self.StatsFrame = f

        f:SetPoint("CENTER", UIParent, "CENTER")
        f:SetSize(200, 300)         -- Initial size
        f:SetResizeBounds(200, 220) -- Initial minimum size

        NemesisChat:RegisterConfig(f, "NemesisChatStatsFrameDB")
        NemesisChat:RestorePosition(f)

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
            NemesisChat:SavePosition(NCInfo.StatsFrame)
        end)

        -- Close Button
        f.closeButton = CreateFrame("Button", nil, f, "UIPanelCloseButton UIPanelButtonTemplate")
        f.closeButton:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)
        f.closeButton:SetSize(16, 16)
        f.closeButton.tooltipText = format("%s\n\nYou may use %s to re-open.", NCColors.Emphasize("Close the info frame"), NCColors.MetricsNeutral("/nc showinfo"))
        f.closeButton:SetScript("OnClick", function()
            NCConfig:SetShowInfoFrame(false)
            f:Hide()
        end)

        -- Minimize Button
        f.minimizeButton = CreateFrame("Button", nil, f, "UIPanelCloseButton UIPanelButtonTemplate")
        f.minimizeButton:SetPoint("RIGHT", f.closeButton, "LEFT", 0, 0)
        f.minimizeButton:SetSize(16, 16)
        f.minimizeButton:SetNormalAtlas("RedButton-Condense")
        f.minimizeButton:SetPushedAtlas("RedButton-Condense-Pressed")
        f.minimizeButton:SetDisabledAtlas("RedButton-Condense-Disabled")
        f.minimizeButton:SetHighlightAtlas("RedButton-Highlight")
        f.minimizeButton.tooltipText = NCColors.Emphasize("Minimize the info frame.")
        f.minimizeButton:SetScript("OnClick", function()
            NCInfo:ToggleMinimize()
        end)

        -- Header Frame
        f.headerFrame = CreateFrame("Frame", nil, f)
        f.headerFrame:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, 0)
        f.headerFrame:SetPoint("TOPRIGHT", f.title, "BOTTOMRIGHT", 0, 0)
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
        f.playerDropdown = CreateFrame("Frame", "NCInfoPlayerDropdown", f.dropdownFrame, "UIDropDownMenuTemplate")
        f.playerDropdown:SetPoint("LEFT", f.dropdownFrame, "LEFT", 30, 0)
        f.playerDropdown:SetPoint("RIGHT", f.dropdownFrame, "RIGHT", -30, 0)
        UIDropDownMenu_SetWidth(f.playerDropdown, f:GetWidth() - 60)

        -- Customize the dropdown appearance
        local dropdownName = f.playerDropdown:GetName()
        _G[dropdownName .. "Left"]:SetAlpha(0)
        _G[dropdownName .. "Middle"]:SetAlpha(0)
        _G[dropdownName .. "Right"]:SetAlpha(0)
        local button = _G[dropdownName .. "Button"]
        button:ClearAllPoints()
        button:SetPoint("LEFT", f.playerDropdown, "LEFT", 5, 0)
        button:SetSize(16, 16)
        local text = _G[dropdownName .. "Text"]
        text:ClearAllPoints()
        text:SetPoint("LEFT", button, "RIGHT", 2, 0)
        text:SetPoint("RIGHT", f.playerDropdown, "RIGHT", -2, 0)
        text:SetJustifyH("LEFT")
        text:SetTextColor(1, 0.82, 0)
        text:SetFontObject("GameFontWhiteSmall")
        text:SetText(self.CurrentPlayer)
        f.playerDropdown:SetHeight(16)

        -- Set initial text
        local truncatedName = TruncateName(self.CurrentPlayer, 12)
        UIDropDownMenu_SetText(f.playerDropdown, truncatedName)

        -- Previous Player Button
        f.prevPlayerButton = CreateFrame("Button", nil, f.dropdownFrame, "UIPanelButtonTemplate")
        f.prevPlayerButton:SetSize(20, 20)
        f.prevPlayerButton:SetPoint("LEFT", f.dropdownFrame, "LEFT", 2, 0)
        f.prevPlayerButton:SetText("<")
        f.prevPlayerButton:SetScript("OnClick", function()
            NCInfo:SelectPreviousPlayer()
        end)

        -- Next Player Button
        f.nextPlayerButton = CreateFrame("Button", nil, f.dropdownFrame, "UIPanelButtonTemplate")
        f.nextPlayerButton:SetSize(20, 20)
        f.nextPlayerButton:SetPoint("RIGHT", f.dropdownFrame, "RIGHT", -2, 0)
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
        UIDropDownMenu_SetWidth(f.channelDropdown, 100)
        local display = TruncateName(
            "Channel: " .. (self:GetChannelDisplayName(self.SelectedChannel) or "Select Channel"), 24)
        UIDropDownMenu_SetText(f.channelDropdown, display)

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
            NemesisChat:SavePosition(NCInfo.StatsFrame)
        end)

        -- Scroll Frame
        f.scrollFrame = CreateFrame("ScrollFrame", "NCInfoScrollFrame", f, "UIPanelScrollFrameTemplate")
        f.scrollFrame:SetPoint("TOPLEFT", f.dropdownFrame, "BOTTOMLEFT", 0, -5)
        f.scrollFrame:SetPoint("BOTTOMRIGHT", f.footerFrame, "TOPRIGHT", -24, 5)

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
        f.minimizeButton:SetPassThroughButtons("RightButton")
        f.closeButton:SetPassThroughButtons("RightButton")

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

        -- OnShow handler
        f:SetScript("OnShow", function()
            if IsNCEnabled() then
                self:UpdateDropdownText()
            end
        end)

        -- OnHide handler
        f:SetScript("OnHide", function()
            if IsNCEnabled() then
                f:StopMovingOrSizing()
            end
        end)

        self:CreateCompareCheckbox()
        self:InitializePlayerDropdown()
        self:UpdateLayout()
    end,

    CreateCompareCheckbox = function(self)
        local f = self.StatsFrame
        local content = f.scrollFrame.scrollChild
        if not content.compareCheckbox then
            content.compareCheckbox = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
            content.compareCheckbox:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -5)
            content.compareCheckbox:SetSize(16, 16) -- Set a smaller size
            content.compareCheckbox:SetScript("OnClick", function(self)
                NCConfig:Set("infoClickCompare", self:GetChecked())
                NCInfo:Update()
            end)
            content.compareCheckbox.text = content.compareCheckbox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            content.compareCheckbox.text:SetPoint("LEFT", content.compareCheckbox, "RIGHT", 2, 0) -- Adjusted text position
            content.compareCheckbox.text:SetText("Compare Metrics")
            content.compareCheckbox.text:SetFontObject("GameFontNormalSmall")                     -- Use a smaller font
        end
    end,

    -- OnResize function
    OnResize = function(self)
        if not IsNCEnabled() then return end
        if self.IsMinimized then return end

        self:SetWidthsAndTruncatedTexts()
        self:Update()
    end,

    SetWidthsAndTruncatedTexts = function(self)
        local f = self.StatsFrame
        local scrollFrame = f.scrollFrame
        scrollFrame.scrollChild:SetWidth(scrollFrame:GetWidth())

        -- Update channel dropdown text
        local maxChannelLength = GetMaxChannelTextLength(f)
        local channelDisplayText = TruncateName(self:GetChannelDisplayName(self.SelectedChannel), maxChannelLength)
        UIDropDownMenu_SetText(f.channelDropdown, "Channel: " .. channelDisplayText)

        -- Update player dropdown text
        local maxPlayerLength = GetMaxDropdownTextLength(f)
        local playerDisplayText = TruncateName(self.CurrentPlayer, maxPlayerLength)
        UIDropDownMenu_SetText(f.playerDropdown, playerDisplayText)
    end,

    -- Update function
    Update = function(self)
        if not IsNCEnabled() or not self.StatsFrame then return end

        local dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()

        -- Only auto-minimize on first load or when explicitly requested
        if not dungeonData and not self.IsMinimized and not self.hasBeenExpanded then
            self:ShowMinimized()
            return
        end

        -- Allow updates while minimized if user is trying to expand
        if self.IsMinimized and not self.hasBeenExpanded then
            return
        end

        self:UpdateHeader()
        self:UpdatePlayerInfo(dungeonData)
        self:UpdateCompareCheckbox()
        self:UpdateMetrics(dungeonData)
        self:UpdateLayout()
        self:UpdateDropdownText()
        self:UpdateChannelDropdown()
        self:UpdatePrevNextButtons(dungeonData)
        self:UpdatePlayerDropdown()
        self:SetWidthsAndTruncatedTexts()
    end,

    UpdateHeader = function(self)
        if not self.StatsFrame or not self.StatsFrame.header then return end

        local dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()
        local headerText = "Dungeon Statistics"  -- Default title

        if dungeonData then
            -- Try to get identifier from either direct property or method
            local identifier = dungeonData.Identifier or (dungeonData.GetIdentifier and dungeonData:GetIdentifier())
            local level = dungeonData.Level or (dungeonData.GetLevel and dungeonData:GetLevel())

            if identifier and identifier ~= "" and identifier ~= "DUNGEON" then
                if level and level > 0 then
                    headerText = identifier .. " +" .. level
                else
                    headerText = identifier
                end
            end
        end

        self.StatsFrame.header:SetText(headerText)
    end,

    UpdatePlayerInfo = function(self, dungeonData)
        if not dungeonData then
            dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()
        end
        local playerInfo = dungeonData and dungeonData.RosterSnapshot[self.CurrentPlayer] or {}

        local leftText = playerInfo.spec or nil
        local rightText = playerInfo.class or nil
        local rawClass = playerInfo.rawClass or nil
        local role = playerInfo.role or UnitGroupRolesAssigned(self.CurrentPlayer) or "OTHER"

        if leftText == "Unknown" then
            leftText = nil
        end

        -- Map OTHER/DPS role to DAMAGER for icon lookup
        local iconRole = role
        if role == "OTHER" or role == "DPS" then
            iconRole = "DAMAGER"
        end

        local infoText = leftText
            and NCColors.ClassColor(rawClass, leftText .. " " .. rightText)
            or NCColors.ClassColor(rawClass, rightText)

        -- Only add icon if we have a valid role
        local roleIcon = IconTable:GetIconString("Role", iconRole, 20)
        self.StatsFrame.infoFrame.text:SetText((roleIcon ~= "" and roleIcon .. "  " or "") .. (infoText or ""))
    end,

    UpdateCompareCheckbox = function(self)
        local checkbox = self.StatsFrame.scrollFrame.scrollChild.compareCheckbox
        if not checkbox then return end

        local dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()
        if not dungeonData then
            checkbox:Hide()
            return
        end

        checkbox:Show()
        checkbox:SetChecked(NCConfig:Get("infoClickCompare"))
    end,

    UpdateMetrics = function(self, dungeonData)
        if not dungeonData then
            dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()
        end

        local content = self.StatsFrame.scrollFrame.scrollChild

        -- Hide all metric rows initially
        for _, row in pairs(content.rows) do
            row:Hide()
        end

        -- Disable UI elements when no data
        local hasData = dungeonData ~= nil

        -- Disable dropdowns
        if hasData then
            UIDropDownMenu_EnableDropDown(self.StatsFrame.playerDropdown)
            UIDropDownMenu_EnableDropDown(self.StatsFrame.channelDropdown)
        else
            UIDropDownMenu_DisableDropDown(self.StatsFrame.playerDropdown)
            UIDropDownMenu_DisableDropDown(self.StatsFrame.channelDropdown)
        end

        -- Update clear button
        if self.StatsFrame.clearButton then
            self.StatsFrame.clearButton:SetEnabled(hasData)
            if hasData then
                self.StatsFrame.clearButton:GetNormalTexture():SetDesaturated(false)
                self.StatsFrame.clearButton:GetHighlightTexture():SetDesaturated(false)
                self.StatsFrame.clearButton:GetPushedTexture():SetDesaturated(false)
            else
                self.StatsFrame.clearButton:GetNormalTexture():SetDesaturated(true)
                self.StatsFrame.clearButton:GetHighlightTexture():SetDesaturated(true)
                self.StatsFrame.clearButton:GetPushedTexture():SetDesaturated(true)
            end
        end

        -- Hide compare checkbox when no data
        if content.compareCheckbox then
            content.compareCheckbox:SetShown(hasData)
        end

        if not hasData then
            -- Show message if not already created
            if not content.emptyStateText then
                content.emptyStateText = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
                content.emptyStateText:SetPoint("CENTER", content, "CENTER", 0, 20)
                -- Using auto-wrapping text
                content.emptyStateText:SetWidth(content:GetWidth() - 40) -- 20px padding on each side
                content.emptyStateText:SetText("Dungeon statistics will appear when you enter or complete a dungeon")
                content.emptyStateText:SetTextColor(0.7, 0.7, 0.7)
                content.emptyStateText:SetJustifyH("CENTER")
                content.emptyStateText:SetWordWrap(true)
            else
                -- Update width in case frame was resized
                content.emptyStateText:SetWidth(content:GetWidth() - 40)
            end
            content.emptyStateText:Show()
            return
        else
            -- Hide empty state message and show rows
            if content.emptyStateText then
                content.emptyStateText:Hide()
            end
            for _, row in pairs(content.rows) do
                row:Show()
            end
        end

        for _, key in ipairs(self.MetricKeys) do
            local value = self:GetDungeonStat(dungeonData, self.CurrentPlayer, key)
            self:UpdateRow(key, value, dungeonData)
        end
    end,

    UpdateLayout = function(self)
        local f = self.StatsFrame
        local content = f.scrollFrame.scrollChild
        local yOffset = -5
        local rowHeight = 18
        local contentPadding = 10
        local dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()

        -- Disable UI elements when no data
        local hasData = dungeonData ~= nil

        -- Calculate minimum height components
        local titleHeight = f.title:GetHeight() + 2
        local headerFrameHeight = f.headerFrame:GetHeight() + 2
        local dropdownFrameHeight = f.dropdownFrame:GetHeight() + 10
        local infoFrameHeight = f.infoFrame:GetHeight() + 2
        local compareCheckboxHeight = 0
        if content.compareCheckbox and content.compareCheckbox:IsShown() then
            compareCheckboxHeight = content.compareCheckbox:GetHeight() + 5
        end
        local footerFrameHeight = f.footerFrame:GetHeight() + 5

        f.infoFrame:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
        f.infoFrame:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, 0)

        yOffset = yOffset - f.infoFrame:GetHeight()

        if content.compareCheckbox then
            content.compareCheckbox:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
            content.compareCheckbox.tooltipText = format("%s\n\n%s\n%s",
                NCColors.Emphasize("Compare other players' metrics to your own."),
                NCColors.MetricsLesser("Red: The other player's value is better than yours."),
                NCColors.MetricsGreater("Green: Your value is better than the other player's."))
            content.compareCheckbox:SetScript("OnEnter", function()
                GameTooltip:SetOwner(content.compareCheckbox, "ANCHOR_RIGHT")
                GameTooltip:AddLine(content.compareCheckbox.tooltipText, 1, 1, 1)
                GameTooltip:Show()
            end)
            content.compareCheckbox:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)

            if hasData then
                content.compareCheckbox:Show()
            end

            yOffset = yOffset - content.compareCheckbox:GetHeight() - 5
        end

        local contentHeight = 0
        -- Create or update rows for each metric
        for index, key in ipairs(self.MetricKeys) do
            local row = content.rows[key]
            if not row then
                row = CreateFrame("Frame", nil, content)
                row:SetHeight(rowHeight)
                row.columns = {}
                for i = 1, 2 do
                    row.columns[i] = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                    row.columns[i]:SetJustifyH(i == 1 and "LEFT" or "RIGHT")
                    row.columns[i]:SetPoint(i == 1 and "LEFT" or "RIGHT", row, i == 1 and "LEFT" or "RIGHT",
                        i == 1 and 5 or -5, 0)
                end
                row.columns[1]:SetText(self.METRIC_REPLACEMENTS[key] or key)
                row:SetScript("OnMouseDown", function() self:ReportMetric(key, self.CurrentPlayer) end)
                content.rows[key] = row
                row:SetPassThroughButtons("RightButton")
            end
            row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
            row:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, yOffset)
            yOffset = yOffset - rowHeight
            contentHeight = contentHeight + rowHeight
        end

        -- Calculate total content height (absolute value of final yOffset)
        contentHeight = math.abs(yOffset)

        -- Set the scroll child height to exactly match the content
        content:SetHeight(contentHeight)

        -- Calculate total minimum height
        local minHeight = titleHeight + headerFrameHeight + dropdownFrameHeight + infoFrameHeight + compareCheckboxHeight +
            contentHeight + footerFrameHeight + contentPadding - 80

        -- Set a reasonable minimum width
        local minWidth = 200

        -- Set the minimum size of the frame
        f:SetResizeBounds(minWidth, minHeight)

        -- Ensure the frame is at least the minimum size
        if f:GetWidth() < minWidth then
            f:SetWidth(minWidth)
        end
        if f:GetHeight() < minHeight then
            f:SetHeight(minHeight)
        end

        -- Adjust scroll frame height
        f.scrollFrame:SetHeight(f:GetHeight() - (titleHeight + headerFrameHeight + dropdownFrameHeight + footerFrameHeight))
    end,

    UpdateRow = function(self, statType, value, dungeonData)
        local row = self.StatsFrame.scrollFrame.scrollChild.rows[statType]
        if not row then return end

        local positive = NCRankings.METRICS[statType]
        local greaterColor = positive and NCColors.MetricsGreater() or NCColors.MetricsLesser()
        local lesserColor = positive and NCColors.MetricsLesser() or NCColors.MetricsGreater()
        local neutralColor = NCColors.MetricsNeutral()

        row.columns[2]:SetText(NemesisChat:FormatNumber(value))

        -- Store the comparison info for tooltip use
        row.tooltipInfo = {
            statType = statType,
            value = value,
            dungeonData = dungeonData
        }

        if NCConfig:Get("infoClickCompare") and self.CurrentPlayer ~= UnitName("player") then
            local myStat = self:GetDungeonStat(dungeonData, UnitName("player"), statType)
            local delta = value - myStat

            if delta > 0 then
                row.columns[2]:SetText(NemesisChat:FormatNumber(value) .. " (+" .. NemesisChat:FormatNumber(delta) .. ")")
                row.columns[2]:SetTextColor(unpack(greaterColor))
                row.columns[2].desiredColor = greaterColor
            elseif delta < 0 then
                row.columns[2]:SetText(NemesisChat:FormatNumber(value) ..
                    " (-" .. NemesisChat:FormatNumber(math.abs(delta)) .. ")")
                row.columns[2]:SetTextColor(unpack(lesserColor))
                row.columns[2].desiredColor = lesserColor
            else
                row.columns[2]:SetTextColor(unpack(neutralColor))
                row.columns[2].desiredColor = neutralColor
            end
        else
            row.columns[2]:SetTextColor(unpack(neutralColor))
            row.columns[2].desiredColor = neutralColor
        end

        if dungeonData and not NCRankings:IsMetricApplicable(statType, self.CurrentPlayer) then
            local disabledColor = NCColors.MetricsDisabled()
            row.columns[1]:SetTextColor(unpack(disabledColor))
            row.columns[1].desiredColor = disabledColor
            row.columns[2]:SetTextColor(unpack(disabledColor))
            row.columns[2].desiredColor = disabledColor
        else
            row.columns[1]:SetTextColor(unpack(neutralColor))
            row.columns[1].desiredColor = neutralColor
        end

        row:SetScript("OnEnter", function()
            -- Highlight the text
            row.columns[1]:SetTextColor(1, 1, 1)
            row.columns[2]:SetTextColor(1, 1, 1)

            -- Show tooltip
            GameTooltip:SetOwner(row, "ANCHOR_RIGHT")

            local helperText = format("%s: Report this metric.\n%s: Passthrough (control camera)",
                NCColors.Emphasize("Left-click"),
                NCColors.Emphasize("Right-click"))

            if NCConfig:Get("infoClickCompare") and self.CurrentPlayer ~= UnitName("player") then
                local myStat = self:GetDungeonStat(row.tooltipInfo.dungeonData, UnitName("player"), row.tooltipInfo.statType)
                local delta = math.abs(row.tooltipInfo.value - myStat)
                local comparison = row.tooltipInfo.value > myStat and "higher than" or (row.tooltipInfo.value < myStat and "lower than" or "the same as")

                -- Get player class for coloring
                local playerData = row.tooltipInfo.dungeonData.RosterSnapshot[self.CurrentPlayer]
                local rawClass = playerData and playerData.rawClass or select(2, UnitClass(self.CurrentPlayer)) or "UNKNOWN"

                -- Color the comparison text based on the value
                local positive = NCRankings.METRICS[row.tooltipInfo.statType]
                local coloredComparison = row.tooltipInfo.value > myStat and
                    (positive and NCColors.MetricsGreater(comparison) or NCColors.MetricsLesser(comparison)) or
                    (row.tooltipInfo.value < myStat and
                        (positive and NCColors.MetricsLesser(comparison) or NCColors.MetricsGreater(comparison)) or
                        NCColors.MetricsNeutral(comparison))

                local tooltipText = format("%s's %s is %s %s yours (%s)\n\n%s",
                    NCColors.ClassColor(rawClass, self.CurrentPlayer),
                    self.METRIC_REPLACEMENTS[row.tooltipInfo.statType] or row.tooltipInfo.statType,
                    NemesisChat:FormatNumber(delta),
                    coloredComparison,
                    NemesisChat:FormatNumber(myStat),
                    helperText
                )
                GameTooltip:AddLine(tooltipText, 1, 1, 1, true)
            else
                GameTooltip:AddLine(helperText, 1, 1, 1, true)
            end

            GameTooltip:Show()
        end)

        row:SetScript("OnLeave", function()
            row.columns[1]:SetTextColor(unpack(row.columns[1].desiredColor))
            row.columns[2]:SetTextColor(unpack(row.columns[2].desiredColor))
            GameTooltip:Hide()
        end)
    end,

    UpdatePrevNextButtons = function(self, dungeonData)
        if not dungeonData then
            dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()
        end

        -- Disable buttons if no dungeon data or only one player
        if not dungeonData or not dungeonData.RosterSnapshot then
            self.StatsFrame.prevPlayerButton:Disable()
            self.StatsFrame.nextPlayerButton:Disable()
            return
        end

        -- Count players in roster
        local playerCount = 0
        for _ in pairs(dungeonData.RosterSnapshot) do
            playerCount = playerCount + 1
        end

        -- Disable if only one player
        if playerCount <= 1 then
            self.StatsFrame.prevPlayerButton:Disable()
            self.StatsFrame.nextPlayerButton:Disable()
            return
        end

        -- Update player list if needed
        if not self.playerList or GetTime() - (self.lastPlayerListUpdate or 0) > 1 then
            self.playerList = {}
            for name in pairs(dungeonData.RosterSnapshot) do
                table.insert(self.playerList, name)
            end
            table.sort(self.playerList)
            self.lastPlayerListUpdate = GetTime()
        end

        self.StatsFrame.prevPlayerButton:Enable()
        self.StatsFrame.nextPlayerButton:Enable()
    end,

    UpdateChannelDropdown = function(self)
        self:RefreshChannelDropdown()
    end,

    -- Update player dropdown
    UpdatePlayerDropdown = function(self)
        if not self.StatsFrame then return end

        -- Clear and rebuild player list
        self.playerList = nil
        self.lastPlayerListUpdate = nil

        local maxPlayerLength = GetMaxDropdownTextLength(self.StatsFrame)
        local playerDisplayText = TruncateName(self.CurrentPlayer, maxPlayerLength)
        UIDropDownMenu_SetText(self.StatsFrame.playerDropdown, playerDisplayText)
        UIDropDownMenu_SetWidth(self.StatsFrame.playerDropdown, self.DropdownWidth)
        UIDropDownMenu_Initialize(self.StatsFrame.playerDropdown, function(dropdown, level, menuList)
            self:InitializePlayerDropdown(dropdown, level, menuList)
        end)
    end,

    InitializePlayerDropdown = function(self)
        if not self.StatsFrame then return end

        local dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()
        local raidGroup = IsInRaid()
        local partyMembers = GetNumGroupMembers()

        -- Force roster update if we're in a group
        if IsInGroup() and dungeonData then
            NCRuntime:UpdateGroupRosterRoles()
            if dungeonData.SnapshotCurrentRoster then
                dungeonData:SnapshotCurrentRoster()
            end
        end

        local f = self.StatsFrame
        UIDropDownMenu_Initialize(f.playerDropdown, function(dropdown, level, menuList)
            if level == 1 then
                -- Only use raid groups if we actually have group data and are in an active raid
                if raidGroup and partyMembers > 5 and IsInRaid() and dungeonData and
                   dungeonData.RosterSnapshot and next(dungeonData.RosterSnapshot) and
                   dungeonData.RosterSnapshot[next(dungeonData.RosterSnapshot)].group then
                    self:CreateRaidGroupedDropdown(dropdown, level, dungeonData)
                else
                    -- Use normal dropdown for completed dungeons or party groups
                    self:CreateNormalDropdown(dropdown, level, dungeonData)
                end
            elseif level == 2 and menuList then
                self:CreateRaidGroupMenu(menuList, dropdown, level)
            end
        end)

        self:UpdateDropdownText()
    end,

    CreateRaidGroupedDropdown = function(self, dropdown, level)
        local groupedPlayers = self:GroupRaidPlayers()

        for i = 1, 8 do
            if groupedPlayers[i] and #groupedPlayers[i] > 0 then
                local info = UIDropDownMenu_CreateInfo()
                info.text = "Group " .. i
                info.hasArrow = true
                info.notCheckable = true
                info.menuList = groupedPlayers[i]
                UIDropDownMenu_AddButton(info, level)
            end
        end
    end,

    CreateRaidGroupMenu = function(self, players, dropdown, level)
        for _, playerInfo in ipairs(players) do
            self:AddPlayerToDropdown(playerInfo, dropdown, level)
        end
    end,

    CreateNormalDropdown = function(self, dropdown, level, dungeonData)
        dungeonData = dungeonData or (NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon())
        if not dungeonData then return end

        local playerName = UnitName("player")
        local sortedPlayers = {}
        local roleOrder = { ["TANK"] = 1, ["HEALER"] = 2, ["DAMAGER"] = 3, ["DPS"] = 3, ["OTHER"] = 4 }

        -- First, add current player
        if dungeonData.RosterSnapshot[playerName] then
            self:AddPlayerToDropdown({ name = playerName, data = dungeonData.RosterSnapshot[playerName] }, dropdown, level)
        end

        -- Sort remaining players by role (defined by roleOrder above)
        for name, player in pairs(dungeonData.RosterSnapshot) do
            if name ~= playerName then
                local role = player.role or UnitGroupRolesAssigned(name) or "OTHER"
                -- Normalize DPS to DAMAGER
                if role == "DPS" then role = "DAMAGER" end

                table.insert(sortedPlayers, {
                    name = name,
                    data = player,
                    roleOrder = roleOrder[role] or 4
                })
            end
        end

        table.sort(sortedPlayers, function(a, b)
            if a.roleOrder == b.roleOrder then
                return a.name < b.name
            end
            return a.roleOrder < b.roleOrder
        end)

        -- Add sorted players to dropdown
        for _, player in ipairs(sortedPlayers) do
            self:AddPlayerToDropdown({ name = player.name, data = player.data }, dropdown, level)
        end
    end,

    GroupRaidPlayers = function(self)
        local groupedPlayers = {}
        for i = 1, 8 do groupedPlayers[i] = {} end
        local dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()
        if not dungeonData then return groupedPlayers end

        for name, player in pairs(dungeonData.RosterSnapshot) do
            -- Default to group 1 if no group is assigned
            local subgroup = tonumber(player.group) or 1
            -- Ensure subgroup is within valid range
            subgroup = math.min(math.max(subgroup, 1), 8)
            table.insert(groupedPlayers[subgroup], { name = name, data = player })
        end

        return groupedPlayers
    end,

    CreateSoloDropdown = function(self, dropdown, level)
        local playerName = UnitName("player")
        local info = UIDropDownMenu_CreateInfo()
        info.text = NCColors.Emphasize(playerName)
        info.checked = true
        info.isNotRadio = true
        info.func = function(self)
            NCInfo:UpdatePlayerInfo()
            NCInfo:UpdateMetrics()
            NCInfo:UpdateDropdownText()
            CloseDropDownMenus()
        end
        UIDropDownMenu_AddButton(info, level)
    end,

    DebugPrintRaidInfo = function(self)
        if IsInRaid() then
            print("Raid Roster Debug:")
            for i = 1, 40 do
                local name, _, subgroup = GetRaidRosterInfo(i)
                if name then
                    print(string.format("Player: %s, Group: %d", name, subgroup))
                end
            end
        else
            print("Not in a raid group.")
        end
    end,

    AddPlayerToDropdown = function(self, playerInfo, dropdown, level)
        local info = UIDropDownMenu_CreateInfo()
        local name, player = playerInfo.name, playerInfo.data
        local class = player.class or UnitClass(name) or "Unknown"
        local rawClass = player.rawClass or select(2, UnitClass(name)) or "Unknown"
        local role = player.role or UnitGroupRolesAssigned(name) or "OTHER"

        local maxLength = GetMaxDropdownTextLength(self.StatsFrame)
        local truncatedName = TruncateName(name, maxLength)

        -- Create the icon string using the role icon
        local roleIcon = IconTable:GetIconString("Role", role, 16)
        local infoString = string.format("%s", truncatedName)

        local colorized = NCColors.ClassColor(rawClass, roleIcon .. " " .. infoString)
        if name == UnitName("player") then
            colorized = NCColors.Emphasize(truncatedName)
        end

        info.text = colorized
        info.value = name
        info.checked = (name == self.CurrentPlayer)
        info.func = function(self)
            NCInfo.CurrentPlayer = self.value
            NCInfo:UpdatePlayerInfo()
            NCInfo:UpdateMetrics()
            NCInfo:UpdateDropdownText()
            NCInfo:SetWidthsAndTruncatedTexts()
            CloseDropDownMenus()
        end

        UIDropDownMenu_AddButton(info, level)
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
            self.channelDropdownInitialized = true
        end

        UIDropDownMenu_SetWidth(f.channelDropdown, self.DropdownWidth)

        -- Set initial text
        local maxLength = GetMaxChannelTextLength(f)
        local displayText = TruncateName(self:GetChannelDisplayName(self.SelectedChannel), maxLength)
        UIDropDownMenu_SetText(f.channelDropdown, "Channel: " .. displayText)
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

        -- Get the maximum text length based on current frame width
        local maxLength = GetMaxChannelTextLength(self.StatsFrame)

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
                    local displayText = TruncateName(NCInfo:GetChannelDisplayName(itemSelf.value), maxLength)
                    UIDropDownMenu_SetText(dropdown, "Channel: " .. displayText)
                end
            end
            info.checked = (self.SelectedChannel == channelInfo.value)
            UIDropDownMenu_AddButton(info, level)
        end

        -- Update the displayed text
        local displayText = TruncateName(self:GetChannelDisplayName(self.SelectedChannel), maxLength)
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

        local dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()
        if not dungeonData then return end

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
            message = string.format("My %s (%s): %s", (self.METRIC_REPLACEMENTS[metric] or metric),
                dungeonData.Identifier or "dungeon",
                NemesisChat:FormatNumber(self:GetDungeonStat(dungeonData, player, metric)))
        else
            message = string.format("%s for %s (%s): %s", (self.METRIC_REPLACEMENTS[metric] or metric), player,
                dungeonData.Identifier or "dungeon",
                NemesisChat:FormatNumber(self:GetDungeonStat(dungeonData, player, metric)))
            if NCConfig:Get("infoClickCompare") then
                local delta = self:GetDungeonStat(dungeonData, player, metric) -
                    self:GetDungeonStat(dungeonData, UnitName("player"), metric)
                if delta > 0 then
                    message = message .. string.format(" (%s higher than mine)", NemesisChat:FormatNumber(delta))
                elseif delta < 0 then
                    message = message ..
                        string.format(" (%s lower than mine)", NemesisChat:FormatNumber(math.abs(delta)))
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

    UpdateDropdownText = function(self)
        if not self.StatsFrame or not self.StatsFrame.playerDropdown then
            return
        end

        local maxLength = GetMaxDropdownTextLength(self.StatsFrame)
        local truncatedName = TruncateName(self.CurrentPlayer, maxLength)
        UIDropDownMenu_SetText(self.StatsFrame.playerDropdown, truncatedName)
        _G[self.StatsFrame.playerDropdown:GetName() .. "Text"]:SetTextColor(1, 0.82, 0)
    end,

    SelectNextPlayer = function(self)
        if not IsNCEnabled() then return end

        local dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()
        if not dungeonData then return end

        local playerList = self:GetSortedPlayerList(dungeonData)
        local currentIndex = tIndexOf(playerList, self.CurrentPlayer)
        if currentIndex then
            local nextIndex = currentIndex % #playerList + 1
            self.CurrentPlayer = playerList[nextIndex]
            self:UpdatePlayerInfo(dungeonData)
            self:UpdateMetrics(dungeonData)
            self:UpdateDropdownText()
        end
    end,

    SelectPreviousPlayer = function(self)
        if not IsNCEnabled() then return end

        local dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()
        if not dungeonData then return end

        local playerList = self:GetSortedPlayerList(dungeonData)
        local currentIndex = tIndexOf(playerList, self.CurrentPlayer)
        if currentIndex then
            local prevIndex = (currentIndex - 2 + #playerList) % #playerList + 1
            self.CurrentPlayer = playerList[prevIndex]
            self:UpdatePlayerInfo(dungeonData)
            self:UpdateMetrics(dungeonData)
            self:UpdateDropdownText()
        end
    end,

    ToggleMinimize = function(self)
        if not IsNCEnabled() or not self.StatsFrame then return end

        local f = self.StatsFrame
        if self.IsMinimized then
            -- Expand the frame
            self.IsMinimized = false
            self.hasBeenExpanded = true
            f.minimizeButton:SetNormalAtlas("RedButton-Expand")
            f.minimizeButton:SetPushedAtlas("RedButton-Expand-Pressed")
            f.minimizeButton:SetDisabledAtlas("RedButton-Expand-Disabled")
            f.minimizeButton:SetHighlightAtlas("RedButton-Highlight")
            f.minimizeButton.tooltipText = NCColors.Emphasize("Minimize the info frame.")

            -- Show all elements
            f:SetHeight(self.ExpandedHeight or 300)
            f:SetResizable(true)
            f.scrollFrame:Show()
            f.dropdownFrame:Show()
            f.footerFrame:Show()
            f.headerFrame:Show()
            f.resizeButton:Show()
            f:SetAlpha(1)

            -- Force a full update
            self:Update()
        else
            -- Save current height
            self.ExpandedHeight = f:GetHeight()

            -- Minimize the frame
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
        self.IsMinimized = true
        self.savedHeight = f:GetHeight()

        f.minimizeButton.tooltipText = NCColors.Emphasize("Expand the info frame.")

        -- Update minimize button texture
        f.minimizeButton:SetNormalAtlas("RedButton-Condense")
        f.minimizeButton:SetPushedAtlas("RedButton-Condense-Pressed")
        f.minimizeButton:SetDisabledAtlas("RedButton-Condense-Disabled")
        f.minimizeButton:SetHighlightAtlas("RedButton-Highlight")

        -- Set minimized height
        local titleHeight = f.title:GetHeight() + 16
        f:SetHeight(titleHeight)

        -- Hide content while minimized
        f.scrollFrame:Hide()
        f.dropdownFrame:Hide()
        f.footerFrame:Hide()
        f.headerFrame:Hide()
        f.resizeButton:Hide()

        -- Disable resizing while minimized
        f:SetResizable(false)
        f:SetAlpha(0.6)
    end,

    GetDungeonStat = function(self, dungeonData, playerName, metric)
        -- First validate we have actual dungeon data
        if not dungeonData then
            dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()
        end
        if not dungeonData then return 0 end

        local value = 0
        local success, err = pcall(function()
            if dungeonData == NCDungeon then
                if metric == "DPS" then
                    value = NCDungeon:GetDps(playerName)
                else
                    value = NCDungeon:GetStats(playerName, metric)
                end
            elseif dungeonData.Stats then
                -- Handle restored data
                if metric == "DPS" then
                    value = dungeonData.Stats and dungeonData.Stats.DPS and dungeonData.Stats.DPS[playerName] or 0
                else
                    value = dungeonData.Stats and dungeonData.Stats[metric] and dungeonData.Stats[metric][playerName] or
                           dungeonData[metric] and dungeonData[metric][playerName] or 0
                end
            else
                value = 0
            end
        end)

        if not success then
            local errorMessage = string.format("Error getting dungeon stat: %s", err or "Unknown error")
            NemesisChat:HandleError(errorMessage)
            return 0
        end

        return value
    end,

    OnStatUpdate = function(self, statType, player, value)
        if not self.StatsFrame or not self.StatsFrame:IsShown() then return end

        if player == self.CurrentPlayer then
            local dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()
            if dungeonData then
                self:UpdateRow(statType, value, dungeonData)
                self:UpdateLayout()
            end
        end
    end,

    _SetMetricKeys = function(self)
        local keys = NemesisChat:GetKeys(NCRankings.METRICS)
        table.sort(keys)
        self.MetricKeys = keys
    end,

    -- Generate the list of available channels based on current group state
    _GetAvailableChannels = function(self)
        local channels = {}
        local dungeonData = NCDungeon:IsActive() and NCDungeon or NCRuntime:GetLastCompletedDungeon()

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
            if IsInRaid(LE_PARTY_CATEGORY_HOME) then
                table.insert(channels, { text = "Raid", value = "RAID" })
            end
        elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            table.insert(channels, { text = "Instance", value = "INSTANCE_CHAT" })
        end

        if C_GuildInfo and C_GuildInfo.CanSpeakInOfficerChat and C_GuildInfo.CanSpeakInOfficerChat() then
            table.insert(channels, { text = "Officer", value = "OFFICER" })
        end

        -- Whisper options
        if dungeonData then
            for name in pairs(dungeonData.RosterSnapshot) do
                table.insert(channels, { text = "Whisper: " .. name, value = "WHISPER_" .. name })
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

    -- Add this helper function
    GetSortedPlayerList = function(self, dungeonData)
        local playerName = UnitName("player")
        local sortedPlayers = {}
        local roleOrder = { ["TANK"] = 1, ["HEALER"] = 2, ["DAMAGER"] = 3, ["DPS"] = 3, ["OTHER"] = 4 }

        -- First add current player
        if dungeonData.RosterSnapshot[playerName] then
            table.insert(sortedPlayers, {
                name = playerName,
                data = dungeonData.RosterSnapshot[playerName],
                roleOrder = 0  -- Always first
            })
        end

        -- Add remaining players
        for name, player in pairs(dungeonData.RosterSnapshot) do
            if name ~= playerName then
                local role = player.role or UnitGroupRolesAssigned(name) or "OTHER"
                if role == "DPS" then role = "DAMAGER" end

                table.insert(sortedPlayers, {
                    name = name,
                    data = player,
                    roleOrder = roleOrder[role] or 4
                })
            end
        end

        -- Sort by role, then name
        table.sort(sortedPlayers, function(a, b)
            if a.roleOrder == b.roleOrder then
                return a.name < b.name
            end
            return a.roleOrder < b.roleOrder
        end)

        -- Convert to simple name list while maintaining order
        local nameList = {}
        for _, player in ipairs(sortedPlayers) do
            table.insert(nameList, player.name)
        end

        return nameList
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
