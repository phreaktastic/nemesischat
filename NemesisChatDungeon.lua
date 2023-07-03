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

function NemesisChat:InstantiateDungeon()
    function NCDungeon:Initialize()
        NCDungeon = DeepCopy(core.runtimeDefaults.ncDungeon)

        NemesisChat:InstantiateDungeon()
    end

    function NCDungeon:IsActive()
        return NCDungeon.active
    end

    function NCDungeon:SetActive()
        NCDungeon.active = true
    end

    function NCDungeon:SetInactive()
        NCDungeon.active = false
    end

    function NCDungeon:GetLevel()
        return NCDungeon.level
    end

    function NCDungeon:SetLevel(level)
        NCDungeon.level = level
    end

    function NCDungeon:GetStartTime()
        return NCDungeon.startTime
    end

    function NCDungeon:SetStartTime(startTime)
        NCDungeon.startTime = startTime
    end

    function NCDungeon:GetEndTime()
        return NCDungeon.endTime
    end

    function NCDungeon:SetEndTime(endTime)
        NCDungeon.endTime = endTime
    end

    function NCDungeon:GetTotalTime()
        return NCDungeon.totalTime
    end

    function NCDungeon:SetTotalTime(totalTime)
        NCDungeon.totalTime = totalTime
    end

    function NCDungeon:IsComplete()
        return NCDungeon.complete
    end

    function NCDungeon:SetComplete(complete)
        NCDungeon.complete = complete
    end

    function NCDungeon:IsSuccess()
        return NCDungeon.success
    end

    function NCDungeon:SetSuccess(success)
        NCDungeon.success = success
    end

    function NCDungeon:GetDeathCounter()
        return NCDungeon.deathCounter
    end

    function NCDungeon:IncrementDeaths(player)
        if NCDungeon.deathCounter[player] == nil then
            NCDungeon.deathCounter[player] = 0
        end

        NCDungeon.deathCounter[player] = NCDungeon.deathCounter[player] + 1
    end

    function NCDungeon:GetDeaths(player)
        if NCDungeon.deathCounter[player] == nil then
            return 0
        end

        return NCDungeon.deathCounter[player]
    end

    function NCDungeon:GetKillCounter()
        return NCDungeon.killCounter
    end

    function NCDungeon:IncrementKills(player)
        if NCDungeon.killCounter[player] == nil then
            NCDungeon.killCounter[player] = 0
        end

        NCDungeon.killCounter[player] = NCDungeon.killCounter[player] + 1
    end

    function NCDungeon:GetKills(player)
        return NCDungeon.killCounter[player]
    end

    -- Helper for a dungeon start event
    function NCDungeon:Start()
        local level, _, _ = C_ChallengeMode.GetActiveKeystoneInfo()
        
        NCDungeon:Initialize()
        NCDungeon:InitAvoidableDamage()
        NCDungeon:SetLevel(level)
        NCDungeon:SetStartTime(GetTime())
        NCDungeon:SetActive()

        NCEvent:StartChallenge()

        core.runtime.NCDungeon = NCDungeon
    end

    -- Helper for initializing the avoidable damage table
    function NCDungeon:InitAvoidableDamage()
        local dungeon = core.runtime.NCDungeon

        dungeon.avoidableDamage = {}

        for playerName, data in pairs(core.runtime.groupRoster) do
            dungeon.avoidableDamage[playerName] = 0
        end

        dungeon.avoidableDamage[core.runtime.myName] = 0
    end

    -- Helper for a dungeon end event
    function NCDungeon:End()
        local _, level, totalTime, onTime = C_ChallengeMode.GetCompletionInfo()

        NCDungeon:SetInactive()
        NCDungeon:SetComplete(true)
        NCDungeon:SetEndTime(GetTime())
        NCDungeon:SetSuccess(onTime)
        NCDungeon:SetTotalTime(totalTime)

        NCEvent:EndChallenge(onTime)

        core.runtime.NCDungeon = nil
    end

    -- Adding avoidable damage for a player
    function NCDungeon:AddAvoidableDamage(damage, dest)
        if core.runtime.NCDungeon.avoidableDamage[dest] == nil then
            core.runtime.NCDungeon.avoidableDamage[dest] = damage
        else
            core.runtime.NCDungeon.avoidableDamage[dest] = core.runtime.NCDungeon.avoidableDamage[dest] + damage
        end
    end

    -- Get avoidable damage for a player
    function NCDungeon:GetAvoidableDamage(player)
        if core.runtime.NCDungeon.avoidableDamage == nil or core.runtime.NCDungeon.avoidableDamage[player] == nil then
            return 0
        end

        return core.runtime.NCDungeon.avoidableDamage[player]
    end
end
