-----------------------------------------------------
-- BOSS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Boss getters, setters, etc.
-----------------------------------------------------

NCBoss = NCSegmentPool:Acquire("BOSS")

function NCBoss:StartCallback()
    NCEvent:SetCategory("BOSS")
    NCEvent:SetEvent("START")
    NCEvent:SetTarget("NA")
    NCEvent:RandomNemesis()
    NCEvent:RandomBystander()
end

function NCBoss:FinishCallback(success)
    NCEvent:SetCategory("BOSS")
    NCEvent:SetEvent("FAIL")
    NCEvent:SetTarget("NA")
    NCEvent:RandomNemesis()
    NCEvent:RandomBystander()

    if success then
        NCEvent:SetEvent("SUCCESS")
    end
end