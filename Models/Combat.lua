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

    NCInfo.StatsFrame:Hide()
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

    NCDungeon.Rankings.Calculate(NCDungeon.Rankings)

    NCInfo:Update()

    if NCConfig:ShouldShowInfoFrame() then
        NCInfo.StatsFrame:Show()
    end

    NCRuntime:CacheGroupRoster()
end

function NCCombat:AnnounceAffixAuras()
    if not NCConfig:IsReportingAffixes_AuraStacks() then
        return
    end

    for _, auraData in pairs(core.affixMobsAuras) do
        for playerName, playerData in pairs(NCRuntime:GetGroupRoster()) do
            local _, _, count = AuraUtil.FindAuraByName(auraData.spellName, playerName, "HARMFUL")

            if count ~= nil and tonumber(count) >= auraData.highStacks then
                SendChatMessage("Nemesis Chat: " .. auraData.name .. " is at " .. count .. "+ stacks -- please wait to pull more mobs!", "PARTY")

                return
            end
        end
    end
end