local _, core = ...

_G.NCL = _G.NCL or {}
_G.NCL.SoundDropdown = {
    Type = "SoundDropdown",
    Version = 1,
    Constructor = nil
}

local AceGUI = LibStub("AceGUI-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local Type = _G.NCL.SoundDropdown.Type
local Version = _G.NCL.SoundDropdown.Version

if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

local function PreviewSound(soundId)
    if soundId then
        if _G.NCL.SoundDropdown.currentPreviewHandle then
            StopSound(_G.NCL.SoundDropdown.currentPreviewHandle)
            _G.NCL.SoundDropdown.currentPreviewHandle = nil
        end
        local _, handle = PlaySound(soundId, "Master", true)
        _G.NCL.SoundDropdown.currentPreviewHandle = handle
    end
end

local function GenerateUUID()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 15) or math.random(8, 11)
        return string.format('%x', v)
    end)
end

local function CreatePreviewButton(parent)
    local previewBtn = CreateFrame("Button", nil, parent)
    previewBtn:SetSize(20, 20)
    previewBtn:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")

    previewBtn:SetScript("OnEnter", function(self)
        if not self.glow then
            self.glow = self:CreateTexture(nil, "OVERLAY")
            self.glow:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
            self.glow:SetBlendMode("ADD")
            self.glow:SetPoint("CENTER")
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

    previewBtn.uuid = GenerateUUID()

    return previewBtn
end

local function AddPreviewButtons(dropdown)
    if not dropdown.isSoundDropdown then return end

    if dropdown.pullout and dropdown.pullout.items then
        for _, item in pairs(dropdown.pullout.items) do
            if not item.previewButton then
                local previewBtn = CreatePreviewButton(item.frame)
                previewBtn:SetPoint("LEFT", item.frame, "LEFT", 2, 0)
                previewBtn:SetScript("OnClick", function()
                    if item.userdata and item.userdata.value and type(item.userdata.value) == "number" then
                        PreviewSound(item.userdata.value)
                    end
                    return true
                end)
                item.previewButton = previewBtn
            else
                item.previewButton:Show()
                item.previewButton:EnableMouse(true)
            end

            item.text:ClearAllPoints()
            item.text:SetPoint("LEFT", item.previewButton, "RIGHT", 5, 0)
            item.text:SetPoint("RIGHT", item.frame, "RIGHT", -2, 0)
        end
    end
end

local function CleanupDropdown(dropdown)
    if dropdown.pullout and dropdown.pullout.items then
        for _, item in pairs(dropdown.pullout.items) do
            if item.previewButton then
                item.previewButton:Hide()
                item.previewButton:EnableMouse(false)
                item.previewButton:SetScript("OnClick", nil)
                item.previewButton = nil
            end

            -- Reset text position to default
            item.text:ClearAllPoints()
            item.text:SetPoint("LEFT", item.frame, "LEFT", 5, 0)
            item.text:SetPoint("RIGHT", item.frame, "RIGHT", -2, 0)
        end
    end

    AceConfigRegistry:NotifyChange("NemesisChat_options")
end

local function ReAddPreviewButtons(dropdown)
    if dropdown.isSoundDropdown then
        C_Timer.After(0.1, function()
            AddPreviewButtons(dropdown)
        end)
    end
end

_G.NCL.SoundDropdown.Constructor = function()
    local dropdown = AceGUI:Create("Dropdown")
    dropdown.type = "SoundDropdown"
    dropdown.isSoundDropdown = true

    local originalRelease = dropdown.OnRelease
    dropdown.OnRelease = function(self)
        CleanupDropdown(self)
        if originalRelease then
            originalRelease(self)
        end
    end

    local mainPreviewBtn = CreatePreviewButton(dropdown.frame)
    mainPreviewBtn:SetPoint("LEFT", dropdown.frame, "LEFT", 6, -8)
    mainPreviewBtn:SetSize(24, 24)
    mainPreviewBtn:SetFrameLevel(dropdown.frame:GetFrameLevel() + 2)

    dropdown.text:ClearAllPoints()
    dropdown.text:SetPoint("LEFT", mainPreviewBtn, "RIGHT", 5, 0)
    dropdown.text:SetPoint("RIGHT", dropdown.button, "LEFT", -2, 0)

    mainPreviewBtn:SetScript("OnClick", function()
        if dropdown.value then
            PreviewSound(dropdown.value)
        end
        return true
    end)

    dropdown.frame:HookScript("OnHide", function()
        CleanupDropdown(dropdown)
    end)

    dropdown.frame:HookScript("OnShow", function()
        ReAddPreviewButtons(dropdown)
    end)

    return dropdown
end

AceGUI:RegisterWidgetType("SoundDropdown", _G.NCL.SoundDropdown.Constructor, 1)
