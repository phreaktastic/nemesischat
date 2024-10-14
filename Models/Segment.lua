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

    -- Rolling points earned by players based on certain actions
    ActionPoints = {},

    -- Affix handler tracker for the segment
    Affixes = {},

    -- Avoidable damage tracker for the segment
    AvoidableDamage = {},

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
    OffHeals = {},

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
        StartTime = 0,
        Success = false,
        TotalTime = 0,
        Wipe = false,
        ActionPoints = {},
        Affixes = {},
        AvoidableDamage = {},
        CrowdControl = {},
        Deaths = {},
        Defensives = {},
        Dispells = {},
        Heals = {},
        Interrupts = {},
        Kills = {},
        OffHeals = {},
        Pulls = {},
        RosterSnapshot = {},
        Observers = {},
        DetailsSegment = DETAILS_SEGMENTID_CURRENT,
    },

    StartPreHook = function(self)
        -- Override me
    end,
    Start = function(self)
        self:Reset()
        self:StartPreHook()
        self.StartTime = GetTime()
        self:SetActive()
        self:StartCallback()
        self.RosterSnapshot = DeepCopy(NCRuntime:GetGroupRoster())
    end,
    StartCallback = function(self)
        -- Override me
    end,
    Finish = function(self, success)
        self.FinishTime = GetTime()
        self.TotalTime = self.FinishTime - self.StartTime
        self.Success = success or false
        self.Wipe = NemesisChat:IsWipe()
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
    AddActionPoints = function(self, amount, player, optDescription)
        if player == nil or amount == nil then
            return
        end

        if self.ActionPoints[player] == nil then
            self.ActionPoints[player] = {}
        end

        table.insert(self.ActionPoints[player], {
            Amount = amount,
            Description = optDescription,
            Timestamp = GetTime()
        })

        self:AddActionPointsCallback(amount, player, optDescription)
    end,
    AddActionPointsCallback = function(self, amount, player, optDescription)
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
    AddAvoidableDamage = function(self, amount, player)
        if player == nil or amount == nil then
            return
        end

        if self.AvoidableDamage[player] == nil then
            self.AvoidableDamage[player] = amount
        else
            self.AvoidableDamage[player] = self.AvoidableDamage[player] + amount
        end

        self.Rankings:UpdateMetric("AvoidableDamage", player, self.AvoidableDamage[player])
        self:NotifyObservers("AvoidableDamage", player, self:GetStats(player, "AvoidableDamage"))
        self:AddAvoidableDamageCallback(amount, player)
    end,
    AddAvoidableDamageCallback = function(self, amount, player)
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
    AddHeals = function(self, amount, source, target)
        if source == nil or amount == nil then
            return
        end

        if self.Heals[source] == nil then
            self.Heals[source] = amount
        else
            self.Heals[source] = self.Heals[source] + amount
        end

        local rosterPlayer = NCRuntime:GetGroupRosterPlayer(source)
        local rosterTarget = NCRuntime:GetGroupRosterPlayer(target)

        -- If the source is not a healer, and the source is not the target, and the target is in the group (ignoring pets and self heals)
        if rosterPlayer ~= nil and rosterPlayer.role ~= "HEALER" and source ~= target and rosterTarget ~= nil then
            self:AddOffHeals(amount, source)
        end

        self:AddHealsCallback(amount, source)
    end,
    AddHealsCallback = function(self, amount, player)
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
    GetOffHeals = function(self, player)
        local offHeals = self.OffHeals or {}
        self.OffHeals = offHeals
        if player then
            local playerOffHeals = offHeals[player] or 0
            offHeals[player] = playerOffHeals
            return playerOffHeals
        end
        return offHeals
    end,
    AddOffHeals = function(self, amount, player)
        if player == nil or amount == nil then
            return
        end

        if self.OffHeals[player] == nil then
            self.OffHeals[player] = amount
        else
            self.OffHeals[player] = self.OffHeals[player] + amount
        end

        self.Rankings:UpdateMetric("OffHeals", player, self.OffHeals[player])
        self:NotifyObservers("Offheals", player, self:GetStats(player, "Offheals"))
        self:AddOffHealsCallback(amount, player)
    end,
    AddOffHealsCallback = function(self, amount, player)
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

        if metric == "DPS" then
            return self:GetDps(playerName)
        elseif metric == "Affixes" then
            return self:GetAffixes(playerName)
        elseif metric == "AvoidableDamage" then
            return self:GetAvoidableDamage(playerName)
        elseif metric == "CrowdControl" then
            return self:GetCrowdControls(playerName)
        elseif metric == "Deaths" then
            return self:GetDeaths(playerName)
        elseif metric == "Defensives" then
            return self:GetDefensives(playerName)
        elseif metric == "Dispells" then
            return self:GetDispells(playerName)
        elseif metric == "Interrupts" then
            return self:GetInterrupts(playerName)
        elseif metric == "Offheals" then
            return self:GetOffHeals(playerName)
        elseif metric == "Pulls" then
            return self:GetPulls(playerName)
        end

        return 0
    end,
    GetDps = function(self, playerName)
        if Details == nil or NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() == false or NCDetailsAPI == nil or NCDetailsAPI.GetDPS == nil then
            return 0
        end

        return NCDetailsAPI:GetDPS(playerName, self:GetDetailsSegment())
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
        for _, segment in ipairs(self.ActiveSegments) do
            segment:AddActionPoints(amount, player, optDescription)
        end
    end,
    GlobalAddAffix = function(self, player, optCount)
        if not player then return end
        for _, segment in ipairs(self.ActiveSegments) do
            segment:AddAffix(player, optCount)
        end
    end,
    GlobalAddAvoidableDamage = function(self, amount, player)
        if not player or not amount then return end
        for _, segment in ipairs(self.ActiveSegments) do
            segment:AddAvoidableDamage(amount, player)
        end
    end,
    GlobalAddCrowdControl = function(self, player)
        if not player then return end
        for _, segment in ipairs(self.ActiveSegments) do
            segment:AddCrowdControl(player)
        end
    end,
    GlobalAddDeath = function(self, player)
        if not player then return end
        for _, segment in ipairs(self.ActiveSegments) do
            segment:AddDeath(player)
        end
    end,
    GlobalAddDefensive = function(self, player)
        if not player then return end
        for _, segment in ipairs(self.ActiveSegments) do
            segment:AddDefensive(player)
        end
    end,
    GlobalAddDispell = function(self, player)
        if not player then return end
        for _, segment in ipairs(self.ActiveSegments) do
            segment:AddDispell(player)
        end
    end,
    GlobalAddHeals = function(self, amount, source, target)
        if not source or not amount then return end
        for _, segment in ipairs(self.ActiveSegments) do
            segment:AddHeals(amount, source, target)
        end
    end,
    GlobalAddInterrupt = function(self, player)
        if not player then return end

        for _, segment in ipairs(self.ActiveSegments) do
            segment:AddInterrupt(player)
        end
    end,
    GlobalAddKill = function(self, player)
        if not player then return end
        for _, segment in ipairs(self.ActiveSegments) do
            segment:AddKill(player)
        end
    end,
    GlobalAddPull = function(self, player)
        if not player then return end
        for _, segment in ipairs(self.ActiveSegments) do
            segment:AddPull(player)
        end
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
                    wipe(self[key])  -- Clear existing table
                else
                    self[key] = {}   -- Create new table if it doesn't exist
                end
            else
                self[key] = defaultValue  -- Reset to default value
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
            self:Start()
        end
    end,
    ResetCallback = function(self, optIdentifier, optStart)
        -- Override me
    end,
    Restore = function(self, backup)
        -- Don't restore the base segment
        if self == NCSegment then
            return
        end

        -- Grab everything from the backup
        for k, v in pairs(backup) do
            if type(v) ~= "function" and not string.find(k, "__") then
                self[k] = v
            end
        end

        if self.Rankings and self.Rankings.Restore then
            self.Rankings:Restore(core.db.profile.cache.DungeonRankings)
        else
            self.Rankings = NCRankings:New(self)
            self.Rankings:Restore(core.db.profile.cache.DungeonRankings)
        end
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
        for _, observer in ipairs(self.Observers) do
            observer:OnStatUpdate(statType, player, value)
        end
    end,
}

