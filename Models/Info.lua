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

NCInfo = {
    SCROLLVIEW_HEIGHT = 0,
    SCROLLVIEW_TOP = 0,
    SCROLLVIEW_BOTTOM = 0,
    DISPLAY_WIDTH = 200,
    CELL_HEIGHT = 14,
    HEADER_HEIGHT = 0,
    HEADER_BUFFER = 48,
    FOOTER_HEIGHT = 16,
    FOOTER_BUFFER = 0,
    TOTAL_WIDTH = 200,
    TOTAL_HEIGHT = 210,

    REPLACEMENTS = {
        ["AvoidableDamage"] = "Avoidable Damage",
        ["CrowdControl"] = "CC Score",
    },

    CurrentPlayer = nil,

    StatsFrame = CreateFrame("MessageFrame", "NemesisChatStatsFrame", UIParent, "BackdropTemplate"),

    Initialize = function(self)
        self:InitializeVars()

        local f = self.StatsFrame

        f:SetSize(self.TOTAL_WIDTH, self.TOTAL_HEIGHT)
        f:SetPoint("CENTER", UIParent, "CENTER")
        f:SetMovable(true)
        f:SetResizable(true)
        f:SetScript("OnHide", function(self)
            self:StopMovingOrSizing()
        end)
        f:SetClampedToScreen(true)
        f:SetUserPlaced(true)
        f:SetFrameStrata("BACKGROUND")
        f:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 2,
            edgeSize = 2,
            insets = {
                left = 0,
                right = 0,
                top = 0,
                bottom = 0
            }
        })
        f:SetBackdropColor(0,0,0,0.4)
        f:SetBackdropBorderColor(0,0,0,1)

        f.header = f:CreateFontString(nil,"ARTWORK","GameFontNormalLarge")
        f.header:SetPoint("TOPLEFT",8,16)
        f.header:SetPoint("TOPRIGHT",-8,16)
        f.header:SetText("NemesisChat")
        f.header:SetTextColor(0.50,0.60,1)
        f.header:SetJustifyH("CENTER")
        f.header:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                NCInfo.StatsFrame:StartMoving()
            end
        end)
        f.header:SetScript("OnMouseUp", function(self, button)
            NCInfo.StatsFrame:StopMovingOrSizing()
        end)

        f.closeButton = CreateFrame("Button",nil,f,"UIPanelCloseButton")
        f.closeButton:SetPoint("TOPRIGHT",0,18)
        f.closeButton:SetSize(16,16)
        f.closeButton:SetScript("OnClick", function(self)
            NCInfo.StatsFrame:Hide()
        end)

        -- Add a dropdown menu to select the player
        f.playerDropdown = CreateFrame("Frame", "NemesisChatStatsFramePlayerDropdown", f, "UIDropDownMenuTemplate")
        f.playerDropdown:SetPoint("TOPLEFT",0,-4)
        f.playerDropdown:SetPoint("BOTTOMRIGHT",0,0)
        f.playerDropdown:SetScript("OnShow", function(self)
            UIDropDownMenu_Initialize(self, function(self, level, menuList)
                for name, _ in pairs(NCRuntime:GetGroupRoster()) do
                    local info = UIDropDownMenu_CreateInfo()
                    info.text = name
                    info.value = name
                    info.checked = (name == NCInfo.CurrentPlayer)
                    info.func = function(self)
                        NCInfo.CurrentPlayer = self.value
                        NCInfo:Update()
                    end
                    UIDropDownMenu_AddButton(info)
                end
            end, "OTHER")
        end)
        UIDropDownMenu_SetWidth(f.playerDropdown, self.TOTAL_WIDTH - 48)
        UIDropDownMenu_SetText(f.playerDropdown, self.CurrentPlayer)
        f.playerDropdown:Show()

        f.scrollFrame = CreateFrame("ScrollFrame",nil,f,"UIPanelScrollFrameTemplate")
        f.scrollFrame:SetPoint("TOPLEFT",8,-(self.SCROLLVIEW_TOP))
        f.scrollFrame:SetPoint("BOTTOMRIGHT",-26, self.SCROLLVIEW_BOTTOM)
        f.scrollFrame:SetSize(self.TOTAL_WIDTH - 34, self.TOTAL_HEIGHT - self.SCROLLVIEW_TOP - self.SCROLLVIEW_BOTTOM)

        f.scrollFrame.scrollChild = CreateFrame("Frame",nil,f.scrollFrame)
        f.scrollFrame.scrollChild:SetPoint("TOPLEFT",5,-5)
        f.scrollFrame.scrollChild:SetPoint("BOTTOMRIGHT",-5, -5)
        f.scrollFrame.scrollChild:SetSize(f.scrollFrame:GetWidth(), f.scrollFrame:GetHeight() - 4)
        f.scrollFrame:SetScrollChild(f.scrollFrame.scrollChild)

        f.scrollFrame:Show()
        f.scrollFrame.scrollChild:Show()

        f.resizeButton = CreateFrame("Button",nil,f)
        f.resizeButton:SetPoint("BOTTOMRIGHT",0,0)
        f.resizeButton:SetSize(16,16)
        f.resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        f.resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        f.resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
        f.resizeButton:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                NCInfo.StatsFrame:StartSizing("BOTTOMRIGHT")
                NCInfo.StatsFrame:SetUserPlaced(false)
                NCInfo.StatsFrame.scrollFrame:Hide()
            end
        end)
        f.resizeButton:SetScript("OnMouseUp", function(self, button)
            NCInfo.StatsFrame:StopMovingOrSizing()
            NCInfo.StatsFrame:SetUserPlaced(true)
        end)
        f:SetScript("OnSizeChanged", function(self, button)
            if NCInfo.StatsFrame:GetWidth() < 200 then
                NCInfo.StatsFrame:SetWidth(200)
            end

            if NCInfo.StatsFrame:GetHeight() < 210 then
                NCInfo.StatsFrame:SetHeight(210)
            end

            NCInfo.TOTAL_HEIGHT = NCInfo.StatsFrame:GetHeight()
            NCInfo.TOTAL_WIDTH = NCInfo.StatsFrame:GetWidth()

            NCInfo.StatsFrame:SetSize(NCInfo.TOTAL_WIDTH, NCInfo.TOTAL_HEIGHT)

            NCInfo:InitializeVars()

            NCInfo.StatsFrame.scrollFrame:SetSize(NCInfo.TOTAL_WIDTH - 34, NCInfo.TOTAL_HEIGHT - NCInfo.SCROLLVIEW_TOP - NCInfo.SCROLLVIEW_BOTTOM)
            NCInfo.StatsFrame.scrollFrame.scrollChild:SetSize(NCInfo.TOTAL_WIDTH - 44, NCInfo.TOTAL_HEIGHT - NCInfo.SCROLLVIEW_TOP - NCInfo.SCROLLVIEW_BOTTOM)
            NCInfo:Update()

            NCInfo.StatsFrame.scrollFrame:Show()
            UIDropDownMenu_SetWidth(NCInfo.StatsFrame.playerDropdown, NCInfo.TOTAL_WIDTH - 48)
        end)

        f.scrollFrame.scrollChild.rows = {}

        self:Update()
    end,

    Update = function(self)
        local f = self.StatsFrame
        local content = f.scrollFrame.scrollChild

        local i = 1
        local ROW_WIDTH = content:GetWidth()
        for metric, positive in pairs(NCRankings.METRICS) do
            if not content.rows[metric] then
                local button = CreateFrame("Button",nil,content)
                
                button:SetSize(ROW_WIDTH, self.CELL_HEIGHT)
                button:SetPoint("TOPLEFT",0,-(i-1)*self.CELL_HEIGHT)
                button.columns = {} -- creating columns for the row
                button.columns[1] = button:CreateFontString(nil,"ARTWORK","GameFontHighlight")
                button.columns[1]:SetPoint("LEFT",0,0)
                button.columns[1]:SetTextColor(0.5,0.6,0.85)
                button.columns[2] = button:CreateFontString(nil,"ARTWORK","GameFontHighlight")
                button.columns[2]:SetPoint("LEFT",ROW_WIDTH * 0.6,0)
                button.columns[2]:SetPoint("RIGHT",0,0)
                button.columns[2]:SetTextColor(0.5,0.6,0.85)
                content.rows[metric] = button
            end

            content.rows[metric].columns[1]:SetText(self.REPLACEMENTS[metric] or metric)
            content.rows[metric].columns[2]:SetText(NemesisChat:FormatNumber(NCDungeon:GetStats(self.CurrentPlayer, metric)))
            content.rows[metric]:SetPoint("TOPLEFT",0,-(i-1)*self.CELL_HEIGHT)
            content.rows[metric]:SetScript("OnEnter", function(self)
                self.columns[1]:SetTextColor(1,1,1)
                self.columns[2]:SetTextColor(1,1,1)

                GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
                GameTooltip:AddLine("Left click: Report to group chat")
                GameTooltip:Show()
            end)
            content.rows[metric]:SetScript("OnLeave", function(self)
                self.columns[1]:SetTextColor(0.5,0.6,0.85)
                self.columns[2]:SetTextColor(0.5,0.6,0.85)

                GameTooltip:Hide()
            end)
            content.rows[metric].columns[1]:SetWidth(ROW_WIDTH * 0.6)
            content.rows[metric].columns[1]:SetJustifyH("LEFT")
            content.rows[metric].columns[2]:SetWidth(ROW_WIDTH * 0.4)
            content.rows[metric].columns[2]:SetJustifyH("RIGHT")

            if not (
                (GetRole(self.CurrentPlayer) == "TANK" and metric == "Pulls") or
                (GetRole(self.CurrentPlayer) == "HEALER" and metric == "Offheals")
            ) then
                content.rows[metric]:SetSize(ROW_WIDTH, self.CELL_HEIGHT)
                content.rows[metric]:Show()
            else
                content.rows[metric]:SetSize(ROW_WIDTH, 0)
                content.rows[metric]:Hide()
            end

            content.rows[metric]:SetScript("OnClick", function(self)
                NCInfo:ReportMetric(metric, NCInfo.CurrentPlayer)
            end)
            
            i = i + 1
        end

        UIDropDownMenu_SetText(f.playerDropdown, self.CurrentPlayer)
    end,

    UpdatePlayerDropdown = function(self)
        UIDropDownMenu_SetText(self.StatsFrame.playerDropdown, self.CurrentPlayer)
        UIDropDownMenu_Initialize(self.StatsFrame.playerDropdown, function(self, level, menuList)
            for name, _ in pairs(NCRuntime:GetGroupRoster()) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = name
                info.value = name
                info.checked = (name == NCInfo.CurrentPlayer)
                info.func = function(self)
                    NCInfo.CurrentPlayer = self.value
                    NCInfo:Update()
                end
                UIDropDownMenu_AddButton(info)
            end
        end, "OTHER")
    end,

    InitializeVars = function(self)
        self.CurrentPlayer = UnitName("player")
        self.SCROLLVIEW_HEIGHT = self.TOTAL_HEIGHT - self.HEADER_HEIGHT - self.HEADER_BUFFER - self.FOOTER_HEIGHT - self.FOOTER_BUFFER
        self.SCROLLVIEW_TOP = self.HEADER_HEIGHT + self.HEADER_BUFFER
        self.SCROLLVIEW_BOTTOM = self.FOOTER_HEIGHT + self.FOOTER_BUFFER
    end,

    ReportMetric = function(self, metric, player)
        local message = string.format("%s for %s (Dungeon): %s", self.REPLACEMENTS[metric] or metric, player, NemesisChat:FormatNumber(NCDungeon:GetStats(player, metric)))
        SendChatMessage(message, NemesisChat:GetActualChannel("GROUP"))
    end,
}