-----------------------------------------------------
-- CONFIGURATION UI
-----------------------------------------------------
-- Core Tab - Messages Configuration
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

core.options.args.messagesGroup = {
    order = 2,
    type = "group",
    name = "Triggered Messages",
    args = {
        messagesHeader = {
            order = 0,
            type = "header",
            name = "Triggered Messages",
        },
        messagesDesc = {
            order = 1,
            type = "description",
            fontSize = "large",
            name = "General",
        },
        messagesPaddingUpper = {
            order = 2,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        messagesCategories = {
            order = 3,
            type = "select",
            name = "Category",
            width = "full",
            values = "GetCategories",
            get = "GetCategory",
            set = "SetCategory"
        },
        messagesEvents = {
            order = 4,
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
            order = 5,
            type = "select",
            name = "Event Triggerer / Source",
            width = "full",
            values = "GetTargets",
            get = "GetTarget",
            set = "SetTarget",
            hidden = "IsTargetsHidden",
            disabled = "IsTargetsHidden",
        },
        messagesConfigPaddingUpper = {
            order = 6,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        messagesDelete = {
            order = 7,
            type = "execute",
            func = "DeleteMessage",
            name = "Delete",
            disabled = "NoMessageSelected",
            hidden = "NoMessageSelected"
        },
        messagesDeselect = {
            order = 8,
            type = "execute",
            func = "DeselectMessage",
            name = "Deselect",
            disabled = "NoMessageSelected",
            hidden = "NoMessageSelected"
        },
        messagesDuplicate = {
            order = 8.5,
            type = "execute",
            func = "DuplicateMessage",
            name = "Duplicate",
            disabled = "NoMessageSelected",
            hidden = "NoMessageSelected"
        },
        messagesConfigured = {
            order = 9,
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
            order = 10,
            type = "input",
            name = "Message Label",
            width = "full",
            get = "GetMessageLabel",
            set = "SetMessageLabel",
            hidden = "IsMessageHidden",
            disabled = "IsMessageHidden",
        },
        messagesMessage = {
            order = 11,
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
            order = 12,
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
            order = 13,
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
            order = 14,
            type = "description",
            fontSize = "medium",
            name = "\n|c00ffcc00Message Preview:|r\n",
            hidden = "IsMessageHidden",
            disabled = "IsMessageHidden",
        },
        messagesPreview = {
            order = 15,
            type = "description",
            name = function() NemesisChat:UpdateMessagePreview() return messagePreview end,
            hidden = "IsMessageHidden",
            disabled = "IsMessageHidden",
        },
        conditionsPaddingUpper = {
            order = 16,
            type = "description",
            fontSize = "large",
            name = " ",
            hidden = "NoMessageSelected",
        },
        conditionsDesc = {
            order = 17,
            type = "description",
            fontSize = "large",
            name = "Conditions",
            hidden = "NoMessageSelected",
        },
        conditionsPaddingLower = {
            order = 18,
            type = "description",
            fontSize = "large",
            name = " ",
            hidden = "NoMessageSelected",
        },
        conditionsAdd = {
            order = 19,
            type = "execute",
            func = "AddCondition",
            name = "Add",
            disabled = "NoMessageSelected",
            hidden = "NoMessageSelected"
        },
        conditionsDelete = {
            order = 20,
            type = "execute",
            func = "DeleteCondition",
            name = "Delete",
            disabled = "NoConditionSelected",
            hidden = "NoConditionSelected"
        },
        conditions = {
            order = 21,
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
            order = 22,
            type = "description",
            fontSize = "medium",
            name = " ",
            hidden = "NoMessageSelected",
        },
        conditionSubject = {
            order = 23,
            type = "select",
            name = "Subject",
            width = 0.90,
            values = "GetConditionSubjects",
            get = "GetConditionSubject",
            set = "SetConditionSubject",
            hidden = "NoConditionSelected",
            disabled = "NoConditionSelected",
        },
        conditionOperator = {
            order = 24,
            type = "select",
            name = "Operator",
            width = 0.7,
            values = "GetConditionOperators",
            get = "GetConditionOperator",
            set = "SetConditionOperator",
            hidden = "NoConditionSelected",
            disabled = "NoConditionSelected",
        },
        conditionValueSelect = {
            order = 25,
            type = "select",
            name = "Value",
            width = 0.83,
            values = "GetConditionValues",
            get = "GetConditionValue",
            set = "SetConditionValue",
            hidden = function() return NemesisChat:ConditionIsInput() or IsNcOperator() end,
            disabled = function() return NemesisChat:ConditionIsInput() or IsNcOperator() end,
        },
        conditionValueInput = {
            order = 25,
            type = "input",
            name = "Value",
            desc = "Replacements (such as |c00ffcc00[NEMESIS]|r) are allowed here. Please refer to the Reference tab for a list of available replacements.",
            width = 0.83,
            get = "GetConditionValue",
            set = "SetConditionValue",
            hidden = function() return NemesisChat:ConditionIsSelect() or IsNcOperator() end,
            disabled = function() return NemesisChat:ConditionIsSelect() or IsNcOperator() end,
        },
        conditionsPaddingSaveDiscard = {
            order = 26,
            type = "description",
            fontSize = "large",
            name = " ",
            hidden = "NoMessageSelected",
        },
        messagesSave = {
            order = 27,
            type = "execute",
            func = "SaveMessage",
            name = "Save",
            disabled = "HideSave",
            hidden = "HideSave"
        },
        messagesDiscard = {
            order = 28,
            type = "execute",
            func = "DiscardChanges",
            name = "Discard",
            disabled = "HideSave",
            hidden = "HideSave"
        },
    }
}

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

function NemesisChat:GetCategories()
    local categories = setmetatable({}, {__mode = "kv"})

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
        return setmetatable({}, {__mode = "kv"})
    end

    local events = setmetatable({}, {__mode = "kv"})

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
        return setmetatable({}, {__mode = "kv"})
    end

    local targets = setmetatable({}, {__mode = "kv"})

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

    local msg = DeepCopy(core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget][tonumber(value)])

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
    local coreChannels = DeepCopy(core.channels)
    local extended = DeepCopy(core.channelsExtended)
    local explicit = DeepCopy(core.channelsExplicit)

    if selectedTarget == "BYSTANDER" or selectedTarget == "NEMESIS" then
        local label = "Whisper Nemesis"
        local otherLabel = "Whisper Bystander (|c00ff0000May be unavailable|r)"
        local otherKey = "WHISPER_BYSTANDER"

        if selectedTarget == "BYSTANDER" then
            label = "Whisper Bystander"
            otherLabel = "Whisper Nemesis (|c00ff0000May be unavailable|r)"
        end

        extended["WHISPER"] = label
        extended[otherKey] = otherLabel

        return MapMerge(coreChannels, extended)
    end

    return MapMerge(coreChannels, explicit)
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

    NCController:PreprocessMessages()
end

function NemesisChat:DeselectMessage()
    message = ""
    messageChannel = ""
    selectedConfiguredMessage = ""
    messageLabel = ""
end

function NemesisChat:DuplicateMessage()
    if core.db.profile.messages[selectedCategory] == nil or core.db.profile.messages[selectedCategory][selectedEvent] == nil or core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget][tonumber(selectedConfiguredMessage)] == nil then
        return
    end

    local msg = DeepCopy(core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget][tonumber(selectedConfiguredMessage)])

    msg.label = msg.label .. " (Copy)"

    table.insert(core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget], msg)

    selectedConfiguredMessage = #core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget] .. ""
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
        return setmetatable({}, {__mode = "kv"})
    end

    local msg = core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget][tonumber(selectedConfiguredMessage)]
    local conditions = setmetatable({}, {__mode = "kv"})

    if msg == nil or msg.conditions == nil or #msg.conditions == 0 then
        return setmetatable({}, {__mode = "kv"})
    end

    for key, val in pairs(msg.conditions) do
        local leftFormatted = GetConditionLabel(val.left)
        local displayText = leftFormatted .. " " .. (GetOperatorFormatted(val.operator) or "?")

        if GetIsNcOperator(val) == false then
            displayText = displayText  .. " " .. GetConditionRight(val.left, val.right)
        end

        conditions[key .. ""] = displayText
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
        return setmetatable({}, {__mode = "kv"})
    end

    local condition = messageConditions[tonumber(selectedCondition)]
    local coreCondition = GetCondition(condition.left)

    condition.leftCategory = condition.leftCategory or coreCondition.category or nil

    if condition.leftCategory == "<GET_CATEGORIES" then
        return NemesisChat:GetConditionSubjectCategories()
    end

    local subjects = {
        ["<GET_CATEGORIES"] = "|c00ffcc00<< " .. condition.leftCategory .. "|r"
    }

    for key, val in pairs(core.messageConditions) do
        if val.category == condition.leftCategory then
            subjects[val.value] = val.label
        end
    end

    return subjects
end

function NemesisChat:GetConditionSubjectCategories()
    if selectedCondition == "" then
        return setmetatable({}, {__mode = "kv"})
    end

    local categories = setmetatable({}, {__mode = "kv"})

    for _, val in pairs(core.messageConditions) do
        if val.category ~= nil and not categories[val.category] then
            categories[val.category] = "|c00ffcc00" .. val.category .. " >>|r"
        end
    end

    return categories
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

    if value == "<GET_CATEGORIES" then
        condition.leftCategory = value
        return
    end

    for _,val in pairs(core.messageConditions) do
        if value == val.category then
            condition.leftCategory = val.category
            return
        end
    end

    condition.left = value

    local operatorKey, _ = next(NemesisChat:GetConditionOperators())
    NemesisChat:SetConditionOperator(nil, operatorKey)
end

function NemesisChat:GetConditionOperators()
    if selectedCondition == "" then
        return setmetatable({}, {__mode = "kv"})
    end

    local condition = messageConditions[tonumber(selectedCondition)]
    local baseCondition = GetCondition(condition.left)
    local operators = setmetatable({}, {__mode = "kv"})

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

    if NemesisChat:ConditionIsSelect() then
        local valueKey, _ = next(NemesisChat:GetConditionSubjects())

        NemesisChat:SetConditionValue(nil, valueKey)
    else
        if GetIsNcOperator(value) then
            NemesisChat:SetConditionValue(nil, "123")
        else
            NemesisChat:SetConditionValue(nil, "")
        end
    end
end

function NemesisChat:GetConditionValues()
    if selectedCondition == "" then
        return setmetatable({}, {__mode = "kv"})
    end

    local condition = messageConditions[tonumber(selectedCondition)]
    local baseCondition = GetCondition(condition.left)
    local values = setmetatable({}, {__mode = "kv"})

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
    local baseCondition = GetCondition(condition.left)

    if (condition.operator == "LT" or condition.operator == "GT" or baseCondition.type == "NUMBER") and tonumber(value) == nil and IsValidReplacement(value) == false then
        PopUp("Invalid Value", "Invalid value input! Please set the value to a number.")
        return
    end

    condition.right = value
end

function NemesisChat:ConditionIsInput()
    if selectedCondition == "" then
        return true
    end

    local condition = messageConditions[tonumber(selectedCondition)]
    local baseCondition = GetCondition(condition.left)

    return baseCondition.type == "INPUT" or baseCondition.type == "NUMBER"
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
        messageConditions = setmetatable({}, {__mode = "kv"})
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

function NemesisChat:GetReplacements()
    local resp = setmetatable({}, {__mode = "kv"})
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

function NemesisChat:UpdateMessagePreview()
    if message == "" then
        return "Select/enter a message to see the preview"
    end

    if NemesisChat:GetNemesesLength() == 0 then
        return ""
    end

    local spacer = ": "
    local color = core.reference.colors[messageChannel] or core.reference.colors["SAY"]

    if messageChannel == "EMOTE" then spacer = " " end

    if HasConditions() then
        for key, val in pairs(core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget][tonumber(selectedConfiguredMessage)].conditions) do
            if (val.left == "SPELL_ID" or val.left == "SPELL_NAME") and val.operator == "IS" then
                NCRuntime.previewSpell = val.right
                break
            end
        end
    end

    local chatMsg = NCController:GetReplacedString(message, true)

    messagePreview = color .. UnitName("player") .. spacer .. chatMsg .. "|r"

    NCRuntime.previewSpell = nil
end

function HasConditions()
    if selectedCategory == nil or selectedEvent == nil or selectedTarget == nil or selectedConfiguredMessage == nil then
        return false
    end

    if core.db.profile.messages[selectedCategory] == nil or core.db.profile.messages[selectedCategory][selectedEvent] == nil or core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget] == nil or core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget][tonumber(selectedConfiguredMessage)] == nil then
        return false
    end

    return (#core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget][tonumber(selectedConfiguredMessage)].conditions or 0) > 0
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
        NemesisChat:SetConfiguredMessage(nil, #core.db.profile.messages[selectedCategory][selectedEvent][selectedTarget] .. "")
    end

    NCController:PreprocessMessages()
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

function IsNcOperator()
    local condition = messageConditions[tonumber(selectedCondition)]

    return GetIsNcOperator(condition)
end

function GetIsNcOperator(condition)
    for key, val in pairs(ArrayMerge(core.constants.OPERATORS, core.constants.NUMERIC_OPERATORS)) do
        if condition.operator == val.value then
            return false
        end
    end

    return true
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

    if condition.type == "INPUT" or condition.type == "NUMBER" then
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

    for key, val in pairs(ArrayMerge(ArrayMerge(core.constants.OPERATORS, core.constants.NUMERIC_OPERATORS), core.constants.UNIT_OPERATORS)) do
        if val.value == operatorValue then
            return val.label
        end
    end
end

function IsValidReplacement(value)
    return core.numericReplacements[value] == 1
end

