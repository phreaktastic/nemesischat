-----------------------------------------------------
-- BASE EVENTS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsGroupLeader = UnitIsGroupLeader
local IsInRaid = IsInRaid
local UnitGUID = UnitGUID

-----------------------------------------------------
-- Event handling for Blizzard events
-----------------------------------------------------

function NemesisChat:PLAYER_ENTERING_WORLD()
    NemesisChat:InstantiateCore()
    NemesisChat:SilentGroupSync()
    NemesisChat:CheckGroup()
end

function NemesisChat:COMBAT_LOG_EVENT_UNFILTERED()
    NemesisChat:PopulateCombatEventDetails()
end

function NemesisChat:CHALLENGE_MODE_START()
    NemesisChat:CheckGroup()
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
    NCEvent:Initialize()
    NemesisChat:PopulateFriends()

    local joins,leaves = NemesisChat:GetRosterDelta()

    -- We left, or the last player left the group leaving us solo
    if #leaves > 0 and #leaves == NCRuntime:GetGroupRosterCountOthers() then
        NCRuntime:ClearGroupRoster()
        NemesisChat:CheckGroup()

        -- To be monitored. We want data on the last group we ran with, and if we get kicked with this in place it is lost.
        --NCSegment:GlobalReset()
    -- We joined, or we invited someone to form a group
    elseif NCRuntime:GetGroupRosterCountOthers() == 0 and #joins > 0 then
        NCRuntime:ClearGroupRoster()
        NCSegment:GlobalReset()
        local members = NemesisChat:GetPlayersInGroup()
        local isLeader = UnitIsGroupLeader(GetMyName())

        for key,val in pairs(members) do
            if val ~= nil and val ~= GetMyName() then
                local player = NCRuntime:AddGroupRosterPlayer(val)

                -- We're the leader, fire off some join events
                if isLeader then
                    -- Imagine inviting a large group to a raid, we don't want to spam the chat
                    if #joins <= 3 then
                        NemesisChat:PLAYER_JOINS_GROUP(val, player.isNemesis)
                    end
                end
            end
        end

        -- We joined, fire off OUR join event
        if not isLeader then
            NemesisChat:PLAYER_JOINS_GROUP(GetMyName(), false)
        end

        NemesisChat:CheckGroup()
    elseif #joins > 0 or #leaves > 0 then
        for key,val in pairs(joins) do
            if val ~= nil and val ~= GetMyName() then
                local player = NCRuntime:AddGroupRosterPlayer(val)

                local leaves = NemesisChat:LeaveCount(player.guid) or 0
                local lowPerforms = NemesisChat:LowPerformerCount(player.guid) or 0
    
                if #joins < 3 then
                    NemesisChat:PLAYER_JOINS_GROUP(val, player.isNemesis)
                end

                local channel = NemesisChat:GetActualChannel("GROUP")

                if leaves > 0 then
                    SendChatMessage("Nemesis Chat: " .. val .. " has bailed on at least " .. leaves .. " groups.", channel)
                end

                if lowPerforms > 0 then
                    SendChatMessage("Nemesis Chat: " .. val .. " has dramatically underperformed at least " .. lowPerforms .. " times.", channel)
                end
            end
        end
    
        for key,val in pairs(leaves) do
            if val ~= nil and val ~= GetMyName() then
                local player = NCRuntime:GetGroupRosterPlayer(val)
    
                if #leaves <= 3 then
                    NemesisChat:PLAYER_LEAVES_GROUP(val, player.isNemesis)
                end

                local timeLeft = NCDungeon:GetTimeLeft()

                if NCDungeon:IsActive() and player.guid ~= nil and NCRuntime:GetGroupRosterCountOthers() == 4 and timeLeft >= 360 and not IsInRaid() and NCDungeon:GetLevel() <= 20 then
                    -- First check if anyone in the party is offline, and if so, report THEM instead of the leaver
                    local offlineName, offlineGuid, leaverGuid, leaverName = nil, nil, nil, nil

                    for oKey,oVal in pairs(NCRuntime:GetGroupRoster()) do
                        if oVal ~= nil and oVal.guid ~= nil and oVal.guid ~= player.guid and not UnitIsConnected(oKey) then
                            offlineName = oKey
                            offlineGuid = oVal.guid
                            break
                        end
                    end

                    if offlineGuid ~= nil then
                        leaverGuid = offlineGuid
                        leaverName = offlineName

                        SendChatMessage("Nemesis Chat: " .. leaverName .. " has disconnected with a dungeon in progress (" .. NemesisChat:GetDuration(timeLeft) .. " left) and has been added to the global leaver DB.", NemesisChat:GetActualChannel("GROUP"))
                    else
                        leaverGuid = player.guid
                        leaverName = val

                        SendChatMessage("Nemesis Chat: " .. leaverName .. " has left the group with a dungeon in progress (" .. NemesisChat:GetDuration(timeLeft) .. " left) and has been added to the global leaver DB.", NemesisChat:GetActualChannel("GROUP"))
                    end

                    self:Print("Added leaver to DB:", leaverName, leaverGuid)
                    NemesisChat:AddLeaver(leaverGuid)
                end
    
                NCRuntime:RemoveGroupRosterPlayer(val)
            end
        end
    end
end

-- We leverage this event for entering combat
function NemesisChat:PLAYER_REGEN_DISABLED()
    NCEvent:Initialize()
    NCCombat:Reset("Combat Segment " .. GetTime(), true)

    NCRuntime:ClearPlayerStates()
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
    NCRuntime:UpdateGroupRosterRoles()
    NemesisChat:CheckGroup()
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
