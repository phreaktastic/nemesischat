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
    StatsFrame = CreateFrame("Frame", "NemesisChatInfoFrame", UIParent, "BackdropTemplate"),

    Initialize = function()
        NCInfo.StatsFrame:SetWidth(256)
        NCInfo.StatsFrame:SetHeight(400)
        NCInfo.StatsFrame:SetAlpha(0.8)
        NCInfo.StatsFrame:SetPoint("CENTER",UIParent)
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
                NCInfo.StatsFrame:SetPoint("CENTER",UIParent,"CENTER",0,200)
                NCInfo.StatsFrame.minimizeButton:SetText("+")
            else
                NCInfo.StatsFrame.content:Show()
                NCInfo.StatsFrame:SetHeight(400)
                NCInfo.StatsFrame:SetPoint("CENTER",UIParent)
                NCInfo.StatsFrame.minimizeButton:SetText("-")
            end
        end)

        NCInfo.StatsFrame.content = CreateFrame("Frame", nil, NCInfo.StatsFrame, "BackdropTemplate")
        NCInfo.StatsFrame.content:SetWidth(256)
        NCInfo.StatsFrame.content:SetHeight(376)
        NCInfo.StatsFrame.content:SetPoint("TOP", NCInfo.StatsFrame, "TOP", 0, -24)
        NCInfo.StatsFrame.content:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
            tile = true, tileSize = 16, edgeSize = 16, 
            insets = { left = 4, right = 4, top = 0, bottom = 4 }})
        NCInfo.StatsFrame.content:SetBackdropColor(0,0,0,0.25)
        NCInfo.StatsFrame.content:SetBackdropBorderColor(0,0,0,0)

        NCInfo.StatsFrame.content.first = CreateFrame("Frame", nil, NCInfo.StatsFrame.content, "BackdropTemplate")
        NCInfo.StatsFrame.content.first:SetPoint("TOPLEFT", NCInfo.StatsFrame.content, "TOPLEFT", 0, 0)
        NCInfo.StatsFrame.content.first:SetWidth(256)
        NCInfo.StatsFrame.content.first:SetHeight(24)

        lwin.RegisterConfig(NCInfo.StatsFrame, core.db.profile.statsFrame)
        lwin.RestorePosition(NCInfo.StatsFrame) 
        lwin.MakeDraggable(NCInfo.StatsFrame)
        lwin.EnableMouseOnAlt(NCInfo.StatsFrame)

        NCInfo.StatsFrame:Show()
    end,
}