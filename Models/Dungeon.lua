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
    NCRuntime:ClearPetOwners()

    NCDungeon:SetIdentifier(name)
    NCDungeon:SetLevel(keystoneLevel)
    NCDungeon:SetKeystoneAffixes(affixIDs)
    NCDungeon:SetTimeLimit(timeLimit)
    NCDungeon:SnapshotCurrentRoster()

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

    NCDungeon:UpdateCache()
    NCRuntime:ClearPetOwners()
end

function NCDungeon:ResetCallback()
    self:SetLevel(0)
    wipe(self.Affixes)
    self.TimeLimit = 0
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
    core.db.profile.cache.NCDungeon = NCDungeon:GetBackup()
    core.db.profile.cache.DungeonRankings = NCDungeon.Rankings:GetBackup()
end

function NCDungeon:CheckCache()
    local cachedDungeon = core.db.profile.cache.NCDungeon
    if cachedDungeon ~= nil and cachedDungeon ~= {} then
        if cachedDungeon.backupTime and cachedDungeon.backupTime > GetTime() - 300 then
            NCDungeon:Restore(core.db.profile.cache.NCDungeon)
        else
            self:ClearCache()
        end
    end
end

function NCDungeon:ClearCache()
    core.db.profile.cache.NCDungeon = {}
    core.db.profile.cache.NCDungeonTime = 0
    core.db.profile.cache.DungeonRankings = {}
end