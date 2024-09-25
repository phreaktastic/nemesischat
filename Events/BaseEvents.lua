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
    if NCRuntime:TimeSinceInitialization() <= 1 then return end

    NCEvent:Initialize()

    local joins, leaves = NCState:GetRosterDelta()
    local groupSizeOthers = NCState:GetGroupSizeOthers()
    local numJoins = #joins
    local numLeaves = #leaves

    -- Check if we left the group or everyone else left
    if numLeaves > 0 and numLeaves == groupSizeOthers then
        self:HandleGroupDisband()
    elseif groupSizeOthers == 0 and numJoins > 0 then
        self:HandleNewGroupFormation(joins)
    else
        if numJoins > 0 then self:ProcessJoins(joins) end
        if numLeaves > 0 then self:ProcessLeaves(leaves) end
        NCState:GroupStateSubscriptions()
    end
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
    local isLeader = UnitIsGroupLeader(GetMyName())
    local maxMessages = 3

    for _, playerName in pairs(joins) do
        if playerName ~= GetMyName() then
            local player = NCState:AddPlayerToGroup(playerName)
            if player then
                if #joins <= maxMessages then
                    self:PLAYER_JOINS_GROUP(playerName, player.isNemesis)
                end
                self:ReportPlayerStatsOnJoin(player)
            end
        end
    end

    if not isLeader then
        self:PLAYER_JOINS_GROUP(GetMyName(), false)
    end
end

function NemesisChat:ProcessLeaves(leaves)
    local maxMessages = 3

    for _, playerName in pairs(leaves) do
        if playerName ~= GetMyName() then
            local player = NCState:GetPlayerState(playerName)
            if #leaves <= maxMessages and player then
                self:PLAYER_LEAVES_GROUP(playerName, player.isNemesis)
            end
            self:HandleLeaver(playerName, player)
            NCState:RemovePlayerFromGroup(playerName)
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
