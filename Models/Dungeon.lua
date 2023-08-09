-----------------------------------------------------
-- DUNGEON
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Dungeon getters, setters, etc.
-----------------------------------------------------

NCDungeon = NCSegment:New()

NCDungeon.Level = 0

function NCDungeon:StartCallback()
    NCEvent:SetCategory("CHALLENGE")
    NCEvent:SetEvent("START")
    NCEvent:SetTarget("NA")
    NCEvent:RandomNemesis()
    NCEvent:RandomBystander()

    core.runtime.NCDungeon = NCDungeon
end

function NCDungeon:FinishCallback(success)
    NCEvent:SetCategory("CHALLENGE")
    NCEvent:SetEvent("FAIL")
    NCEvent:SetTarget("NA")
    NCEvent:RandomNemesis()
    NCEvent:RandomBystander()

    if success then
        NCEvent:SetEvent("SUCCESS")
    end

    core.runtime.NCDungeon = nil
end

function NCDungeon:ResetCallback()
    NCDungeon.Level = 0
end

function NCDungeon:GetLevel()
    return NCDungeon.Level
end

function NCDungeon:SetLevel(level)
    NCDungeon.Level = level
end

function NCDungeon:AddAvoidableDamageCallback()
    core.runtime.NCDungeon = NCDungeon
end

function NCDungeon:AddDeathCallback()
    core.runtime.NCDungeon = NCDungeon
end

function NCDungeon:AddHealsCallback()
    core.runtime.NCDungeon = NCDungeon
end

function NCDungeon:AddOffHealsCallback()
    core.runtime.NCDungeon = NCDungeon
end

function NCDungeon:AddInterruptCallback()
    core.runtime.NCDungeon = NCDungeon
end

function NCDungeon:AddKillCallback()
    core.runtime.NCDungeon = NCDungeon
end