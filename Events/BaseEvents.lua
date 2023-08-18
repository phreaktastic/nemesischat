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
    NCEvent:Initialize()
    NCDungeon:Start()
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
    NCBoss:Finish(success)
    NemesisChat:HandleEvent()
    NemesisChat:Report("BOSS")
end

function NemesisChat:GROUP_ROSTER_UPDATE()
    NCEvent:Initialize()

    local joins,leaves = NemesisChat:GetRosterDelta()

    -- We left
    if #leaves > 0 and #leaves == NemesisChat:GetLength(NCRuntime:GetGroupRoster()) then
        NCRuntime:ClearGroupRoster()
    -- We joined, or we invited someone to form a group
    elseif NemesisChat:GetLength(NCRuntime:GetGroupRoster()) == 0 and #joins > 0 then
        NCRuntime:ClearGroupRoster()
        local members = NemesisChat:GetPlayersInGroup()
        local isLeader = UnitIsGroupLeader(GetMyName())

        for key,val in pairs(members) do
            if val ~= nil then
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
            if val ~= nil then
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
    
                if #joins <= 3 then
                    NemesisChat:PLAYER_JOINS_GROUP(val, isNemesis)
                end
            end
        end
    
        for key,val in pairs(leaves) do
            if val ~= nil then
                local player = NCRuntime:GetGroupRosterPlayer(val)
    
                if #leaves <= 3 then
                    NemesisChat:PLAYER_LEAVES_GROUP(val, player.isNemesis)
                end

                if NCDungeon:IsActive() and player.guid ~= nil then
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
    NCCombat:Reset()
    NCCombat:Start()
    
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
    NemesisChat:CheckGroup()
end

function NemesisChat:CHAT_MSG_ADDON(_, prefix, payload, distribution, sender)
    NemesisChat:OnCommReceived(prefix, payload, distribution, sender)
end
