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

        NCMessage:Initialize()
        NCSpell:Initialize()
    end

    function NCEvent:GetCategory()
        if NCEvent.category == nil then 
            return ""
        end

        return NCEvent.category
    end

    function NCEvent:SetCategory(category)
        NCEvent.category = category
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

        NCSpell:Interrupt(source, dest, spellId, spellName, extraSpellId)
    end

    -- Set the Category, Event, and Target for a spell event
    -- TODO: Modularize
    function NCEvent:Spell(source, dest, spellId, spellName)
        local feast = core.feastIDs[spellId]

        -- We don't care about casts from non-grouped players
        if not UnitInParty(source) then
            NCEvent:Initialize()
            return
        end

        NCEvent:SetEvent("SPELL_CAST_SUCCESS")
        NCEvent:SetTargetFromSource(source)

        -- Allow defined messages to take priority over feast messages
        if NCEvent:EventHasMessages() or feast == nil then
            NCSpell:Spell(source, dest, spellId, spellName)
            return
        end

        local isReplace = (GetTime() - core.runtime.lastFeast <= 20)
        core.runtime.lastFeast = GetTime()

        if isReplace then
            NCEvent:SetEvent("REFEAST")
        elseif feast == 1 then
            NCEvent:SetEvent("FEAST")
        else 
            NCEvent:SetEvent("OLDFEAST")
        end

        NCSpell:Feast(source, spellId)
    end

    -- Set the Category, Event, and Target for a group heal event
    function NCEvent:Heal(source, dest, spellId, spellName)
        NCEvent:SetEvent("HEAL")
        NCEvent:SetTargetFromSource(source)

        NCSpell:Spell(source, dest, spellId, spellName)
    end

    -- Set the Category, Event, and Target for a group enemy kill event
    function NCEvent:Kill(source, dest)
        NCEvent:SetEvent("KILL")
        NCEvent:SetTargetFromSource(source)

        NemesisChat:IncrementKills(source)
    end

    -- Set the Category, Event, and Target for a group member death event
    function NCEvent:Death(dest)
        NCEvent:SetEvent("DEATH")
        NCEvent:SetTargetFromSource(dest)

        NemesisChat:IncrementDeaths(dest)

        if NCBoss:IsActive() then
            NCEvent:SetCategory("BOSS")
        end
    end

    -- Helper for starting a M+ dungeon
    function NCEvent:StartChallenge()
        NCEvent:SetCategory("CHALLENGE")
        NCEvent:SetEvent("START")
        NCEvent:SetTarget("NA")
        NCEvent:RandomNemesis()
        NCEvent:RandomBystander()
    end

    -- Helper for ending a M+ dungeon
    function NCEvent:EndChallenge(onTime)
        NCEvent:SetCategory("CHALLENGE")
        if onTime then NCEvent:SetEvent("SUCCESS") else NCEvent:SetEvent("FAIL") end
        NCEvent:SetTarget("NA")
        NCEvent:RandomNemesis()
        NCEvent:RandomBystander()
    end

    -- Helper for starting a boss encounter
    function NCEvent:StartBoss()
        NCEvent:SetCategory("BOSS")
        NCEvent:SetEvent("START")
        NCEvent:SetTarget("NA")
        NCEvent:RandomNemesis()
        NCEvent:RandomBystander()
    end

    -- Helper for ending a boss encounter
    function NCEvent:EndBoss(isSuccess)
        NCEvent:SetCategory("BOSS")
        NCEvent:SetTarget("NA")
        NCEvent:RandomNemesis()
        NCEvent:RandomBystander()

        if NemesisChat:IsWipe() then 
            NCEvent:SetEvent("FAIL") 
        elseif isSuccess == false then
            -- Boss reset, not a wipe
        else 
            -- Boss killed
            NCEvent:SetEvent("SUCCESS") 
        end
    end

    -- Set the event's Target based on the input source (SELF|NEMESIS|BYSTANDER), and set a random Bystander/Nemesis if appropriate
    function NCEvent:SetTargetFromSource(source)
        local member = core.runtime.groupRoster[source]

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

        if category == nil or #category == 0 then
            return false
        end

        local event = category[NCEvent:GetEvent()]

        if event == nil or #event == 0 then
            return false
        end

        local profileMessages = event[NCEvent:GetTarget()]

        if profileMessages == nil or #profileMessages == 0 then
            return false
        end

        local availableMessages = NCMessage:GetConditionalMessages(profileMessages)

        return availableMessages ~= nil and #availableMessages > 0
    end

    -- A player within the party has taken damage
    function NCEvent:IsDamageEvent(event, dest, misc4)
        return ((event == "SPELL_PERIODIC_DAMAGE" or event == "SPELL_DAMAGE" or event == "SPELL_INSTAKILL" or event == "SWING_DAMAGE") or ((event=="SPELL_AURA_APPLIED" or event=="SPELL_AURA_APPLIED_DOSE" or event=="SPELL_AURA_REFRESH") and misc4=="DEBUFF")) and ((core.runtime.groupRoster[dest] ~= nil and core.runtime.groupRoster[dest] ~= "") or dest == GetMyName())
    end

    function NCEvent:CombatStart()
        NCEvent:SetCategory("COMBATLOG")
        NCEvent:SetEvent("COMBAT_START")
        NCEvent:SetEvent("NA")
    end

    function NCEvent:CombatEnd()
        NCEvent:SetCategory("COMBATLOG")
        NCEvent:SetEvent("COMBAT_END")
        NCEvent:SetEvent("NA")
    end
end