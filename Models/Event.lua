-----------------------------------------------------
-- EVENT
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Event getters, setters, and helper methods
-----------------------------------------------------

function NemesisChat:InstantiateEvent()
    function NCEvent:Initialize()
        NCEvent = DeepCopy(core.runtimeDefaults.ncEvent)

        NemesisChat:InstantiateEvent()

        NCController:Initialize()
        NCSpell:Initialize()
        NemesisChat:PopulateFriends()
    end

    function NCEvent:GetCategory()
        if NCEvent.category == nil then
            return ""
        end

        return NCEvent.category
    end

    function NCEvent:SetCategory(category)
        NCEvent.category = category

        if category == "GUILD" then
            NCController:SetEventType(NC_EVENT_TYPE_GUILD)
        end
    end

    function NCEvent:GetEvent()
        if NCEvent.event == nil then 
            return ""
        end

        return NCEvent.event
    end

    function NCEvent:SetEvent(event)
        NCEvent.event = event
    end

    function NCEvent:GetTarget()
        if NCEvent.target == nil then 
            return ""
        end

        return NCEvent.target
    end

    function NCEvent:SetTarget(target)
        NCEvent.target = target
    end

    function NCEvent:GetNemesis()
        if NCEvent.nemesis == nil then 
            return ""
        end

        return NCEvent.nemesis
    end

    function NCEvent:HasNemesis()
        return NCEvent:GetNemesis() ~= ""
    end

    function NCEvent:SetNemesis(nemesis)
        NCEvent.nemesis = nemesis
    end

    -- Set the event's nemesis to a random nemesis in the party
    function NCEvent:RandomNemesis()
        local nemesis = NemesisChat:GetRandomPartyNemesis()

        if nemesis ~= nil and nemesis ~= "" then
            NCEvent.nemesis = nemesis
        end
    end

    -- Set the event's nemesis to a random nemesis in the guild
    function NCEvent:RandomGuildNemesis()
        local nemesis = NemesisChat:GetRandomGuildNemesis()

        if nemesis ~= nil and nemesis ~= "" then
            NCEvent.nemesis = nemesis
        end
    end

    function NCEvent:GetBystander()
        if NCEvent.bystander == nil then
            return ""
        end

        return NCEvent.bystander
    end

    function NCEvent:HasBystander()
        return NCEvent:GetBystander() ~= ""
    end

    function NCEvent:SetBystander(bystander)
        NCEvent.bystander = bystander
    end

    -- Set the event's bystander to a random bystander in the party
    function NCEvent:RandomBystander()
        local bystander = NemesisChat:GetRandomPartyBystander()

        if bystander ~= nil and bystander ~= "" then
            NCEvent:SetBystander(bystander)
        end
    end

    -- Set the event's bystander to a random bystander in the guild
    function NCEvent:RandomGuildBystander()
        local bystander = NemesisChat:GetRandomGuildBystander()

        if bystander ~= nil and bystander ~= "" then
            NCEvent:SetBystander(bystander)
        end
    end

    -- Set the Category and Event for a group join event
    function NCEvent:GroupJoin()
        NCEvent:SetCategory("GROUP")
        NCEvent:SetEvent("JOIN")
    end

    -- Set the Category and Event for a group leave event
    function NCEvent:GroupLeave()
        NCEvent:SetCategory("GROUP")
        NCEvent:SetEvent("LEAVE")
    end

    -- Set the Category, Event, and Target for an interrupt event
    function NCEvent:Interrupt(source, dest, spellId, spellName, extraSpellId)
        NCEvent:SetEvent("INTERRUPT")
        NCEvent:SetTargetFromSource(source)

        NCSegment:GlobalAddInterrupt(source)

        NCSpell:Interrupt(source, dest, spellId, spellName, extraSpellId)
    end

    -- Set the Category, Event, and Target for a spell event
    -- TODO: Modularize
    function NCEvent:Spell(source, dest, spellId, spellName)
        local feast = core.feastIDs[spellId]

        -- We don't care about casts from non-grouped players / mobs to non-grouped players / mobs
        -- if not UnitInParty(source) and not UnitInParty(dest) then
        --     NCEvent:Initialize()
        --     return
        -- end

        NCEvent:SetEvent("SPELL_CAST_SUCCESS")
        NCEvent:SetTargetFromSource(source)

        -- Allow defined messages to take priority over feast messages
        if NCEvent:EventHasMessages() or feast == nil then
            NCSpell:Spell(source, dest, spellId, spellName)
            return
        end

        -- Feasts last 2 min, so a new feast within 2 min of the last one is a replacement. 100 sec should be reasonable here.
        local isReplace = (GetTime() - NCRuntime:GetLastFeast() <= 100)
        NCRuntime:UpdateLastFeast()

        if isReplace then
            NCEvent:SetEvent("REFEAST")
        elseif feast == 1 then
            NCEvent:SetEvent("FEAST")
        else
            NCEvent:SetEvent("OLDFEAST")
        end

        NCSpell:Feast(source, spellId)
    end

    -- Begin spellcasting 
    function NCEvent:SpellStart(source, dest, spellId, spellName)
        NCEvent:SetEvent("SPELL_CAST_START")
        NCEvent:SetTargetFromSource(source)

        NCSpell:Spell(source, dest, spellId, spellName)
    end

    -- Set the Category, Event, and Target for a group heal event
    function NCEvent:Heal(source, dest, spellId, spellName, healAmount)
        NCEvent:SetEvent("HEAL")
        NCEvent:SetTargetFromSource(source)

        NCSegment:GlobalAddHeals(healAmount, source, dest)

        NemesisChat:SetLastHealPlayerState(source, dest)

        NCSpell:Spell(source, dest, spellId, spellName)
    end

    -- Set the Category, Event, and Target for a group enemy kill event
    function NCEvent:Kill(source, dest)
        NCEvent:SetEvent("KILL")
        NCEvent:SetTargetFromSource(source)

        NCSegment:GlobalAddKill(source)
    end

    -- Set the Category, Event, and Target for a group member death event
    function NCEvent:Death(dest)
        NCEvent:SetEvent("DEATH")
        NCEvent:SetTargetFromSource(dest)

        if NCBoss:IsActive() then
            NCEvent:SetCategory("BOSS")
        end
    end

    -- Same as above, but the death was due to avoidable damage
    function NCEvent:AvoidableDeath(dest)
        NCEvent:Death(dest)
        NCEvent:SetEvent("AVOIDABLE_DEATH")
    end

    --- Handles a damage event<br><br>
    -- @param <b>source</b> string: The source of the damage<br>
    -- @param <b>dest</b> string: The target of the damage<br>
    -- @param <b>spellId</b> number: The ID of the spell causing the damage<br>
    -- @param <b>spellName</b> string: The name of the spell causing the damage<br>
    -- @param <b>amount</b> number: The amount of damage dealt<br>
    -- @param <b>avoidable</b> boolean: Boolean indicating if the damage was avoidable<br>
    function NCEvent:Damage(source, dest, spellId, spellName, amount, avoidable)
        local _, subEvent = CombatLogGetCurrentEventInfo()
        NCEvent:SetEvent("DAMAGE")
        NCEvent:SetTargetFromSource(dest)

        if avoidable then
            NCEvent:SetEvent("AVOIDABLE_DAMAGE")
        end

        if subEvent == "SWING_DAMAGE" then
            NCSpell:Damage(source, dest, source, source, amount)
        else
            NCSpell:Damage(source, dest, spellId, spellName, amount)
        end
    end

    -- Aura applied
    function NCEvent:Aura(source, dest, spellId, spellName)
        NCEvent:SetEvent("AURA_APPLIED")
        NCEvent:SetTargetFromSource(dest)

        NCSpell:Spell(source, dest, spellId, spellName)
    end

    -- Set the event's Target based on the input source (SELF|NEMESIS|BYSTANDER), and set a random Bystander/Nemesis if appropriate
    function NCEvent:SetTargetFromSource(source)
        local member = NCRuntime:GetGroupRosterPlayer(source)

        if source == NemesisChat:GetMyName() then
            NCEvent:SetTarget("SELF")
            NCEvent:RandomNemesis()
            NCEvent:RandomBystander()
        elseif member ~= nil then
            if member.isNemesis then
                NCEvent:SetTarget("NEMESIS")
                NCEvent:SetNemesis(source)
                NCEvent:RandomBystander()
            else
                NCEvent:SetTarget("BYSTANDER")
                NCEvent:SetBystander(source)
                NCEvent:RandomNemesis()
            end
        else
            -- If we're not in combat, we don't care about the event
            if not NCCombat:IsActive() or not IsInInstance() then
                NCEvent:Initialize()
                return
            end

            -- Enemy mob, can be a boss, affix mob, or trash mob. Random Bystander and Nemesis.
            if NCBoss:IsActive() and source == NCBoss:GetIdentifier() then
                NCEvent:SetTarget("BOSS")

                if not self:EventHasMessages() then
                    NCEvent:SetTarget("ANY_MOB")
                end
            elseif core.affixMobsLookup[source] ~= nil then
                NCEvent:SetTarget("AFFIX")

                if not self:EventHasMessages() then
                    NCEvent:SetTarget("ANY_MOB")
                end
            else
                NCEvent:SetTarget("ANY_MOB")
            end

            NCEvent:RandomNemesis()
            NCEvent:RandomBystander()
        end
    end

    function NCEvent:IsValidEvent()
        return (NCEvent:GetCategory() ~= "" and NCEvent:GetEvent() ~= "" and NCEvent:GetTarget() ~= "")
    end

    function NCEvent:EventHasMessages()
        if NCEvent:GetCategory() == "" or NCEvent:GetEvent() == "" or NCEvent:GetTarget() == "" then
            return false
        end

        local category = core.db.profile.messages[NCEvent:GetCategory()]

        if category == nil then
            return false
        end

        local event = category[NCEvent:GetEvent()]

        if event == nil then
            return false
        end

        local profileMessages = event[NCEvent:GetTarget()]

        if profileMessages == nil or #profileMessages == 0 then
            return false
        end

        local availableMessages = NCController:GetConditionalMessages(profileMessages)

        return availableMessages ~= nil and #availableMessages > 0
    end

    -- A player within the party has taken damage
    function NCEvent:IsDamageEvent(event, dest, misc4)
        return misc4 and type(misc4) == "number" and misc4 > 0 and UnitInParty(dest)
    end

    function NCEvent:CombatStart()
        NCEvent:SetCategory("COMBATLOG")
        NCEvent:SetEvent("COMBAT_START")
        NCEvent:SetTarget("NA")
    end

    function NCEvent:CombatEnd()
        NCEvent:SetCategory("COMBATLOG")
        NCEvent:SetEvent("COMBAT_END")
        NCEvent:SetTarget("NA")
    end
end