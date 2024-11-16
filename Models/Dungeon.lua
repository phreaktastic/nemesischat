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
NCDungeon.CombatTime = 0
NCDungeon._tempCombatTime = 0

function NCDungeon:StartCallback()
    local dungeonHandler = core.DungeonHandler
    self:SetLevel(dungeonHandler.keystoneLevel)
    self:SetKeystoneAffixes(dungeonHandler.keystoneAffixes)
    self:SetTimeLimit(dungeonHandler.dungeonTimeLimit)
    self:SetDetailsSegment(DETAILS_SEGMENTID_OVERALL)
    self:SnapshotCurrentRoster()
    self:UpdateCache()
    NCInfo:Update()
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
    self.Rankings:RecalculateMetric("DPS")
    local backup = self:GetBackup()
    backup.Level = self:GetLevel()
    backup.Affixes = self:GetKeystoneAffixes()
    backup.TimeLimit = self:GetTimeLimit()
    NCConfig:SetPath("cache.NCDungeon", backup)
    NCConfig:SetPath("cache.DungeonRankings", self.Rankings:GetBackup())
end

function NCDungeon:CheckCache()
    local cachedDungeon = NCConfig:GetPath("cache.NCDungeon")

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
                NCInfo:Update()
            else
                self:RegisterObserver("NCInfo")
                NCInfo:Update()
            end
        end
    end
end

function NCDungeon:ClearCache()
    NCConfig:SetPath("cache.NCDungeon", {})
    NCConfig:SetPath("cache.NCDungeonTime", 0)
    NCConfig:SetPath("cache.DungeonRankings", {})
end

function NCDungeon:RestoreCallback(backup)
    -- Restore NCDungeon-specific properties
    self.Level = backup.Level or self.Level
    self.Affixes = backup.Affixes or self.Affixes
    self.TimeLimit = backup.TimeLimit or self.TimeLimit
end

function NCDungeon:AddCombatTime(time)
    self.CombatTime = (self.CombatTime or 0) + time
end

function NCDungeon:GetCombatTime()
    return self.CombatTime or 0
end

function NCDungeon:ResetCombatTime()
    self.CombatTime = 0
end

function NCDungeon:GetTempCombatTime()
    return self._tempCombatTime or 0
end

function NCDungeon:SetTempCombatTime(time)
    self._tempCombatTime = time or 0
end

function NCDungeon:ClearTempCombatTime()
    self._tempCombatTime = 0
end

function NCDungeon:ResetTempCombatTime()
    self._tempCombatTime = 0
end

function NCDungeon:AddTempCombatTime(time)
    self._tempCombatTime = (self._tempCombatTime or 0) + time
end

function NCDungeon:GetDPS(playerName)
    local combatTime = self:GetCombatTime()
    local tempCombatTime = self:GetTempCombatTime()
    local totalCombatTime = combatTime + tempCombatTime
    local damage = self:GetDamage(playerName)
    return math.floor(damage / totalCombatTime * 100) / 100
end

function NCDungeon:AddAvoidedDamageCallback(amount, playerName)
    NCDungeon.Rankings:RecalculateMetric("AvoidableDamage")
end

-- COMBAT_DAMAGE is a very low priority event which is used to Update
-- the DPS metric for the player. We leverage _tempCombatTime to avoid
-- recalculating the entire combat time for each event, and to avoid
-- attempts at division by zero. When combat ends, _tempCombatTime is
-- cleared and the final DPS value is calculated.
core.EventSystem:RegisterEvent("COMBAT_DAMAGE", function(unit, _, tempCombatTime)
    NCDungeon:SetTempCombatTime(tempCombatTime)
    NCDungeon.Rankings:UpdateMetric("DPS", unit, NCDungeon:GetDPS(unit))
end, 1, { staggered = true, frameDelay = 15 })
