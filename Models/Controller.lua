-----------------------------------------------------
-- CONTROLLER
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Controller logic for handling events
-----------------------------------------------------

function NemesisChat:InstantiateController()
    function NCController:Initialize()
        NCController = DeepCopy(core.runtimeDefaults.NCController)

        NemesisChat:InstantiateController()
        NemesisChatAPI:InitializeReplacements()
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

    -- Add a custom replacement, replacing anything which already exists for key
    function NCController:AddCustomReplacement(key, value)
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
        if input == "" then
            return ""
        end

        if NCEvent:GetBystander() == nil and not useExamples then
            NCEvent:RandomBystander()
        end

        -- We have a base list of replacements that will be available (mostly) everywhere. Some events
        -- will have custom replacements, such as API-based replacements (DPS numbers with Details! for example)
        --
        -- These are all set as functions so we don't hydrate all the replacements (inefficient), but rather only
        -- hydrate the ones we need, when we need them.
        local msg = input

        -- Custom replacements, example: Details API [DPS] and [NEMESISDPS], this comes first as overrides are possible
        if not useExamples then
            for k, v in pairs(NCController.customReplacements) do
                -- First check for condition specific replacements
                if msg:match(k) then
                    local val = v()
    
                    if type(val) == "string" or type(val) == "number" then
                        msg = msg:gsub(k, val)
                    else
                        NemesisChat:Print("ERROR!", "Replacement for", k, "is not a string!", type(val))
                    end
                end
            end
        end

        -- Remove condition-specific replacement text
        msg = msg:gsub("_CONDITION%]", "]")

        -- One more pass on custom replacements, without condition replacement text, as a fallback
        for k, v in pairs(NCController.customReplacements) do
            if msg:match(k) then
                local val

                if useExamples == true and NCController.customReplacementExamples[k] ~= nil then
                    val = NCController.customReplacementExamples[k]()
                else
                    val = v()
                end

                if type(val) == "string" or type(val) == "number" then
                    msg = msg:gsub(k, val)
                else
                    if not useExamples then
                        NemesisChat:Print("ERROR!", "Replacement for", k, "is not a string!", type(val))
                    end
                end
            end
        end

        return msg
    end

    function NCController:Send()
        -- Anti-spam, hardcoded to prevent setting it to 0
        if GetTime() - NCRuntime:GetLastMessage() < 1 and not NCController:IsMinTimeException() then
            NCEvent:Initialize()
            return
        end

        -- Config driven minimum time between messages
        if GetTime() - NCRuntime:GetLastMessage() < core.db.profile.minimumTime and not NCController:IsMinTimeException() then
            NCEvent:Initialize()
            return
        end

        -- Respect non-combat-mode. If we're in combat, and non-combat-mode is enabled, bail.
        -- We have to bypass this if it's a boss start event, as that's driven by going into combat with a boss.
        if core.db.profile.nonCombatMode and NCCombat:IsActive() and not NCController:IsNonCombatModeException() then
            NCEvent:Initialize()
            return
        end

        -- Send it to whatever channel we've designated
        if NCController.channel ~= "WHISPER" then
            SendChatMessage(NCController.message, NCController.channel)
        -- It's a whisper, it requires a third argument
        else
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
        if NCController:GetChannel() == "WHISPER_NEMESIS" then
            NCController:SetChannel("WHISPER")
            NCController:SetTarget(NCEvent:GetNemesis())
        elseif NCController:GetChannel() == "WHISPER_BYSTANDER" then
            NCController:SetChannel("WHISPER")
            NCController:SetTarget(NCEvent:GetBystander())
        else
            if NCEvent:GetTarget() ~= "BYSTANDER" then
                NCController:SetTarget(NCEvent:GetNemesis())
            else
                NCController:SetTarget(NCEvent:GetBystander())
            end
        end

        NCController:SetChannel(NemesisChat:GetActualChannel(NCController:GetChannel()))
    end

    -- Set values for a random configured message
    function NCController:ConfigMessage()
        -- If a global chance is configured, respect it
        if core.db.profile.useGlobalChance == true then
            if not NemesisChat:Roll(core.db.profile.globalChance or 1) then
                NCEvent:Initialize()
                return
            end
        end

        if core.db.profile.messages[NCEvent:GetCategory()] == nil or core.db.profile.messages[NCEvent:GetCategory()][NCEvent:GetEvent()] == nil or core.db.profile.messages[NCEvent:GetCategory()][NCEvent:GetEvent()][NCEvent:GetTarget()] == nil then
            return
        end

        local profileMessages = core.db.profile.messages[NCEvent:GetCategory()][NCEvent:GetEvent()][NCEvent:GetTarget()]

        if profileMessages == nil then
            NCEvent:Initialize()
            return
        end

        local msg = ""

        -- Ensure conditions are met on all messages
        local availableMessages = NCController:GetConditionalMessages(ShuffleTable(profileMessages))

        if availableMessages == nil then
            NCEvent:Initialize()
            return
        end

        if #availableMessages == 1 then
            msg = availableMessages[1]
        elseif #availableMessages == 0 then
            NCEvent:Initialize()
            return
        else
            -- If we have more than one message that is available for an event, prioritize Nemesis based messages
            local nemesisMsg

            for _, aMsg in pairs(ShuffleTable(availableMessages)) do
                if string.find(aMsg.message, "%[(NEMESIS)[A-Za-z]*%]") ~= nil then
                    nemesisMsg = aMsg
                    break
                end
            end

            if nemesisMsg then
                msg = nemesisMsg
            else
                msg = availableMessages[random(#availableMessages)]
            end
        end

        -- Roll the message chance
        if (msg.chance < 1.0 and not NemesisChat:Roll(msg.chance)) or msg.chance == 0.0 then
            NCEvent:Initialize()
            return
        end

        NCController:SetChannel(msg.channel)
        NCController:SetMessage(msg.message)
    end

    -- Get a pool of conditional messages pertaining to the current scenarios
    function NCController:GetConditionalMessages(pool)
        if pool == nil or #pool == 0 then
            return {}
        end

        local returnMessages = {}

        for key, value in pairs(pool) do
            if NCController:CheckAllConditions(value) then
                table.insert(returnMessages, value)
            end
        end

        -- Keep rolling through Nemeses to see if one matches conditions
        if #returnMessages == 0 and NCEvent:GetTarget() ~= "NEMESIS" and NCState:GetGroupNemesesCount() > 1 then
            table.insert(NCController.excludedNemeses, NCEvent:GetNemesis())

            local newNemesis = NCState:GetNonExcludedNemesis()

            if newNemesis ~= nil then
                NCEvent:SetNemesis(newNemesis)

                return NCController:GetConditionalMessages(pool)
            end
        end

        -- Keep rolling through Bystanders to see if one matches conditions
        if #returnMessages == 0 and NCEvent:GetTarget() ~= "BYSTANDER" and NCState:GetGroupBystandersCount() > 1 then
            table.insert(NCController.excludedBystanders, NCEvent:GetBystander())

            local newBystander = NCState:GetNonExcludedBystander()

            if newBystander ~= nil then
                NCEvent:SetBystander(newBystander)

                return NCController:GetConditionalMessages(pool)
            end
        end

        return returnMessages
    end

    function NCController:CheckAllConditions(message)
        local includesNemesis = (string.find(message.message, "[NEMESIS]", nil, true) ~= nil) or (message.channel == "WHISPER" and NCEvent:GetTarget() == "SELF") or (message.channel == "WHISPER_NEMESIS" and (NCEvent:GetTarget() == "SELF" or NCEvent:GetTarget() == "NA"))
        local includesBystander = (string.find(message.message, "[BYSTANDER]", nil, true) ~= nil) or (message.channel == "WHISPER" and NCEvent:GetTarget() == "SELF") or (message.channel == "WHISPER_BYSTANDER" and (NCEvent:GetTarget() == "SELF" or NCEvent:GetTarget() == "NA"))

        if includesNemesis and not NCState:HasGroupNemeses() then
            return false
        end

        if includesBystander and not NCState:HasGroupBystanders() then
            return false
        end

        if message.conditions == nil or #message.conditions == 0 then
            return true
        end

        local pass = true

        for condKey, condVal in pairs(message.conditions) do
            if NCController:CheckCondition(condVal) == false then
                pass = false
            end
        end

        return pass
    end

    function NCController:CheckCondition(condition)
        local subjectFunc = NCController.Condition[condition.left]

        if subjectFunc == nil then
            for k, api in pairs(core.apis) do
                local tempSubjectFunc

                for i, subject in pairs(api.subjects) do
                    if subject.value == condition.left then
                        tempSubjectFunc = subject.exec
                        break
                    end
                end

                if tempSubjectFunc ~= nil then
                    subjectFunc = tempSubjectFunc
                    break
                end
            end
        end

        if subjectFunc == nil then
            NemesisChat:Print("ERROR: Condition subject function not found for " .. condition.left .. "!")
            return false
        end

        local val1 = subjectFunc()
        local val2 = NCController:GetReplacedString(condition.right:gsub("%[([A-Z_]*)%]", "[%1_CONDITION]")) -- Set this to a condition-specific replacement, non-formatted, ie [NEMESISDPS] -> [NEMESISDPS_CONDITION]
        local operator = condition.operator

        return NCController.Condition[operator](val1, val2)
    end

    -- Set values for a random AI message
    function NCController:AIMessage()
        NCController:SetMessage(NemesisChat:GetRandomAiPhrase())
        NCController:SetChannel("GROUP")
    end

    -- Returns TRUE if messages are configured, FALSE otherwise
    function NCController:HasMessages()
        local profileMessages = core.db.profile.messages[NCEvent:GetCategory()][NCEvent:GetEvent()][NCEvent:GetTarget()]

        return (profileMessages ~= nil and #profileMessages >= 1)
    end

    -- Perform all pre-send logic, and send the message to the appropriate channel
    function NCController:Handle()
        if not NCController:ValidMessage() then
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

    -- Condition methods
    NCController.Condition = {
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
            if NCState:GetPlayerState(val1) == nil then
                return false
            end

            return NCState:GetPlayerState(val1).isNemesis
        end,
        ["NOT_NEMESIS"] = function(val1, val2)
            if NCState:GetPlayerState(val1) == nil then
                return true
            end

            return NCState:GetPlayerState(val1).isNemesis == false
        end,
        ["IS_FRIEND"] = function(val1, val2)
            if NCState:GetPlayerState(val1) == nil then
                return false
            end

            return NCState:GetPlayerState(val1).isFriend
        end,
        ["NOT_FRIEND"] = function(val1, val2)
            if NCState:GetPlayerState(val1) == nil then
                return true
            end

            return not NCState:GetPlayerState(val1).isFriend
        end,
        ["IS_GUILDMATE"] = function(val1, val2)
            if NCState:GetPlayerState(val1) == nil then
                return false
            end

            return NCState:GetPlayerState(val1).isGuildmate
        end,
        ["NOT_GUILDMATE"] = function(val1, val2)
            if NCState:GetPlayerState(val1) == nil then
                return true
            end

            return not NCState:GetPlayerState(val1).isGuildmate
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
end
