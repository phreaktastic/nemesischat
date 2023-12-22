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
    NemesisChat:CheckGroup()
end

function NemesisChat:COMBAT_LOG_EVENT_UNFILTERED()
    NemesisChat:PopulateCombatEventDetails()
end

function NemesisChat:CHALLENGE_MODE_START()
    NemesisChat:CheckGroup()
    NCEvent:Initialize()
    NCDungeon:Reset("", true)
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

    -- We left
    if #leaves > 0 and #leaves == NCRuntime:GetGroupRosterCountOthers() then
        NCRuntime:ClearGroupRoster()
        NCSegment:GlobalReset()
    -- We joined, or we invited someone to form a group
    elseif NCRuntime:GetGroupRosterCountOthers() == 0 and #joins > 0 then
        NCRuntime:ClearGroupRoster()
        NCSegment:GlobalReset()
        local members = NemesisChat:GetPlayersInGroup()
        local isLeader = UnitIsGroupLeader(GetMyName())

        for key,val in pairs(members) do
            if val ~= nil and val ~= GetMyName() then
                local isInGuild = UnitIsInMyGuild(val) ~= nil
                local isNemesis = (core.db.profile.nemeses[val] ~= nil or (NCRuntime:GetFriend(val) ~= nil and core.db.profile.flagFriendsAsNemeses) or (isInGuild and core.db.profile.flagGuildiesAsNemeses))
    
                local newPlayer = {
                    guid = UnitGUID(val),
                    isGuildmate = isInGuild,
                    isFriend = NCRuntime:IsFriend(val),
                    isNemesis = isNemesis,
                    role = UnitGroupRolesAssigned(val),
                }

                NCRuntime:AddGroupRosterPlayer(val, newPlayer)

                -- We're the leader, fire off some join events
                if isLeader then
                    -- Imagine inviting a large group to a raid, we don't want to spam the chat
                    if #joins <= 3 then
                        NemesisChat:PLAYER_JOINS_GROUP(val, isNemesis)
                    end
                end
            end
        end

        -- We joined, fire off OUR join event
        if not isLeader then
            NemesisChat:PLAYER_JOINS_GROUP(GetMyName(), false)
        end
        
    else
        for key,val in pairs(joins) do
            if val ~= nil and val ~= GetMyName() then
                local isInGuild = UnitIsInMyGuild(val) ~= nil
                local isNemesis = (core.db.profile.nemeses[val] ~= nil or (NCRuntime:GetFriend(val) ~= nil and core.db.profile.flagFriendsAsNemeses) or (isInGuild and core.db.profile.flagGuildiesAsNemeses))
                local unitGuid = UnitGUID(val)
    
                local newPlayer = {
                    guid = unitGuid,
                    isGuildmate = isInGuild,
                    isFriend = NCRuntime:IsFriend(val),
                    isNemesis = isNemesis,
                    role = UnitGroupRolesAssigned(val),
                }

                NCRuntime:AddGroupRosterPlayer(val, newPlayer)

                local leaves = NemesisChat:LeaveCount(unitGuid) or 0
                local lowPerforms = NemesisChat:LowPerformerCount(unitGuid) or 0
    
                if #joins <= 3 then
                    NemesisChat:PLAYER_JOINS_GROUP(val, isNemesis)
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

                if NCDungeon:IsActive() and player.guid ~= nil then
                    self:Print("Added leaver to DB:", val)
                    SendChatMessage("Nemesis Chat: " .. val .. " has left the group with a dungeon in progress, and has been added to the global leaver DB.", NemesisChat:GetActualChannel("GROUP"))
                    NemesisChat:AddLeaver(player.guid)
                end
    
                NCRuntime:RemoveGroupRosterPlayer(val)
            end
        end
    end

    NemesisChat:CheckGroup()
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
    NemesisChat:CheckGroup()
end

function NemesisChat:CHAT_MSG_ADDON(_, prefix, payload, distribution, sender)
    NemesisChat:OnCommReceived(prefix, payload, distribution, sender)
end

function NemesisChat:UNIT_SPELLCAST_START(_, unitTarget, castGUID, spellID)
    local casterName = UnitName(unitTarget)

    if not core.affixMobsCastersLookup[casterName] then
        return
    end

    if NCConfig:IsReportingAffixes_CastStart() then
        SendChatMessage("Nemesis Chat: " .. casterName .. " is casting!", "YELL")
    end
end

function NemesisChat:UNIT_SPELLCAST_SUCCEEDED(_, unitTarget, castGUID, spellID)
    local casterName = UnitName(unitTarget)

    if not core.affixMobsCastersLookup[casterName] then
        return
    end

    if NCConfig:IsReportingAffixes_CastStart() then
        SendChatMessage("Nemesis Chat: " .. casterName .. " successfully cast!", "YELL")
    end
end

function NemesisChat:UNIT_SPELLCAST_INTERRUPTED(_, unitTarget, castGUID, spellID)
    local casterName = UnitName(unitTarget)

    if not core.affixMobsCastersLookup[casterName] then
        return
    end

    local castInterruptedGuid = UnitGUID(unitTarget)
    
    if NCConfig:IsReportingAffixes_CastFailed() and not UnitIsUnconscious(castInterruptedGuid) and not UnitIsDead(castInterruptedGuid) then
        SendChatMessage("Nemesis Chat: " .. casterName .. " cast interrupted, but not incapacitated/dead!", "YELL")
    end
end

function NemesisChat:PLAYER_TARGET_CHANGED(_, unitTarget)
    local targetName = UnitName("target")

    if not targetName or not core.affixMobsCastersLookup[targetName] then
        return
    end

    SetRaidTarget("target", 5)
    SendChatMessage("Nemesis Chat: I am currently handling {moon}MOON{moon}!", NemesisChat:GetActualChannel("GROUP"))
end
