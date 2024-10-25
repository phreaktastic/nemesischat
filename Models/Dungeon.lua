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
    local dungeonHandler = core.DungeonHandler
    self:SetLevel(dungeonHandler.keystoneLevel)
    self:SetKeystoneAffixes(dungeonHandler.keystoneAffixes)
    self:SetTimeLimit(dungeonHandler.dungeonTimeLimit)
    self:SetDetailsSegment(DETAILS_SEGMENTID_OVERALL)
    self:UpdateCache()
end

function NCDungeon:FinishCallback(success)
    self:UpdateCache()
end

function NCDungeon:ResetCallback()
    self:SetLevel(0)
    wipe(self.Affixes)
    self.TimeLimit = 0
end

function NCDungeon:GetLevel()
    return (self.Level or 0)
end

function NCDungeon:SetLevel(level)
    self.Level = (level or 0)
end

function NCDungeon:SetKeystoneAffixes(affixes)
    self.Affixes = affixes or {}
end

function NCDungeon:GetKeystoneAffixes()
    return self.Affixes
end

function NCDungeon:GetTimeLimit()
    return self.TimeLimit
end

function NCDungeon:GetTimeLimitString()
    local timeLimit = self:GetTimeLimit()
    local minutes = math.floor(timeLimit / 60)
    local seconds = timeLimit - (minutes * 60)
    return string.format("%02d:%02d", minutes, seconds)
end

function NCDungeon:SetTimeLimit(timeLimit)
    self.TimeLimit = timeLimit or 0
end

function NCDungeon:GetTimeLeft()
    if not self:IsActive() then
        return 0
    end
    return (self:GetStartTime() + self:GetTimeLimit()) - GetTime()
end

function NCDungeon:UpdateCache()
    local backup = self:GetBackup()
    backup.Level = self:GetLevel()
    backup.Affixes = self:GetKeystoneAffixes()
    backup.TimeLimit = self:GetTimeLimit()
    core.db.profile.cache.NCDungeon = backup
    core.db.profile.cache.DungeonRankings = self.Rankings:GetBackup()
end

function NCDungeon:CheckCache()
    local cachedDungeon = core.db.profile.cache.NCDungeon

    if cachedDungeon ~= nil and cachedDungeon ~= {} and cachedDungeon.Identifier and cachedDungeon.Identifier ~= "DUNGEON" then
        if cachedDungeon.backupTime and cachedDungeon.backupTime < GetTime() - 300 then
            self:ClearCache()
        else
            local success, err = pcall(function()
                self:Restore(cachedDungeon)
            end)

            if not success then
                NemesisChat:HandleError("Failed to restore cached dungeon: " .. err)
                self:ClearCache()
                self:Reset()
            end

            if not self:IsActive() then
                NCRuntime:SetLastCompletedDungeon(self)
                NCInfo:Update(true)
            else
                self:RegisterObserver(NCInfo)
                NCInfo:Update()
            end
        end
    end
end

function NCDungeon:ClearCache()
    core.db.profile.cache.NCDungeon = {}
    core.db.profile.cache.NCDungeonTime = 0
    core.db.profile.cache.DungeonRankings = {}
end

function NCDungeon:RestoreCallback(backup)
    -- Restore NCDungeon-specific properties
    self.Level = backup.Level or self.Level
    self.Affixes = backup.Affixes or self.Affixes
    self.TimeLimit = backup.TimeLimit or self.TimeLimit
end
