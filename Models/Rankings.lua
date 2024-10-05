-----------------------------------------------------
-- RANKINGS
-----------------------------------------------------
-- Namespaces
local _, core = ...;

NCRankings = {
    METRICS = {
        AvoidableDamage = false,
        CrowdControl = true,
        Deaths = false,
        Defensives = true,
        Dispells = true,
        DPS = true,
        Interrupts = true,
        Offheals = true,
        Pulls = false,
    },

    template = {
        Top = {},
        Bottom = {},
        All = {},
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
        Interrupts = { TANK = true, HEALER = false, DAMAGER = true },
        Offheals = { TANK = true, HEALER = false, DAMAGER = true },
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
            o.Top[metricKey] = {Player = nil, Value = 0, Delta = 0, DeltaPercent = 0}
            o.Bottom[metricKey] = {Player = nil, Value = 99999999, Delta = 0, DeltaPercent = 0}
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

            self.Top[metricKey] = {Player = nil, Value = 0, Delta = 0, DeltaPercent = 0}
            self.Bottom[metricKey] = {Player = nil, Value = 99999999, Delta = 0, DeltaPercent = 0}
        end

        self._segment = segment
    end,

    UpdateMetric = function(self, metricKey, playerName, newValue)
        local metric = self.All[metricKey]
        local oldValue = metric[playerName]
        metric[playerName] = newValue

        self:UpdateSortedList(metricKey, playerName, oldValue, newValue)
        self.cache[metricKey] = nil
        self.lastUpdateTime[metricKey] = GetTime()
    end,

    UpdateSortedList = function(self, metricKey, playerName, oldValue, newValue)
        local sorted = self.sortedPlayers[metricKey]
        local playerIndex = nil

        for i, player in ipairs(sorted) do
            if player.name == playerName then
                playerIndex = i
                player.value = newValue
                break
            end
        end

        if not playerIndex then
            table.insert(sorted, {name = playerName, value = newValue})
            playerIndex = #sorted
        end

        -- Simple bubble sort for the affected player
        local i = playerIndex
        if self.METRICS[metricKey] then
            while i > 1 and sorted[i].value > sorted[i-1].value do
                sorted[i], sorted[i-1] = sorted[i-1], sorted[i]
                i = i - 1
            end
            while i < #sorted and sorted[i].value < sorted[i+1].value do
                sorted[i], sorted[i+1] = sorted[i+1], sorted[i]
                i = i + 1
            end
        else
            while i > 1 and sorted[i].value < sorted[i-1].value do
                sorted[i], sorted[i-1] = sorted[i-1], sorted[i]
                i = i - 1
            end
            while i < #sorted and sorted[i].value > sorted[i+1].value do
                sorted[i], sorted[i+1] = sorted[i+1], sorted[i]
                i = i + 1
            end
        end
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
            self:RecalculateMetric(metricKey)
        end
    end,

    RecalculateMetric = function(self, metricKey)
        local topPlayer, topValue = self:GetTopPlayer(metricKey)
        local bottomPlayer, bottomValue = self:GetBottomPlayer(metricKey)

        if topPlayer then
            self.Top[metricKey].Player = topPlayer
            self.Top[metricKey].Value = topValue
        end

        if bottomPlayer then
            self.Bottom[metricKey].Player = bottomPlayer
            self.Bottom[metricKey].Value = bottomValue
        end

        if topPlayer and bottomPlayer and #self.sortedPlayers[metricKey] > 1 then
            local sorted = self.sortedPlayers[metricKey]
            local secondTop = sorted[2].value
            local secondBottom = sorted[#sorted - 1].value

            local topDelta = topValue - secondTop
            local bottomDelta = secondBottom - bottomValue

            self.Top[metricKey].Delta = topDelta
            self.Bottom[metricKey].Delta = bottomDelta

            if topValue > 0 then
                self.Top[metricKey].DeltaPercent = math.floor((topDelta / topValue) * 10000) / 100
            else
                self.Top[metricKey].DeltaPercent = 0
            end

            if bottomValue > 0 then
                self.Bottom[metricKey].DeltaPercent = math.floor((bottomDelta / bottomValue) * 10000) / 100
            else
                self.Bottom[metricKey].DeltaPercent = 0
            end
        end
    end,

    GetStats = function(self, playerName, metric)
        return self._segment:GetStats(playerName, metric)
    end,

    GetTopPerformer = function(self)
        local topScore = 0
        local topPerformer = nil

        for playerName, _ in pairs(self._segment.RosterSnapshot) do
            local score = 0
            for metricKey, isPositive in pairs(self.METRICS) do
                if isPositive and self.Top[metricKey].Player == playerName then
                    score = score + self.Top[metricKey].DeltaPercent
                elseif not isPositive and self.Bottom[metricKey].Player == playerName then
                    score = score + self.Bottom[metricKey].DeltaPercent
                end
            end
            if score > topScore then
                topScore = score
                topPerformer = playerName
            end
        end

        return topPerformer, topScore
    end,

    GetBottomPerformer = function(self)
        local bottomScore = 0
        local bottomPerformer = nil

        for playerName, _ in pairs(self._segment.RosterSnapshot) do
            local score = 0
            for metricKey, isPositive in pairs(self.METRICS) do
                if isPositive and self.Bottom[metricKey].Player == playerName then
                    score = score + self.Bottom[metricKey].DeltaPercent
                elseif not isPositive and self.Top[metricKey].Player == playerName then
                    score = score + self.Top[metricKey].DeltaPercent
                end
            end
            if score > bottomScore then
                bottomScore = score
                bottomPerformer = playerName
            end
        end

        return bottomPerformer, bottomScore
    end,

    IsMetricApplicable = function(self, metricKey, playerName)
        local playerRole

        if self._segment and self._segment.RosterSnapshot and self._segment.RosterSnapshot[playerName] then
            playerRole = self._segment.RosterSnapshot[playerName].role
        else
            -- Fallback to current roster
            local rosterPlayer = NCRuntime:GetGroupRosterPlayer(playerName)
            playerRole = rosterPlayer and rosterPlayer.role or UnitGroupRolesAssigned(playerName)
        end

        -- If not in a group, assume all metrics are applicable
        if not IsInGroup() then
            return true
        end

        -- If we couldn't determine the role, assume the metric is applicable
        if not playerRole then
            return true
        end

        return self.METRIC_APPLICABILITY[metricKey][playerRole] or false
    end
}