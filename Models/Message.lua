-----------------------------------------------------
-- MESSAGE
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Message getters, setters, etc.
-----------------------------------------------------

function NemesisChat:InstantiateMsg()
    function NCMessage:Initialize()
        NCMessage = DeepCopy(core.runtimeDefaults.ncMessage)

        NemesisChat:InstantiateMsg()
    end

    function NCMessage:GetChannel()
        if NCMessage.channel == nil then
            return ""
        end

        return NCMessage.channel
    end

    function NCMessage:SetChannel(channel)
        NCMessage.channel = channel
    end

    function NCMessage:GetMessage()
        if NCMessage.message == nil then
            return ""
        end
        
        return NCMessage.message
    end

    function NCMessage:SetMessage(msg)
        NCMessage.message = msg
    end

    function NCMessage:GetTarget()
        if NCMessage.target == nil then
            return ""
        end
        
        return NCMessage.target
    end

    function NCMessage:SetTarget(target)
        NCMessage.target = target
    end

    -- Set the custom replacements property, replacing any existing value(s)
    function NCMessage:SetCustomReplacements(customReplacements)
        NCMessage.customReplacements = customReplacements
    end

    -- Add a custom replacement, replacing anything which already exists for key
    function NCMessage:AddCustomReplacement(key, value)
        NCMessage.customReplacements[key] = value
    end

    -- Run the string replacement and set the message property to the replaced value
    function NCMessage:ReplaceStrings()
        if NCMessage:GetMessage() == "" then
            return
        end

        NCMessage:SetMessage(NCMessage:GetReplacedString(NCMessage:GetMessage()))
    end

    function NCMessage:GetReplacedString(input)
        if input == "" then
            return ""
        end

        if NCEvent:GetBystander() == nil then
            NCEvent:RandomBystander()
        end

        -- We have a base list of replacements that will be available (mostly) everywhere. Some events
        -- will have custom replacements, such as API-based replacements (DPS numbers with Details! for example)
        --
        -- These are all set as functions so we don't hydrate all the replacements (inefficient), but rather only
        -- hydrate the ones we need, when we need them.
        local msg = input

        -- Custom replacements, example: Details API [DPS] and [NEMESISDPS], this comes first as overrides are possible
        for k, v in pairs(NCMessage.customReplacements) do
            -- First check for condition specific replacements
            msg = msg:gsub(k, v())
        end

        -- Remove condition-specific replacement text
        msg = msg:gsub("_CONDITION%]", "]")

        -- One more pass on custom replacements, without condition replacement text, as a fallback
        for k, v in pairs(NCMessage.customReplacements) do
            msg = msg:gsub(k, v())
        end

        return msg
    end

    function NCMessage:Send()
        -- Anti-spam, hardcoded to prevent setting it to 0
        if GetTime() - NCRuntime:GetLastMessage() < 1 and not NCMessage:IsMinTimeException() then
            NCEvent:Initialize()
            return
        end

        -- Config driven minimum time between messages
        if GetTime() - NCRuntime:GetLastMessage() < core.db.profile.minimumTime and not NCMessage:IsMinTimeException() then
            NCEvent:Initialize()
            return
        end

        -- Respect non-combat-mode. If we're in combat, and non-combat-mode is enabled, bail.
        -- We have to bypass this if it's a boss start event, as that's driven by going into combat with a boss.
        if core.db.profile.nonCombatMode and NCCombat:IsActive() and (NCEvent:GetCategory() ~= "BOSS" or NCEvent:GetEvent() ~= "START") then
            NCEvent:Initialize()
            return
        end

        -- Send it to whatever channel we've designated
        if NCMessage.channel ~= "WHISPER" then
            SendChatMessage(NCMessage.message, NCMessage.channel)
        -- It's a whisper, it requires a third argument
        else
            SendChatMessage(NCMessage.message, NCMessage.channel, nil, NCMessage.target)
        end

        NCRuntime:UpdateLastMessage()
    end

    -- Group join events are an exception to the minimum time rule
    function NCMessage:IsMinTimeException()
        return NCEvent:GetCategory() == "GROUP" and (NCEvent:GetEvent() == "JOIN" or NCEvent:GetEvent() == "LEAVE")
    end

    -- If `channel` is `GROUP`, we need to set it to `PARTY`, `INSTANCE_CHAT`, or `RAID`
    function NCMessage:CheckChannel()
        -- Dynamically set the target
        if NCMessage:GetChannel() == "WHISPER_NEMESIS" then
            NCMessage:SetChannel("WHISPER")
            NCMessage:SetTarget(NCEvent:GetNemesis())
        elseif NCMessage:GetChannel() == "WHISPER_BYSTANDER" then
            NCMessage:SetChannel("WHISPER")
            NCMessage:SetTarget(NCEvent:GetBystander())
        else
            if NCEvent:GetTarget() ~= "BYSTANDER" then
                NCMessage:SetTarget(NCEvent:GetNemesis())
            else
                NCMessage:SetTarget(NCEvent:GetBystander())
            end
        end

        NCMessage:SetChannel(NemesisChat:GetChannel(NCMessage:GetChannel()))
    end

    -- Set values for a random configured message
    function NCMessage:ConfigMessage()
        if core.db.profile.messages[NCEvent:GetCategory()] == nil or core.db.profile.messages[NCEvent:GetCategory()][NCEvent:GetEvent()] == nil or core.db.profile.messages[NCEvent:GetCategory()][NCEvent:GetEvent()][NCEvent:GetTarget()] == nil then
            return
        end

        local profileMessages = core.db.profile.messages[NCEvent:GetCategory()][NCEvent:GetEvent()][NCEvent:GetTarget()]

        if profileMessages == nil then
            NCEvent:Initialize()
            return
        end

        -- if core.db.profile.detailsAPI == true then
        --     if NemesisChat:DETAILS_REPLACEMENTS() == false then
        --         NemesisChat:Print("ERROR: Details API is enabled, but an error occurred when attempting to pull data from it! Please ensure Details is enabled.")
        --         NCEvent:Initialize()
        --         return
        --     end
        -- end

        local msg = ""

        -- If a global chance is configured, respect it
        if core.db.profile.useGlobalChance == true then
            if not NemesisChat:Roll(core.db.profile.globalChance or 1) then
                NCEvent:Initialize()
                return
            end
        end

        -- Ensure conditions are met on all messages
        local availableMessages = NCMessage:GetConditionalMessages(profileMessages)

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
            msg = availableMessages[random(#availableMessages)]
        end

        -- Roll the message chance
        if not NemesisChat:Roll(msg.chance) then
            NCEvent:Initialize()
            return
        end

        NCMessage:SetChannel(msg.channel)
        NCMessage:SetMessage(msg.message)
    end

    -- Get a pool of conditional messages pertaining to the current scenarios
    function NCMessage:GetConditionalMessages(pool)
        if pool == nil or #pool == 0 then
            return {}
        end

        local returnMessages = {}

        for key, value in pairs(pool) do
            if NCMessage:CheckAllConditions(value) then
                table.insert(returnMessages, value)
            end
        end

        -- Keep rolling through Nemeses to see if one does match conditions
        if #returnMessages == 0 and NCEvent:GetTarget() ~= "NEMESIS" and NemesisChat:GetPartyNemesesCount() > 1 then
            table.insert(NCMessage.excludedNemeses, NCEvent:GetNemesis())

            local newNemesis = NemesisChat:GetNonExcludedNemesis()

            if newNemesis ~= nil then
                NCEvent:SetNemesis(newNemesis)

                return NCMessage:GetConditionalMessages(pool)
            end
        end

        return returnMessages
    end

    function NCMessage:CheckAllConditions(message)
        local includesNemesis = (string.find(message.message, "[NEMESIS]", nil, true) ~= nil) or (message.channel == "WHISPER" and NCEvent:GetTarget() == "SELF") or (message.channel == "WHISPER_NEMESIS" and NCEvent:GetTarget() == "SELF")
        local includesBystander = (string.find(message.message, "[BYSTANDER]", nil, true) ~= nil) or (message.channel == "WHISPER" and NCEvent:GetTarget() == "SELF") or (message.channel == "WHISPER_BYSTANDER" and NCEvent:GetTarget() == "SELF")

        if includesNemesis and not NemesisChat:HasPartyNemeses() then
            return false
        end

        if includesBystander and not NemesisChat:HasPartyBystanders() then
            return false
        end

        if message.conditions == nil or #message.conditions == 0 then
            return true
        end

        local pass = true

        for condKey, condVal in pairs(message.conditions) do
            if NCMessage:CheckCondition(condVal) == false then
                pass = false
            end
        end

        return pass
    end

    function NCMessage:CheckCondition(condition)
        local subjectFunc = NCMessage.Condition[condition.left]

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
        local val2 = NCMessage:GetReplacedString(condition.right:gsub("%[([A-Z_]*)%]", "[%1_CONDITION]")) -- Set this to a condition-specific replacement, non-formatted, ie [NEMESISDPS] -> [NEMESISDPS_CONDITION]
        local operator = condition.operator

        return NCMessage.Condition[operator](val1, val2)
    end

    -- Set values for a random AI message
    function NCMessage:AIMessage()
        NCMessage:SetMessage(NemesisChat:GetRandomAiPhrase())
        NCMessage:SetChannel("GROUP")
    end

    -- Returns TRUE if messages are configured, FALSE otherwise
    function NCMessage:HasMessages()
        local profileMessages = core.db.profile.messages[NCEvent:GetCategory()][NCEvent:GetEvent()][NCEvent:GetTarget()]

        return (profileMessages ~= nil and #profileMessages >= 1)
    end

    -- Perform all pre-send logic, and send the message to the appropriate channel
    function NCMessage:Handle()
        if not NCMessage:ValidMessage() then
            return
        end

        -- Custom replacements / hooks from APIs
        NemesisChatAPI:InitPreMessage()

        NCMessage:ReplaceStrings()
        NCMessage:CheckChannel()
        NCMessage:Send()

        NemesisChatAPI:InitPostMessage()
    end

    function NCMessage:ValidMessage()
        return NCMessage:GetMessage() ~= ""
    end

    -- Condition methods
    NCMessage.Condition = {
        -- Subjects
        ["NEMESIS_ROLE"] = function()
            return NCRuntime:GetGroupRosterPlayer(NCEvent:GetNemesis()).role
        end,
        ["SPELL_ID"] = function()
            -- Return as string so input comparisons work properly
            return NCSpell:GetSpellId() .. ""
        end,
        ["SPELL_NAME"] = function()
            return NCSpell:GetSpellName()
        end,
        ["SPELL_TARGET"] = function()
            return NCSpell:GetTarget()
        end,
        ["GROUP_COUNT"] = function()
            return #NCRuntime:GetGroupRoster() or 0
        end,
        ["NEMESES_COUNT"] = function()
            -- Return as string so input comparisons work properly
            return NemesisChat:GetPartyNemesesCount() .. ""
        end,
        ["INTERRUPTS"] = function()
            -- Return as string so input comparisons work properly
            return NCCombat:GetInterrupts(GetMyName()) .. ""
        end,
        ["INTERRUPTS_OVERALL"] = function()
            -- Return as string so input comparisons work properly
            return NCDungeon:GetInterrupts(GetMyName()) .. ""
        end,
        ["NEMESIS_INTERRUPTS"] = function()
            -- Return as string so input comparisons work properly
            return NCCombat:GetInterrupts(NCEvent:GetNemesis()) .. ""
        end,
        ["NEMESIS_INTERRUPTS_OVERALL"] = function()
            -- Return as string so input comparisons work properly
            return NCDungeon:GetInterrupts(NCEvent:GetNemesis()) .. ""
        end,

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
            if NCRuntime:GetGroupRosterPlayer(val1) == nil then
                return false
            end

            return NCRuntime:GetGroupRosterPlayer(val1).isNemesis
        end,
        ["NOT_NEMESIS"] = function(val1, val2)
            if NCRuntime:GetGroupRosterPlayer(val1) == nil then
                return true
            end

            return NCRuntime:GetGroupRosterPlayer(val1).isNemesis == false
        end,
        ["IS_FRIEND"] = function(val1, val2)
            if NCRuntime:GetGroupRosterPlayer(val1) == nil then
                return false
            end

            return NCRuntime:GetGroupRosterPlayer(val1).isFriend
        end,
        ["NOT_FRIEND"] = function(val1, val2)
            if NCRuntime:GetGroupRosterPlayer(val1) == nil then
                return true
            end

            return not NCRuntime:GetGroupRosterPlayer(val1).isFriend
        end,
        ["IS_GUILDMATE"] = function(val1, val2)
            if NCRuntime:GetGroupRosterPlayer(val1) == nil then
                return false
            end

            return NCRuntime:GetGroupRosterPlayer(val1).isGuildmate
        end,
        ["NOT_GUILDMATE"] = function(val1, val2)
            if NCRuntime:GetGroupRosterPlayer(val1) == nil then
                return true
            end

            return not NCRuntime:GetGroupRosterPlayer(val1).isGuildmate
        end,
    }
end