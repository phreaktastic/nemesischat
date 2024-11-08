-----------------------------------------------------
-- GROUP HELPERS
-----------------------------------------------------
local _, core = ...;
local groupRoster = core.runtime.groupRoster
local UnitIsGroupLeader = UnitIsGroupLeader
local IsInRaid = IsInRaid

-----------------------------------------------------
-- Core Group Roster Management
-----------------------------------------------------
function NemesisChat:HandleRosterUpdate()
    if NCRuntime:IsAcceptedLFG() then
        -- Initialize events and update friends list
        NCEvent:Reset()
        NemesisChat:PopulateFriends()
        NCRuntime:CacheGroupRoster()

        -- Update internal group state
        self:SilentGroupSync()
        NemesisChat:CheckGroup()
        NCController:PreprocessMessages()

        NemesisChat:HandleAcceptedLFG()
        return
    end

    local joins, leaves = NemesisChat:GetRosterDelta()
    local othersCount = NCRuntime:GetGroupRosterCountOthers()

    if #joins == 0 and #leaves == 0 then return end

    -- Initialize events and update friends list
    NCEvent:Reset()
    NemesisChat:PopulateFriends()
    NCRuntime:CacheGroupRoster()

    -- Update internal group state
    self:SilentGroupSync()
    NemesisChat:CheckGroup()
    NCController:PreprocessMessages()

    -- Handle group changes
    if self:IsGroupDisband(leaves, othersCount) then
        self:HandleGroupDisband(leaves)
    elseif self:IsGroupFormation(joins, othersCount) then
        self:HandleGroupFormation(joins)
    else
        self:HandleGeneralGroupChanges(joins, leaves)
    end

    NCInfo:Update()
end

function NemesisChat:HandleAcceptedLFG()
    NCEvent:SetCategory("GROUP")
    NCEvent:SetEvent("LFG_PROPOSAL_SUCCEEDED")
    NCEvent:SetTarget("NA")
    NCEvent:RandomBystander()
    NCEvent:RandomNemesis()

    self:HandleEvent()
end

function NemesisChat:GetPlayersInGroup()
    local plist = setmetatable({}, { __mode = "kv" })

    if IsInRaid() then
        for i = 1, 40 do
            if (UnitName('raid' .. i)) then
                local n, s = UnitName('raid' .. i)
                local playerName = n
                if s then playerName = playerName .. "-" .. s end
                if playerName ~= "Unknown" then
                    plist[playerName] = playerName
                end
            end
        end
    elseif IsInGroup() then
        for i = 1, 5 do
            if (UnitName('party' .. i)) then
                local n, s = UnitName('party' .. i)
                local playerName = n
                if s then playerName = playerName .. "-" .. s end
                if playerName ~= "Unknown" then
                    plist[playerName] = playerName
                end
            end
        end
    end

    return plist
end

-----------------------------------------------------
-- Group State Detection
-----------------------------------------------------
function NemesisChat:IsGroupDisband(leaves, othersCount)
    return #leaves > 0 and #leaves == othersCount
end

function NemesisChat:IsGroupFormation(joins, othersCount)
    return othersCount == 0 and #joins > 0
end

function NemesisChat:IsWipe()
    if not UnitIsDead("player") then return false end

    local players = NemesisChat:GetPlayersInGroup()
    for _, val in pairs(players) do
        if not UnitIsDead(val) then return false end
    end

    return true
end

-----------------------------------------------------
-- Group Change Handlers
-----------------------------------------------------
function NemesisChat:HandleGroupDisband(leaves)
    NCRuntime:ClearGroupRoster()
end

function NemesisChat:HandleGroupFormation(joins)
    if not NCSegment or type(NCSegment.GlobalReset) ~= "function" then return end

    NCSegment:GlobalReset()
    local members = NemesisChat:GetPlayersInGroup()
    local isLeader = UnitIsGroupLeader(GetMyName())

    for _, member in pairs(members) do
        if member and member ~= GetMyName() then
            local player = groupRoster[member]
            if player and isLeader and #joins < 3 then
                NemesisChat:PLAYER_JOINS_GROUP(member, player.isNemesis)
            end
        end
    end

    if not isLeader then
        NemesisChat:PLAYER_JOINS_GROUP(GetMyName(), false)
    end
end

function NemesisChat:HandleGeneralGroupChanges(joins, leaves)
    if #joins > 0 then self:ProcessJoins(joins) end
    if #leaves > 0 then self:ProcessLeaves(leaves) end
    NCRuntime:CacheGroupRoster()
end

-----------------------------------------------------
-- Join/Leave Processing
-----------------------------------------------------
function NemesisChat:ProcessJoins(joins)
    for _, playerName in ipairs(joins) do
        if playerName and playerName ~= GetMyName() then
            local player = groupRoster[playerName] or NCRuntime:AddGroupRosterPlayer(playerName)
            if player then
                local leavesCount = NemesisChat:LeaveCount(player.guid) or 0
                local lowPerforms = NemesisChat:LowPerformerCount(player.guid) or 0

                if #joins < 3 then
                    NemesisChat:PLAYER_JOINS_GROUP(playerName, player.isNemesis)
                end

                self:ReportPlayerStatistics(playerName, leavesCount, lowPerforms)
            end
        end
    end
end

function NemesisChat:ProcessLeaves(leaves)
    for _, playerName in ipairs(leaves) do
        if playerName and playerName ~= GetMyName() then
            local player = groupRoster[playerName] or NCConfig:GetCacheValue("groupRoster." .. playerName)
            if player then
                if #leaves < 3 then
                    NemesisChat:PLAYER_LEAVES_GROUP(playerName, player.isNemesis)
                end
                self:HandleDungeonLeaver(player, playerName)
            end
        end
    end
end

-----------------------------------------------------
-- Utility Functions
-----------------------------------------------------
function NemesisChat:GetRosterDelta()
    local newRoster = NemesisChat:GetPlayersInGroup()
    local oldRoster = NemesisChat:GetRosterPlayersMap()
    local joined, left = {}, {}

    for _, val in pairs(newRoster) do
        if oldRoster[val] == nil and val ~= GetMyName() then
            tinsert(joined, val)
        end
    end

    for _, val in pairs(oldRoster) do
        if newRoster[val] == nil and val ~= GetMyName() then
            tinsert(left, val)
        end
    end

    return joined, left
end

function NemesisChat:GetRosterPlayersMap()
    local players = setmetatable({}, { __mode = "kv" })
    for key in pairs(NCRuntime:GetGroupRoster()) do
        players[key] = key
    end
    return players
end

function NemesisChat:SilentGroupSync()
    NCRuntime:ClearGroupRoster()
    local members = NemesisChat:GetPlayersInGroup()
    for _, val in pairs(members) do
        if val ~= nil and val ~= GetMyName() then
            NCRuntime:AddGroupRosterPlayer(val)
        end
    end
end

function NemesisChat:CheckGroup()
    local isEnabled = IsNCEnabled()
    local hasGroupMembers = NCRuntime:GetGroupRosterCountOthers() > 0
    local shouldSubscribe = isEnabled and hasGroupMembers

    if NCRuntime.lastCheckSubscribe == shouldSubscribe then return end

    NCRuntime.lastCheckSubscribe = shouldSubscribe

    local method = shouldSubscribe and "RegisterEvent" or "UnregisterEvent"
    for _, event in pairs(core.dynamicEvents) do
        NemesisChat[method](NemesisChat, event)
    end
end

-----------------------------------------------------
-- Player Statistics and Reporting
-----------------------------------------------------
function NemesisChat:ReportPlayerStatistics(playerName, leaves, lowPerforms)
    local channel = NemesisChat:GetActualChannel("GROUP")

    if leaves >= (NCConfig:GetReportingLeaversOnJoinThreshold() or 0) and NCConfig:IsReportingLeaversOnJoin() then
        local message = string.format(
            "Nemesis Chat: %s has bailed on at least %d groups.",
            playerName, leaves
        )
        SendChatMessage(message, channel)
    end

    if lowPerforms >= (NCConfig:GetReportingLowPerformersOnJoinThreshold() or 0) and NCConfig:IsReportingLowPerformersOnJoin() then
        local message = string.format(
            "Nemesis Chat: %s has dramatically underperformed at least %d times.",
            playerName, lowPerforms
        )
        SendChatMessage(message, channel)
    end
end

function NemesisChat:HandleDungeonLeaver(player, playerName)
    local timeLeft = NCDungeon:GetTimeLeft()

    if NCDungeon:IsActive() and NCDungeon:GetLevel() > 0 and player.guid
    and NCRuntime:GetGroupRosterCountOthers() == 4
    and timeLeft >= 360 and not IsInRaid() and NCDungeon:GetLevel() <= 10 then
        local minutes = math.floor(timeLeft / 60)
        local seconds = timeLeft - (minutes * 60)
        local timeLeftFormatted = string.format("%02d:%02d", minutes, seconds)

        local leaverGuid, leaverName = self:FindOfflineLeaver(player, playerName)

        if leaverGuid and leaverName and NCConfig:IsTrackingLeavers() then
            NemesisChat:AddLeaver(leaverGuid)
            local message = string.format(
                "Nemesis Chat: %s has disconnected with a dungeon in progress (%s left) and has been added to the global leaver DB.",
                leaverName, timeLeftFormatted
            )
            SendChatMessage(message, "PARTY")
        end
    end
end

function NemesisChat:FindOfflineLeaver(player, playerName)
    for name, info in pairs(NCConfig:GetCacheValue("groupRoster")) do
        if info and info.guid ~= player.guid and not UnitIsConnected(name) then
            return info.guid, name
        end
    end

    if player and player.guid then
        return player.guid, playerName
    end

    return nil, nil
end
