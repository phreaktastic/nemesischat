-----------------------------------------------------
-- BASE EVENTS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local UnitIsGroupLeader = UnitIsGroupLeader
local IsInRaid = IsInRaid
local UnitGUID = UnitGUID

-----------------------------------------------------
-- Event handling for Blizzard events
-----------------------------------------------------

function NemesisChat:PLAYER_ENTERING_WORLD()
    NCRuntime:UpdateInitializationTime()
    NemesisChat:InstantiateCore()
    NCState:SilentGroupSync()
    NCState:GroupStateSubscriptions()
end

function NemesisChat:COMBAT_LOG_EVENT_UNFILTERED()
    NCCombatLogEvent:Fire()
end

function NemesisChat:CHALLENGE_MODE_START()
    NCState:GroupStateSubscriptions()
    NCEvent:Initialize()
    NCDungeon:Reset("M+ Dungeon", true)
    NemesisChat:HandleEvent()
end

function NemesisChat:CHALLENGE_MODE_COMPLETED()
    local _, level, totalTime, onTime = C_ChallengeMode.GetCompletionInfo()
    NCEvent:Initialize()
    NCDungeon:Finish(onTime)

    NemesisChat:HandleEvent()

    NemesisChat:Report("DUNGEON")
end

function NemesisChat:ENCOUNTER_START(_, encounterID, encounterName, difficultyID, groupSize, instanceID)
    NCEvent:Initialize()
    NCBoss:Reset(encounterName, true)
    NemesisChat:HandleEvent()
end

function NemesisChat:ENCOUNTER_END(_, encounterID, encounterName, difficultyID, groupSize, success, fightTime)
    NCEvent:Initialize()
    NCBoss:Finish(success == 1)
    NemesisChat:HandleEvent()
    NemesisChat:Report("BOSS")
end

function NemesisChat:GROUP_ROSTER_UPDATE()
    -- Prevent processing during initialization to avoid spam
    if NCRuntime:TimeSinceInitialization() < 1 then return end

    -- Ensure the player's name is available
    local myName = self:GetMyName()
    if not myName or myName == UNKNOWNOBJECT then
        -- Player's name is not yet available; delay processing
        return
    end

    NCEvent:Initialize()

    -- Get the current group members from NCState
    local currentMembersTable = NCState:GetPlayersInGroup() -- Returns a table keyed by player names
    local currentMembers = {}
    for playerName, _ in pairs(currentMembersTable) do
        table.insert(currentMembers, playerName)
    end

    -- Get the previous group member names from NCState
    local previousMembersTable = NCState:GetGroupPlayers() -- Returns a table of player states keyed by player names
    local previousMembers = {}
    for playerName, _ in pairs(previousMembersTable or {}) do
        table.insert(previousMembers, playerName)
    end

    -- Determine joins and leaves by comparing previous and current group members
    local joins, leaves = self:GetRosterDelta(previousMembers, currentMembers)

    -- Check if we just joined a group (previously solo, now in a group)
    if #previousMembers == 0 and #currentMembers > 0 then
        -- We just joined a group
        self:HandleJoinExistingGroup(currentMembers)
    else
        if #leaves > 0 then
            self:ProcessLeaves(leaves)
        end
        if #joins > 0 then
            self:ProcessJoins(joins)
        end
    end

    -- Update NCState with the current group members
    NCState:UpdateGroupState(currentMembers)
end

--- Handles the scenario when the player joins an existing group.
-- Adds existing group members to NCState without firing join events for them.
-- Fires a join event only for the player themselves.
-- @param members A table of current group member names.
function NemesisChat:HandleJoinExistingGroup(members)
    NCState:ClearGroup()
    NCSegment:GlobalReset()

    -- Add existing group members to NCState without firing events
    for _, playerName in pairs(members) do
        NCState:AddPlayerToGroup(playerName)
    end

    -- Fire a join event for ourselves
    self:PLAYER_JOINS_GROUP(self:GetMyName(), false)
end

function NemesisChat:HandleGroupDisband()
    NCState:ClearGroup()
    NCState:GroupStateSubscriptions()
end

function NemesisChat:HandleNewGroupFormation(joins)
    NCState:ClearGroup()
    NCSegment:GlobalReset()

    local isLeader = UnitIsGroupLeader(GetMyName())
    local members = NCState:GetPlayersInGroup()

    for _, playerName in pairs(members) do
        if playerName ~= GetMyName() then
            local player = NCState:AddPlayerToGroup(playerName)
            if isLeader and #joins <= 3 and player then self:PLAYER_JOINS_GROUP(playerName, player.isNemesis) end
        end
    end

    if not isLeader then
        self:PLAYER_JOINS_GROUP(GetMyName(), false)
    end

    NCState:GroupStateSubscriptions()
end

function NemesisChat:ProcessJoins(joins)
    local maxMessages = 3
    local myName = self:GetMyName()

    if not myName then
        -- Player's name is not available; delay processing
        return
    end

    for _, playerName in pairs(joins) do
        if playerName ~= myName then
            local player = NCState:AddPlayerToGroup(playerName)
            if player then
                local baseName = Ambiguate(playerName, "short") -- Strips realm name
                if #joins <= maxMessages then
                    self:PLAYER_JOINS_GROUP(baseName, player.isNemesis)
                end
                self:ReportPlayerStatsOnJoin(player)
            end
        else
            -- It is us -- we should never hit this
        end
    end
end

--- Processes players who have left the group.
-- Fires leave events for each player who has left.
-- @param leaves A table of player names who have left.
function NemesisChat:ProcessLeaves(leaves)
    local maxMessages = 3

    for _, playerName in pairs(leaves) do
        if playerName ~= self:GetMyName() then
            local player = NCState:GetPlayerState(playerName)
            if player then
                local baseName = Ambiguate(playerName, "short") -- Strips realm name
                if #leaves <= maxMessages then
                    self:PLAYER_LEAVES_GROUP(baseName, player.isNemesis)
                end
                -- Additional logic for handling leavers can be added here
            end
            NCState:RemovePlayerFromGroup(playerName)
        else
            -- Handle if needed when the player is yourself
        end
    end
end

function NemesisChat:ReportPlayerStatsOnJoin(player)
    local leaves = self:LeaveCount(player.guid) or 0
    local lowPerforms = self:LowPerformerCount(player.guid) or 0
    local channel = self:GetActualChannel("GROUP")

    if leaves > (NCConfig:GetReportingLeaversOnJoinThreshold() or 0) and NCConfig:IsReportingLeaversOnJoin() then
        SendChatMessage("Nemesis Chat: " .. player.name .. " has bailed on at least " .. leaves .. " groups.", channel)
    end

    if lowPerforms > (NCConfig:GetReportingLowPerformersOnJoinThreshold() or 0) and NCConfig:IsReportingLowPerformersOnJoin() then
        SendChatMessage("Nemesis Chat: " .. player.name .. " has dramatically underperformed at least " .. lowPerforms .. " times.", channel)
    end
end

function NemesisChat:HandleLeaver(playerName, player)
    if not player or not player.guid then return end

    local timeLeft = NCDungeon:GetTimeLeft()
    local groupSizeOthers = NCState:GetGroupSizeOthers()

    if NCDungeon:IsActive() and groupSizeOthers == 4 and timeLeft >= 360 and not IsInRaid() and NCDungeon:GetLevel() <= 20 then
        local leaverGuid, leaverName = player.guid, playerName

        for oName, oPlayer in pairs(NCState:GetGroupPlayers()) do
            if oPlayer.guid ~= leaverGuid and not UnitIsConnected(oName) then
                leaverGuid = oPlayer.guid
                leaverName = oName
                break
            end
        end

        if NCConfig:IsTrackingLeavers() then
            local status = (leaverGuid ~= player.guid) and "disconnected" or "left the group"
            local msg = string.format("Nemesis Chat: %s has %s with a dungeon in progress (%s left) and has been added to the global leaver DB.", leaverName, status, self:GetDuration(timeLeft))
            SendChatMessage(msg, self:GetActualChannel("GROUP"))
            self:Print("Added leaver to DB:", leaverName, leaverGuid)
        end

        self:AddLeaver(leaverGuid)
    end
end

-- We leverage this event for entering combat
function NemesisChat:PLAYER_REGEN_DISABLED()
    NCEvent:Initialize()
    NCCombat:Reset("Combat Segment " .. GetTime(), true)

    NemesisChat:HandleEvent()
end

-- We leverage this event for exiting combat
function NemesisChat:PLAYER_REGEN_ENABLED()
    NCEvent:Initialize()
    NCCombat:Finish()

    NemesisChat:HandleEvent()

    NemesisChat:Report("COMBAT")
end

function NemesisChat:PLAYER_ROLES_ASSIGNED()
    NCEvent:Initialize()
    NCState:UpdateAllPlayerRoles()
    NCState:GroupStateSubscriptions()
end

function NemesisChat:CHAT_MSG_ADDON(_, prefix, payload, distribution, sender)
    NemesisChat:OnCommReceived(prefix, payload, distribution, sender)
end

function NemesisChat:UNIT_SPELLCAST_START(_, unitTarget, castGUID, spellID)
    if not IsInInstance() then
        return
    end

    local casterName = UnitName(unitTarget)

    if not core.affixMobsCastersLookup[casterName] then
        return
    end

    if NCConfig:IsReportingAffixes_CastStart() and UnitIsEnemy("player", unitTarget) then
        SendChatMessage("Nemesis Chat: " .. casterName .. " is casting!", "YELL")
    end
end

function NemesisChat:UNIT_SPELLCAST_SUCCEEDED(_, unitTarget, castGUID, spellID)
    if not IsInInstance() then
        return
    end

    local casterName = UnitName(unitTarget)

    if not core.affixMobsCastersLookup[casterName] then
        return
    end

    if NCConfig:IsReportingAffixes_CastSuccess() and UnitIsEnemy("player", unitTarget) then
        SendChatMessage("Nemesis Chat: " .. casterName .. " successfully cast!", "YELL")
    end
end

function NemesisChat:UNIT_SPELLCAST_INTERRUPTED(_, unitId, spellName, rank, lineId, spellId)
    if not IsInInstance() then
        return
    end

    local casterName = UnitName(unitId)

    if not core.affixMobsCastersLookup[casterName] then
        return
    end

    local castInterruptedGuid = UnitGUID(unitId)

    if NCConfig:IsReportingAffixes_CastFailed() and not UnitIsUnconscious(castInterruptedGuid) and not UnitIsDead(castInterruptedGuid) then
        SendChatMessage("Nemesis Chat: " .. casterName .. " cast interrupted, but not incapacitated/dead!", "YELL")
    end
end

function NemesisChat:PLAYER_TARGET_CHANGED(_, unitTarget)
    if not IsInInstance() then
        return
    end

    local targetName = UnitName("target")

    if not targetName or not core.affixMobsCastersLookup[targetName] or UnitIsDead("player") or not core.db.profile.reportConfig["AFFIXES"]["MARKERS"] then
        return
    end

    local configMarker = core.db.profile.reportConfig["AFFIXES"]["MARKER"] or 5
    local marker = core.markers[configMarker]

    SetRaidTarget("target", marker.index)
    SendChatMessage(string.format("Nemesis Chat: I am currently handling {%s} %s {%s}!", marker.value, marker.name, marker.value), NemesisChat:GetActualChannel("GROUP"))
end

function NemesisChat:UNIT_CONNECTION(unitID, hasConnected)
    -- Check if the unit is part of your party or raid
    if UnitInParty(unitID) or UnitInRaid(unitID) then
        local playerName = UnitName(unitID)
        if not hasConnected then
            print(NCColors:Emphasize("Nemesis Chat: " .. playerName .. " has disconnected."))
            -- Add your logic here for when a player disconnects
        else
            print(NCColors:Emphasize("Nemesis Chat: " .. playerName .. " has reconnected."))
            -- Add your logic here for when a player reconnects
        end
    end
end

function NemesisChat:BN_FRIEND_INFO_CHANGED(_, index)
    NCState:PopulateFriends()
end

function NemesisChat:OnCommReceived(prefix, payload, distribution, sender)
    NCSync:OnCommReceived(prefix, payload, distribution, sender)
end
