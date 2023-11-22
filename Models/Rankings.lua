-----------------------------------------------------
-- Rankings
-----------------------------------------------------
-- Gives rankings for the current segment           -
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Core rankings logic
-----------------------------------------------------

NCRankings = {
    -- Top stats
    Top = {
        -- Top affixes
        Affixes = {
            -- Top affixes player
            Player = nil,
            -- Top affixes value
            Value = 0,
        },
        -- Top avoidable damage
        AvoidableDamage = {
            -- Top avoidable damage player
            Player = nil,
            -- Top avoidable damage value
            Value = 0,
        },
        -- Top deaths
        Deaths = {
            -- Top deaths player
            Player = nil,
            -- Top deaths value
            Value = 0,
        },
        -- Top DPS
        DPS = {
            -- Top DPS player
            Player = nil,
            -- Top DPS value
            Value = 0,
        },
        -- Top interrupts
        Interrupts = {
            -- Top interrupts player
            Player = nil,
            -- Top interrupts value
            Value = 0,
        },
        -- Top offheals
        Offheals = {
            -- Top offheals player
            Player = nil,
            -- Top offheals value
            Value = 0,
        },
        -- Top pulls
        Pulls = {
            -- Top pulls player
            Player = nil,
            -- Top pulls value
            Value = 0,
        },
    },
    
    -- Bottom stats
    Bottom = {
        -- Bottom affixes
        Affixes = {
            -- Bottom affixes player
            Player = nil,
            -- Bottom affixes value
            Value = 0,
            -- Delta number
            Delta = 0,
            -- Delta percentage
            DeltaPercent = 0,
        },
        -- Bottom avoidable damage
        AvoidableDamage = {
            -- Bottom avoidable damage player
            Player = nil,
            -- Bottom avoidable damage value
            Value = 0,
            -- Delta number
            Delta = 0,
            -- Delta percentage
            DeltaPercent = 0,
        },
        -- Bottom deaths
        Deaths = {
            -- Bottom deaths player
            Player = nil,
            -- Bottom deaths value
            Value = 0,
            -- Delta number
            Delta = 0,
            -- Delta percentage
            DeltaPercent = 0,
        },
        -- Bottom DPS
        DPS = {
            -- Bottom DPS player
            Player = nil,
            -- Bottom DPS value
            Value = 0,
            -- Delta number
            Delta = 0,
            -- Delta percentage
            DeltaPercent = 0,
        },
        -- Bottom interrupts
        Interrupts = {
            -- Bottom interrupts player
            Player = nil,
            -- Bottom interrupts value
            Value = 0,
            -- Delta number
            Delta = 0,
            -- Delta percentage
            DeltaPercent = 0,
        },
        -- Bottom offheals
        Offheals = {
            -- Bottom offheals player
            Player = nil,
            -- Bottom offheals value
            Value = 0,
            -- Delta number
            Delta = 0,
            -- Delta percentage
            DeltaPercent = 0,
        },
        -- Bottom pulls
        Pulls = {
            -- Bottom pulls player
            Player = nil,
            -- Bottom pulls value
            Value = 0,
            -- Delta number
            Delta = 0,
            -- Delta percentage
            DeltaPercent = 0,
        },
    },

    -- Rankings for all players by metric
    All = {
        Affixes = {},
        AvoidableDamage = {},
        Deaths = {},
        DPS = {},
        Interrupts = {},
        Offheals = {},
        Pulls = {},
    },

    -- Bottom players with scores based on their deltas
    BottomTracker = {},

    -- Top players with scores based on their deltas
    TopTracker = {},

    -- Configuration values
    Configuration = {
        -- The amount to increment a score for good performance / high deltas 
        Increments = {
            BottomInitial = 1,
            TopInitial = 1,
            BottomBreakpoints = {
                [90] = 5,
                [70] = 4,
                [50] = 3,
                [30] = 2,
            },
            BottomBreakpointExclusions = {
                ["Pulls"] = true,
                ["Deaths"] = true,
            },
            TopBreakpoints = {
                [90] = 5,
                [70] = 4,
                [50] = 3,
                [30] = 2,
            },
            TopBreakpointExclusions = {},
            Metrics = {
                DPS = {
                    Healer = 10,
                    Tank = 5,
                },
            },
        },
    },

    --- The segment to get rankings for
    ---@type NCSegment
    _segment = nil,

    -- Metrics to calculate. If true, top is good. If false, bottom is good.
    METRICS = {
        Affixes = true,
        AvoidableDamage = false,
        Deaths = false,
        DPS = true,
        Interrupts = true,
        Offheals = true,
        Pulls = false,
    },

    ---Instantiate a new Rankings object
    ---@param segment NCSegment Segment to get rankings for
    ---@return NCRankings
    New = function(self, segment)
        local o = {
            Top = DeepCopy(self.Top),
            Bottom = DeepCopy(self.Bottom),
            BottomTracker = {},
            _segment = segment,
        }
        setmetatable(o, self)
        self.__index = self
        return o
    end,

    ---Get the top, bottom, and delta for all metrics
    Calculate = function(self)
        for metricKey, metricVal in pairs(self.METRICS) do
            local topVal = 0
            local botVal = 99999999
            local topPlayer = nil
            local botPlayer = nil
            local myRole = GetRole()
            local myName = GetMyName()

            for playerName, playerData in pairs(NCRuntime:GetGroupRoster()) do
                topVal, botVal, topPlayer, botPlayer = self:_SetTopBottom(metricKey, playerData.role, playerName, topVal, botVal, topPlayer, botPlayer)

                self.All[metricKey][playerName] = self._segment:GetStats(playerName, metricKey) or 0
            end

            if topVal == 0 then
                topPlayer = nil
            end

            if botVal == 99999999 then
                botPlayer = nil
            end

            if topPlayer ~= nil then
                self.Top[metricKey].Player = topPlayer
                self.Top[metricKey].Value = topVal
            end

            if botPlayer ~= nil and topPlayer ~= nil then
                -- order[1] is the lowest value's key, order[#order] is the highest value's key
                local order = GetKeysSortedByValue(self.All[metricKey], function(a, b) return a < b end)

                local topDelta, topDeltaPercent, bottomDelta, bottomDeltaPercent

                self.Bottom[metricKey].Player = botPlayer
                self.Bottom[metricKey].Value = botVal

                if botVal == 0 then
                    topDelta = topVal
                    topDeltaPercent = 100
                    bottomDelta = topVal
                    bottomDeltaPercent = 100
                else
                    topDelta = topVal - self.All[metricKey][order[#order-1]]
                    topDeltaPercent = math.floor((topDelta / topVal) * 10000) / 100
                    bottomDelta = self.All[metricKey][order[2]] - botVal
                    bottomDeltaPercent = math.floor((bottomDelta / botVal) * 10000) / 100
                end

                self.Bottom[metricKey].Delta = bottomDelta
                self.Bottom[metricKey].DeltaPercent = bottomDeltaPercent
                self.Top[metricKey].Delta = topDelta
                self.Top[metricKey].DeltaPercent = topDeltaPercent

                local topIncrement, bottomIncrement = self.Configuration.Increments.TopInitial, self.Configuration.Increments.BottomInitial

                if not self.Configuration.Increments.BottomBreakpointExclusions[metricKey] then
                    for _, key in ipairs(GetKeysSortedByValue(self.Configuration.Increments.TopBreakpoints, function(a, b) return a > b end)) do
                        local percent = tonumber(key) or 101
                        local increment = self.Configuration.Increments.TopBreakpoints[key]

                        if bottomDeltaPercent >= percent then
                            bottomIncrement = increment
                        end
                    end
                end

                if not self.Configuration.Increments.TopBreakpointExclusions[metricKey] then
                    for _, key in ipairs(GetKeysSortedByValue(self.Configuration.Increments.TopBreakpoints, function(a, b) return a > b end)) do
                        local percent = tonumber(key) or 101
                        local increment = self.Configuration.Increments.TopBreakpoints[key]

                        if topDeltaPercent >= percent then
                            topIncrement = increment
                        end
                    end
                end

                if metricKey == "DPS" and botVal < self._segment:GetStats(NCRuntime:GetGroupHealer(), "DPS") then
                    bottomIncrement = bottomIncrement + self.Configuration.Increments.Metrics.DPS.Healer
                elseif metricKey == "DPS" and botVal < self._segment:GetStats(NCRuntime:GetGroupTank(), "DPS") then
                    bottomIncrement = bottomIncrement + self.Configuration.Increments.Metrics.DPS.Tank
                end

                if metricVal then
                    if self.BottomTracker[botPlayer] == nil then
                        self.BottomTracker[botPlayer] = bottomIncrement
                    else 
                        self.BottomTracker[botPlayer] = self.BottomTracker[botPlayer] + bottomIncrement
                    end

                    if self.TopTracker[topPlayer] == nil then
                        self.TopTracker[topPlayer] = topIncrement
                    else
                        self.TopTracker[topPlayer] = self.TopTracker[topPlayer] + topIncrement
                    end
                else
                    if self.BottomTracker[topPlayer] == nil then
                        self.BottomTracker[topPlayer] = topIncrement
                    else
                        self.BottomTracker[topPlayer] = self.BottomTracker[topPlayer] + topIncrement
                    end

                    if self.TopTracker[botPlayer] == nil then
                        self.TopTracker[botPlayer] = bottomIncrement
                    else
                        self.TopTracker[botPlayer] = self.TopTracker[botPlayer] + bottomIncrement
                    end
                end
            end
        end
    end,

    -- Get the lowest performer from the bottom tracker
    GetLowestPerformer = function(self)
        local players = GetKeysSortedByValue(self.BottomTracker, function(a, b) return a < b end)

        return players[1], self.BottomTracker[players[1]]
    end,

    -- Get the highest performer from the top tracker
    GetHighestPerformer = function(self)
        local players = GetKeysSortedByValue(self.TopTracker, function(a, b) return a > b end)

        return players[1], self.TopTracker[players[1]]
    end,

    -- Get all metrics for a player, looking in self.Top if the metric value is true, and self.Bottom if it is false. 
    -- Returns the metric names for all metrics where playerName exists.
    GetPlayerMetrics = function(self, playerName)
        local metrics = {}

        for metricKey, metricVal in pairs(self.METRICS) do
            if not metricVal then
                if self.Top[metricKey].Player == playerName then
                    table.insert(metrics, metricKey)
                end
            else
                if self.Bottom[metricKey].Player == playerName then
                    table.insert(metrics, metricKey)
                end
            end
        end

        -- Return metrics
        return metrics
    end,

    _SetTopBottom = function(self, metricKey, playerRole, playerName, topVal, botVal, topPlayer, botPlayer)
        if not metricKey or not playerRole or not playerName then
            return topVal, botVal, topPlayer, botPlayer
        end

        if (playerRole ~= "DAMAGER" and metricKey == "DPS") or (playerRole == "TANK" and metricKey == "Pulls") or (playerRole == "HEALER" and metricKey == "Offheals") or playerName == nil then
            return topVal, botVal, topPlayer, botPlayer
        end

        local val = self._segment:GetStats(playerName, metricKey) or 0

        if type(val) == "number" then
            if val > topVal then
                topVal = val
                topPlayer = playerName
            elseif val == topVal then
                topPlayer = playerName
            elseif val < botVal then
                botVal = val
                botPlayer = playerName
            elseif val == botVal then
                botPlayer = playerName
            end
        end

        return topVal, botVal, topPlayer, botPlayer
    end,
}