-----------------------------------------------------
-- CONFIGURATION UI
-----------------------------------------------------
-- Core Tab - Nemeses Configuration
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

core.options.args.nemesesGroup = {
    order = 1,
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
            name = "This is a list of all character names which will be flagged as Nemeses.",
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
            name = "Add Nemesis",
            func = function() NemesisChat:ShowAddRename(false) end,
        },
        nemeses = {
            order = 4,
            type = "select",
            name = "Nemeses",
            width = "full",
            desc = "Which character names triggered events can target.",
            values = "GetNemeses",
            get = "GetNemesis",
            set = "SetNemesis",
        },
        deleteNemesis = {
            order = 5,
            type = "execute",
            name = "Delete",
            disabled = "DisableNemesisButtons",
            desc = "Delete a nemesis from the list by selecting it.",
            func = "RemoveNemesis",
        },
        renameNemesis = {
            order = 6,
            type = "execute",
            name = "Rename",
            disabled = "DisableNemesisButtons",
            desc = "Rename a nemesis from the list by selecting it.",
            func = function() NemesisChat:ShowAddRename(true) end,
        },
    }
}

local selectedNemesisName = ""

function NemesisChat:DisableNemesisButtons()
    return selectedNemesisName == nil or selectedNemesisName == ""
end

function NemesisChat:GetNemeses(info)
    return core.db.profile.nemeses
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
end

function NemesisChat:RenameNemesis(nemesisName)
    core.db.profile.nemeses[selectedNemesisName] = nil

    core.db.profile.nemeses[nemesisName] = nemesisName
    selectedNemesisName = nemesisName
end

function NemesisChat:AddNemesis(nemesisName)
    if nemesisName == "" then
        return
    end
    core.db.profile.nemeses[nemesisName] = nemesisName
    selectedNemesisName = nemesisName
end

function NemesisChat:ShowAddRename(isRename)
    local AceGUI = LibStub("AceGUI-3.0")
    local frame = AceGUI:Create("Frame")
    local nemesisName = ""

    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    frame:SetLayout("Flow")
    frame:SetWidth(300)
    frame:SetHeight(200)

    local editbox = AceGUI:Create("EditBox")
    editbox:SetLabel("Nemesis name:")
    editbox:SetFullWidth(true)
    frame:AddChild(editbox)

    if isRename then
        frame:SetTitle("Rename Nemesis")
        editbox:SetText(selectedNemesisName)
        nemesisName = selectedNemesisName
    else
        frame:SetTitle("Add Nemesis")
    end

    local button = AceGUI:Create("Button")
    button:SetText("Save")
    button:SetFullWidth(true)
    button:SetDisabled(true)
    button:SetCallback("OnClick", function() if isRename then NemesisChat:RenameNemesis(nemesisName) frame:Release() else NemesisChat:AddNemesis(nemesisName) frame:Release() end end)
    frame:AddChild(button)

    editbox:SetCallback("OnEnterPressed", function(widget, event, text) nemesisName = text if nemesisName ~= "" then button:SetDisabled(false) else button:SetDisabled(true) end end)
end