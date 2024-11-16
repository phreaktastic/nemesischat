-----------------------------------------------------
-- RANKINGS
-----------------------------------------------------
-- Namespaces
local _, core = ...;

local groupRoster = core.runtime.groupRoster

NCRankings = {
    METRICS = {
        AvoidableDamage = true, -- true means lower is better
        CrowdControl = false,
        Deaths = true,          -- true means lower is better
        Defensives = false,
        Dispells = false,
        DPS = false,
        Interrupts = false,
        Offheals = false,
        Pulls = true, -- true means lower is better
    },

    cache = {},
    sortedPlayers = {},
    lastUpdateTime = {},

    METRIC_APPLICABILITY = {
        AvoidableDamage = { TANK = true, HEALER = true, DAMAGER = true },
        CrowdControl = { TANK = true, HEALER = true, DAMAGER = true },
        Deaths = { TANK = true, HEALER = true, DAMAGER = true },
        Defensives = { TANK = true, HEALER = true, DAMAGER = true },
        Dispells = { TANK = true, HEALER = true, DAMAGER = true },
        DPS = { TANK = false, HEALER = true, DAMAGER = true },
        Interrupts = { TANK = true, HEALER = true, DAMAGER = true },
        Offheals = { TANK = false, HEALER = false, DAMAGER = true },
        Pulls = { TANK = false, HEALER = true, DAMAGER = true },
    },

    -- The segment to get rankings for
    _segment = nil,

    New = function(self, segment)
        local o = {
            Top = {},
            Bottom = {},
            All = {},
            cache = {},
            sortedPlayers = {},
            lastUpdateTime = {},
            _segment = segment,
        }

        -- Initialize template structures
        for metricKey, _ in pairs(self.METRICS) do
            o.Top[metricKey] = { Player = nil, Value = 0, Delta = 0, DeltaPercent = 0 }
            o.Bottom[metricKey] = { Player = nil, Value = 99999999, Delta = 0, DeltaPercent = 0 }
            o.All[metricKey] = {}
            o.sortedPlayers[metricKey] = {}
        end

        setmetatable(o, self)
        self.__index = self

        return o
    end,

    Reset = function(self, segment)
        for metricKey, _ in pairs(self.METRICS) do
            wipe(self.Top[metricKey])
            wipe(self.Bottom[metricKey])
            wipe(self.All[metricKey])
            wipe(self.sortedPlayers[metricKey])
            self.cache[metricKey] = nil
            self.lastUpdateTime[metricKey] = nil

            self.Top[metricKey] = { Player = nil, Value = 0, Delta = 0, DeltaPercent = 0 }
            self.Bottom[metricKey] = { Player = nil, Value = 99999999, Delta = 0, DeltaPercent = 0 }
        end

        self._segment = segment
    end,

    UpdateMetric = function(self, metricKey, playerName, newValue)
        if not self.All[metricKey] then
            self.All[metricKey] = {}
        end
        self.All[metricKey][playerName] = newValue
        self:UpdateSortedList(metricKey)
        self:RecalculateMetric(metricKey)
    end,

    UpdateSortedList = function(self, metricKey)
        local sorted = {}
        local isLowerBetter = self.METRICS[metricKey]

        -- Only include players with valid values and applicable metrics
        for playerName, playerData in pairs(self._segment.RosterSnapshot) do
            local value = self.All[metricKey][playerName] or 0
            if value and type(value) == "number" and self:IsMetricApplicable(metricKey, playerName, nil) then
                table.insert(sorted, { name = playerName, value = value })
            end
        end

        -- Only sort if we have valid entries
        if #sorted > 0 then
            table.sort(sorted, function(a, b)
                if isLowerBetter then
                    return a.value < b.value
                else
                    return a.value > b.value
                end
            end)
        end

        self.sortedPlayers[metricKey] = sorted
    end,

    GetTopPlayer = function(self, metricKey)
        local sorted = self.sortedPlayers[metricKey]
        if sorted and #sorted > 0 then
            return sorted[1].name, sorted[1].value
        end
        return nil, nil
    end,

    GetBottomPlayer = function(self, metricKey)
        local sorted = self.sortedPlayers[metricKey]
        if sorted and #sorted > 0 then
            return sorted[#sorted].name, sorted[#sorted].value
        end
        return nil, nil
    end,

    Calculate = function(self)
        for metricKey, _ in pairs(self.METRICS) do
            self:UpdateSortedList(metricKey)
            self:RecalculateMetric(metricKey)
        end
    end,

    RecalculateMetric = function(self, metricKey)
        local sorted = self.sortedPlayers[metricKey]
        if #sorted < 2 then
            -- Reset the values if we don't have enough valid players
            self.Top[metricKey] = { Player = nil, Value = 0, Delta = 0, DeltaPercent = 0 }
            self.Bottom[metricKey] = { Player = nil, Value = 99999999, Delta = 0, DeltaPercent = 0 }
            return
        end

        local isLowerBetter = self.METRICS[metricKey]
        local bestPlayer = sorted[1]
        local worstPlayer = sorted[#sorted]
        local secondBest = sorted[2]
        local secondWorst = sorted[#sorted - 1]

        self.Top[metricKey] = {
            Player = bestPlayer.name,
            Value = bestPlayer.value,
            Delta = math.abs(bestPlayer.value - secondBest.value),
            DeltaPercent = bestPlayer.value ~= 0 and
                math.abs((bestPlayer.value - secondBest.value) / bestPlayer.value * 100) or 0
        }

        self.Bottom[metricKey] = {
            Player = worstPlayer.name,
            Value = worstPlayer.value,
            Delta = math.abs(worstPlayer.value - secondWorst.value),
            DeltaPercent = worstPlayer.value ~= 0 and
                math.abs((worstPlayer.value - secondWorst.value) / worstPlayer.value * 100) or 0
        }
    end,

    GetStats = function(self, playerName, metric)
        return self._segment:GetStats(playerName, metric)
    end,

    IsMetricApplicable = function(self, metricKey, playerName, dungeonData)
        -- Early validation
        if not metricKey or not playerName or not self.METRIC_APPLICABILITY[metricKey] then
            return false
        end

        local playerRole

        -- Check dungeon data first
        if dungeonData and dungeonData.RosterSnapshot and
           dungeonData.RosterSnapshot[playerName] and
           dungeonData.RosterSnapshot[playerName].role then
            playerRole = dungeonData.RosterSnapshot[playerName].role
        -- Check segment data
        elseif self._segment and self._segment.RosterSnapshot and
               self._segment.RosterSnapshot[playerName] and
               self._segment.RosterSnapshot[playerName].role then
            playerRole = self._segment.RosterSnapshot[playerName].role
        -- Check last completed dungeon
        elseif NCRuntime:GetLastCompletedDungeon() and
               NCRuntime:GetLastCompletedDungeon().RosterSnapshot and
               NCRuntime:GetLastCompletedDungeon().RosterSnapshot[playerName] and
               NCRuntime:GetLastCompletedDungeon().RosterSnapshot[playerName].role then
            playerRole = NCRuntime:GetLastCompletedDungeon().RosterSnapshot[playerName].role
        else
            -- Fallback to current roster or cached roster
            local rosterPlayer = groupRoster[playerName]
            if not rosterPlayer then
                local cachedRoster = NCRuntime:GetRosterCache()
                rosterPlayer = cachedRoster and cachedRoster[playerName]
            end
            playerRole = rosterPlayer and rosterPlayer.role or UnitGroupRolesAssigned(playerName)
        end

        -- If we still couldn't determine the role, default to false
        if not playerRole then
            return false
        end

        return self.METRIC_APPLICABILITY[metricKey][playerRole] or false
    end,

    GetBackup = function(self)
        local backup = {
            Top = {},
            Bottom = {},
            All = {},
            sortedPlayers = {},
            cache = {},
            lastUpdateTime = {},
        }

        for metricKey, _ in pairs(self.METRICS) do
            backup.Top[metricKey] = self.Top[metricKey]
            backup.Bottom[metricKey] = self.Bottom[metricKey]
            backup.All[metricKey] = self.All[metricKey]
            backup.sortedPlayers[metricKey] = self.sortedPlayers[metricKey]
            backup.cache[metricKey] = self.cache[metricKey]
            backup.lastUpdateTime[metricKey] = self.lastUpdateTime[metricKey]
        end

        backup.backupTime = GetTime()

        return backup
    end,

    Restore = function(self)
        local backup = NCConfig:GetPath("cache.DungeonRankings")

        for metricKey, _ in pairs(self.METRICS) do
            self.Top[metricKey] = backup.Top[metricKey]
            self.Bottom[metricKey] = backup.Bottom[metricKey]
            self.All[metricKey] = backup.All[metricKey]
            self.sortedPlayers[metricKey] = backup.sortedPlayers[metricKey]
            self.cache[metricKey] = backup.cache[metricKey]
            self.lastUpdateTime[metricKey] = backup.lastUpdateTime[metricKey]
        end
    end,
}
