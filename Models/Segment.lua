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

    -- Roster snapshot at the beginning of the segment
    RosterSnapshot = {},

    DetailsSegment = DETAILS_SEGMENTID_CURRENT,

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
        self:SetActiveCallback()
    end,
    SetActiveCallback = function(self)
        -- Override me
    end,
    SetInactive = function(self)
        self.Active = false
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
        if player == nil then
            return self.Affixes
        end
        
        if self.Affixes[player] == nil then
            self.Affixes[player] = 0
        end

        return self.Affixes[player]
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
        if player == nil then
            return self.AvoidableDamage
        end
        
        if self.AvoidableDamage[player] == nil then
            self.AvoidableDamage[player] = 0
        end

        return self.AvoidableDamage[player]
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

        self:AddAvoidableDamageCallback(amount, player)
    end,
    AddAvoidableDamageCallback = function(self, amount, player)
        -- Override me
    end,
    GetCrowdControls = function(self, player)
        if player == nil then
            return self.CrowdControl
        end
        
        if self.CrowdControl[player] == nil then
            self.CrowdControl[player] = 0
        end

        return self.CrowdControl[player]
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

        self:AddCrowdControlCallback(player)
    end,
    AddCrowdControlCallback = function(self, player)
        -- Override me
    end,
    GetDeaths = function(self, player)
        if player == nil then
            return self.Deaths
        end
        
        if self.Deaths[player] == nil then
            self.Deaths[player] = 0
        end

        return self.Deaths[player]
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

        self:AddDeathCallback(player)
    end,
    AddDeathCallback = function(self, player)
        -- Override me
    end,
    GetDefensives = function(self, player)
        if player == nil then
            return self.Defensives
        end
        
        if self.Defensives[player] == nil then
            self.Defensives[player] = 0
        end

        return self.Defensives[player]
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

        self:AddDefensiveCallback(player)
    end,
    AddDefensiveCallback = function(self, player)
        -- Override me
    end,
    GetDispells = function(self, player)
        if player == nil then
            return self.Dispells
        end
        
        if self.Dispells[player] == nil then
            self.Dispells[player] = 0
        end

        return self.Dispells[player]
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
        if player == nil then
            return self.Interrupts
        end
        
        if self.Interrupts[player] == nil then
            self.Interrupts[player] = 0
        end

        return self.Interrupts[player]
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

        self:AddInterruptCallback(player)
    end,
    AddInterruptCallback = function(self, player)
        -- Override me
    end,
    GetKills = function(self, player)
        if player == nil then
            return self.Kills
        end
        
        if self.Kills[player] == nil then
            self.Kills[player] = 0
        end

        return self.Kills[player]
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
        if player == nil then
            return self.OffHeals
        end
        
        if self.OffHeals[player] == nil then
            self.OffHeals[player] = 0
        end

        return self.OffHeals[player]
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

        self:AddOffHealsCallback(amount, player)
    end,
    AddOffHealsCallback = function(self, amount, player)
        -- Override me
    end,
    GetPulls = function(self, player)
        if player == nil then
            return self.Pulls
        end
        
        if self.Pulls[player] == nil then
            self.Pulls[player] = 0
        end

        return self.Pulls[player]
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
        if player == nil or amount == nil then
            return
        end

        for _, segment in pairs(NCSegment.Segments) do
            if segment:IsActive() then
                segment:AddActionPoints(amount, player, optDescription)
            end
        end
    end,
    GlobalAddAffix = function(self, player, optCount)
        if player == nil then
            return
        end

        for _, segment in pairs(NCSegment.Segments) do
            if segment:IsActive() then
                segment:AddAffix(player, optCount)
            end
        end
    end,
    GlobalAddAvoidableDamage = function(self, amount, player)
        if player == nil or amount == nil then
            return
        end

        for _, segment in pairs(NCSegment.Segments) do
            if segment:IsActive() then
                segment:AddAvoidableDamage(amount, player)
            end
            
        end
    end,
    GlobalAddCrowdControl = function(self, player)
        if player == nil then
            return
        end

        for _, segment in pairs(NCSegment.Segments) do
            if segment:IsActive() then
                segment:AddCrowdControl(player)
            end
        end
    end,
    GlobalAddDeath = function(self, player)
        if player == nil then
            return
        end

        for _, segment in pairs(NCSegment.Segments) do
            if segment:IsActive() then
                segment:AddDeath(player)
            end
        end
    end,
    GlobalAddDefensive = function(self, player)
        if player == nil then
            return
        end

        for _, segment in pairs(NCSegment.Segments) do
            segment:AddDefensive(player)
        end
    end,
    GlobalAddDispell = function(self, player)
        if player == nil then
            return
        end

        for _, segment in pairs(NCSegment.Segments) do
            segment:AddDispell(player)
        end
    end,
    GlobalAddHeals = function(self, amount, source, target)
        if source == nil or amount == nil then
            return
        end

        for _, segment in pairs(NCSegment.Segments) do
            if segment:IsActive() then
                segment:AddHeals(amount, source, target)
            end
        end
    end,
    GlobalAddInterrupt = function(self, player)
        if player == nil then
            return
        end

        for _, segment in pairs(NCSegment.Segments) do
            if segment:IsActive() then
                segment:AddInterrupt(player)
            end
        end
    end,
    GlobalAddKill = function(self, player)
        if player == nil then
            return
        end

        for _, segment in pairs(NCSegment.Segments) do
            if segment:IsActive() then
                segment:AddKill(player)
            end
        end
    end,
    GlobalAddPull = function(self, player)
        if player == nil then
            return
        end

        for _, segment in pairs(NCSegment.Segments) do
            if segment:IsActive() then
                segment:AddPull(player)
            end
        end
    end,
    GlobalReset = function(self)
        for _, segment in pairs(NCSegment.Segments) do
            segment:Reset()
        end
    end,
    New = function(self, identifier)
        local o = {
            Identifier = identifier,
            Segments = nil,
            Affixes = {},
            AvoidableDamage = {},
            Deaths = {},
            Heals = {},
            Interrupts = {},
            OffHeals = {},
            Pulls = {},
        }
        
        setmetatable(o, self)
        self.__index = self

        o.Rankings = NCRankings:New(o)

        NCSegment.Segments[#NCSegment.Segments + 1] = o

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
        -- Don't reset the base segment
        if self == NCSegment then
            return
        end

        local identifier = optIdentifier or self:GetIdentifier() or ""
        
        -- Don't touch anything that's not inherited
        for k, v in pairs(NCSegment) do
            -- We don't care about maintaining tables, just reset to {}
            if type(v) == "table" and k ~= "Rankings" and not string.find(k, "__") then
                self[k] = {}
            elseif type(v) ~= "function" and k ~= "Rankings" and not string.find(k, "__") then
                self[k] = v
            end
        end

        self.Identifier = identifier
        self.Rankings = NCRankings:New(self)

        self:ResetCallback(optIdentifier, optStart)

        if optStart == true then
            self:Start()
        end
    end,
    ResetCallback = function(self, optIdentifier, optStart)
        -- Override me
    end
}

