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

    BottomTracker = {},

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
            Top = {},
            Bottom = {},
            _segment = {},
        }
        setmetatable(o, self)
        self.__index = self
        self._segment = segment
        return o
    end,

    ---Get the top, bottom, and delta for all metrics
    Calculate = function(self)
        for metricKey, metricVal in pairs(self.METRICS) do
            local topVal = 0
            local botVal = 99999999
            local topPlayer = nil
            local botPlayer = nil

            for playerName, playerData in pairs(NCRuntime:GetGroupRoster()) do
                if (playerData.role ~= "DAMAGER" and metricKey == "DPS") or (playerData.role == "TANK" and metricKey == "Pulls") or (playerData.role == "HEALER" and metricKey == "Offheals") then
                    goto continue
                end

                local val = self._segment:GetStats(playerName, metricKey)

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

                ::continue::
            end
            
            local myName = GetMyName()
            local myVal = self._segment:GetStats(myName, metricKey)

            if myVal > topVal then
                topVal = myVal
                topPlayer = myName
            elseif myVal == topVal then
                topPlayer = myName
            elseif myVal < botVal then
                botVal = myVal
                botPlayer = myName
            elseif myVal == botVal then
                botPlayer = myName
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
                local delta, deltaPercent

                self.Bottom[metricKey].Player = botPlayer
                self.Bottom[metricKey].Value = botVal

                if botVal == 0 then
                    delta = topVal
                    deltaPercent = 100
                else
                    delta = topVal - botVal
                    deltaPercent = math.floor(((topVal - botVal) / topVal) * 10000) / 100
                end

                self.Bottom[metricKey].Delta = delta
                self.Bottom[metricKey].DeltaPercent = deltaPercent
                self.Top[metricKey].Delta = delta
                self.Top[metricKey].DeltaPercent = deltaPercent

                if metricVal then
                    if self.BottomTracker[botPlayer] == nil then
                        self.BottomTracker[botPlayer] = 0
                    end

                    if deltaPercent >= 30 then
                        self.BottomTracker[botPlayer] = self.BottomTracker[botPlayer] + 1
                    end
                else
                    if self.BottomTracker[topPlayer] == nil then
                        self.BottomTracker[topPlayer] = 0
                    end

                    if deltaPercent >= 30 then
                        self.BottomTracker[topPlayer] = self.BottomTracker[topPlayer] + 1
                    end
                end
            end
        end
    end,

    -- Get the lowest performer from the bottom tracker
    GetLowestPerformer = function(self)
        for i = 10, 2, -1 do
            for playerName, playerCount in pairs(self.BottomTracker) do
                if playerCount == i then
                    return playerName
                end
            end
        end
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
}