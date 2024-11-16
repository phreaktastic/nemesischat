-----------------------------------------------------
-- Segment
-----------------------------------------------------
-- A segment is a timeperiod which can be inherited -
-- and extended. We currently leverage this with:   -
--    - Boss: A boss encounter                      -
--    - Combat: ANY combat segment                  -
--    - Dungeon: A dungeon segment                  -
-----------------------------------------------------
-- Instantiate with:                                -
--   local segment = Segment:New()                  -
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Core segment logic
-----------------------------------------------------

NCSegmentPool = {
    pool = {},
    maxSize = 3,
}

function NCSegmentPool:Acquire(identifier)
    local segment = table.remove(self.pool) or NCSegment:New(identifier)
    segment:Reset(identifier)
    return segment
end

function NCSegmentPool:Release(segment)
    if #self.pool < self.maxSize then
        table.insert(self.pool, segment)
    else
        segment:Destroy()
    end
end

--- @type NCSegment
NCSegment = {
    -- Is this segment active?
    Active = false,

    -- Segment finish time
    FinishTime = 0,

    -- Segment identifier (Dungeon Keystone Level, Boss Name, etc.)
    Identifier = nil,

    -- Segment start time
    StartTime = 0,

    -- Was this segment a success?
    Success = false,

    -- Total segment time
    TotalTime = 0,

    -- Was this segment a wipe?
    Wipe = false,

    -- Time in combat
    CombatTime = 0,

    -- Rolling points earned by players based on certain actions
    ActionPoints = {},

    -- Affix handler tracker for the segment
    Affixes = {},

    -- Avoidable damage tracker for the segment
    AvoidableDamage = {},

    -- Damage tracker for the segment
    Damage = {},

    -- Crowd control tracker for the segment
    CrowdControl = {},

    -- Death tracker for the segment
    Deaths = {},

    -- Defensive tracker for the segment
    Defensives = {},

    -- Dispell tracker for the segment
    Dispells = {},

    -- Heal tracker for the segment
    Heals = {},

    -- Interrupt tracker for the segment
    Interrupts = {},

    -- Kill tracker for the segment
    Kills = {},

    -- Off heal tracker for the segment
    Offheals = {},

    -- Pulls tracker for the segment
    Pulls = {},

    -- Rankings object (NCRankings)
    Rankings = {},

    -- Segment tracker -- array containing all objects which inherited from NCSegment
    Segments = {},

    -- ACTIVE segments, used for processing to alleviate the need for looping
    ActiveSegments = {},

    -- Roster snapshot at the beginning of the segment
    RosterSnapshot = {},

    -- Table of observers, used for notifying observers of stat updates
    Observers = {},

    DetailsSegment = DETAILS_SEGMENTID_CURRENT,

    -- Template for initial state
    template = {
        Active = false,
        FinishTime = 0,
        Identifier = "",
        StartTime = 0,
        Success = false,
        TotalTime = 0,
        Wipe = false,
        CombatTime = 0,
        ActionPoints = {},
        Affixes = {},
        AvoidableDamage = {},
        Damage = {},
        CrowdControl = {},
        Deaths = {},
        Defensives = {},
        Dispells = {},
        Heals = {},
        Interrupts = {},
        Kills = {},
        Offheals = {},
        Pulls = {},
        RosterSnapshot = {},
        Observers = {},
        DetailsSegment = DETAILS_SEGMENTID_CURRENT,
    },

    StartPreHook = function(self)
        -- Override me
    end,
    Start = function(self)
        self:StartPreHook()
        self:Reset()
        self:SetStartParameters()
        self:StartCallback()
        self.RosterSnapshot = DeepCopy(NCRuntime:GetGroupRoster())
    end,
    StartCallback = function(self)
        -- Override me
    end,
    SetStartParameters = function(self)
        self.StartTime = GetTime()
        self:SetActive()
    end,
    Finish = function(self, success)
        self.FinishTime = GetTime()
        self.TotalTime = self.FinishTime - self.StartTime
        self.Success = success or false
        self.Wipe = NemesisChat:IsWipe()

        -- Update DPS rankings before calculating final rankings
        if self.RosterSnapshot then
            for playerName, _ in pairs(self.RosterSnapshot) do
                local dps = self:GetDPS(playerName)
                if dps and dps > 0 then
                    self.Rankings:UpdateMetric("DPS", playerName, dps)
                end
            end
        end

        self:SetInactive()

        if self.Rankings and self.Rankings.Calculate then
            self.Rankings:Calculate()
        end

        self:FinishCallback(success)
    end,
    FinishCallback = function(self, success)
        -- Override me
    end,
    SetActive = function(self)
        self.Active = true

        table.insert(NCSegment.ActiveSegments, self)
        self:SetActiveCallback()
    end,
    SetActiveCallback = function(self)
        -- Override me
    end,
    SetInactive = function(self)
        self.Active = false
        for i, segment in ipairs(NCSegment.ActiveSegments) do
            if segment == self then
                table.remove(NCSegment.ActiveSegments, i)
                break
            end
        end
        self:SetInactiveCallback()
    end,
    SetInactiveCallback = function(self)
        -- Override me
    end,
    IsActive = function(self)
        return self.Active
    end,
    IsInactive = function(self)
        return not self.Active
    end,
    IsSuccess = function(self)
        return self.Success
    end,
    IsWipe = function(self)
        return self.Wipe
    end,
    GetFinishTime = function(self)
        return self.FinishTime
    end,
    GetStartTime = function(self)
        return self.StartTime
    end,
    GetTotalTime = function(self)
        return self.TotalTime
    end,
    GetAffixes = function(self, player)
        local affixes = self.Affixes or {}
        self.Affixes = affixes
        if player then
            local playerAffixes = affixes[player] or 0
            affixes[player] = playerAffixes
            return playerAffixes
        end
        return affixes
    end,
    AddActionPoints = function(self, player, amount, optDescription)
        if player == nil or amount == nil then return end

        if self.ActionPoints[player] == nil then
            self.ActionPoints[player] = {}
        end

        table.insert(self.ActionPoints[player], {
            Amount = amount,
            Description = optDescription,
            Timestamp = GetTime()
        })

        self:AddActionPointsCallback(player, amount, optDescription)
    end,
    AddActionPointsCallback = function(self, player, amount, optDescription)
        -- Override me
    end,
    GetActionPoints = function(self, player)
        if player == nil then
            return self.ActionPoints
        end

        if self.ActionPoints[player] == nil then
            self.ActionPoints[player] = {}
        end

        return self.ActionPoints[player]
    end,
    GetActionPointsAmount = function(self, player)
        if player == nil then
            return 0
        end

        if self.ActionPoints[player] == nil then
            self.ActionPoints[player] = {}
        end

        local amount = 0

        for _, actionPoint in pairs(self.ActionPoints[player]) do
            amount = amount + actionPoint.Amount
        end

        return amount
    end,
    AddAffix = function(self, player, optCount)
        if player == nil then
            return
        end

        if self.Affixes[player] == nil then
            self.Affixes[player] = optCount or 1
        else
            self.Affixes[player] = self.Affixes[player] + (optCount or 1)
        end

        self:AddAffixCallback(player)
    end,
    AddAffixCallback = function(self, player)
        -- Override me
    end,
    GetAvoidableDamage = function(self, player)
        local avoidableDamage = self.AvoidableDamage or {}
        self.AvoidableDamage = avoidableDamage
        if player then
            local playerDamage = avoidableDamage[player] or 0
            avoidableDamage[player] = playerDamage
            return playerDamage
        end
        return avoidableDamage
    end,
    AddAvoidableDamage = function(self, player, amount)
        if player == nil or amount == nil then return end

        if self.AvoidableDamage[player] == nil then
            self.AvoidableDamage[player] = amount
        else
            self.AvoidableDamage[player] = self.AvoidableDamage[player] + amount
        end

        self.Rankings:UpdateMetric("AvoidableDamage", player, self.AvoidableDamage[player])
        self:NotifyObservers("AvoidableDamage", player, self:GetStats(player, "AvoidableDamage"))
        self:AddAvoidableDamageCallback(player, amount)
    end,
    AddAvoidableDamageCallback = function(self, player, amount)
        -- Override me
    end,
    GetDamage = function(self, player)
        local damage = self.Damage or {}
        self.Damage = damage
        if player then
            local playerDamage = damage[player] or 0
            damage[player] = playerDamage
            return playerDamage
        end
        return damage
    end,
    AddDamage = function(self, player, amount)
        if player == nil or amount == nil then return end

        if self.Damage[player] == nil then
            self.Damage[player] = amount
        else
            self.Damage[player] = self.Damage[player] + amount
        end

        self:AddDamageCallback(player, amount)
    end,
    AddDamageCallback = function(self, player, amount)
        -- Override me
    end,
    GetCrowdControls = function(self, player)
        local crowdControl = self.CrowdControl or {}
        self.CrowdControl = crowdControl
        if player then
            local playerCC = crowdControl[player] or 0
            crowdControl[player] = playerCC
            return playerCC
        end
        return crowdControl
    end,
    AddCrowdControl = function(self, player)
        if player == nil then
            return
        end

        if self.CrowdControl[player] == nil then
            self.CrowdControl[player] = 1
        else
            self.CrowdControl[player] = self.CrowdControl[player] + 1
        end

        self.Rankings:UpdateMetric("CrowdControl", player, self.CrowdControl[player])
        self:NotifyObservers("CrowdControl", player, self:GetStats(player, "CrowdControl"))
        self:AddCrowdControlCallback(player)
    end,
    AddCrowdControlCallback = function(self, player)
        -- Override me
    end,
    GetDeaths = function(self, player)
        local deaths = self.Deaths or {}
        self.Deaths = deaths
        if player then
            local playerDeaths = deaths[player] or 0
            deaths[player] = playerDeaths
            return playerDeaths
        end
        return deaths
    end,
    AddDeath = function(self, player)
        if player == nil then
            return
        end

        if self.Deaths[player] == nil then
            self.Deaths[player] = 1
        else
            self.Deaths[player] = self.Deaths[player] + 1
        end

        self.Rankings:UpdateMetric("Deaths", player, self.Deaths[player])
        self:NotifyObservers("Deaths", player, self:GetStats(player, "Deaths"))
        self:AddDeathCallback(player)
    end,
    AddDeathCallback = function(self, player)
        -- Override me
    end,
    GetDefensives = function(self, player)
        local defensives = self.Defensives or {}
        self.Defensives = defensives
        if player then
            local playerDefensives = defensives[player] or 0
            defensives[player] = playerDefensives
            return playerDefensives
        end
        return defensives
    end,
    AddDefensive = function(self, player)
        if player == nil then
            return
        end

        if self.Defensives[player] == nil then
            self.Defensives[player] = 1
        else
            self.Defensives[player] = self.Defensives[player] + 1
        end

        self.Rankings:UpdateMetric("Defensives", player, self.Defensives[player])
        self:NotifyObservers("Defensives", player, self:GetStats(player, "Defensives"))
        self:AddDefensiveCallback(player)
    end,
    AddDefensiveCallback = function(self, player)
        -- Override me
    end,
    GetDispells = function(self, player)
        local dispells = self.Dispells or {}
        self.Dispells = dispells
        if player then
            local playerDispells = dispells[player] or 0
            dispells[player] = playerDispells
            return playerDispells
        end
        return dispells
    end,
    AddDispell = function(self, player)
        if player == nil then
            return
        end

        if self.Dispells[player] == nil then
            self.Dispells[player] = 1
        else
            self.Dispells[player] = self.Dispells[player] + 1
        end

        self.Rankings:UpdateMetric("Dispells", player, self.Dispells[player])
        self:NotifyObservers("Dispells", player, self:GetStats(player, "Dispells"))
        self:AddDispellCallback(player)
    end,
    AddDispellCallback = function(self, player)
        -- Override me
    end,
    GetHeals = function(self, player)
        if player == nil then
            return self.Heals
        end

        if self.Heals[player] == nil then
            self.Heals[player] = 0
        end

        return self.Heals[player]
    end,
    AddHeals = function(self, player, amount, target)
        if player == nil or amount == nil then return end

        if self.Heals[player] == nil then
            self.Heals[player] = amount
        else
            self.Heals[player] = self.Heals[player] + amount
        end

        local rosterPlayer = NCRuntime:GetGroupRosterPlayer(player)
        local rosterTarget = NCRuntime:GetGroupRosterPlayer(target)

        -- If the source is not a healer, and the source is not the target, and the target is in the group (ignoring pets and self heals)
        if rosterPlayer ~= nil and rosterPlayer.role ~= "HEALER" and player ~= target and rosterTarget ~= nil then
            self:AddOffheals(player, amount)
        end

        self:AddHealsCallback(player, amount)
    end,
    AddHealsCallback = function(self, player, amount)
        -- Override me
    end,
    GetIdentifier = function(self)
        if self.Identifier == nil then
            self.Identifier = ""
        end

        return self.Identifier
    end,
    SetIdentifier = function(self, identifier)
        self.Identifier = identifier
    end,
    GetInterrupts = function(self, player)
        local interrupts = self.Interrupts or {}
        self.Interrupts = interrupts
        if player then
            local playerInterrupts = interrupts[player] or 0
            interrupts[player] = playerInterrupts
            return playerInterrupts
        end
        return interrupts
    end,
    AddInterrupt = function(self, player)
        if player == nil then
            return
        end

        if self.Interrupts[player] == nil then
            self.Interrupts[player] = 1
        else
            self.Interrupts[player] = self.Interrupts[player] + 1
        end

        self.Rankings:UpdateMetric("Interrupts", player, self.Interrupts[player])
        self:NotifyObservers("Interrupts", player, self:GetStats(player, "Interrupts"))
        self:AddInterruptCallback(player)
    end,
    AddInterruptCallback = function(self, player)
        -- Override me
    end,
    GetKills = function(self, player)
        local kills = self.Kills or {}
        self.Kills = kills
        if player then
            local playerKills = kills[player] or 0
            kills[player] = playerKills
            return playerKills
        end
        return kills
    end,
    AddKill = function(self, player)
        if player == nil then
            return
        end

        if self.Kills[player] == nil then
            self.Kills[player] = 1
        else
            self.Kills[player] = self.Kills[player] + 1
        end

        self:AddKillCallback(player)
    end,
    AddKillCallback = function(self, player)
        -- Override me
    end,
    GetOffheals = function(self, player)
        local offHeals = self.Offheals or {}
        self.Offheals = offHeals
        if player then
            local playerOffheals = offHeals[player] or 0
            offHeals[player] = playerOffheals
            return playerOffheals
        end
        return offHeals
    end,
    AddOffheals = function(self, player, amount)
        if player == nil or amount == nil then return end

        if self.Offheals[player] == nil then
            self.Offheals[player] = amount
        else
            self.Offheals[player] = self.Offheals[player] + amount
        end

        self.Rankings:UpdateMetric("Offheals", player, self.Offheals[player])
        self:NotifyObservers("Offheals", player, self:GetStats(player, "Offheals"))
        self:AddOffhealsCallback(player, amount)
    end,
    AddOffhealsCallback = function(self, player, amount)
        -- Override me
    end,
    GetPulls = function(self, player)
        local pulls = self.Pulls or {}
        self.Pulls = pulls
        if player then
            local playerPulls = pulls[player] or 0
            pulls[player] = playerPulls
            return playerPulls
        end
        return pulls
    end,
    AddPull = function(self, player)
        if player == nil then
            return
        end

        if self.Pulls[player] == nil then
            self.Pulls[player] = 1
        else
            self.Pulls[player] = self.Pulls[player] + 1
        end

        self.Rankings:UpdateMetric("Pulls", player, self.Pulls[player])
        self:NotifyObservers("Pulls", player, self:GetStats(player, "Pulls"))
        self:AddPullCallback(player)
    end,
    AddPullCallback = function(self, player)
        -- Override me
    end,
    GetStats = function(self, playerName, metric)
        if not playerName then
            playerName = UnitName("player")
        end

        local getter = self["Get" .. metric]
        if type(getter) == "function" then
            local value = getter(self, playerName)
            return type(value) == "number" and value or 0
        end
        return 0
    end,
    GetDPS = function(self, playerName)
        local damage = self:GetDamage(playerName)
        if damage == nil or damage == 0 then
            return 0
        end

        local DPS = math.floor(damage / self:GetTotalTime() * 100) / 100

        return DPS
    end,
    GetDetailsSegment = function(self)
        return self.DetailsSegment
    end,
    SetDetailsSegment = function(self, detailsSegment)
        self.DetailsSegment = detailsSegment
    end,
    GetLowestPerformer = function(self)
        return self.Rankings:GetLowestPerformer()
    end,
    GetHighestPerformer = function(self)
        return self.Rankings:GetHighestPerformer()
    end,
    GlobalAddActionPoints = function(self, amount, player, optDescription)
        if not player or not amount then return end
        core.EventSystem:Publish("SEGMENT_GLOBAL_ADD", "ActionPoints", player, amount, optDescription)
    end,
    GlobalAddAffix = function(self, player, optCount)
        if not player then return end
        core.EventSystem:Publish("SEGMENT_GLOBAL_ADD", "Affix", player, optCount)
    end,
    GlobalAddAvoidableDamage = function(self, amount, player)
        if not player or not amount then return end
        core.EventSystem:Publish("SEGMENT_GLOBAL_ADD", "AvoidableDamage", player, amount)
    end,
    GlobalAddCrowdControl = function(self, player)
        if not player then return end
        core.EventSystem:Publish("SEGMENT_GLOBAL_ADD", "CrowdControl", player)
    end,
    GlobalAddDeath = function(self, player)
        if not player then return end
        core.EventSystem:Publish("SEGMENT_GLOBAL_ADD", "Death", player)
    end,
    GlobalAddDefensive = function(self, player)
        if not player then return end
        core.EventSystem:Publish("SEGMENT_GLOBAL_ADD", "Defensive", player)
    end,
    GlobalAddDamage = function(self, amount, player)
        if not player or not amount then return end
        core.EventSystem:Publish("SEGMENT_GLOBAL_ADD", "Damage", player, amount)
    end,
    GlobalAddDispell = function(self, player)
        if not player then return end
        core.EventSystem:Publish("SEGMENT_GLOBAL_ADD", "Dispell", player)
    end,
    GlobalAddHeals = function(self, amount, source, target)
        if not source or not amount then return end
        core.EventSystem:Publish("SEGMENT_GLOBAL_ADD", "Heals", source, amount, target)
    end,
    GlobalAddInterrupt = function(self, player)
        if not player then return end
        core.EventSystem:Publish("SEGMENT_GLOBAL_ADD", "Interrupt", player)
    end,
    GlobalAddKill = function(self, player)
        if not player then return end
        core.EventSystem:Publish("SEGMENT_GLOBAL_ADD", "Kill", player)
    end,
    GlobalAddPull = function(self, player)
        if not player then return end
        core.EventSystem:Publish("SEGMENT_GLOBAL_ADD", "Pull", player)
    end,
    GlobalReset = function(self)
        if not self.Segments then
            self.Segments = {}
        end
        for _, segment in pairs(self.Segments) do
            if segment and type(segment.Reset) == "function" then
                segment:Reset()
            end
        end
    end,
    GetSegment = function(self, identifier)
        if not self.Segments then
            return nil
        end
        for _, segment in pairs(self.Segments) do
            if segment:GetIdentifier() == identifier then
                return segment
            end
        end
        return nil
    end,
    SnapshotCurrentRoster = function(self)
        self.RosterSnapshot = DeepCopy(NCRuntime:GetGroupRoster())
    end,
    New = function(self, identifier)
        local o = {}

        -- Initialize using the template
        for key, defaultValue in pairs(self.template) do
            if type(defaultValue) == "table" then
                o[key] = {}
            else
                o[key] = defaultValue
            end
        end

        o.Segments = nil
        o.Identifier = identifier
        o.Rankings = NCRankings:New(o)

        setmetatable(o, self)
        self.__index = self

        -- Register single event handler for all global adds
        core.EventSystem:RegisterEvent("SEGMENT_GLOBAL_ADD", function(metric, ...)
            if not o.Active or not metric then return end

            local methodName = "Add" .. metric
            if o[methodName] then
                o[methodName](o, ...)
            end
        end, 5, {
            staggered = true,
            frameDelay = 1
        })

        table.insert(self.Segments, o)
        return o
    end,
    Destroy = function(self)
        -- Don't destroy the base segment
        if self == NCSegment then
            return
        end

        for i, segment in pairs(NCSegment.Segments) do
            if segment == self then
                table.remove(NCSegment.Segments, i)
            end
        end

        self = nil
    end,
    Reset = function(self, optIdentifier, optStart)
        if self == NCSegment then return end

        local identifier = optIdentifier or self:GetIdentifier() or ""

        -- Reset properties using the template
        for key, defaultValue in pairs(self.template) do
            if type(defaultValue) == "table" then
                if self[key] then
                    wipe(self[key]) -- Clear existing table
                else
                    self[key] = {}  -- Create new table if it doesn't exist
                end
            else
                self[key] = defaultValue -- Reset to default value
            end
        end

        self.Identifier = identifier

        -- Reset Rankings without destroying its structure
        if self.Rankings then
            self.Rankings:Reset(self)
        else
            self.Rankings = NCRankings:New(self)
        end

        self:ResetCallback(optIdentifier, optStart)

        if optStart == true then
            self:SetStartParameters()
        end
    end,
    ResetCallback = function(self, optIdentifier, optStart)
        -- Override me
    end,
    Restore = function(self, backup)
        if self == NCSegment then return end

        -- Grab everything from the backup
        for k, v in pairs(backup) do
            if type(v) ~= "function" and not string.find(k, "__") then
                self[k] = v
            end
        end

        if self.Rankings and self.Rankings.Restore then
            self.Rankings:Restore()
        else
            self.Rankings = NCRankings:New(self)
            self.Rankings:Restore()
        end

        if self.Active then
            local inActiveTable = false
            for i, segment in ipairs(NCSegment.ActiveSegments) do
                if segment.Identifier == self.Identifier then
                    table.remove(NCSegment.ActiveSegments, i)
                    table.insert(NCSegment.ActiveSegments, self)
                    inActiveTable = true
                    break
                end
            end

            if not inActiveTable then
                table.insert(NCSegment.ActiveSegments, self)
            end
        end

        self:RestoreCallback(backup)
    end,
    RestoreCallback = function(self, backup)
        -- Override me
    end,
    GetBackup = function(self)
        -- Don't backup the base segment
        if self == NCSegment then
            return nil
        end

        local backup = {}

        for k, v in pairs(self.template) do
            if type(v) ~= "function" and not string.find(k, "__") and k ~= "Rankings" then
                backup[k] = self[k]
            end
        end

        backup.backupTime = GetTime()

        return backup
    end,
    RegisterObserver = function(self, observer)
        if not observer then return end
        if tContains(self.Observers, observer) then return end

        table.insert(self.Observers, observer)
    end,
    UnregisterObserver = function(self, observer)
        for i, obs in ipairs(self.Observers) do
            if obs == observer then
                table.remove(self.Observers, i)
                break
            end
        end
    end,
    NotifyObservers = function(self, statType, player, value)
        for _, observerStr in ipairs(self.Observers) do
            local observer = _G[observerStr]
            if observer and type(observer.OnStatUpdate) == "function" then
                observer:OnStatUpdate(statType, player, value)
            end
        end
    end,
}
