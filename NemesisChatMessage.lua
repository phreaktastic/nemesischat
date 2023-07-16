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
        local msg = input
        local myName = GetMyName()
        local replacements = {
            ["self"] = myName,
            ["nemesis"] = NCEvent:GetNemesis(),
            ["nemesisDeaths"] = NCDungeon:GetDeaths(NCEvent:GetNemesis()) or 0,
            ["nemesisKills"] = NCDungeon:GetKills(NCEvent:GetNemesis()) or 0,
            ["deaths"] = NCDungeon:GetDeaths(myName) or 0,
            ["kills"] = NCDungeon:GetKills(myName) or 0,
            ["dungeonTime"] = NemesisChat:GetDuration(NCDungeon:GetStartTime()),
            ["keystoneLevel"] = NCDungeon:GetLevel(),
            ["bossTime"] = NemesisChat:GetDuration(NCBoss:GetStartTime()),
            ["bossName"] = NCBoss:GetName(),
            ["interrupts"] = NCCombat:GetInterrupts(myName),
            ["interruptsOverall"] = NCDungeon:GetInterrupts(myName),
            ["nemesisInterrupts"] = NCCombat:GetInterrupts(NCEvent:GetNemesis()),
            ["nemesisInterruptsOverall"] = NCDungeon:GetInterrupts(NCEvent:GetNemesis()),
            ["nemesisRole"] = GetRole(NCEvent:GetNemesis()),
            ["role"] = GetRole(),
            ["bystander"] = NCEvent:GetBystander(),
            ["bystanderRole"] = GetRole(NCEvent:GetBystander()),
        }

        if NCSpell:GetTarget() then
            replacements["target"] = NCSpell:GetTarget()
        end

        -- We have no Bystander, and shouldn't actually ever reach this due to treating this as a failed condition.
        if NCEvent:GetBystander() == "" then 
            replacements["bystander"] = "someone"
            replacements["bystanderRole"] = "party animal"
        end

        -- We will add these here since there isn't technically an API. Sad.
        -- To be refactored nonetheless. This shouldn't live here.
        if core.db.profile.gtfoAPI and GTFO then
            replacements["avoidableDamage"] = NemesisChat:FormatNumber(NCCombat:GetAvoidableDamage(GetMyName()))
            replacements["nemesisAvoidableDamage"] = NemesisChat:FormatNumber(NCCombat:GetAvoidableDamage(NCEvent:GetNemesis()))
            replacements["avoidableDamageOverall"] = NemesisChat:FormatNumber(NCDungeon:GetAvoidableDamage(GetMyName()))
            replacements["nemesisAvoidableDamageOverall"] = NemesisChat:FormatNumber(NCDungeon:GetAvoidableDamage(NCEvent:GetNemesis()))

            -- Condition specific, unformatted so they can be compared
            NCMessage:AddCustomReplacement("%[AVOIDABLEDAMAGE_CONDITION%]", NCCombat:GetAvoidableDamage(GetMyName()))
            NCMessage:AddCustomReplacement("%[AVOIDABLEDAMAGEOVERALL_CONDITION%]", NCDungeon:GetAvoidableDamage(GetMyName()))
            NCMessage:AddCustomReplacement("%[NEMESISAVOIDABLEDAMAGE_CONDITION%]", NCCombat:GetAvoidableDamage(NCEvent:GetNemesis()))
            NCMessage:AddCustomReplacement("%[NEMESISAVOIDABLEDAMAGEOVERALL_CONDITION%]", NCDungeon:GetAvoidableDamage(NCEvent:GetNemesis()))
        end

        -- SpellId will be populated for feasts, while ExtraSpellId will be populated for interrupts
        if NCSpell:IsValidSpell() then
            replacements["spell"] = NCSpell:GetSpellLink() or NCSpell:GetExtraSpellLink() or "Spell"
        end

        -- Custom replacements, example: Details API [DPS] and [NEMESISDPS], this comes first as overrides are possible
        for k, v in pairs(NCMessage.customReplacements) do
            -- First check for condition specific replacements
            msg = msg:gsub(k, v)
        end

        -- Remove condition-specific replacement text
        msg = msg:gsub("_CONDITION%]", "]")

        -- One more pass without condition replacement text, as a fallback
        for k, v in pairs(NCMessage.customReplacements) do
            msg = msg:gsub(k, v)
        end

        -- Format the message
        for k, v in pairs(core.supportedReplacements) do
            if (k ~= nil and v ~= nil and replacements[v] ~= nil) then
                msg = msg:gsub(k, replacements[v])
            end
        end

        return msg
    end

    function NCMessage:Send()
        -- Anti-spam, hardcoded to prevent setting it to 0
        if GetTime() - core.runtime.lastMessage < 1 and not NCMessage:IsMinTimeException() then
            NCEvent:Initialize()
            return
        end

        -- Config driven minimum time between messages
        if GetTime() - core.runtime.lastMessage < core.db.profile.minimumTime and not NCMessage:IsMinTimeException() then
            NCEvent:Initialize()
            return
        end

        -- Respect non-combat-mode. If we're in combat, and non-combat-mode is enabled, bail.
        -- We have to bypass this if it's a boss start event, as that's driven by going into combat with a boss.
        if core.db.profile.nonCombatMode and NCCombat:InCombat() and (NCEvent:GetCategory() ~= "BOSS" or NCEvent:GetEvent() ~= "START") then
            NCEvent:Initialize()
            return
        end

        -- Send it to whatever channel we've designated
        if NCMessage.channel ~= "WHISPER" then
            SendChatMessage(NCMessage.message, NCMessage.channel)
        -- It's a whisper, it requires a third argument
        else
            SendChatMessage(NCMessage.message, NCMessage.channel, NCMessage.target)
        end

        core.runtime.lastMessage = GetTime()
    end

    -- Group join events are an exception to the minimum time rule
    function NCMessage:IsMinTimeException()
        return NCEvent:GetCategory() == "GROUP" and (NCEvent:GetEvent() == "JOIN" or NCEvent:GetEvent() == "LEAVE")
    end

    -- If `channel` is `GROUP`, we need to set it to `PARTY`, `INSTANCE_CHAT`, or `RAID`
    function NCMessage:CheckChannel()
        if NCMessage.channel ~= "GROUP" then
            return
        end

        -- Default to party chat
        local channel = "PARTY"

        -- In an instance
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then channel = "INSTANCE_CHAT" end
        
        -- In a raid
        if IsInRaid() then channel = "RAID" end

        NCMessage:SetChannel(channel)
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

        if core.db.profile.detailsAPI == true then
            if NemesisChat:DETAILS_REPLACEMENTS() == false then
                NemesisChat:Print("ERROR: Details API is enabled, but an error occurred when attempting to pull data from it! Please ensure Details is enabled.")
                NCEvent:Initialize()
                return
            end
        end

        local msg = ""

        -- If a global chance is configured, respect it
        if core.db.profile.useGlobalChance == true then
            if not NemesisChat:Roll(core.db.profile.globalChance or 1) then
                NCEvent:Initialize()
                return
            end
        end

        -- Channel must be set prior to checking conditions
        NCMessage:SetChannel(msg.channel)

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

        NCMessage:SetMessage(msg.message)

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
        local includesNemesis = (string.find(message.message, "[NEMESIS]", nil, true) ~= nil) or (NCMessage:GetChannel() == "WHISPER" and NCEvent:GetTarget() == "SELF")
        local includesBystander = (string.find(message.message, "[BYSTANDER]", nil, true) ~= nil) or (NCMessage:GetChannel() == "WHISPER" and NCEvent:GetTarget() == "SELF")

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
        local val1 = NCMessage.Condition[condition.left]()
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

        NCMessage:ReplaceStrings()
        NCMessage:CheckChannel()
        NCMessage:Send()
    end

    function NCMessage:ValidMessage()
        return NCMessage:GetMessage() ~= ""
    end

    -- Condition methods
    NCMessage.Condition = {
        -- Subjects
        ["NEMESIS_ROLE"] = function()
            return core.runtime.groupRoster[NCEvent:GetNemesis()].role
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
            return #core.runtime.groupRoster or 0
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
            if core.runtime.groupRoster[val1] == nil then
                return false
            end

            return core.runtime.groupRoster[val1].isNemesis
        end,
        ["NOT_NEMESIS"] = function(val1, val2)
            if core.runtime.groupRoster[val1] == nil then
                return true
            end

            return core.runtime.groupRoster[val1].isNemesis == false
        end,
        
        -- Details! API 
        ["NEMESIS_DPS"] = function()
            if NemesisChat.DETAILS and NemesisChat.DETAILS["NEMESIS_DPS"] ~= nil then
                return NemesisChat.DETAILS["NEMESIS_DPS"]()
            end
        end,
        ["MY_DPS"] = function()
            if NemesisChat.DETAILS and NemesisChat.DETAILS["MY_DPS"] ~= nil then
                return NemesisChat.DETAILS["MY_DPS"]()
            end
        end,
        ["NEMESIS_DPS_OVERALL"] = function()
            if NemesisChat.DETAILS and NemesisChat.DETAILS["NEMESIS_DPS_OVERALL"] ~= nil then
                return NemesisChat.DETAILS["NEMESIS_DPS_OVERALL"]()
            end
        end,
        ["MY_DPS_OVERALL"] = function()
            if NemesisChat.DETAILS and NemesisChat.DETAILS["MY_DPS_OVERALL"] ~= nil then
                return NemesisChat.DETAILS["MY_DPS_OVERALL"]()
            end
        end,

        -- GTFO API
        ["NEMESIS_AD"] = function()
            return NCCombat:GetAvoidableDamage(NCEvent:GetNemesis()) .. ""
        end,
        ["MY_AD"] = function()
            return NCCombat:GetAvoidableDamage(GetMyName()) .. ""
        end,
        ["NEMESIS_AD_OVERALL"] = function()
            return NCDungeon:GetAvoidableDamage(NCEvent:GetNemesis()) .. ""
        end,
        ["MY_AD_OVERALL"] = function()
            return NCDungeon:GetAvoidableDamage(GetMyName()) .. ""
        end,
    }
end