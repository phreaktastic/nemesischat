-----------------------------------------------------
-- CONFIGURATION UI
-----------------------------------------------------
-- Core Tab - Nemeses Configuration
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

core.options.args.coreGroup.args.nemeses = {
    order = 2,
    type = "group",
    name = "Nemeses",
    args = {
        nemesesHeader = {
            order = 0,
            type = "header",
            name = "Nemeses",
        },
        nemesesDesc = {
            order = 1,
            type = "description",
            fontSize = "medium",
            name =
            "This is a list of all character names which will be flagged as Nemeses. You must include the realm name if the character is not on your realm, e.g. 'Nemesis-Stormrage'.",
        },
        nemesesPaddingUpper = {
            order = 2,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        addNemesis = {
            order = 3,
            type = "execute",
            name = "Add New Nemesis",
            func = function() NemesisChat:ShowAddRename(false) end,
        },
        nemesisSelect = {
            order = 4,
            type = "select",
            name = "Nemeses",
            width = "full",
            desc = "Choose a Nemesis to edit",
            values = "GetNemeses",
            get = "GetNemesis",
            set = "SetNemesis",
        },
        deleteNemesis = {
            order = 5,
            type = "execute",
            name = "Remove Selected",
            disabled = "DisableNemesisButtons",
            desc = "Remove the selected Nemesis from the list",
            func = "RemoveNemesis",
        },
        renameNemesis = {
            order = 6,
            type = "execute",
            name = "Rename Selected",
            disabled = "DisableNemesisButtons",
            desc = "Change the name of the selected Nemesis",
            func = function() NemesisChat:ShowAddRename(true) end,
        },
    }
}

local selectedNemesisName = ""

function NemesisChat:DisableNemesisButtons()
    return selectedNemesisName == nil or selectedNemesisName == ""
end

function NemesisChat:GetNemesis(info, value)
    if selectedNemesisName then return selectedNemesisName end

    return ""
end

function NemesisChat:SetNemesis(info, value)
    selectedNemesisName = value
end

function NemesisChat:GetAddNemesis(info)
    if selectedNemesisName ~= nil then return selectedNemesisName end
    return ""
end

function NemesisChat:RemoveNemesis(info, value)
    if core.db.profile.dbg then
        self:Print("Removing ", selectedNemesisName)
    end

    core.db.profile.nemeses[selectedNemesisName] = nil
    selectedNemesisName = ""
    NemesisChat:RefreshNemesesGroup()
end

function NemesisChat:RenameNemesis(nemesisName)
    core.db.profile.nemeses[selectedNemesisName] = nil

    core.db.profile.nemeses[nemesisName] = nemesisName
    selectedNemesisName = nemesisName
    NemesisChat:RefreshNemesesGroup()
end

function NemesisChat:AddNemesis(name)
    if not core.db.profile.nemeses[name] then
        core.db.profile.nemeses[name] = name
        self:Print("Added " .. name .. " as a Nemesis.")
        return name -- Return the new Nemesis name
    else
        self:Print(name .. " is already a Nemesis!")
        return nil
    end
end

function NemesisChat:ShowAddRename(isRename)
    StaticPopupDialogs["NEMESISCHAT_ADD_RENAME_NEMESIS"] = {
        text = "Enter name of new Nemesis:",
        button1 = "Accept",
        button2 = "Cancel",
        hasEditBox = true,
        editBoxWidth = 150,
        maxLetters = 12,
        OnAccept = function(self, data, data2)
            local name = self.editBox:GetText()
            if isRename then
                NemesisChat:RenameNemesis(name)
            else
                local newNemesis = NemesisChat:AddNemesis(name)
                if newNemesis then
                    NemesisChat:SetNemesis(nil, newNemesis)
                    selectedNemesisName = newNemesis
                    NemesisChat:RefreshNemesesGroup()
                end
            end
        end,
        OnShow = function(self, data)
            if isRename then
                self.text:SetFormattedText("Enter new name for %s:", selectedNemesisName)
                self.editBox:SetText(selectedNemesisName)
            end
        end,
        timeout = 0,
        exclusive = 1,
        whileDead = 1,
        hideOnEscape = 1
    }
    StaticPopup_Show("NEMESISCHAT_ADD_RENAME_NEMESIS", selectedNemesisName)
end

function NemesisChat:RefreshNemesesGroup()
    -- Update the values
    --self.options.args.nemesesGroup.args.nemesisSelect.values = self:GetNemeses()

    -- Notify Ace3 of the change
    AceConfigRegistry:NotifyChange("NemesisChat_options")
end
