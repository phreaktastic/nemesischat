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

    --- The segment to get rankings for
    ---@type NCSegment
    _segment = nil,

    ---@enum metrics
    METRICS = {
        Affixes = 1,
        AvoidableDamage = 2,
        Deaths = 3,
        DPS = 4,
        Interrupts = 5,
        Offheals = 6,
        Pulls = 7,
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

            for playerName, _ in pairs(NCRuntime:GetGroupRoster()) do
                local val

                val = self._segment:GetStats(playerName, metricKey)

                if val > topVal then
                    topVal = val
                    topPlayer = playerName
                elseif val == topVal then
                    topPlayer = topPlayer .. " + " .. playerName
                elseif val < botVal then
                    botVal = val
                    botPlayer = playerName
                end
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
                self.Bottom[metricKey].Player = botPlayer
                self.Bottom[metricKey].Value = botVal
                self.Bottom[metricKey].Delta = topVal - botVal
                self.Bottom[metricKey].DeltaPercent = math.floor((topVal - botVal) / topVal * 100)
            end
        end
    end,

}