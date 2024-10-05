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

NCDungeon = NCSegmentPool:Acquire("DUNGEON")

NCDungeon.Level = 0
NCDungeon.Affixes = {}
NCDungeon.TimeLimit = 0

function NCDungeon:StartCallback()
    NCEvent:SetCategory("CHALLENGE")
    NCEvent:SetEvent("START")
    NCEvent:SetTarget("NA")
    NCEvent:RandomNemesis()
    NCEvent:RandomBystander()
    NCDungeon:SetDetailsSegment(DETAILS_SEGMENTID_OVERALL)

    local keystoneLevel, affixIDs, name, timeLimit

    if C_ChallengeMode.IsChallengeModeActive() then
        keystoneLevel, affixIDs = C_ChallengeMode.GetActiveKeystoneInfo()
        name, _, timeLimit = C_ChallengeMode.GetMapUIInfo(C_ChallengeMode.GetActiveChallengeMapID())
    else
        keystoneLevel = 0
        affixIDs = {}
        name = "Unknown"
        timeLimit = 0

        local dName, type, difficultyIndex, difficultyName, maxPlayers,
        dynamicDifficulty, isDynamic, instanceMapId, lfgID = GetInstanceInfo()

        if dName and difficultyName then
            name = dName .. " " .. difficultyName
        end
    end

    NCDungeon:ClearCache()
    NCDungeon:SetIdentifier(name)
    NCDungeon:SetLevel(keystoneLevel)
    NCDungeon:SetKeystoneAffixes(affixIDs)
    NCDungeon:SetTimeLimit(timeLimit)
    NCRuntime:ClearPetOwners()

    NCInfo:Update()
    NCDungeon:UpdateCache()
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

    if NCDungeon and type(NCDungeon.UpdateCache) == "function" then
        NCDungeon:UpdateCache()
    else
        NemesisChat:Print("Error: NCDungeon is not properly initialized in Combat FinishCallback")
    end
end

function NCDungeon:ResetCallback()
    NCDungeon:SetLevel(0)
end

function NCDungeon:GetLevel()
    return (NCDungeon.Level or 0)
end

function NCDungeon:SetLevel(level)
    NCDungeon.Level = (level or 0)
end

function NCDungeon:SetKeystoneAffixes(affixes)
    NCDungeon.Affixes = affixes
end

function NCDungeon:GetKeystoneAffixes()
    return NCDungeon.Affixes
end

function NCDungeon:GetTimeLimit()
    return NCDungeon.TimeLimit
end

function NCDungeon:GetTimeLimitString()
    local timeLimit = NCDungeon:GetTimeLimit()
    local minutes = math.floor(timeLimit / 60)
    local seconds = timeLimit - (minutes * 60)

    return string.format("%02d:%02d", minutes, seconds)
end

function NCDungeon:SetTimeLimit(timeLimit)
    NCDungeon.TimeLimit = timeLimit
end

function NCDungeon:GetTimeLeft()
    if not NCDungeon:IsActive() then
        return 0
    end

    return (NCDungeon:GetStartTime() + NCDungeon:GetTimeLimit()) - GetTime()
end

function NCDungeon:UpdateCache()
    if not NCDungeon then
        NemesisChat:Print("Error: NCDungeon is nil in UpdateCache")
        return
    end

    if core.db.profile.cache.NCDungeon and type(core.db.profile.cache.NCDungeon.Restore) == "function" then
        core.db.profile.cache.NCDungeon:Restore(NCDungeon)
    else
        NCSegmentPool:Release(NCDungeon)
        core.db.profile.cache.NCDungeon = NCSegmentPool:Acquire("DUNGEON")
        if type(core.db.profile.cache.NCDungeon.Restore) == "function" then
            core.db.profile.cache.NCDungeon:Restore(NCDungeon)
        else
            NemesisChat:Print("Error: Restore function not found on cache.NCDungeon")
        end
    end
end

function NCDungeon:CheckCache()
    if core.db.profile.cache.NCDungeon ~= nil and core.db.profile.cache.NCDungeon ~= {} then
        NCDungeon:Restore(core.db.profile.cache.NCDungeon)
    end
end

function NCDungeon:ClearCache()
    core.db.profile.cache.NCDungeon = {}
    core.db.profile.cache.NCDungeonTime = 0
end