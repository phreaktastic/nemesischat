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

    core.runtime.pulledUnits = {}
end