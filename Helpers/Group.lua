-----------------------------------------------------
-- GROUP HELPERS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local UnitIsGroupLeader = UnitIsGroupLeader
local IsInRaid = IsInRaid

-----------------------------------------------------
-- Helpers for group related functionality
-----------------------------------------------------

function NemesisChat:HandleRosterUpdate()
    -- Initialize events and update friends list
    NCEvent:Initialize()
    NemesisChat:PopulateFriends()

    -- Get the changes in the group roster
    local joins, leaves = NemesisChat:GetRosterDelta()
    local othersCount = NCRuntime:GetGroupRosterCountOthers()

    -- Update the internal group roster first
    self:SilentGroupSync()

    -- After updating the roster, handle events based on changes
    if self:IsGroupDisband(leaves, othersCount) then
        self:HandleGroupDisband(leaves)
    elseif self:IsGroupFormation(joins, othersCount) then
        pcall(function()
            self:HandleGroupFormation(joins)
        end)
    else
        self:HandleGeneralGroupChanges(joins, leaves)
    end
end

-- Determines if the group has been disbanded
function NemesisChat:IsGroupDisband(leaves, othersCount)
    return #leaves > 0 and #leaves == othersCount
end

-- Determines if the group is being formed or reformed
function NemesisChat:IsGroupFormation(joins, othersCount)
    return othersCount == 0 and #joins > 0
end

-- Handles the group disband scenario
function NemesisChat:HandleGroupDisband(leaves)
    NCRuntime:ClearGroupRoster()
    NemesisChat:CheckGroup()
    -- Trigger a group disband event
end

-- Handles the group formation scenario
function NemesisChat:HandleGroupFormation(joins)
    -- Ensure NCSegment is properly initialized
    if not NCSegment or type(NCSegment.GlobalReset) ~= "function" then
        self:Print("Error: NCSegment not properly initialized")
        return
    end

    -- Call GlobalReset
    pcall(function()
        NCSegment:GlobalReset()
    end)

    local members = NemesisChat:GetPlayersInGroup()
    local isLeader = UnitIsGroupLeader(GetMyName())

    for _, member in pairs(members) do
        if member and member ~= GetMyName() then
            local player = NCRuntime:GetGroupRosterPlayer(member)
            if player and isLeader then
                if #joins < 3 then
                    NemesisChat:PLAYER_JOINS_GROUP(member, player.isNemesis)
                end
            end
        end
    end

    if not isLeader then
        NemesisChat:PLAYER_JOINS_GROUP(GetMyName(), false)
    end

    NemesisChat:CheckGroup()
end

-- Handles general group changes (joins and leaves)
function NemesisChat:HandleGeneralGroupChanges(joins, leaves)
    if #joins > 0 then
        self:ProcessJoins(joins)
    end

    if #leaves > 0 then
        self:ProcessLeaves(leaves)
    end
end

-- Processes players joining the group
function NemesisChat:ProcessJoins(joins)
    for _, playerName in ipairs(joins) do
        if playerName and playerName ~= GetMyName() then
            local player = NCRuntime:GetGroupRosterPlayer(playerName)
            if not player then
                player = NCRuntime:AddGroupRosterPlayer(playerName)
            end

            if player then
                local leavesCount = NemesisChat:LeaveCount(player.guid) or 0
                local lowPerforms = NemesisChat:LowPerformerCount(player.guid) or 0

                if #joins < 3 then
                    NemesisChat:PLAYER_JOINS_GROUP(playerName, player.isNemesis)
                end

                self:ReportPlayerStatistics(playerName, leavesCount, lowPerforms)
            else
                self:Print("Failed to find player in roster:", playerName)
            end
        end
    end
end

-- Reports statistics about players who joined
function NemesisChat:ReportPlayerStatistics(playerName, leaves, lowPerforms)
    local channel = NemesisChat:GetActualChannel("GROUP")

    if leaves > (NCConfig:GetReportingLeaversOnJoinThreshold() or 0) and NCConfig:IsReportingLeaversOnJoin() then
        local message = string.format(
            "Nemesis Chat: %s has bailed on at least %d groups.",
            playerName, leaves
        )

        SendChatMessage(message, channel)
    end

    if lowPerforms > (NCConfig:GetReportingLowPerformersOnJoinThreshold() or 0) and NCConfig:IsReportingLowPerformersOnJoin() then
        local message = string.format(
            "Nemesis Chat: %s has dramatically underperformed at least %d times.",
            playerName, lowPerforms
        )
        SendChatMessage(message, channel)
    end
end

-- Processes players leaving the group
function NemesisChat:ProcessLeaves(leaves)
    for _, playerName in ipairs(leaves) do
        if playerName and playerName ~= GetMyName() then
            local player = NCRuntime:GetGroupRosterPlayer(playerName)
            if player then
                if #leaves <= 3 then
                    NemesisChat:PLAYER_LEAVES_GROUP(playerName, player.isNemesis)
                end

                self:HandleDungeonLeaver(player, playerName)
            else
                self:Print("Failed to retrieve player from roster:", playerName)
            end
        end
    end
end

-- Handles scenarios where a player leaves during an active dungeon
function NemesisChat:HandleDungeonLeaver(player, playerName)
    local timeLeft = NCDungeon:GetTimeLeft()

    if NCDungeon:IsActive() and NCDungeon:GetLevel() > 0 and player.guid and NCRuntime:GetGroupRosterCountOthers() == 4
       and timeLeft >= 360 and not IsInRaid() and NCDungeon:GetLevel() <= 20 then

        local leaverGuid, leaverName = self:FindOfflineLeaver(player.guid, playerName)

        if leaverGuid and leaverName then
            if NCConfig:IsTrackingLeavers() then
                local message = string.format(
                    "Nemesis Chat: %s has disconnected with a dungeon in progress (%s left) and has been added to the global leaver DB.",
                    leaverName, NemesisChat:GetDuration(timeLeft)
                )
                NemesisChat:TriggerCustomEvent("REPORT_DUNGEON_LEAVER", message, "GROUP")
                NemesisChat:TriggerCustomEvent("ADD_LEAVER_TO_DB", leaverName, leaverGuid)
            end
            NemesisChat:AddLeaver(leaverGuid)
        end
    end
end

-- Finds an offline player in the group to report as the leaver
function NemesisChat:FindOfflineLeaver(excludeGuid, defaultName)
    for name, info in pairs(NCRuntime:GetGroupRoster()) do
        if info and info.guid ~= excludeGuid and not UnitIsConnected(name) then
            return info.guid, name
        end
    end
    return nil, nil
end