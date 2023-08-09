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

NCBoss = NCSegment:New()

function NCBoss:StartCallback()
    NCEvent:SetCategory("BOSS")
    NCEvent:SetEvent("START")
    NCEvent:SetTarget("NA")
    NCEvent:RandomNemesis()
    NCEvent:RandomBystander()

    core.runtime.NCBoss = NCBoss
end

function NCBoss:FinishCallback()
    NCEvent:SetCategory("BOSS")
    NCEvent:SetEvent("FAIL")
    NCEvent:SetTarget("NA")
    NCEvent:RandomNemesis()
    NCEvent:RandomBystander()

    if success then
        NCEvent:SetEvent("SUCCESS")
    end

    core.runtime.NCBoss = nil
end

function NCBoss:ResetCallback()
    core.runtime.NCBoss = nil
end

function NCBoss:AddAvoidableDamageCallback()
    core.runtime.NCBoss = NCBoss
end

function NCBoss:AddDeathCallback()
    core.runtime.NCBoss = NCBoss
end

function NCBoss:AddHealsCallback()
    core.runtime.NCBoss = NCBoss
end

function NCBoss:AddOffHealsCallback()
    core.runtime.NCBoss = NCBoss
end

function NCBoss:AddInterruptCallback()
    core.runtime.NCBoss = NCBoss
end

function NCBoss:AddKillCallback()
    core.runtime.NCBoss = NCBoss
end