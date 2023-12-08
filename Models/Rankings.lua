-----------------------------------------------------
-- Rankings
-----------------------------------------------------
-- Gives rankings for the current segment           -
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local LGIST = LibStub:GetLibrary("LibGroupInSpecT-1.1")

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
    -- Bottom players' score explanations
    BottomScores = {},

    -- Top players with scores based on their deltas
    TopTracker = {},
    -- Top players' score explanations
    TopScores = {},

    -- Configuration values
    Configuration = {
        -- The amount to increment a score for good performance / high deltas 
        Increments = {
            BottomInitial = 1,
            TopInitial = 1,
            Metrics = {
                Affixes = {
                    IsIncludedCallback = function(self, player)
                        return true
                    end,
                    AdditiveCallback = function(self, topPlayer, botPlayer, topVal, botVal)
                        return (topVal - botVal), (topVal - botVal)
                    end,
                },
                AvoidableDamage = {
                    TopDeltaBreakpoints = {
                        [200] = 20,
                        [100] = 10,
                    },
                    BottomDeltaBreakpoints = {
                        [200] = 3,
                        [100] = 2,
                        [50] = 1,
                    },
                    IsIncludedCallback = function(self, player)
                        return true
                    end,
                    AdditiveCallback = function(self, topPlayer, botPlayer, topVal, botVal)
                        return 0
                    end,
                },
                Deaths = {
                    IsIncludedCallback = function(self, player)
                        return true
                    end,
                    AdditiveCallback = function(self, topPlayer, botPlayer, topVal, botVal)
                        return (topVal - botVal), (topVal - botVal) * 2
                    end,
                },
                DPS = {
                    TopDeltaBreakpoints = {
                        [50] = 20,
                        [30] = 10,
                    },
                    BottomDeltaBreakpoints = {
                        [50] = 20,
                        [30] = 10,
                    },
                    IsIncludedCallback = function(self, player)
                        return GetRole(player) == "DAMAGER"
                    end,
                    AdditiveCallback = function(self, topPlayer, botPlayer, topVal, botVal)
                        local topItemLevel = NemesisChat:GetItemLevel(topPlayer)
                        local bottomItemLevel = NemesisChat:GetItemLevel(botPlayer)

                        local addTop = 0
                        local addBot = 0

                        local order = nil
                        local secondItemLevel = nil

                        -- Add the difference between the top player and the second player's item level
                        if not topItemLevel or not bottomItemLevel then
                            addBot = 0
                            addTop = 0
                        else
                            addBot = math.abs(topItemLevel - bottomItemLevel)
                            addTop = math.abs(topItemLevel - bottomItemLevel)
                        end

                        -- If the bot player's DPS is lower than the tank or healer, they're dramatically underperforming
                        if botVal < self._segment:GetStats(NCRuntime:GetGroupHealer(), "DPS") then
                            addBot = addBot + self.Configuration.Increments.Metrics.DPS.Healer

                            -- Add the scores for explanation on top / bottom placement(s)
                            if self.BottomScores[botPlayer] == nil then
                                self.BottomScores[botPlayer] = {
                                    ["DPS < Healer"] = addBot,
                                }
                            else
                                self.BottomScores[botPlayer]["DPS < Healer"] = addBot
                            end
                        elseif botVal < self._segment:GetStats(NCRuntime:GetGroupTank(), "DPS") then
                            addBot = addBot + self.Configuration.Increments.Metrics.DPS.Tank

                            -- Add the scores for explanation on top / bottom placement(s)
                            if self.BottomScores[botPlayer] == nil then
                                self.BottomScores[botPlayer] = {
                                    ["DPS < Tank"] = addBot,
                                }
                            else
                                self.BottomScores[botPlayer]["DPS < Tank"] = addBot
                            end
                        end

                        if self.All and self.All["DPS"] then
                            order = GetKeysSortedByValue(self.All["DPS"], function(a, b) return a < b end)
                            secondItemLevel = NemesisChat:GetItemLevel(order[#order-1]) or 0
                        end

                        -- If the second player's item level is higher than the top player's, add scores
                        if secondItemLevel and topItemLevel and secondItemLevel > topItemLevel then
                            -- The top player is seemingly overperforming
                            addTop = addTop + 10

                            -- The second player is seemingly underperforming
                            if self.BottomTracker[order[#order-1]] == nil then
                                self.BottomTracker[order[#order-1]] = 10
                            else
                                self.BottomTracker[order[#order-1]] = self.BottomTracker[order[#order-1]] + 10
                            end

                            -- Add the scores for explanation on top / bottom placement(s)
                            if self.BottomScores[order[#order-1]] == nil then
                                self.BottomScores[order[#order-1]] = {
                                    ["iLvl " .. secondItemLevel .. " DPS < iLvl " .. topItemLevel .. " DPS"] = 10,
                                }
                            else
                                self.BottomScores[order[#order-1]]["iLvl " .. secondItemLevel .. " DPS < iLvl " .. topItemLevel .. " DPS"] = 10
                            end

                            -- Deduct from the top player's BottomTracker score
                            if self.BottomTracker[topPlayer] ~= nil then
                                if self.BottomTracker[topPlayer] < 10 then
                                    self.BottomTracker[topPlayer] = nil
                                else
                                    self.BottomTracker[topPlayer] = self.BottomTracker[topPlayer] - 10
                                end
                            end
                        end

                        return addTop, addBot
                    end,
                },
                Interrupts = {
                    TopDeltaBreakpoints = {
                        [50] = 3,
                        [30] = 2,
                    },
                    BottomDeltaBreakpoints = {
                        [50] = 5,
                        [30] = 3,
                    },
                    IsIncludedCallback = function(self, player)
                        local _, classId = UnitClassBase(player)

                        -- Warlock and Druid are forgiven for not interrupting
                        return classId ~= 9 and classId ~= 11
                    end,
                    AdditiveCallback = function(self, topPlayer, botPlayer, topVal, botVal)
                        return (topVal - botVal), (topVal - botVal)
                    end,
                },
                Offheals = {
                    IsIncludedCallback = function(self, player)
                        -- If the player is a healer, they're forgiven for not offhealing
                        if GetRole(player) == "HEALER" then
                            return false
                        end

                        local _, classId = UnitClassBase(player)

                        -- Only certain classes can offheal
                        -- Paladin, Priest, Shaman, Monk, Druid, Evoker
                        return classId == 2 or classId == 5 or classId == 7 or classId == 10 or classId == 11 or classId == 13
                    end,
                    AdditiveCallback = function(self, topPlayer, botPlayer, topVal, botVal)
                        return (topVal - botVal), (topVal - botVal)
                    end,
                },
                Pulls = {
                    IsIncludedCallback = function(self, player)
                        return true
                    end,
                    AdditiveCallback = function(self, topPlayer, botPlayer, topVal, botVal)
                        return math.floor((topVal - botVal) / 2), math.floor((topVal - botVal) / 2)
                    end,
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
        self.BottomTracker = {}
        self.BottomScores = {}
        self.TopTracker = {}
        self.TopScores = {}

        for metricKey, metricVal in pairs(self.METRICS) do
            local topVal = 0
            local botVal = 99999999
            local topPlayer = nil
            local botPlayer = nil
            local myRole = GetRole()
            local myName = GetMyName()

            for playerName, playerData in pairs(NCRuntime:GetGroupRoster()) do
                self.All[metricKey][playerName] = (self._segment:GetStats(playerName, metricKey) or nil)

                topVal, botVal, topPlayer, botPlayer = self:_SetTopBottom(metricKey, playerData.role, playerName, topVal, botVal, topPlayer, botPlayer)
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
                    -- Deltas are from the top / bottom player to the NEXT player
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

                -- Breakpoint-based increments
                if self.Configuration.Increments.Metrics[metricKey] and self.Configuration.Increments.Metrics[metricKey].IsIncludedCallback(self, topPlayer) then
                    if self.Configuration.Increments.Metrics[metricKey].TopDeltaBreakpoints ~= nil then
                        for _, key in ipairs(GetKeysSortedByValue(self.Configuration.Increments.Metrics[metricKey].TopDeltaBreakpoints, function(a, b) return a > b end)) do
                            local percent = tonumber(key) or 101
                            local increment = self.Configuration.Increments.Metrics[metricKey].TopDeltaBreakpoints[key]
    
                            if topDeltaPercent >= percent then
                                topIncrement = increment
                            end
                        end
                    end

                    if self.Configuration.Increments.Metrics[metricKey].BottomDeltaBreakpoints ~= nil then
                        for _, key in ipairs(GetKeysSortedByValue(self.Configuration.Increments.Metrics[metricKey].BottomDeltaBreakpoints, function(a, b) return a > b end)) do
                            local percent = tonumber(key) or 101
                            local increment = self.Configuration.Increments.Metrics[metricKey].BottomDeltaBreakpoints[key]
    
                            if bottomDeltaPercent >= percent then
                                bottomIncrement = increment
                            end
                        end
                    end
                end

                -- Additive increments
                if self.Configuration.Increments.Metrics[metricKey] and self.Configuration.Increments.Metrics[metricKey].AdditiveCallback then
                    local addTop, addBot = self.Configuration.Increments.Metrics[metricKey].AdditiveCallback(self, topPlayer, botPlayer, topVal, botVal)

                    topIncrement = topIncrement + addTop
                    bottomIncrement = bottomIncrement + addBot
                end

                -- Add the scores for explanation on top / bottom placement(s)
                if self.BottomScores[botPlayer] == nil then
                    self.BottomScores[botPlayer] = {
                        [metricKey] = bottomIncrement,
                    }
                else
                    self.BottomScores[botPlayer][metricKey] = bottomIncrement
                end

                if self.TopScores[topPlayer] == nil then
                    self.TopScores[topPlayer] = {
                        [metricKey] = topIncrement,
                    }
                else
                    self.TopScores[topPlayer][metricKey] = topIncrement
                end

                -- Add players to the top / bottom tracker. If metricVal is true, top is good. If false, bottom is good.
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

                    -- Add the scores for explanation on top / bottom placement(s)
                    if self.BottomScores[botPlayer] == nil then
                        self.BottomScores[botPlayer] = {
                            [metricKey] = bottomIncrement,
                        }
                    else
                        self.BottomScores[botPlayer][metricKey] = bottomIncrement
                    end

                    if self.TopScores[topPlayer] == nil then
                        self.TopScores[topPlayer] = {
                            [metricKey] = topIncrement,
                        }
                    else
                        self.TopScores[topPlayer][metricKey] = topIncrement
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

                    -- Add the scores for explanation on top / bottom placement(s)
                    if self.BottomScores[topPlayer] == nil then
                        self.BottomScores[topPlayer] = {
                            [metricKey] = bottomIncrement,
                        }
                    else
                        self.BottomScores[topPlayer][metricKey] = topIncrement
                    end

                    if self.TopScores[botPlayer] == nil then
                        self.TopScores[botPlayer] = {
                            [metricKey] = topIncrement,
                        }
                    else
                        self.TopScores[botPlayer][metricKey] = bottomIncrement
                    end
                end
            end
        end
    end,

    -- Get the under performer, if there is one
    GetUnderperformer = function(self)
        local players = GetKeysSortedByValue(self.BottomTracker, function(a, b) return a > b end)

        -- If the next lowest performer is within 10 points of the lowest performer, return nil
        if (players[2] ~= nil and self.BottomTracker[players[2]] >= self.BottomTracker[players[1]] - 10) or self.BottomTracker[players[1]] == nil or self.BottomTracker[players[1]] < 10 then
            return nil, nil
        end

        return players[1], self.BottomTracker[players[1]]
    end,

    -- Get the over performer, if there is one
    GetOverperformer = function(self)
        local players = GetKeysSortedByValue(self.TopTracker, function(a, b) return a > b end)

        -- If the next highest performer is within 10 points of the highest performer, return nil
        if (players[2] ~= nil and self.TopTracker[players[2]] >= self.TopTracker[players[1]] - 10) or self.TopTracker[players[1]] == nil or self.TopTracker[players[1]] < 10 then
            return nil, nil
        end

        return players[1], self.TopTracker[players[1]]
    end,

    -- Get the highest performing player (may not be an overperformer) from the TopTracker
    GetHighestPerformingPlayer = function(self)
        if type(self.TopTracker) ~= "table" then
            return nil, nil
        end

        local players = GetKeysSortedByValue(self.TopTracker, function(a, b) return a > b end)

        return players[1], self.TopTracker[players[1]]
    end,

    -- Get the lowest performing player (may not be an underperformer) from the BottomTracker
    GetLowestPerformingPlayer = function(self)
        if type(self.BottomTracker) ~= "table" then
            return nil, nil
        end

        local players = GetKeysSortedByValue(self.BottomTracker, function(a, b) return a > b end)

        return players[1], self.BottomTracker[players[1]]
    end,

    -- Get all (bad) metrics for a player, looking in self.Top if the metric value is true, and self.Bottom if it is false. 
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

        if (playerRole ~= "DAMAGER" and metricKey == "DPS") or (playerRole == "TANK" and metricKey == "Pulls") or (playerRole == "HEALER" and metricKey == "Offheals") then
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