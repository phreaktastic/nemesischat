-----------------------------------------------------
-- COMBAT HELPERS
-- Handles combat-related utilities, aura checking, and AI taunts
-----------------------------------------------------
local addonName, core = ...

-----------------------------------------------------
-- Aura Management
-----------------------------------------------------
function NemesisChat:UnitHasAura(unit, auraName, auraType)
    -- Normalize aura type naming
    if string.lower(auraType) == "buff" then
        auraType = "HELPFUL"
    elseif string.lower(auraType) == "debuff" then
        auraType = "HARMFUL"
    end

    -- Find aura and get stack count
    local _, _, count = AuraUtil.FindAuraByName(auraName, unit, auraType)

    -- Return both the existence check and count for detailed usage
    return count ~= nil and tonumber(count) > 0, count
end

-- Convenience wrapper for checking buffs
function NemesisChat:UnitHasBuff(unit, buffName)
    return NemesisChat:UnitHasAura(unit, buffName, "buff")
end

-- Convenience wrapper for checking debuffs
function NemesisChat:UnitHasDebuff(unit, debuffName)
    return NemesisChat:UnitHasAura(unit, debuffName, "debuff")
end

-----------------------------------------------------
-- AI Taunt System
-----------------------------------------------------
function NemesisChat:GetRandomAiPhrase()
    -- Validate taunt path exists
    if not self:ValidateTauntPath() then
        return
    end

    -- Get the pool of available taunts for the current context
    local pool = self:GetTauntPool()
    if not pool then
        return ""
    end

    -- Select and return a random taunt
    local key = math.random(#pool or 5)
    return pool[key]
end

-----------------------------------------------------
-- AI Taunt Helpers
-----------------------------------------------------
function NemesisChat:ValidateTauntPath()
    return core.ai.taunts[NCEvent:GetCategory()] ~= nil and
           core.ai.taunts[NCEvent:GetCategory()][NCEvent:GetEvent()] ~= nil and
           core.ai.taunts[NCEvent:GetCategory()][NCEvent:GetEvent()][NCEvent:GetTarget()] ~= nil
end

function NemesisChat:GetTauntPool()
    return core.ai.taunts[NCEvent:GetCategory()][NCEvent:GetEvent()][NCEvent:GetTarget()]
end
