_G.NCL = _G.NCL or {}
_G.NCL.SoundDropdown = {
    Type = "NCSoundDropdown",
    Version = 1,
    Constructor = nil
}

local AceGUI = LibStub("AceGUI-3.0")
local Type = _G.NCL.SoundDropdown.Type
local Version = _G.NCL.SoundDropdown.Version

if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

local function PreviewSound(soundId)
    if soundId then
        if _G.NCL.SoundDropdown.currentPreviewHandle then
            StopSound(_G.NCL.SoundDropdown.currentPreviewHandle)
            _G.NCL.SoundDropdown.currentPreviewHandle = nil
        end
        local _, handle = PlaySound(soundId, "Master")
        _G.NCL.SoundDropdown.currentPreviewHandle = handle
    end
end

local function CreatePreviewButton(parent)
    local previewBtn = CreateFrame("Button", nil, parent)
    previewBtn:SetSize(16, 16)
    previewBtn:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")

    -- Add subtle glow effect on hover
    previewBtn:SetScript("OnEnter", function(self)
        if not self.glow then
            self.glow = self:CreateTexture(nil, "OVERLAY")
            self.glow:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
            self.glow:SetBlendMode("ADD")
            self.glow:SetPoint("CENTER")
            self.glow:SetSize(20, 20)
        end
        self.glow:Show()
        self:GetNormalTexture():SetVertexColor(1.0, 0.82, 0)
    end)
    previewBtn:SetScript("OnLeave", function(self)
        if self.glow then
            self.glow:Hide()
        end
        self:GetNormalTexture():SetVertexColor(1, 1, 1)
    end)

    return previewBtn
end

local function AddPreviewButtons(dropdown)
    if dropdown.pullout and dropdown.pullout.items then
        for _, item in pairs(dropdown.pullout.items) do
            if item and item.frame and not item.previewButton then
                local previewBtn = CreatePreviewButton(item.frame)
                previewBtn:SetPoint("LEFT", item.frame, "LEFT", 2, 0)

                -- Adjust text position
                item.text:ClearAllPoints()
                item.text:SetPoint("LEFT", previewBtn, "RIGHT", 5, 0)
                item.text:SetPoint("RIGHT", item.frame, "RIGHT", -2, 0)

                previewBtn:SetScript("OnClick", function()
                    if item.userdata and item.userdata.value then
                        PreviewSound(item.userdata.value)
                    end
                    return true
                end)

                item.previewButton = previewBtn
            end
        end
    end
end

_G.NCL.SoundDropdown.Constructor = function()
    local dropdown = AceGUI:Create("Dropdown")
    local frame = dropdown.frame

    -- Add preview button for selected value
    local mainPreviewBtn = CreatePreviewButton(frame)
    mainPreviewBtn:SetPoint("LEFT", frame, "LEFT", 6, -8)
    mainPreviewBtn:SetSize(24, 24)
    mainPreviewBtn:SetFrameLevel(frame:GetFrameLevel() + 2) -- Ensure button is above other elements

    -- Adjust text position for the main dropdown
    dropdown.text:ClearAllPoints()
    dropdown.text:SetPoint("LEFT", mainPreviewBtn, "RIGHT", 5, 0)
    dropdown.text:SetPoint("RIGHT", dropdown.button, "LEFT", -2, 0)

    mainPreviewBtn:SetScript("OnClick", function()
        if dropdown.value then
            PreviewSound(dropdown.value)
        end
        return true
    end)

    -- Override the SetList method to ensure preview buttons are added when the list changes
    local originalSetList = dropdown.SetList
    function dropdown:SetList(...)
        originalSetList(self, ...)
        if self.pullout and self.pullout:IsShown() then
            C_Timer.After(0.1, function()
                AddPreviewButtons(self)
            end)
        end
    end

    function dropdown:SetDisabled(disabled)
        self.button:SetEnabled(not disabled)
        mainPreviewBtn:SetEnabled(not disabled)
    end

    return dropdown
end

AceGUI:RegisterWidgetType(Type, _G.NCL.SoundDropdown.Constructor, Version)
