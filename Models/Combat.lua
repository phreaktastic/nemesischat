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

    NCDungeon:ClearTempCombatTime()
    NCDungeon:AddCombatTime(self:GetTotalTime())

    core.runtime.pulledUnits = GetWeakTable()

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

function NCCombat:AddDamageCallback(unit, amount)
    local tempCombatTime = GetTime() - self:GetStartTime()
    core.EventSystem:Publish("COMBAT_DAMAGE", unit, amount, tempCombatTime)
end
