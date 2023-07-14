-----------------------------------------------------
-- COMBAT
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Event getters, setters, and helper methods
-----------------------------------------------------

function NemesisChat:InstantiateCombat()
    function NCCombat:Initialize()
        NCCombat = DeepCopy(core.runtimeDefaults.ncCombat)

        NemesisChat:InstantiateCombat()
        NCCombat:InitAvoidableDamage()
        NCCombat:InitInterrupts()
    end

    function NCCombat:EnterCombat()
        NCCombat.inCombat = true

        NCEvent:SetCategory("COMBATLOG")
        NCEvent:SetEvent("COMBAT_START")
        NCEvent:SetTarget("NA")
        NCEvent:RandomNemesis()
        NCEvent:RandomBystander()
    end

    function NCCombat:LeaveCombat()
        NCCombat.inCombat = false

        NCEvent:SetCategory("COMBATLOG")
        NCEvent:SetEvent("COMBAT_END")
        NCEvent:SetTarget("NA")
        NCEvent:RandomNemesis()
        NCEvent:RandomBystander()
    end

    function NCCombat:InCombat()
        return NCCombat.inCombat
    end

    -- Add avoidable damage for a player
    function NCCombat:AddAvoidableDamage(damage, dest)
        if not UnitInParty(dest) or damage <= 0 then
            return
        end

        if NCCombat.avoidableDamage[dest] == nil then
            NCCombat.avoidableDamage[dest] = damage
        else
            NCCombat.avoidableDamage[dest] = NCCombat.avoidableDamage[dest] + damage
        end
    end

    -- Get avoidable damage for a player
    function NCCombat:GetAvoidableDamage(player)
        if NCCombat.avoidableDamage == nil then
            NCCombat:InitAvoidableDamage()
        end

        if NCCombat.avoidableDamage[player] == nil then
            NCCombat.avoidableDamage[player] = 0
        end

        return NCCombat.avoidableDamage[player]
    end

    -- Add interrupt for a player
    function NCCombat:AddInterrupt(dest)
        if not UnitInParty(dest) then
            return
        end

        if NCCombat.interrupts[dest] == nil then
            NCCombat.interrupts[dest] = 1
        else
            NCCombat.interrupts[dest] = NCCombat.interrupts[dest] + 1
        end
    end

    -- Get interrupts for a player
    function NCCombat:GetInterrupts(player)
        if NCCombat.interrupts == nil then
            NCCombat:InitInterrupts()
        end

        if NCCombat.interrupts[player] == nil then
            NCCombat.interrupts[player] = 0
        end

        return NCCombat.interrupts[player]
    end

    -- Helper for initializing the avoidable damage table
    function NCCombat:InitAvoidableDamage()
        NCCombat.avoidableDamage = {}

        for playerName, data in pairs(core.runtime.groupRoster) do
            NCCombat.avoidableDamage[playerName] = 0
        end

        NCCombat.avoidableDamage[GetMyName()] = 0
    end

    -- Helper for initializing the interrupts table
    function NCCombat:InitInterrupts()
        NCCombat.interrupts = {}

        for playerName, data in pairs(core.runtime.groupRoster) do
            NCCombat.interrupts[playerName] = 0
        end

        NCCombat.interrupts[GetMyName()] = 0
    end
end