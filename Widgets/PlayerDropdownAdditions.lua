local addonName, core = ...
local Lib = LibStub("LibDropDownExtension-1.0")
if not Lib then
    return
end

local dropdown = {
    validTypes = {
        ARENAENEMY = true,
        BN_FRIEND = true,
        CHAT_ROSTER = true,
        COMMUNITIES_GUILD_MEMBER = true,
        COMMUNITIES_WOW_MEMBER = true,
        ENEMY_PLAYER = true,
        FOCUS = true,
        FRIEND = true,
        GUILD = true,
        GUILD_OFFLINE = true,
        PARTY = true,
        PLAYER = true,
        RAID = true,
        RAID_PLAYER = true,
        SELF = false,
        TARGET = false,
        WORLD_STATE_SCORE = false,
    },
    validTags = {
        MENU_LFG_FRAME_SEARCH_ENTRY = 1,
        MENU_LFG_FRAME_MEMBER_APPLY = 1,
    }
}

local selectedName, selectedRealm, selectedLevel, selectedUnit, selectedFaction

local isEnabled = false
local initialized = false

-- Helper functions
local function IsValidDropDown(bdropdown)
    if not isEnabled then return false end
    return (bdropdown == LFGListFrameDropDown) or
           (type(bdropdown.which) == "string" and dropdown.validTypes[bdropdown.which])
end

local function GetNameRealmForDropDown(bdropdown)
    local unit = bdropdown.unit
    if unit and UnitExists(unit) then
        if UnitIsPlayer(unit) then
            return UnitName(unit), GetNormalizedRealmName(), UnitLevel(unit), unit, UnitFactionGroup(unit)
        end
        return nil
    end
    return bdropdown.name, bdropdown.server, nil, nil, UnitFactionGroup("player")
end

-- Pre-define options
local unitOptions = {
    {
        text = function() return NCConfig and NCConfig:GetNemesis(selectedName) ~= nil and "Unmark as Nemesis" or "Mark as Nemesis" end,
        notCheckable = true,
        func = function()
            NCConfig:ToggleNemesis(selectedName)
        end,
    }
}

local function OnToggle(dropdownFrame, event, options, level, data)
    if event == "OnShow" then
        if not IsValidDropDown(dropdownFrame) then
            return false
        end

        selectedName, selectedRealm, selectedLevel, selectedUnit, selectedFaction = GetNameRealmForDropDown(dropdownFrame)
        if not selectedName then
            return false
        end

        if not options[1] then
            local index = 0
            for i = 1, #unitOptions do
                local option = unitOptions[i]
                index = index + 1
                options[index] = option
            end
            return true
        end
    elseif event == "OnHide" then
        if options[1] then
            table.wipe(options)
            return true
        end
    end
    return false
end

-- ModifyMenu support
local ModifyMenu = Menu and Menu.ModifyMenu
local function OnMenuShow(owner, rootDescription, contextData)
    if not contextData then
        return
    end

    if not dropdown.validTypes[contextData.which] then
        return
    end

    local name = contextData.name
    local fullName = contextData.server and contextData.server ~= GetNormalizedRealmName() and (name .. "-" .. contextData.server) or name

    local buttonText = NCConfig and NCConfig:GetNemesis(fullName) ~= nil and "Unmark as Nemesis" or "Mark as Nemesis"

    rootDescription:CreateDivider()
    rootDescription:CreateTitle("Nemesis Chat")
    rootDescription:CreateButton(buttonText, function()
        NCConfig:ToggleNemesis(fullName)
    end)
end

local function OnContextMenuToggled(enabled)
    isEnabled = enabled

    -- If we're disabling and we have registered handlers, clean up
    if not enabled and initialized then
        if ModifyMenu then
            for name, enabled in pairs(dropdown.validTypes) do
                if enabled then
                    local tag = format("MENU_UNIT_%s", name)
                    ModifyMenu(tag, nil) -- Remove handler
                end
            end
            for tag, _ in pairs(dropdown.validTags) do
                ModifyMenu(tag, nil) -- Remove handler
            end
        end

        Lib:UnregisterEvent("OnShow OnHide", OnToggle)
        initialized = false
    -- If we're enabling and haven't initialized, set up handlers
    elseif enabled and not initialized then
        -- Register both LibDropDownExtension and ModifyMenu handlers
        if ModifyMenu then
            for name, enabled in pairs(dropdown.validTypes) do
                if enabled then
                    local tag = format("MENU_UNIT_%s", name)
                    ModifyMenu(tag, GenerateClosure(OnMenuShow))
                end
            end
            for tag, _ in pairs(dropdown.validTags) do
                ModifyMenu(tag, GenerateClosure(OnMenuShow))
            end
        end

        Lib:RegisterEvent("OnShow OnHide", OnToggle, 1, dropdown)
        initialized = true
    end
end

-- Subscribe to both initial setup and toggle events
core.EventSystem:RegisterEvent("DATABASE_INITIALIZED", function()
    isEnabled = NCConfig:IsContextMenuEnabled()
    OnContextMenuToggled(isEnabled)
end, 1)
core.EventSystem:RegisterEvent("NC_CONTEXT_MENU_TOGGLED", OnContextMenuToggled, 1)
