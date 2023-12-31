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
    DROPDOWN_WIDTH = 128,

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

    CurrentPlayer = nil,

    StatsFrame = CreateFrame("MessageFrame", "NemesisChatStatsFrame", UIParent, "BackdropTemplate"),

    Initialize = function(self)
        self.CurrentPlayer = UnitName("player")
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
            NCConfig:SetShowInfoFrame(false)
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

            UIDropDownMenu_SetWidth(NCInfo.StatsFrame.playerDropdown, NCInfo.DROPDOWN_WIDTH)
        end)

        f.scrollFrame.scrollChild.rows = {}

        self:Update()
    end,

    Update = function(self)
        local f = NCInfo.StatsFrame
        local infoFrame = f.infoFrame
        local content = f.scrollFrame.scrollChild
        local i = 1
        local ROW_WIDTH = content:GetWidth()

        local red = {0.85,0.6,0.5}
        local green = {0.5,0.85,0.6}
        local neutral = {0.5,0.6,0.85}

        local rosterPlayer = NCRuntime:GetGroupRosterPlayer(NCInfo.CurrentPlayer)
        local snapshotPlayer = NCDungeon.RosterSnapshot[NCInfo.CurrentPlayer]
        local playerInfo = MapMerge(rosterPlayer, snapshotPlayer)
        local race = playerInfo.race or UnitRace(NCInfo.CurrentPlayer) or "Unknown"
        local class = playerInfo.class or UnitClass(NCInfo.CurrentPlayer) or "Unknown"

        -- Player information -- group roster race, class, and role
        if not infoFrame then
            local button = CreateFrame("Button",nil,f)
            
            button:SetSize(NCInfo.TOTAL_WIDTH, self.CELL_HEIGHT)
            button:SetPoint("TOPLEFT",0,-34)
            button:SetPoint("TOPRIGHT",0,-34)

            button.text = button:CreateFontString(nil,"ARTWORK","GameFontHighlight")
            button.text:SetPoint("LEFT",0,0)
            button.text:SetPoint("RIGHT",0,0)
            button.text:SetWidth(NCInfo.TOTAL_WIDTH)
            button.text:SetHeight(self.CELL_HEIGHT)
            button.text:SetJustifyH("CENTER")
            
            infoFrame = button
            f.infoFrame = infoFrame
            f.infoFrame:Show()
        end

        infoFrame.text:SetText(race .. " " .. class)

        if NCInfo.CurrentPlayer ~= GetMyName() then
            if not content.rows["compareWithMeCheckbox"] then
                local checkbox = CreateFrame("CheckButton",nil,content,"ChatConfigCheckButtonTemplate")
                checkbox:SetPoint("TOPLEFT",0,-(i-1)*self.CELL_HEIGHT)
                checkbox:SetSize(14, 14)
                checkbox:SetChecked(core.db.profile.infoClickCompare)
                checkbox:SetScript("OnClick", function(self)
                    core.db.profile.infoClickCompare = self:GetChecked()
                    NCInfo:Update()
                end)
                checkbox.text = checkbox:CreateFontString(nil,"ARTWORK","GameFontHighlight")
                checkbox.text:SetPoint("LEFT",20,0)
                checkbox.text:SetText("Compare with me")
                checkbox.text:SetTextColor(0.5,0.6,0.85)
                checkbox.text:SetJustifyH("LEFT")
                checkbox.text:SetWidth(ROW_WIDTH - 20)
                checkbox.text:SetHeight(self.CELL_HEIGHT)
                content.rows["compareWithMeCheckbox"] = checkbox
            end

            content.rows["compareWithMeCheckbox"]:Show()

            i = i + 1
        else
            if content.rows["compareWithMeCheckbox"] then
                content.rows["compareWithMeCheckbox"]:Hide()
            end
        end

        for metric, positive in pairs(NCRankings.METRICS) do
            local greaterColor = positive and green or red
            local lesserColor = positive and red or green

            if not content.rows[metric] then
                local button = CreateFrame("Button",nil,content)
                
                button:SetSize(ROW_WIDTH, self.CELL_HEIGHT)
                button:SetPoint("TOPLEFT",0,-(i-1)*self.CELL_HEIGHT)
                button.columns = {}
                button.columns[1] = button:CreateFontString(nil,"ARTWORK","GameFontHighlight")
                button.columns[1]:SetPoint("LEFT",0,0)
                button.columns[1]:SetTextColor(0.5,0.6,0.85)
                button.columns[2] = button:CreateFontString(nil,"ARTWORK","GameFontHighlight")
                button.columns[2]:SetPoint("LEFT",ROW_WIDTH * 0.6,0)
                button.columns[2]:SetPoint("RIGHT",0,0)
                button.columns[2]:SetTextColor(0.5,0.6,0.85)
                content.rows[metric] = button
            end

            content.rows[metric].columns[1]:SetText(self.METRIC_REPLACEMENTS[metric] or metric)

            if core.db.profile.infoClickCompare then
                local delta = NCDungeon:GetStats(NCInfo.CurrentPlayer, metric) - NCDungeon:GetStats(NemesisChat:GetMyName(), metric)

                if delta > 0 then
                    content.rows[metric].columns[2]:SetText(NemesisChat:FormatNumber(NCDungeon:GetStats(NCInfo.CurrentPlayer, metric)) .. " (+" .. NemesisChat:FormatNumber(delta) .. ")")
                    content.rows[metric].columns[2]:SetTextColor(greaterColor[1], greaterColor[2], greaterColor[3])
                    content.rows[metric].columns[2].desiredColor = {greaterColor[1], greaterColor[2], greaterColor[3]}
                elseif delta < 0 then
                    content.rows[metric].columns[2]:SetText(NemesisChat:FormatNumber(NCDungeon:GetStats(NCInfo.CurrentPlayer, metric)) .. " (-" .. NemesisChat:FormatNumber(math.abs(delta)) .. ")")
                    content.rows[metric].columns[2]:SetTextColor(lesserColor[1], lesserColor[2], lesserColor[3])
                    content.rows[metric].columns[2].desiredColor = {lesserColor[1], lesserColor[2], lesserColor[3]}
                else
                    content.rows[metric].columns[2]:SetText(NemesisChat:FormatNumber(NCDungeon:GetStats(NCInfo.CurrentPlayer, metric)))
                    content.rows[metric].columns[2]:SetTextColor(neutral[1], neutral[2], neutral[3])
                    content.rows[metric].columns[2].desiredColor = {neutral[1], neutral[2], neutral[3]}
                end
            else
                content.rows[metric].columns[2]:SetText(NemesisChat:FormatNumber(NCDungeon:GetStats(NCInfo.CurrentPlayer, metric)))
                content.rows[metric].columns[2]:SetTextColor(neutral[1], neutral[2], neutral[3])
                content.rows[metric].columns[2].desiredColor = {neutral[1], neutral[2], neutral[3]}
            end

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
                self.columns[2]:SetTextColor(self.columns[2].desiredColor[1],self.columns[2].desiredColor[2],self.columns[2].desiredColor[3])

                GameTooltip:Hide()
            end)

            content.rows[metric].columns[1]:SetWidth(96)
            content.rows[metric].columns[1]:SetJustifyH("LEFT")
            content.rows[metric].columns[2]:SetWidth(ROW_WIDTH - 96)
            content.rows[metric].columns[2]:SetJustifyH("RIGHT")
            content.rows[metric].columns[2]:SetMaxLines(1)

            content.rows[metric]:SetScript("OnClick", function(self)
                NCInfo:ReportMetric(metric, NCInfo.CurrentPlayer)
            end)

            if NCRankings.Configuration.Increments.Metrics[metric]:IsIncludedCallback(NCInfo.CurrentPlayer) then
                content.rows[metric]:SetSize(ROW_WIDTH, self.CELL_HEIGHT)
                content.rows[metric]:Show()
                i = i + 1
            else
                content.rows[metric]:SetSize(ROW_WIDTH, 0)
                content.rows[metric]:Hide()
            end
        end

        UIDropDownMenu_SetText(f.playerDropdown, NCInfo.CurrentPlayer)
    end,

    UpdatePlayerDropdown = function(self)
        UIDropDownMenu_SetText(NCInfo.StatsFrame.playerDropdown, NCInfo.CurrentPlayer)
        UIDropDownMenu_Initialize(NCInfo.StatsFrame.playerDropdown, function(self, level, menuList)
            local roster = NCRuntime:GetGroupRoster()
            local snapshot = NCDungeon.RosterSnapshot
            local mergedData = MapMerge(roster, snapshot)
            local players = GetHashmapKeys(mergedData)

            for _, name in pairs(players) do
                local info = UIDropDownMenu_CreateInfo()
                local role = NCInfo.ROLE_REPLACEMENTS[mergedData[name].role or "OTHER"]
                info.text = name .. " (" .. (role or "unknown") .. ")"
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
        self.SCROLLVIEW_HEIGHT = self.TOTAL_HEIGHT - self.HEADER_HEIGHT - self.HEADER_BUFFER - self.FOOTER_HEIGHT - self.FOOTER_BUFFER
        self.SCROLLVIEW_TOP = self.HEADER_HEIGHT + self.HEADER_BUFFER
        self.SCROLLVIEW_BOTTOM = self.FOOTER_HEIGHT + self.FOOTER_BUFFER
    end,

    ReportMetric = function(self, metric, player)
        local message = string.format("%s for %s (Dungeon): %s", (self.METRIC_REPLACEMENTS[metric] or metric), player, NemesisChat:FormatNumber(NCDungeon:GetStats(player, metric)))
        if core.db.profile.infoClickCompare then
            local delta = NCDungeon:GetStats(player, metric) - NCDungeon:GetStats(NemesisChat:GetMyName(), metric)
            
            if delta > 0 then
                message = message .. string.format(" (%s higher than mine)", NemesisChat:FormatNumber(delta))
            elseif delta < 0 then
                message = message .. string.format(" (%s lower than mine)", NemesisChat:FormatNumber(math.abs(delta)))
            end
        end
        SendChatMessage(message, NemesisChat:GetActualChannel("GROUP"))
    end,
}