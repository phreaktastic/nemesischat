-----------------------------------------------------
-- COMBAT
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local AuraUtil = AuraUtil

-----------------------------------------------------
-- Event getters, setters, and helper methods
-----------------------------------------------------

NCCombat = NCSegment:New()

function NCCombat:StartCallback()
    NCEvent:SetCategory("COMBATLOG")
    NCEvent:SetEvent("COMBAT_START")
    NCEvent:SetTarget("NA")
    NCEvent:RandomNemesis()
    NCEvent:RandomBystander()
end

function NCCombat:FinishCallback()
    NCEvent:SetCategory("COMBATLOG")
    NCEvent:SetEvent("COMBAT_END")
    NCEvent:SetTarget("NA")
    NCEvent:RandomNemesis()
    NCEvent:RandomBystander()

    if NCDungeon:IsActive() then
        NCCombat:AnnounceAffixAuras()
    end

    core.runtime.pulledUnits = {}
end

function NCCombat:AnnounceAffixAuras()
    for _, auraData in pairs(core.affixMobsAuras) do
        for playerName, playerData in pairs(NCRuntime:GetGroupRoster()) do
            local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = AuraUtil.FindAuraByName(auraData.spellName, playerName, "HARMFUL")

            if count >= auraData.highStacks then
                SendChatMessage("Nemesis Chat: " .. auraData.name .. " is at " .. count .. " stacks -- please wait to pull more mobs!", "PARTY")

                return
            end
        end
    end
end