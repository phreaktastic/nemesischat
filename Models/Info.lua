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

lwin = LibStub("LibWindow-1.1")

NCInfo = {
    LowPerformerOrder = 2,
    HighPerformerOrder = 1,
    PullReportOrder = 3,

    StatsFrame = CreateFrame("Frame", "NemesisChatInfoFrame", UIParent, "BackdropTemplate"),

    Initialize = function()
        NCInfo.StatsFrame:SetWidth(256)
        NCInfo.StatsFrame:SetHeight(280)
        NCInfo.StatsFrame:SetAlpha(0.8)
        NCInfo.StatsFrame:SetPoint("CENTER",UIParent,"CENTER",0,0)
        NCInfo.StatsFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
            tile = true, tileSize = 16, edgeSize = 16, 
            insets = { left = 4, right = 4, top = 4, bottom = 4 }})
        NCInfo.StatsFrame:SetBackdropColor(0,0,0,1)
        NCInfo.StatsFrame:SetBackdropBorderColor(0,0,0,1)

        NCInfo.StatsFrame.header = NCInfo.StatsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        NCInfo.StatsFrame.header:SetPoint("TOP", NCInfo.StatsFrame, "TOP", 0, -4)
        NCInfo.StatsFrame.header:SetText("Nemesis Chat")
        NCInfo.StatsFrame.header:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")

        NCInfo.StatsFrame.minimizeButton = CreateFrame("Button", nil, NCInfo.StatsFrame, "UIPanelButtonTemplate")
        NCInfo.StatsFrame.minimizeButton:SetPoint("TOPRIGHT", NCInfo.StatsFrame, "TOPRIGHT", -2, -2)
        NCInfo.StatsFrame.minimizeButton:SetSize(20, 20)
        NCInfo.StatsFrame.minimizeButton:SetText("-")
        NCInfo.StatsFrame.minimizeButton:SetNormalFontObject("GameFontNormal")
        NCInfo.StatsFrame.minimizeButton:SetHighlightFontObject("GameFontHighlight")
        NCInfo.StatsFrame.minimizeButton:SetScript("OnClick", function(self)
            if NCInfo.StatsFrame.content:IsShown() then
                NCInfo.StatsFrame.content:Hide()
                NCInfo.StatsFrame:SetHeight(24)
                NCInfo.StatsFrame:SetPoint("CENTER",UIParent,"CENTER",0,188)
                NCInfo.StatsFrame.minimizeButton:SetText("+")
            else
                NCInfo.StatsFrame.content:Show()
                NCInfo.StatsFrame:SetHeight(280)
                NCInfo.StatsFrame:SetPoint("CENTER",UIParent)
                NCInfo.StatsFrame.minimizeButton:SetText("-")
            end
        end)

        NCInfo.StatsFrame.content = CreateFrame("Frame", nil, NCInfo.StatsFrame, "BackdropTemplate")
        NCInfo.StatsFrame.content:SetWidth(256)
        NCInfo.StatsFrame.content:SetHeight(256)
        NCInfo.StatsFrame.content:SetPoint("TOP", NCInfo.StatsFrame, "TOP", 0, -24)
        NCInfo.StatsFrame.content:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
            tile = true, tileSize = 16, edgeSize = 16, 
            insets = { left = 4, right = 4, top = 0, bottom = 4 }})
        NCInfo.StatsFrame.content:SetBackdropColor(0,0,0,0.25)
        NCInfo.StatsFrame.content:SetBackdropBorderColor(0,0,0,0)

        NCInfo.StatsFrame.content.rows = CreateFrame("Frame", nil, NCInfo.StatsFrame.content, "BackdropTemplate")
        NCInfo.StatsFrame.content.rows:SetWidth(250)
        NCInfo.StatsFrame.content.rows:SetHeight(376)
        NCInfo.StatsFrame.content.rows:SetPoint("TOP", NCInfo.StatsFrame.content, "TOP", -3, 48)

        lwin.RegisterConfig(NCInfo.StatsFrame, core.db.profile.statsFrame)
        lwin.RestorePosition(NCInfo.StatsFrame) 
        lwin.MakeDraggable(NCInfo.StatsFrame)
        lwin.EnableMouseOnAlt(NCInfo.StatsFrame)

        NCInfo:Update()
    end,

    UpdateLastUnsafePullRow = function(self)
        local player, mob, count = NCRuntime:GetLastUnsafePull()
        local pullRow

        if player == "" then
            player = nil
        end

        local val = (player or "None") .. " (" .. (count or 0) .. ")"

        if NCInfo.StatsFrame.content and NCInfo.StatsFrame.content.rows[NCInfo.PullReportOrder] then
            pullRow = NCInfo.StatsFrame.content.rows[NCInfo.PullReportOrder]
            pullRow.value:SetText(val)
            pullRow.announceToPartyButton:Enable()
            pullRow.announceToPartyButton:Show()
        else
            pullRow = self:AddReportableContentRow(NCInfo.PullReportOrder, "Last Unsafe Pull", val)
        end

        pullRow.announceToPartyButton:SetScript("OnClick", function(self)
            local message = "Nemesis Chat: Last unsafe pull by " .. player .. " with a total mob count of " .. count .. "."

            if player ~= nil then
                SendChatMessage(message, "PARTY")
            end
        end)
        pullRow.announceToPartyButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Announce the last unsafe pull to the party.")
            GameTooltip:Show()
        end)
        pullRow.announceToPartyButton:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        if not player or player == "" then
            pullRow.announceToPartyButton:Hide()
        end
    end,

    UpdateHighPerformerRow = function(self)
        local highPerformer = NCDungeon:GetOverperformer()
        local highPerformerRow

        if NCInfo.StatsFrame.content and NCInfo.StatsFrame.content.rows[NCInfo.HighPerformerOrder] then
            highPerformerRow = NCInfo.StatsFrame.content.rows[NCInfo.HighPerformerOrder]
            highPerformerRow.value:SetText(highPerformer or "None")
            highPerformerRow.announceToPartyButton:Enable()
            highPerformerRow.announceToPartyButton:Show()
        else
            highPerformerRow = self:AddReportableContentRow(NCInfo.HighPerformerOrder, "Overperformer", highPerformer or "None", false)
        end

        highPerformerRow:SetScript("OnEnter", function(self)
            if not highPerformer then
                -- Add a tooltip whose owner is the cursor
                GameTooltip:SetOwner(self.value, "ANCHOR_RIGHT")
                GameTooltip:SetText("When there's a high performer, this will show their scoring.")
                GameTooltip:Show()
                return
            end

            local reasonArray = NCDungeon.Rankings.TopScores[highPerformer]
            local reasons = ""

            if not reasonArray or type(reasonArray) ~= "table" then
                return
            end

            for metric, reason in pairs(reasonArray) do
                reasons = reasons .. metric .. ": " .. reason .. " points\n"
            end

            GameTooltip:SetOwner(self.value, "ANCHOR_RIGHT")
            GameTooltip:SetText("Reasons for high performance:\n" .. reasons)
            GameTooltip:Show()
        end)

        highPerformerRow:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        highPerformerRow.announceToPartyButton:SetScript("OnClick", function(self)
            if not highPerformer then
                return
            end

            local message = "Nemesis Chat: " .. highPerformer .. " is dramatically outperforming the group."

            if highPerformer ~= nil then
                SendChatMessage(message, "PARTY")
            end
        end)
        highPerformerRow.announceToPartyButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Announce the highest performer to the party.")
            GameTooltip:Show()
        end)
        highPerformerRow.announceToPartyButton:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        if not highPerformer then
            highPerformerRow.announceToPartyButton:Hide()
        end
    end,

    UpdateLowPerformerRow = function(self)
        local lowPerformer = NCDungeon:GetUnderperformer()
        local rosterPlayer = NCRuntime:GetGroupRosterPlayer(lowPerformer)
        local lowPerformerRow

        if NCInfo.StatsFrame.content and NCInfo.StatsFrame.content.rows[NCInfo.LowPerformerOrder] then
            lowPerformerRow = NCInfo.StatsFrame.content.rows[NCInfo.LowPerformerOrder]
            lowPerformerRow.value:SetText(lowPerformer or "None")
            lowPerformerRow.addToListButton:Enable()
            lowPerformerRow.addToListButton:Show()
            lowPerformerRow.announceToPartyButton:Enable()
            lowPerformerRow.announceToPartyButton:Show()
        else
            lowPerformerRow = self:AddReportableContentRow(NCInfo.LowPerformerOrder, "Underperformer", lowPerformer or "None", true)
        end

        lowPerformerRow:SetScript("OnEnter", function(self)
            if not lowPerformer then
                GameTooltip:SetOwner(self.value, "ANCHOR_RIGHT")
                GameTooltip:SetText("When there's a low performer, this will show their scoring.")
                GameTooltip:Show()
                return
            end

            local reasonArray = NCDungeon.Rankings.TopScores[lowPerformer]
            local reasons = ""

            if not reasonArray or type(reasonArray) ~= "table" then
                return
            end

            for metric, reason in pairs(reasonArray) do
                reasons = reasons .. metric .. ": " .. reason .. " points\n"
            end

            GameTooltip:SetOwner(self.value, "ANCHOR_RIGHT")
            GameTooltip:SetText("Reasons for low performance:\n" .. reasons)
            GameTooltip:Show()
        end)

        lowPerformerRow:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        lowPerformerRow.announceToPartyButton:SetScript("OnClick", function(self)
            if not lowPerformer then
                return
            end

            local message = "Nemesis Chat: " .. lowPerformer .. " is dramatically underperforming."

            if lowPerformer ~= nil then
                SendChatMessage(message, "PARTY")
            end
        end)
        lowPerformerRow.announceToPartyButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Announce the lowest performer to the party.")
            GameTooltip:Show()
        end)
        lowPerformerRow.announceToPartyButton:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        lowPerformerRow.addToListButton:SetScript("OnClick", function(self)
            if not lowPerformer or not rosterPlayer then
                return
            end

            NemesisChat:AddLowPerformer(rosterPlayer.guid)

            lowPerformerRow.addToListButton:Hide()
            NemesisChat:Print("Added low performer to DB:", lowPerformer)
        end)
        lowPerformerRow.addToListButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Add the lowest performer to the database.")
            GameTooltip:Show()
        end)
        lowPerformerRow.addToListButton:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
        
        if not lowPerformer then
            lowPerformerRow.addToListButton:Hide()
            lowPerformerRow.announceToPartyButton:Hide()
        end
    end,

    Update = function(self)
        NCInfo:UpdateLowPerformerRow()
        NCInfo:UpdateHighPerformerRow()
        NCInfo:UpdateLastUnsafePullRow()
    end,

    AddReportableRow = function(self, label, value, rowParent, listButton, x, y)
        local reportableRow = CreateFrame("Frame", nil, rowParent, "BackdropTemplate")
        local valueX = -40
        local btnWidth = 40

        if not listButton then
            valueX = -20
            btnWidth = 20
        end

        reportableRow:SetPoint("TOPLEFT", rowParent, "TOPLEFT", x, y)
        reportableRow:SetWidth(242)
        reportableRow:SetHeight(72)
        reportableRow:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
            tile = true, tileSize = 16, edgeSize = 16, 
            insets = { left = 4, right = 4, top = 4, bottom = 4 }})
        reportableRow:SetBackdropColor(1,1,1,0.1)
        reportableRow:SetBackdropBorderColor(1,1,1,0.5)

        reportableRow.header = reportableRow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        reportableRow.header:SetPoint("TOP", reportableRow, "TOP", 0, 6)
        reportableRow.header:SetText(label)
        reportableRow.header:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
        
        reportableRow.value = reportableRow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        reportableRow.value:SetPoint("TOP", reportableRow, "TOP", 0, -22)
        reportableRow.value:SetText(value or "None")
        reportableRow.value:SetFont("Fonts\\FRIZQT__.TTF", 12)
        reportableRow.value:SetTextColor(1, 1, 1, 1)
        reportableRow.value:SetHeight(12)
        reportableRow.value:SetWidth(200)
        reportableRow.value:SetJustifyH("CENTER")
        reportableRow.value:SetJustifyV("CENTER")
        reportableRow.value:SetWordWrap(true)
        reportableRow.value:SetNonSpaceWrap(true)

        reportableRow.announceToPartyButton = CreateFrame("Button", nil, reportableRow, "UIPanelButtonTemplate")
        reportableRow.announceToPartyButton:SetPoint("BOTTOM", reportableRow.value, "RIGHT", 0, -34)
        reportableRow.announceToPartyButton:SetSize(20, 20)
        reportableRow.announceToPartyButton:SetNormalFontObject("GameFontNormal")
        reportableRow.announceToPartyButton:SetHighlightFontObject("GameFontHighlight")

        reportableRow.announceToPartyButton.icon = reportableRow.announceToPartyButton:CreateTexture(nil, "OVERLAY")
        reportableRow.announceToPartyButton.icon:SetSize(16, 16)
        reportableRow.announceToPartyButton.icon:SetPoint("CENTER", reportableRow.announceToPartyButton, "CENTER", 0, 0)
        reportableRow.announceToPartyButton.icon:SetTexture("Interface\\Icons\\UI_Chat")

        if listButton then
            reportableRow.addToListButton = CreateFrame("Button", nil, reportableRow, "UIPanelButtonTemplate")
            reportableRow.addToListButton:SetPoint("RIGHT", reportableRow.announceToPartyButton, "LEFT", 0, 0)
            reportableRow.addToListButton:SetSize(20, 20)
            reportableRow.addToListButton:SetNormalFontObject("GameFontNormal")
            reportableRow.addToListButton:SetHighlightFontObject("GameFontHighlight")

            reportableRow.addToListButton.icon = reportableRow.addToListButton:CreateTexture(nil, "OVERLAY")
            reportableRow.addToListButton.icon:SetSize(16, 16)
            reportableRow.addToListButton.icon:SetPoint("CENTER", reportableRow.addToListButton, "CENTER", 0, 0)
            reportableRow.addToListButton.icon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
        end

        -- reportableRow.label = reportableRow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        -- reportableRow.label:SetPoint("LEFT", reportableRow, "LEFT", 4, 0)
        -- reportableRow.label:SetText(label)
        -- reportableRow.label:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        
        return reportableRow
    end,

    AddReportableContentRow = function(self, order, label, value, listButton)
        local y = ((-82 * order) + 24)
        NCInfo.StatsFrame.content.rows[order] = self:AddReportableRow(label, value, NCInfo.StatsFrame.content.rows, listButton, 7, y)

        return NCInfo.StatsFrame.content.rows[order]
    end,
}