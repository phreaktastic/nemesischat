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

        -- We have a base list of replacements that will be available (mostly) everywhere. Some events
        -- will have custom replacements, such as API-based replacements (DPS numbers with Details! for example)
        local msg = input
        local replacements = {
            ["self"] = core.runtime.myName,
            ["nemesis"] = NCEvent:GetNemesis(),
            ["nemesisDeaths"] = NCDungeon:GetDeaths(NCEvent:GetNemesis()) or 0,
            ["nemesisKills"] = NCDungeon:GetKills(NCEvent:GetNemesis()) or 0,
            ["deaths"] = NCDungeon:GetDeaths(core.runtime.myName) or 0,
            ["kills"] = NCDungeon:GetKills(core.runtime.myName) or 0,
            ["dungeonTime"] = NemesisChat:GetDuration(NCDungeon:GetStartTime()),
            ["keystoneLevel"] = NCDungeon:GetLevel(),
            ["bossTime"] = NemesisChat:GetDuration(NCBoss:GetStartTime()),
            ["bossName"] = NCBoss:GetName(),
        }

        if NCSpell:GetTarget() then
            replacements["target"] = NCSpell:GetTarget()
        end

        -- When we have explicitly set a bystander, we'll use that. Otherwise, there are times where
        -- we just want a random Bystander from the party.
        if NCEvent:GetBystander() ~= "" then 
            replacements["bystander"] = NCEvent:GetBystander()
        else
            replacements["bystander"] = NemesisChat:GetRandomPartyBystander()
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
                -- Strip any _CONDITION occurrences as they will not exist in core supported replacements
                msg = msg:gsub("_CONDITION%]", "]"):gsub(k, replacements[v])
            end
        end

        return msg
    end

    function NCMessage:Send()
        -- Anti-spam, hardcoded to prevent setting it to 0
        if GetTime() - core.runtime.lastMessage < 1 then
            NCEvent:Initialize()
            return
        end

        -- Config driven minimum time between messages
        if GetTime() - core.runtime.lastMessage < core.db.profile.minimumTime then
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

        -- Always set the target to the Nemesis to prevent potentially whispering randoms in groups.
        NCMessage:SetTarget(NCEvent:GetNemesis())
    end

    -- Get a pool of conditional messages pertaining to the current scenarios
    function NCMessage:GetConditionalMessages(pool)
        if pool == nil or #pool == 0 then
            return {}
        end

        local returnMessages = {}

        for key, value in pairs(pool) do
            if value.conditions == nil or value.conditions == {} or #value.conditions == 0 then
                table.insert(returnMessages, value)
            elseif NCMessage:CheckAllConditions(value) then
                table.insert(returnMessages, value)
            end
        end

        return returnMessages
    end

    function NCMessage:CheckAllConditions(message)
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
        local val2 = NCMessage:GetReplacedString(condition.right:gsub("%[([A-Z_]*)%]", "[%1_CONDITION]")) -- Set this to a condition-specific replacement, non-formatted, ie [NEMESIS_DPS] -> [NEMESIS_DPS_CONDITION]
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
            if NemesisChat.DETAILS and NemesisChat.DETAILS["MY_DPS"] ~= nil then -- What?!
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
    }
end