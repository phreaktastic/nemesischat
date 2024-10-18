-----------------------------------------------------
-- CONTROLLER
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------

local ipairs = ipairs
local pairs = pairs
local tonumber = tonumber
local tostring = tostring
local math_max = math.max
local GetTime = GetTime

local _, core = ...;
local messageCache = {}
local eventLookup = {}

-----------------------------------------------------
-- Controller logic for handling events
-----------------------------------------------------

NCController = {
    channel = "SAY",
    message = "",
    target = "",
    customReplacements = {},
    customReplacementExamples = {},
    isInitialized = false,
    lastGroupCacheKey = "",
    placeholders = {},
    subjectValueCache = {},
    conditionSubjects = {},
}

function NCController:Initialize()
    if self.isInitialized then
        return
    end

    NemesisChatAPI:InitializeReplacements()
    NCController:PreprocessMessages()

    self.isInitialized = true
end

function NCController:Reset()
    wipe(self.placeholders)
    wipe(self.subjectValueCache)
    wipe(self.conditionSubjects)
    NCController.channel = "SAY"
    NCController.message = ""
    NCController.target = ""
    NCController.lastGroupCacheKey = ""

    -- Reset all message indices
    for _, messages in pairs(messageCache) do
        messages.lastNemesisIndex = #messages.nemesis -- Set to last index so it wraps to 1 on first use
        messages.lastRegularIndex = #messages.regular
    end
end

function NCController:PreprocessMessages()
    local groupCacheKey = "nemesis:" ..
        tostring(NCRuntime:HasNemesis()) .. "_bystander:" .. tostring(NCRuntime:HasBystander())
    if self.lastGroupCacheKey == groupCacheKey then
        -- No significant group change, skip preprocessing
        return
    end
    self.lastGroupCacheKey = groupCacheKey
    wipe(messageCache)
    wipe(eventLookup)
    for category, events in pairs(core.db.profile.messages) do
        for event, targets in pairs(events) do
            for target, messages in pairs(targets) do
                -- Check if we should skip processing messages for this target
                if target ~= "NEMESIS" or NCRuntime:HasNemesis() then
                    local eventKey = category .. "_" .. event .. "_" .. target
                    messageCache[eventKey] = {
                        nemesis = {},
                        regular = {},
                        lastNemesisIndex = 0,
                        lastRegularIndex = 0
                    }
                    for _, message in ipairs(messages) do
                        local processedMessage = {
                            label = message.label,
                            channel = message.channel,
                            message = message.message,
                            chance = message.chance,
                            conditions = {},
                            placeholders = {}
                        }
                        -- Extract placeholders
                        for placeholder in message.message:gmatch("%[([A-Z_]+)%]") do
                            processedMessage.placeholders[placeholder] = true
                        end
                        -- Preprocess conditions
                        if message.conditions then
                            for _, condition in ipairs(message.conditions) do
                                local preprocessedCondition = self:PreprocessCondition(condition)
                                if preprocessedCondition then
                                    table.insert(processedMessage.conditions, preprocessedCondition)
                                else
                                    NemesisChat:HandleError("Invalid condition in message: " .. (message.label or ""))
                                end
                            end
                        end
                        if target == "NEMESIS" then
                            table.insert(messageCache[eventKey].nemesis, processedMessage)
                        else
                            table.insert(messageCache[eventKey].regular, processedMessage)
                        end
                        eventLookup[eventKey] = true
                    end
                end
                -- If the condition is false, the code inside the 'if' block is skipped, effectively continuing to the next iteration
            end
        end
    end
end

function NCController:PreprocessCondition(condition)
    local subjectFunc = self.conditionSubjects[condition.left]
    if not subjectFunc then
        -- Attempt to find the subject function in core.apis
        for _, api in pairs(core.apis) do
            for _, subject in pairs(api.subjects) do
                if subject.value == condition.left then
                    subjectFunc = subject.exec
                    self.conditionSubjects[condition.left] = subjectFunc -- Cache it
                    break
                end
            end
            if subjectFunc then break end
        end
    end

    if not subjectFunc then
        NemesisChat:HandleError("Condition subject function not found for " .. condition.left)
        return nil
    end

    local operatorFunc = self.ConditionOperators[condition.operator]
    if not operatorFunc then
        NemesisChat:HandleError("Condition operator function not found for " .. condition.operator)
        return nil
    end

    -- Preprocess the right side of the condition to handle placeholders
    local rightValue = condition.right
    if rightValue and rightValue:find("%[") then
        rightValue = self:GetReplacedString(rightValue:gsub("%[([A-Z_]*)%]", "[%1_CONDITION]"))
    end

    -- Return the preprocessed condition
    return {
        subjectFunc = subjectFunc,
        operatorFunc = operatorFunc,
        right = rightValue,
    }
end

function NCController:GetMessageCache()
    return messageCache
end

function NCController:GetEventLookup()
    return eventLookup
end

function NCController:EventHasMessages(eventKey)
    if not eventKey then
        eventKey = string.format("%s_%s_%s", NCEvent:GetCategory(), NCEvent:GetEvent(), NCEvent:GetTarget())
    end
    return eventLookup[eventKey] == true
end

function NCController:GetChannel()
    if NCController.channel == nil then
        return ""
    end

    return NCController.channel
end

function NCController:SetChannel(channel)
    NCController.channel = channel
end

function NCController:GetMessage()
    if NCController.message == nil then
        return ""
    end

    return NCController.message
end

function NCController:SetMessage(msg)
    NCController.message = msg
end

function NCController:GetTarget()
    if NCController.target == nil then
        return ""
    end

    return NCController.target
end

function NCController:SetTarget(target)
    NCController.target = target
end

-- Set the custom replacements property, replacing any existing value(s)
function NCController:SetCustomReplacements(customReplacements)
    NCController.customReplacements = customReplacements
end

-- Add a custom replacement, provided it does not already exist
function NCController:AddCustomReplacement(key, value)
    if NCController.customReplacements[key] ~= nil then
        return
    end
    NCController.customReplacements[key] = value
end

-- Set the custom replacement examples property, replacing any existing value(s)
function NCController:SetCustomReplacementExamples(customReplacementExamples)
    NCController.customReplacementExamples = customReplacementExamples
end

-- Add a custom replacement example, giving sample replacements for a key
function NCController:AddCustomReplacementExample(key, value)
    NCController.customReplacementExamples[key] = value
end

function NCController:SetEventType(eventType)
    eventType = tonumber(eventType or "0") or 0

    if eventType < 1 or eventType > NC_EVENT_TYPE_MAXIMUM then
        eventType = NC_EVENT_TYPE_GROUP
    end

    NCController.eventType = eventType
end

function NCController:GetEventType()
    return NCController.eventType or NC_EVENT_TYPE_GROUP
end

-- Run the string replacement and set the message property to the replaced value
function NCController:ReplaceStrings()
    if NCController:GetMessage() == "" then
        return
    end
    NCController:SetMessage(NCController:GetReplacedString(NCController:GetMessage()))
end

function NCController:GetReplacedString(input, useExamples)
    if not input or input == "" then
        return ""
    end

    if NCEvent and NCEvent.GetBystander and NCEvent:GetBystander() == nil and not useExamples then
        NCEvent:RandomBystander()
    end

    local msg = input
    local placeholders = self.placeholders

    -- If placeholders are not available, extract them from the input
    if not placeholders then
        placeholders = {}
        for placeholder in msg:gmatch("%[([A-Z_]+)%]") do
            placeholders[placeholder] = true
        end
    end

    local customReplacements = self.customReplacements or {}
    local customReplacementExamples = self.customReplacementExamples or {}

    -- Process each placeholder
    for placeholder in pairs(placeholders) do
        local key = "[" .. placeholder .. "]"
        local replacementFunc = customReplacements[key]
        local val

        if useExamples and customReplacementExamples[key] then
            val = customReplacementExamples[key]()
        elseif replacementFunc then
            val = replacementFunc()
        else
            val = nil -- No replacement function available
        end

        if val ~= nil then
            if type(val) == "string" or type(val) == "number" then
                local success, err = pcall(function()
                    msg = msg:gsub("%[" .. placeholder .. "%]", tostring(val))
                end)
                if not success then
                    NemesisChat:HandleError("Replacement for " .. key .. " failed: " .. tostring(err))
                end
            else
                NemesisChat:HandleError("Replacement for " .. key .. " is not a string or number: " .. type(val))
            end
        else
            -- Will ponder this
            msg = msg:gsub("%[" .. placeholder .. "%]", "UNKNOWN")
        end
    end

    return msg
end

function NCController:Send()
    -- Anti-spam, hardcoded minimum of 1 to prevent setting it to 0 in the config file
    local timeSinceLastMessage = GetTime() - NCRuntime:GetLastMessage()
    if timeSinceLastMessage < math_max(1, NCConfig:GetMinimumTime() or 1) and not NCController:IsMinTimeException() then
        NCEvent:Reset()
        return
    end

    -- Respect non-combat-mode. If we're in combat, and non-combat-mode is enabled, bail.
    -- We have to bypass this if it's a boss start event, as that's driven by going into combat with a boss.
    if NCConfig:IsNonCombatMode() and NCCombat:IsActive() and not NCController:IsNonCombatModeException() then
        NCEvent:Reset()
        return
    end

    -- Send it to whatever channel we've designated
    if NCController.channel ~= "WHISPER" then
        SendChatMessage(NCController.message, NCController.channel)
        -- It's a whisper, it requires a third argument
    else
        if NCController.target == "" then
            NCEvent:Reset()
            return
        end
        SendChatMessage(NCController.message, NCController.channel, nil, NCController.target)
    end

    NCRuntime:UpdateLastMessage()
end

function NCController:IsNonCombatModeException()
    if NCEvent:GetCategory() == "BOSS" and NCEvent:GetEvent() == "START" then
        return true
    end

    if NCEvent:GetEvent() == "INTERRUPT" and NCConfig:IsInterruptException() then
        return true
    end

    if NCEvent:GetEvent() == "DEATH" and NCConfig:IsDeathException() then
        return true
    end

    if NCEvent:GetTarget() == "BOSS" or NCEvent:GetTarget() == "ANY_MOB" then
        return true
    end

    return false
end

-- Group join events are an exception to the minimum time rule
function NCController:IsMinTimeException()
    return NCEvent:GetCategory() == "GROUP" and (NCEvent:GetEvent() == "JOIN" or NCEvent:GetEvent() == "LEAVE")
end

-- If `channel` is `GROUP`, we need to set it to `PARTY`, `INSTANCE_CHAT`, or `RAID`
function NCController:CheckChannel()
    -- Dynamically set the target
    local channel = NCController:GetChannel()
    if channel == "WHISPER_NEMESIS" then
        NCController:SetChannel("WHISPER")
        NCController:SetTarget(NCEvent:GetNemesis())
    elseif channel == "WHISPER_BYSTANDER" then
        NCController:SetChannel("WHISPER")
        NCController:SetTarget(NCEvent:GetBystander())
    else
        local target = (NCEvent:GetTarget() ~= "BYSTANDER") and NCEvent:GetNemesis() or NCEvent:GetBystander()
        NCController:SetTarget(target)
    end
    NCController:SetChannel(NemesisChat:GetActualChannel(NCController:GetChannel()))
end

-- Set values for a random configured message
function NCController:ConfigMessage()
    local eventKey = string.format("%s_%s_%s", NCEvent:GetCategory(), NCEvent:GetEvent(), NCEvent:GetTarget())
    local relevantMessages = messageCache[eventKey]

    if not relevantMessages then return end

    local selectedMessage = NCConfig:IsRollingMessages()
        and self:GetRollingMessage(relevantMessages)
        or self:GetRandomMessage(relevantMessages)

    if selectedMessage then
        self.message = selectedMessage.message
        self.channel = selectedMessage.channel
        self.selectedMessageChance = selectedMessage.chance or 1
        self.placeholders = selectedMessage.placeholders
    end
end

function NCController:GetRollingMessage(relevantMessages)
    local function getNextMessage(messages, lastIndex)
        if #messages == 0 then
            return nil, lastIndex
        end
        local newIndex = (lastIndex % #messages) + 1
        local message = messages[newIndex]
        if self:IsValidMessage(message) and self:CheckAllConditions(message) then
            return message, newIndex
        end
        -- If no valid message found, still update the index
        return nil, newIndex
    end

    local nemesisMessage, nemesisIndex = getNextMessage(relevantMessages.nemesis, relevantMessages.lastNemesisIndex)
    if nemesisMessage then
        relevantMessages.lastNemesisIndex = nemesisIndex
        return nemesisMessage
    end

    local regularMessage, regularIndex = getNextMessage(relevantMessages.regular, relevantMessages.lastRegularIndex)
    relevantMessages.lastRegularIndex = regularIndex -- Always update the index
    return regularMessage
end

function NCController:GetNextValidMessage(messages, lastIndex)
    local startIndex = (lastIndex % #messages) + 1
    for i = 0, #messages - 1 do
        local index = ((startIndex + i - 1) % #messages) + 1
        local message = messages[index]
        if self:IsValidMessage(message) and self:CheckAllConditions(message) then
            return { message = message, index = index }
        end
    end
    return nil
end

function NCController:GetRandomMessage(relevantMessages)
    local validNemesisMessages = self:GetValidMessages(relevantMessages.nemesis)
    if #validNemesisMessages > 0 then
        return validNemesisMessages[math.random(#validNemesisMessages)]
    end

    local validRegularMessages = self:GetValidMessages(relevantMessages.regular)
    if #validRegularMessages > 0 then
        return validRegularMessages[math.random(#validRegularMessages)]
    end

    return nil
end

function NCController:GetValidMessages(messages)
    local validMessages = {}
    for _, message in ipairs(messages) do
        if self:IsValidMessage(message) and self:CheckAllConditions(message) then
            table.insert(validMessages, message)
        end
    end
    return validMessages
end

function NCController:IsValidMessage(message)
    local hasNemesis = NCRuntime:HasNemesis()
    local hasBystander = NCRuntime:HasBystander()

    if (not hasNemesis and message.message:find("%[NEMESIS%]")) or
        (not hasNemesis and message.channel == "WHISPER_NEMESIS") or
        (not hasBystander and message.channel == "WHISPER_BYSTANDER") or
        (not hasBystander and message.message:find("%[BYSTANDER%]")) then
        return false
    end
    return true
end

-- Get a pool of conditional messages pertaining to the current scenarios
function NCController:GetConditionalMessages(pool)
    local conditionalMessages = {}
    local unconditionalMessages = {}

    for _, message in ipairs(pool) do
        if message.conditions and #message.conditions > 0 then
            table.insert(conditionalMessages, message)
        else
            table.insert(unconditionalMessages, message)
        end
    end

    return #conditionalMessages > 0 and conditionalMessages or unconditionalMessages
end

function NCController:CheckAllConditions(message)
    if not message.conditions or #message.conditions == 0 then
        return true
    end

    -- Clear the condition result cache before checking conditions
    self.conditionResultCache = {}

    for _, condition in ipairs(message.conditions) do
        if not self:CheckCondition(condition) then
            return false
        end
    end
    return true
end

function NCController:CheckCondition(condition)
    -- Call the subject function directly
    local val1 = condition.subjectFunc()
    local val2 = condition.right -- Preprocessed during message caching

    -- If val2 contains placeholders, replace them
    if val2 and val2:find("%[") then
        val2 = self:GetReplacedString(val2)
    end

    local result = condition.operatorFunc(val1, val2)

    return result
end

-- Set values for a random AI message
function NCController:AIMessage()
    NCController:SetMessage(NemesisChat:GetRandomAiPhrase())
    NCController:SetChannel("GROUP")
end

-- Perform all pre-send logic, and send the message to the appropriate channel
function NCController:Handle()
    local eventKey = string.format("%s_%s_%s", NCEvent:GetCategory(), NCEvent:GetEvent(), NCEvent:GetTarget())
    if not NCController:EventHasMessages(eventKey) then
        return
    end

    NCController:ConfigMessage()

    if not NCController:ValidMessage() then
        return
    end

    local messageChance = NCController.selectedMessageChance or 1
    if not NemesisChat:Roll(messageChance) then
        return
    end

    if not NCController.customReplacements then
        NemesisChatAPI:InitializeReplacements()
    end

    NCController:ReplaceStrings()
    NCController:CheckChannel()
    NCController:Send()
end

function NCController:ValidMessage()
    return NCController:GetMessage() ~= ""
end

local function getPlayerData(val1)
    local playerData = NCRuntime:GetGroupRosterPlayer(val1)
    return playerData or {}
end

-- Condition methods
NCController.ConditionOperators = {
    -- Subjects are all handled in the API now

    -- Operators
    ["IS"] = function(val1, val2)
        return val1 == val2
    end,
    ["IS_NOT"] = function(val1, val2)
        return val1 ~= val2
    end,
    ["GT"] = function(val1, val2)
        return (tonumber(val1) or 0) > (tonumber(val2) or 0)
    end,
    ["LT"] = function(val1, val2)
        return (tonumber(val1) or 0) < (tonumber(val2) or 0)
    end,
    ["IS_NEMESIS"] = function(val1, val2)
        if getPlayerData(val1) == nil then
            return false
        end

        return getPlayerData(val1).isNemesis
    end,
    ["NOT_NEMESIS"] = function(val1, val2)
        if getPlayerData(val1) == nil then
            return true
        end

        return getPlayerData(val1).isNemesis == false
    end,
    ["IS_FRIEND"] = function(val1, val2)
        if getPlayerData(val1) == nil then
            return false
        end

        return getPlayerData(val1).isFriend
    end,
    ["NOT_FRIEND"] = function(val1, val2)
        if getPlayerData(val1) == nil then
            return true
        end

        return not getPlayerData(val1).isFriend
    end,
    ["IS_GUILDMATE"] = function(val1, val2)
        if getPlayerData(val1) == nil then
            return false
        end

        return getPlayerData(val1).isGuildmate
    end,
    ["NOT_GUILDMATE"] = function(val1, val2)
        if getPlayerData(val1) == nil then
            return true
        end

        return not getPlayerData(val1).isGuildmate
    end,
    ["IS_UNDERPERFORMER"] = function(val1, val2)
        return NCDungeon:GetUnderperformer() == val1
    end,
    ["IS_OVERPERFORMER"] = function(val1, val2)
        return NCDungeon:GetOverperformer() == val1
    end,
    ["IS_ALIVE"] = function(val1, val2)
        return UnitIsDeadOrGhost(val1) == false
    end,
    ["IS_DEAD"] = function(val1, val2)
        return UnitIsDeadOrGhost(val1) == true
    end,
    ["IS_AFFIX_MOB"] = function(val1, val2)
        return core.affixMobs[val1] ~= nil
    end,
    ["NOT_AFFIX_MOB"] = function(val1, val2)
        return core.affixMobs[val1] == nil
    end,
    ["IS_AFFIX_CASTER"] = function(val1, val2)
        return core.affixMobsCastersLookup[val1] == true
    end,
    ["NOT_AFFIX_CASTER"] = function(val1, val2)
        return core.affixMobsCastersLookup[val1] ~= true
    end,
    ["IS_GROUP_LEAD"] = function(val1, val2)
        return UnitIsGroupLeader(val1)
    end,
    ["NOT_GROUP_LEAD"] = function(val1, val2)
        return not UnitIsGroupLeader(val1)
    end,
    ["HAS_BUFF"] = function(val1, val2)
        return NemesisChat:HasBuff(val1, val2)
    end,
    ["NOT_HAS_BUFF"] = function(val1, val2)
        return not NemesisChat:HasBuff(val1, val2)
    end,
    ["HAS_DEBUFF"] = function(val1, val2)
        return NemesisChat:HasDebuff(val1, val2)
    end,
    ["NOT_HAS_DEBUFF"] = function(val1, val2)
        return not NemesisChat:HasDebuff(val1, val2)
    end,
}
