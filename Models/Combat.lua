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

NCCombat = NCSegmentPool:Acquire("COMBAT")

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

    core.runtime.pulledUnits = {}

    if NCDungeon.Rankings.Calculate then
        NCDungeon.Rankings:Calculate()
    end

    if NCConfig:ShouldShowInfoFrame() then
        NCInfo.StatsFrame:Show()
        if NCInfo.IsMinimized then
            NCInfo:ShowMinimized()
        else
            NCInfo:Update()
        end
    end

    NCRuntime:CacheGroupRoster()
    NCDungeon:UpdateCache()
end
