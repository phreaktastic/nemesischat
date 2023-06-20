-----------------------------------------------------
-- CONFIGURATION UI
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local messagePreview = ""

core.defaults = {
	profile = {
		enabled = true,
        dbg = false,
        detailsAPI = false,
        ai = true,
        useGlobalChance = false,
        globalChance = 0.5,
        minimumTime = 1,
        nemeses = {},
        messages = {},
	},
}

core.options = { 
	name = "Nemesis Chat",
	handler = NemesisChat,
	type = "group",
    -- childGroups = "tab",
	args = {
        generalGroup = {
            order = 0,
            type = "group",
            name = "General Settings",
            args = {
                -- dbg = {
                --     order = 0,
                --     type = "toggle",
                --     name = "Debug",
                --     desc = "Shows debug information",
                --     get = "IsDebug",
                --     set = "ToggleDebug",
                -- },
                enabled = {
                    order = 1,
                    type = "toggle",
                    name = "Enable",
                    desc = "Enable/disable Nemesis Chat",
                    get = "IsEnabled",
                    set = "EnableDisable",
                },
                detailsAPI = {
                    order = 2,
                    type = "toggle",
                    name = "Details API",
                    desc = "Enable/disable Details API -- data driven smack talking! If you out-DPS someone, talk smack. If they out-DPS you, talk smack.",
                    get = "IsDetailsAPI",
                    set = "ToggleDetailsAPI",
                },
                ai = {
                    order = 3,
                    type = "toggle",
                    name = "AI Phrases",
                    desc = "Enable/disable AI Generated Phrases. This allows you to run NC without configuring any phrases.",
                    get = "IsAI",
                    set = "ToggleAI",
                },
                globalChanceToggle = {
                    order = 4,
                    type = "toggle",
                    name = "Use Global Chance",
                    desc = "Enable/disable Global Chance. This allows you to ensure that messages will only be sent a percentage of the time.",
                    get = "IsUseGlobalChance",
                    set = "ToggleUseGlobalChance",
                },
                globalChanceSlider = {
                    order = 5,
                    type = "range",
                    min = 0.0,
                    max = 1.0,
                    step = 0.05,
                    name = "Global Chance",
                    desc = "A chance can be 0.0 (0%) to 1.0 (100%).",
                    get = "GetGlobalChance",
                    set = "SetGlobalChance",
                    disabled = function() return core.db.profile.useGlobalChance ~= true end
                },
                minimumTimeSlider = {
                    order = 6,
                    type = "range",
                    min = 1,
                    max = 300,
                    step = 1,
                    name = "Minimum Time",
                    desc = "The minimum time (in seconds) between messages.",
                    get = "GetMinimumTime",
                    set = "SetMinimumTime",
                },
            }
        },
        nemesesGroup = {
            order = 1,
            type = "group",
            name = "Nemesis Chat Core",
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
                    name = "This is a list of all character names which will be bantered with. |c00ffcc00If this list is empty, no banter will occur.|r",
                },
                nemesesPaddingUpper = {
                    order = 2,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                nemeses = {
                    order = 3,
                    type = "select",
                    name = "Nemeses",
                    desc = "Which character names to talk smack to.",
                    values = "GetNemeses",
                    get = "GetNemesis",
                    set = "SetNemesis",
                },
                nemesisInput = {
                    order = 4,
                    type = "input",
                    name = "Nemesis Name",
                    desc = "Enter a character name to add. If a nemesis is selected, this will rename the selected nemesis.",
                    get = "GetAddNemesis",
                    set = "SetAddNemesis",
                },
                deselectNemesis = {
                    order = 5,
                    type = "execute",
                    name = "Deselect",
                    disabled = "DisableNemesisButtons",
                    desc = "Deselect the currently selected nemesis.",
                    func = "DeselectNemesis",
                },
                deleteNemesis = {
                    order = 6,
                    type = "execute",
                    name = "Remove",
                    disabled = "DisableNemesisButtons",
                    desc = "Remove a nemesis from the list by selecting it.",
                    func = "RemoveNemesis",
                },
                nemesesPaddingLower = {
                    order = 7,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                messagesHeader = {
                    order = 8,
                    type = "header",
                    name = "Triggered Messages",
                },
                messagesDesc = {
                    order = 9,
                    type = "description",
                    fontSize = "large",
                    name = "General",
                },
                messagesPaddingUpper = {
                    order = 10,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                messagesCategories = {
                    order = 11,
                    type = "select",
                    name = "Category",
                    width = "full",
                    values = "GetCategories",
                    get = "GetCategory",
                    set = "SetCategory"
                },
                messagesEvents = {
                    order = 12,
                    type = "select",
                    name = "Event",
                    width = "full",
                    values = "GetEvents",
                    get = "GetEvent",
                    set = "SetEvent",
                    hidden = "IsEventsHidden",
                    disabled = "IsEventsHidden",
                },
                messagesTargets = {
                    order = 13,
                    type = "select",
                    name = "Target",
                    width = "full",
                    values = "GetTargets",
                    get = "GetTarget",
                    set = "SetTarget",
                    hidden = "IsTargetsHidden",
                    disabled = "IsTargetsHidden",
                },
                messagesConfigPaddingUpper = {
                    order = 14,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                messagesDelete = {
                    order = 15,
                    type = "execute",
                    func = "DeleteMessage",
                    name = "Delete",
                    disabled = "NoMessageSelected",
                    hidden = "NoMessageSelected"
                },
                messagesDeselect = {
                    order = 16,
                    type = "execute",
                    func = "DeselectMessage",
                    name = "Deselect",
                    disabled = "NoMessageSelected",
                    hidden = "NoMessageSelected"
                },
                messagesConfigured = {
                    order = 17,
                    type = "select",
                    name = "Configured Messages",
                    width = "full",
                    values = "GetConfiguredMessages",
                    get = "GetConfiguredMessage",
                    set = "SetConfiguredMessage",
                    hidden = "ConfiguredMessagesDisabled",
                    disabled = "ConfiguredMessagesDisabled",
                },
                messagesLabel = {
                    order = 18,
                    type = "input",
                    name = "Message Label",
                    width = "full",
                    get = "GetMessageLabel",
                    set = "SetMessageLabel",
                    hidden = "IsMessageHidden",
                    disabled = "IsMessageHidden",
                },
                messagesMessage = {
                    order = 19,
                    type = "input",
                    name = "Message",
                    multiline = true,
                    width = "full",
                    get = "GetMessage",
                    set = "SetMessage",
                    hidden = "IsMessageHidden",
                    disabled = "IsMessageHidden",
                },
                messagesChannel = {
                    order = 20,
                    type = "select",
                    name = "Chat Channel",
                    width = "full",
                    values = "GetChannels",
                    get = "GetChannel",
                    set = "SetChannel",
                    hidden = "IsMessageHidden",
                    disabled = "IsMessageHidden",
                },
                messagesChance = {
                    order = 21,
                    type = "range",
                    name = "Chance",
                    desc = "The chance that this individual message will be sent. 0.0 (0%) to 1.0 (100%).",
                    width = "full",
                    get = "GetChance",
                    set = "SetChance",
                    min = 0.0,
                    max = 1.0,
                    step = 0.05,
                    hidden = "IsMessageHidden",
                    disabled = "IsMessageHidden",
                },
                messagesPreviewHeader = {
                    order = 22,
                    type = "description",
                    fontSize = "medium",
                    name = "\n|c00ffcc00Message Preview:|r\n",
                    hidden = "IsMessageHidden",
                    disabled = "IsMessageHidden",
                },
                messagesPreview = {
                    order = 23,
                    type = "description",
                    name = function() NemesisChat:UpdateMessagePreview() return messagePreview end,
                    hidden = "IsMessageHidden",
                    disabled = "IsMessageHidden",
                },
                conditionsPaddingUpper = {
                    order = 24,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                    hidden = "NoMessageSelected",
                },
                conditionsDesc = {
                    order = 25,
                    type = "description",
                    fontSize = "large",
                    name = "Conditions",
                    hidden = "NoMessageSelected",
                },
                conditionsPaddingLower = {
                    order = 26,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                    hidden = "NoMessageSelected",
                },
                conditionsAdd = {
                    order = 27,
                    type = "execute",
                    func = "AddCondition",
                    name = "Add",
                    disabled = "NoMessageSelected",
                    hidden = "NoMessageSelected"
                },
                conditionsDelete = {
                    order = 28,
                    type = "execute",
                    func = "DeleteCondition",
                    name = "Delete",
                    disabled = "NoConditionSelected",
                    hidden = "NoConditionSelected"
                },
                conditions = {
                    order = 29,
                    type = "select",
                    name = "Condition",
                    width = "full",
                    values = "GetConditions",
                    get = "GetCondition",
                    set = "SetCondition",
                    hidden = "NoMessageSelected",
                    disabled = "NoMessageSelected",
                },
                conditionsPaddingButtons = {
                    order = 30,
                    type = "description",
                    fontSize = "medium",
                    name = " ",
                    hidden = "NoMessageSelected",
                },
                conditionSubject = {
                    order = 31,
                    type = "select",
                    name = "Condition",
                    -- width = "full",
                    values = "GetConditionSubjects",
                    get = "GetConditionSubject",
                    set = "SetConditionSubject",
                    hidden = "NoConditionSelected",
                    disabled = "NoConditionSelected",
                },
                conditionOperator = {
                    order = 32,
                    type = "select",
                    name = "Operator",
                    width = "half",
                    values = "GetConditionOperators",
                    get = "GetConditionOperator",
                    set = "SetConditionOperator",
                    hidden = "NoConditionSelected",
                    disabled = "NoConditionSelected",
                },
                conditionValueSelect = {
                    order = 33,
                    type = "select",
                    name = "Value",
                    -- width = "full",
                    values = "GetConditionValues",
                    get = "GetConditionValue",
                    set = "SetConditionValue",
                    hidden = "ConditionIsInput",
                    disabled = "ConditionIsInput",
                },
                conditionValueInput = {
                    order = 33,
                    type = "input",
                    name = "Value",
                    desc = "Replacements (such as |c00ffcc00[NEMESIS]|r) are allowed here. Please refer to the Reference tab for a list of available replacements.",
                    -- width = "full",
                    get = "GetConditionValue",
                    set = "SetConditionValue",
                    hidden = "ConditionIsSelect",
                    disabled = "ConditionIsSelect",
                },
                conditionsPaddingSaveDiscard = {
                    order = 34,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                    hidden = "NoMessageSelected",
                },
                messagesSave = {
                    order = 35,
                    type = "execute",
                    func = "SaveMessage",
                    name = "Save",
                    disabled = "HideSave",
                    hidden = "HideSave"
                },
                messagesDiscard = {
                    order = 36,
                    type = "execute",
                    func = "DiscardChanges",
                    name = "Discard",
                    disabled = "HideSave",
                    hidden = "HideSave"
                },
            }
        },
        infoGroup = {
            order = 2,
            type = "group",
            name = "Reference",
            args = {
                infoHeader = {
                    order = 0,
                    type = "header",
                    name = "Nemesis Chat Reference",
                },
                infoHeaderPadding = {
                    order = 1,
                    type = "description",
                    fontSize = "large",
                    name = "",
                },
                infoRefReplacementHeader = {
                    order = 2,
                    type = "description",
                    fontSize = "large",
                    name = "Text Replacements",
                },
                infoRefReplacementPaddingTop = {
                    order = 3,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                infoRefReplacements = {
                    order = 4,
                    type = "description",
                    fontSize = "medium",
                    name = function() return NemesisChat:GetReplacementTooltip() end,
                },
                infoRefReplacementPaddingBottom = {
                    order = 5,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                infoChanceHeader = {
                    order = 6,
                    type = "description",
                    fontSize = "large",
                    name = "Message Chance",
                },
                infoChancePaddingTop = {
                    order = 7,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                infoChance = {
                    order = 8,
                    type = "description",
                    fontSize = "medium",
                    name = "Chance is tricky for a multitude of reasons. Firstly, messages are chosen at random when an appropriate trigger event fires. That in consideration, having one message with a chance of 80% and another with a chance of 20% does NOT mean there will be a 100% chance for one of them to fire. Secondly, missing a roll means a phrase will not be sent at all. Finally, the real math behind a chance would be |c00ffcc00(1 / x) * (y / 100)|r with |c00ffcc00x|r being the number of phrases for this event, and |c00ffcc00y|r being the individual phrase's chance. So with 2 phrases for one triggered event, you have a 50% chance to get a particular phrase. If the chosen phrase's chance is 50%, that means the overall chance to send that particular phrase is 25%. Please keep this in mind!\n\nThe NC algorithm is designed with spam prevention in mind, not with weighted phrase chance accuracy. Setting a chance below 100% is useful for preventing a phrase from sending every time a particular event fires.",
                    width = "full",
                },
            }
        },
        aboutGroup = {
            order = 3,
            type = "group",
            name = "About",
            args = {
                generalHeader = {
                    order = 0,
                    type = "header",
                    name = "About Nemesis Chat " .. core.version,
                },
                generalDesc = {
                    order = 1,
                    type = "description",
                    fontSize = "medium",
                    name = "Nemesis Chat was (poorly) written by Phreaktastic. Features essentially just come as I run M+ dungeons with my guild and new ideas are spawned.\n\nNC is NOT meant to be anything more than friendly banter. Be cool, don't use it to actually berate people. Use it to have fun and banter with your friends!\n\nThe purpose of this addon is to taunt friends while running in groups. I main DPS, so the majority of features are from a DPS player's standpoint. Other features will likely be added in the future (such as detecting if someone used defensives before a death), embracing other roles and functionality they may enjoy.",
                },
                generalPadding = {
                    order = 3,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                reportingHeader = {
                    order = 4,
                    type = "header",
                    name = "Bug Reporting / Suggestions",
                },
                reportingDesc = {
                    order = 5,
                    type = "description",
                    fontSize = "medium",
                    name = "I haven't been able to test this extremely thoroughly. I have ran through hundreds of Mythic+ dungeons testing functionality and ensuring NC contains minimal bugs, however, that simply isn't enough considering the scope of the addon.\n\nI haven't setup any means of reporting bugs or submitting suggestions yet. If people actually use this addon I will start a Discord for bug reporting. As it stands, I just made this so I can relentlessly talk smack on friends :)\n\nIf there's interest in submitting pull requests for NC, I'm totally open to that. The design of the codebase should be fairly friendly for building onto it, barring a few relics from past iterations.",
                },
                reportingPadding = {
                    order = 6,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                plannedHeader = {
                    order = 7,
                    type = "header",
                    name = "Potential Features, Enhancements, & Fixes",
                },
                plannedDesc = {
                    order = 8,
                    type = "description",
                    fontSize = "medium",
                    name = "|c00ffcc00Details Finalization|r: Wrapping up on the Details! API. Additional events and banter based on Details data.\n|c00ffcc00More Replacements|r: Additional replacements, such as [INTERRUPTS], [NEMESISINTERRUPTS], etc.\n|c00ffcc00Selection Mode|r: A toggleable mode which will show a non-invasive pop-up to choose phrases. Example, you just finished a M+ and now have a pop-up with phrases to choose from (both from the end trigger AND Details data). This would be useful for scenarios where multiple events may trigger, but you don't want them to spam chat.\n",
                },
                plannedPadding = {
                    order = 9,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                plannedDisclaimer = {
                    order = 10,
                    type = "description",
                    fontSize = "large",
                    name = "Disclaimer: None of the features, enhancements, or fixes listed above are guaranteed. I have provided a general roadmap as a guide to what is currently on the radar and being considered. It is not meant as a list of priorities or work that is in progress.",
                },
                plannedDisclaimerPadding = {
                    order = 11,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
            }
        },
	},
}

-- Local variables

-- Nemesis cfg
local selectedNemesisName = ""

-- Message cfg
local selectedCategory = ""
local selectedEvent = ""
local selectedTarget = ""
local selectedConfiguredMessage = ""
local selectedCondition = ""

local message = ""
local messageChannel = ""
local messageLabel = ""
local messageChance = 1.0
local messageConditions = {}

-- Reference
local selectedRefTrigger = ""
local selectedRefReplacement = ""

-- Initialization - called from core
function NemesisChat:InitializeConfig()
    AC:RegisterOptionsTable("NemesisChat_options", core.options)
	core.optionsFrame = ACD:AddToBlizOptions("NemesisChat_options", "NemesisChat")
end

-- Setters + Getters for config screens
function NemesisChat:DeselectNemesis()
    selectedNemesisName = ""
end

function NemesisChat:DisableNemesisButtons()
    return selectedNemesisName == nil or selectedNemesisName == ""
end

function NemesisChat:IsEnabled(info)
	return core.db.profile.enabled
end

function NemesisChat:EnableDisable(info, value)
	core.db.profile.enabled = value
end

function NemesisChat:IsDebug(info)
	return core.db.profile.dbg
end

function NemesisChat:ToggleDebug(info, value)
	core.db.profile.dbg = value

    if value then
        self:Print("Debug mode enabled.")
    else
        self:Print("Debug mode disabled.")
    end
end

function NemesisChat:IsDetailsAPI(info)
	return core.db.profile.detailsAPI
end

function NemesisChat:ToggleDetailsAPI(info, value)
    if value == true and Details == nil then
        self:Print("Cannot enable Details API: Details could not be found! Please ensure it is enabled and functional.")
        return
    end
	core.db.profile.detailsAPI = value

    if value == false then
        return
    end

    local AceGUI = LibStub("AceGUI-3.0")
    local frame = AceGUI:Create("Frame")
    frame:SetTitle("Reload Required")
    -- frame:SetStatusText("Please reload your UI in order to load the changes you just made.")
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    frame:SetLayout("List")
    frame:SetWidth(300)
    frame:SetHeight(300)

    local desc = AceGUI:Create("Label")
    desc:SetText("Enabling the Details! API requires a reload. If you choose not to reload, functionality will absolutely be unexpected and may even cause LUA errors to be thrown. It is highly recommended to reload now, ensuring smooth gameplay without thrown errors.")
    desc:SetFullWidth(true)
    frame:AddChild(desc)

    local padding = AceGUI:Create("Label")
    padding:SetText(" ")
    padding:SetFullWidth(true)
    frame:AddChild(padding)

    local button = AceGUI:Create("Button")
    button:SetText("Reload Now")
    button:SetFullWidth(true)
    button:SetCallback("OnClick", function() ReloadUI() end)
    frame:AddChild(button)
end

function NemesisChat:IsAI(info)
	return core.db.profile.ai
end

function NemesisChat:ToggleAI(info, value)
	core.db.profile.ai = value
end

function NemesisChat:IsUseGlobalChance(info)
	return core.db.profile.useGlobalChance
end

function NemesisChat:ToggleUseGlobalChance(info, value)
	core.db.profile.useGlobalChance = value
end

function NemesisChat:GetGlobalChance(info)
	return core.db.profile.globalChance
end

function NemesisChat:SetGlobalChance(info, value)
	core.db.profile.globalChance = value
end

function NemesisChat:GetMinimumTime(info)
	return core.db.profile.minimumTime
end

function NemesisChat:SetMinimumTime(info, value)
	core.db.profile.minimumTime = value
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

function NemesisChat:SetAddNemesis(info, value)
    if selectedNemesisName ~= "" then
        if core.db.profile.dbg then 
            self:Print("Removing ", selectedNemesisName)
        end

        core.db.profile.nemeses[selectedNemesisName] = nil

        if core.db.profile.dbg then 
            self:Print("Adding ", value)
        end

        core.db.profile.nemeses[value] = value
        selectedNemesisName = ""
    else
        core.db.profile.nemeses[value] = value
    end
end

function NemesisChat:RemoveNemesis(info, value)
    if core.db.profile.dbg then 
        self:Print("Removing ", selectedNemesisName)
    end

    core.db.profile.nemeses[selectedNemesisName] = nil
    selectedNemesisName = ""
end

function NemesisChat:GetCategories()
    local categories = {}

    for key, val in pairs(core.configTree) do
        local count = 0

        for eKey, eVal in pairs(val.events) do
            for tKey, tVal in pairs(core.units) do
                if core.db.profile.messages[key] and core.db.profile.messages[key][eVal.value] and core.db.profile.messages[key][eVal.value][tVal.value] ~= nil then
                    count = count + #core.db.profile.messages[key][eVal.value][tVal.value]
                end
            end
        end
        if count > 0 then
            categories[key] = val.label .. " (|c00ffcc00" .. count .. "|r)"
        else
            categories[key] = val.label
        end
        
    end

    return categories
end

function NemesisChat:GetCategory()
    return selectedCategory
end

function NemesisChat:SetCategory(info, value)
    selectedCategory = value

    selectedEvent = ""
    selectedTarget = ""
    selectedConfiguredMessage = ""
    selectedCondition = ""
    message = ""
    messageLabel = ""
    messageChance = 1.0
    messageConditions = {}
end

function NemesisChat:GetEvents()
    if selectedCategory == "" then
        return {}
    end

    local events = {}

    for key, val in pairs(core.configTree[selectedCategory].events) do
        local count = 0

        for tKey, tVal in pairs(core.units) do
            if core.db.profile.messages[selectedCategory] and core.db.profile.messages[selectedCategory][val.value] and core.db.profile.messages[selectedCategory][val.value][tVal.value] ~= nil then
                count = count + #core.db.profile.messages[selectedCategory][val.value][tVal.value]
            end
        end


        if count > 0 then
            events[val.value] = val.label .. " (|c00ffcc00" .. count .. "|r)"
        else
            events[val.value] = val.label
        end
    end

    return events
end

function NemesisChat:GetEvent()
    return selectedEvent
end

function NemesisChat:SetEvent(info, value)
    selectedEvent = value
    selectedTarget = ""
    selectedConfiguredMessage = ""
    selectedCondition = ""
    message = ""
    messageLabel = ""
    messageChance = 1.0
    messageConditions = {}
end

function NemesisChat:IsEventsHidden()
    return selectedCategory == "" or selectedCategory == nil
end

function NemesisChat:GetTargets()
    if selectedEvent == "" then
        return {}
    end

    local targets = {}

    for key, val in pairs(core.configTree[selectedCategory].events[GetEventIndex()].options) do
        local option = core.units[val]
        local count = 0

        if core.db.profile.messages[selectedCategory] and core.db.profile.messages[selectedCategory][selectedEvent] and core.db.profile.messages[selectedCategory][selectedEvent][option.value] ~= nil then
            count = count + #core.db.profile.messages[selectedCategory][selectedEvent][option.value]
        end

        if count > 0 then
            targets[option.value] = option.label .. " (|c00ffcc00" .. count .. "|r)"
        else
            targets[option.value] = option.label
        end
    end

    return targets
end

function NemesisChat:GetTarget()
    if #NemesisChat:GetKeys(NemesisChat:GetTargets()) == 1 then
        for key, val in pairs(NemesisChat:GetTargets()) do
            selectedTarget = key
        end
    end
    return selectedTarget
end

function NemesisChat:SetTarget(info, value)
    selectedTarget = value

    selectedConfiguredMessage = ""
    selectedCondition = ""
    message = ""
    messageLabel = ""
    messageChance = 1.0
    messageConditions = {}
end

function NemesisChat:IsTargetsHidden()
    return selectedEvent == "" or selectedEvent == nil
end

function NemesisChat:GetConfiguredMessages()
    local msgs = core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget]
    local available = {}
    
    for key, val in pairs(msgs or {}) do
        available[key .. ""] = val.label or val.message
    end

    return available
end

function NemesisChat:GetConfiguredMessage()
    return selectedConfiguredMessage
end

function NemesisChat:SetConfiguredMessage(info, value)
    selectedConfiguredMessage = value

    local msg = core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget][tonumber(value)]

    if msg == nil then
        selectedConfiguredMessage = ""
        return
    end

    message = msg.message
    messageChannel = msg.channel
    messageChance = msg.chance
    messageLabel = msg.label
    messageConditions = msg.conditions

    selectedCondition = ""
end

function NemesisChat:ConfiguredMessagesDisabled()
    return core.db.profile.messages[selectedCategory] == nil or core.db.profile.messages[selectedCategory][selectedEvent] == nil or core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget] == nil
end

function NemesisChat:GetMessage()
    return message
end

function NemesisChat:SetMessage(info, value)
    message = value
end

function NemesisChat:IsMessageHidden()
    return selectedCategory == "" or selectedEvent == "" or selectedTarget == ""
end

function NemesisChat:GetChannels()
    return DeepCopy(core.channels)
end

function NemesisChat:GetChannel()
    return messageChannel
end

function NemesisChat:SetChannel(info, value)
    messageChannel = value
end

function NemesisChat:DeleteMessage()
    if core.db.profile.messages[selectedCategory] == nil or core.db.profile.messages[selectedCategory][selectedEvent] == nil or core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget][tonumber(selectedConfiguredMessage)] == nil then
        return
    end

    table.remove(core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget], tonumber(selectedConfiguredMessage))

    selectedConfiguredMessage = ""
    selectedCondition = ""
    message = ""
    messageChance = ""
    messageChannel = ""
    messageConditions = ""
    messageLabel = ""
end

function NemesisChat:DeselectMessage()
    message = ""
    messageChannel = ""
    selectedConfiguredMessage = ""
    messageLabel = ""
end

function NemesisChat:GetMessageLabel()
    return messageLabel
end

function NemesisChat:SetMessageLabel(info, value)
    messageLabel = value
end

function NemesisChat:GetChance()
    if selectedConfiguredMessage == "" then
        return 0.0
    end

    return messageChance
end

function NemesisChat:SetChance(info, value)
    messageChance = value
end

function NemesisChat:SaveMessage()
    StoreMessage()
end

function NemesisChat:DiscardChanges()
    if selectedConfiguredMessage ~= "" then
        local msg = core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget][tonumber(selectedConfiguredMessage)]

        if msg == nil then
            selectedConfiguredMessage = ""
            return
        end

        message = msg.message
        messageChannel = msg.channel
        messageChance = msg.chance
        messageLabel = msg.label
        messageConditions = msg.conditions

        selectedCondition = ""
    else
        message = ""
        messageChannel = ""
        messageChance = ""
        messageLabel = ""
        messageConditions = ""

        selectedCondition = ""
    end
end

function NemesisChat:GetConditions()
    if selectedConfiguredMessage == "" or selectedConfiguredMessage == nil then
        return {}
    end

    local msg = core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget][tonumber(selectedConfiguredMessage)]
    local conditions = {}

    if msg == nil or msg.conditions == nil or #msg.conditions == 0 then
        return {}
    end

    for key, val in pairs(msg.conditions) do
        local leftFormatted = GetConditionLabel(val.left)

        conditions[key .. ""] = leftFormatted .. " " .. GetOperatorFormatted(val.operator) .. " " .. GetConditionRight(val.left, val.right)
    end

    return conditions
end

function NemesisChat:GetCondition()
    return selectedCondition
end

function NemesisChat:SetCondition(info, value)
    selectedCondition = value
end

function NemesisChat:GetConditionSubjects()
    if selectedCondition == "" then
        return {}
    end

    subjects = {}

    for key, val in pairs(core.messageConditions) do
        subjects[val.value] = val.label
    end

    return subjects
end

function NemesisChat:GetConditionSubject()
    if selectedCondition == "" then
        return ""
    end

    local condition = messageConditions[tonumber(selectedCondition)]

    return condition.left
end

function NemesisChat:SetConditionSubject(info, value)
    if selectedCondition == "" then
        return ""
    end

    local condition = messageConditions[tonumber(selectedCondition)]

    condition.left = value
end

function NemesisChat:GetConditionOperators()
    if selectedCondition == "" then
        return {}
    end

    local condition = messageConditions[tonumber(selectedCondition)]
    local baseCondition = GetCondition(condition.left)
    local operators = {}

    for key, val in pairs(baseCondition.operators) do
        operators[val.value] = val.label
    end

    return operators
end

function NemesisChat:GetConditionOperator()
    if selectedCondition == "" then
        return ""
    end

    local condition = messageConditions[tonumber(selectedCondition)]
    
    return condition.operator
end

function NemesisChat:SetConditionOperator(info, value)
    if selectedCondition == "" then
        return ""
    end

    local condition = messageConditions[tonumber(selectedCondition)]

    condition.operator = value
end

function NemesisChat:GetConditionValues()
    if selectedCondition == "" then
        return {}
    end

    local condition = messageConditions[tonumber(selectedCondition)]
    local baseCondition = GetCondition(condition.left)
    local values = {}

    for key, val in pairs(baseCondition.options) do
        values[val.value] = val.label
    end

    return values
end

function NemesisChat:GetConditionValue()
    if selectedCondition == "" then
        return ""
    end

    local condition = messageConditions[tonumber(selectedCondition)]

    return condition.right
end

function NemesisChat:SetConditionValue(info, value)
    if selectedCondition == "" then
        return ""
    end

    local condition = messageConditions[tonumber(selectedCondition)]

    condition.right = value
end

function NemesisChat:ConditionIsInput()
    if selectedCondition == "" then
        return true
    end

    local condition = messageConditions[tonumber(selectedCondition)]
    local baseCondition = GetCondition(condition.left)

    return baseCondition.type == "INPUT"
end

function NemesisChat:ConditionIsSelect()
    if selectedCondition == "" then
        return true
    end

    local condition = messageConditions[tonumber(selectedCondition)]
    local baseCondition = GetCondition(condition.left)

    return baseCondition.type == "SELECT"
end

function NemesisChat:AddCondition()
    local condition = DeepCopy(core.runtimeDefaults.messageCondition)

    if type(messageConditions) ~= "table" then
        messageConditions = {}
    end

    table.insert(messageConditions, condition)

    selectedCondition = #messageConditions .. ""
end

function NemesisChat:DeleteCondition()
    table.remove(messageConditions, tonumber(selectedCondition))

    selectedCondition = ""
end

function NemesisChat:NoMessageSelected()
    return selectedConfiguredMessage == ""
end

function NemesisChat:NoConditionSelected()
    return selectedCondition == ""
end

function NemesisChat:HideSave()
    return message == "" or messageLabel == "" or messageChannel == ""
end

function NemesisChat:GetDetailsInterval(info)
    return core.db.profile.details.interval or 60
end

function NemesisChat:SetDetailsInterval(info, value)
    core.db.profile.details.interval = value
end

function NemesisChat:GetReplacements()
    local resp = {}
    for key in pairs(core.reference.replacements) do resp[key] = key end
    return resp
end

function NemesisChat:GetRefReplacement()
    return selectedRefReplacement
end

function NemesisChat:SetRefReplacement(info, value)
    selectedRefReplacement = value
end

function NemesisChat:GetRefReplacementText()
    return core.reference.replacements[selectedRefReplacement]
end

function NemesisChat:GetReplacementTooltip()
    local tip = ""

    for key, value in pairs(core.reference.replacements) do 
        tip = tip .. "|c00ffcc00" .. key .. "|r: " .. value .. "\n"
    end

    return tip
end

function NemesisChat:UpdateMessagePreview()
    if message == "" then
        return "Select/enter a message to see the preview"
    end

    if NemesisChat:GetNemesesLength() == 0 then
        return ""
    end

    local nemesis = NemesisChat:GetRandomNemesis()
    local spacer = ": "
    local color = core.reference.colors[messageChannel] or core.reference.colors["SAY"]
    local spellLink = GetSpellLink(408358)

    if messageChannel == "EMOTE" then spacer = " " end

    if selectedEvent == "OLDFEAST" then
        spellLink = GetSpellLink(126494)
    elseif selectedEvent == "FEAST" then
        spellLink = GetSpellLink(382423)
    elseif selectedEvent == "REFEAST" then
        spellLink = GetSpellLink(382427)
    end

    local chatMsg = message:gsub("%[TARGET%]", "Rabid Wombat"):gsub("%[SELF%]", UnitName("player")):gsub("%[NEMESIS%]", nemesis):gsub("%[NEMESISDEATHS%]", math.random(1,16)):gsub("%[KILLS%]", math.random(1,968)):gsub("%[NEMESISKILLS%]", math.random(1,967)):gsub("%[DUNGEONTIME%]", NemesisChat:GetDuration(GetTime() - math.random(101, 844))):gsub("%[KEYSTONELEVEL%]", math.random(2,28)):gsub("%[BOSSTIME%]", NemesisChat:GetDuration(GetTime() - math.random(101, 276))):gsub("%[BOSSNAME%]", "Magmorax"):gsub("%[SPELL%]", spellLink):gsub("%[BYSTANDER%]", NemesisChat:GetRandomPartyBystander() or "DouglasQuaid")

    messagePreview = color .. UnitName("player") .. spacer .. chatMsg .. "|r"
end

function GetEventIndex()
    for key, val in pairs(core.configTree[selectedCategory].events) do
        if val.value == selectedEvent then
            return key
        end
    end

    return nil
end

function StoreMessage()
    if selectedCategory == "" or selectedEvent == "" or selectedTarget == "" then
        return
    end

    BuildStorePath()

    local saveMessage = {}

    saveMessage.label = messageLabel
    saveMessage.channel = messageChannel
    saveMessage.message = message
    saveMessage.chance = messageChance
    saveMessage.conditions = messageConditions

    if selectedConfiguredMessage ~= "" then
        core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget][tonumber(selectedConfiguredMessage)] = saveMessage
    else
        saveMessage.conditions = {}
        table.insert(core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget], saveMessage)
        NemesisChat:SetConfiguredMessage(nil, #core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget][tonumber(selectedConfiguredMessage)] .. "")
    end
end

function BuildStorePath()
    if core.db.profile.messages[selectedCategory] == nil then
        core.db.profile.messages[selectedCategory] = {}
    end

    if core.db.profile.messages[selectedCategory][selectedEvent] == nil then
        core.db.profile.messages[selectedCategory][selectedEvent] = {}
    end

    if core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget] == nil then
        core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget] = {}
    end
end

function GetCondition(conditionValue)
    if conditionValue == nil or conditionValue == "" then
        return ""
    end

    for key, val in pairs(core.messageConditions) do
        if val.value == conditionValue then
            return val
        end
    end
end

function GetConditionLabel(conditionValue)
    if conditionValue == nil or conditionValue == "" then
        return ""
    end

    return GetCondition(conditionValue).label
end

function GetConditionRight(conditionValue, rightValue)
    local condition = GetCondition(conditionValue)

    if condition.type == "INPUT" then
        return rightValue
    end

    for key, val in pairs(condition.options) do
        if val.value == rightValue then
            return val.label
        end
    end

    return rightValue
end

function GetOperatorFormatted(operatorValue)
    if operatorValue == nil or operatorValue == "" then
        return ""
    end

    for key, val in pairs(ArrayMerge(core.constants.OPERATORS, core.constants.EXTENDED_OPERATORS)) do
        if val.value == operatorValue then
            return val.label
        end
    end
end
