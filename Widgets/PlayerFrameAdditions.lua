local _, core = ...

local nemeses

-- Function to get all units (party members and nameplates)
local function GetAllUnits()
    local units = {}

    -- Add party members
    if IsInGroup() then
        for i = 1, 4 do  -- Use 4 because "player" is not included in "party" units
            local partyUnit = "party" .. i
            if UnitExists(partyUnit) then
                table.insert(units, partyUnit)
            end
        end
    end

    -- Add raid members
    if IsInRaid() then
        for i = 1, 40 do
            local raidUnit = "raid" .. i
            if UnitExists(raidUnit) then
                table.insert(units, raidUnit)
            end
        end
    end

    -- Add nameplates
    local numNameplates = #C_NamePlate.GetNamePlates()
    for i = 1, numNameplates do
        local nameplate = C_NamePlate.GetNamePlateForUnit("nameplate" .. i)
        if nameplate then
            table.insert(units, "nameplate" .. i)
        end
    end

    -- Add target unit
    if UnitExists("target") then
        table.insert(units, "target")
    end

    return units
end

-- Function to get the party frame for a unit
local function GetPartyFrame(unit)
    if ElvUI then
        local index = string.sub(unit, 6) + 1
        return _G["ElvUF_PartyGroup1UnitButton" .. index]
    else
        if string.match(unit, "party") then
            local index = string.sub(unit, 6)
            return _G["CompactPartyFrameMember" .. index]
        end
    end
    return nil
end

-- Function to get the nameplate for a unit
local function GetNameplate(unit)
    return C_NamePlate.GetNamePlateForUnit(unit)
end

-- Function to get the target frame for a unit
local function GetTargetFrame(unit)
    if ElvUI then
        return _G["ElvUF_Target"]
    else
        if unit == "target" then
            return TargetFrame
        end
    end
    return nil
end

-- Function to get the full name of a unit, including realm if necessary
local function GetFullName(unit)
    local name, realm = UnitName(unit)
    if not name then return nil end
    local playerRealm = GetRealmName()
    if realm and realm ~= "" and realm ~= playerRealm then
        return name .. "-" .. realm
    else
        return name
    end
end

-- Function to add or remove an icon on a frame based on nemesis status
local function UpdateIconOnFrame(frame, isNemesis, frameType)
    if not frame then return end

    local configPath = "nemesisIcons.frames." .. frameType
    local isEnabled = NCConfig:GetPath(configPath .. ".enabled")
    if not isEnabled then
        if frame.nemesisIcon then
            frame.nemesisIcon:Hide()
            frame.nemesisIcon = nil
        end
        return
    end

    local iconIndex = NCConfig:GetPath(configPath .. ".iconIndex")
    local iconPath = "Interface\\Addons\\NemesisChat\\Media\\Icons\\Nemesis" .. iconIndex .. ".blp"
    local size = NCConfig:GetPath(configPath .. ".size")
    local point = NCConfig:GetPath(configPath .. ".point")
    local xOffset = NCConfig:GetPath(configPath .. ".xOffset")
    local yOffset = NCConfig:GetPath(configPath .. ".yOffset")

    local anchorFrame = frame
    if ElvUI then
        anchorFrame = frame.Health or frame
    else
        anchorFrame = frame.healthBar or frame
    end

    if isNemesis then
        if not frame.nemesisIcon then
            local iconTexture = anchorFrame:CreateTexture(nil, "OVERLAY")
            iconTexture:SetTexture(iconPath)
            iconTexture:SetSize(size, size)
            iconTexture:SetPoint(point, anchorFrame, point, xOffset, yOffset)
            iconTexture:SetDrawLayer("OVERLAY", 7)
            iconTexture:Show()
            frame.nemesisIcon = iconTexture
        else
            frame.nemesisIcon:SetTexture(iconPath)
            frame.nemesisIcon:SetSize(size, size)
            frame.nemesisIcon:SetPoint(point, anchorFrame, point, xOffset, yOffset)
            frame.nemesisIcon:Show()
        end
    else
        if frame.nemesisIcon then
            frame.nemesisIcon:Hide()
            frame.nemesisIcon = nil
        end
    end
end

-- Function to update the nemesis icon on the target frame
local function UpdateTargetFrame()
    local unit = "target"
    local fullName = GetFullName(unit)
    if fullName then
        local isNemesis = nemeses[fullName] ~= nil
        UpdateIconOnFrame(GetTargetFrame(unit), isNemesis, "target")
    end
end

-- Register for the PLAYER_TARGET_CHANGED event
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_TARGET_CHANGED" then
        UpdateTargetFrame()
    end
end)

-- Function to update nemesis icons on all relevant frames
function UpdateNemesisIcons()
    for _, unit in pairs(GetAllUnits()) do
        local fullName = GetFullName(unit)
        if fullName then
            local frameType
            if string.match(unit, "party") then
                frameType = "party"
            elseif string.match(unit, "nameplate") then
                frameType = "nameplate"
            elseif unit == "target" then
                frameType = "target"
            end

            if frameType then
                local isNemesis = nemeses[fullName] ~= nil
                if frameType == "party" then
                    UpdateIconOnFrame(GetPartyFrame(unit), isNemesis, frameType)
                elseif frameType == "nameplate" then
                    UpdateIconOnFrame(GetNameplate(unit), isNemesis, frameType)
                elseif frameType == "target" then
                    UpdateIconOnFrame(GetTargetFrame(unit), isNemesis, frameType)
                end
            end
        end
    end
end

-- Register the function to the DATABASE_INITIALIZED event
core.EventSystem:RegisterEvent("DATABASE_INITIALIZED", function()
    nemeses = NCConfig:GetNemeses()
    C_Timer.NewTicker(1, UpdateNemesisIcons)
end, 1)

-- Register for the NEMESIS_TOGGLED event
core.EventSystem:RegisterEvent("NEMESIS_TOGGLED", function()
    UpdateTargetFrame()
    UpdateNemesisIcons()
end)
