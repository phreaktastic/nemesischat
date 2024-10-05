local addonName, core = ...

-- Create a new mixin for our custom button
UnitPopupToggleNemesisMixin = CreateFromMixins(UnitPopupButtonBaseMixin);

function UnitPopupToggleNemesisMixin:GetText(contextData)
    local playerName = UnitName(contextData.unit);
    if core.db.profile.nemeses[playerName] then
        return "Unmark as Nemesis";
    else
        return "Mark as Nemesis";
    end
end

function UnitPopupToggleNemesisMixin:CanShow(contextData)
    -- Only show for other players, not for the current player
    return not UnitIsUnit(contextData.unit, "player");
end

function UnitPopupToggleNemesisMixin:OnClick(contextData)
    local playerName = UnitName(contextData.unit);
    if core.db.profile.nemeses[playerName] then
        core.db.profile.nemeses[playerName] = nil;
        NemesisChat:Print(playerName .. " is no longer marked as a nemesis.");
    else
        core.db.profile.nemeses[playerName] = playerName;
        NemesisChat:Print(playerName .. " is now marked as a nemesis!");
    end
    CloseDropDownMenus();
end

-- Function to add our custom button to a specific menu
local function AddCustomButtonToMenu(menuName)
    local menu = UnitPopupManager:GetMenu(menuName);
    if menu then
        local originalGetEntries = menu.GetEntries;
        menu.GetEntries = function(self)
            local entries = originalGetEntries(self);
            table.insert(entries, UnitPopupToggleNemesisMixin);
            return entries;
        end
    end
end

-- Register the custom button with the UnitPopupManager
local function RegisterCustomButton()
    AddCustomButtonToMenu("PLAYER");
    AddCustomButtonToMenu("PARTY");
    AddCustomButtonToMenu("RAID_PLAYER");
    AddCustomButtonToMenu("FRIEND");
end

-- Register the custom button when the addon is loaded
local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");
frame:SetScript("OnEvent", function(self, event, loadedAddonName)
    if loadedAddonName == addonName then
        RegisterCustomButton();
    end
end);