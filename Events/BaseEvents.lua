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

function NemesisChat:CHALLENGE_MODE_START(_)
    NCEvent:Initialize()
    NCDungeon:Start()

    NemesisChat:HandleEvent()
end

function NemesisChat:CHALLENGE_MODE_COMPLETED()
    NCEvent:Initialize()
    NCDungeon:End()

    NemesisChat:HandleEvent()

    NemesisChat:Report("DUNGEON")
end

function NemesisChat:ENCOUNTER_START(_, encounterID, encounterName, difficultyID, groupSize, instanceID)
    NCEvent:Initialize()

    NCBoss:Start(encounterName)

    NemesisChat:HandleEvent()
end

function NemesisChat:ENCOUNTER_END(_, encounterID, encounterName, difficultyID, groupSize, success, fightTime)
    NCEvent:Initialize()

    NCBoss:End(success)

    NemesisChat:HandleEvent()

    NemesisChat:Report("BOSS")
end

function NemesisChat:GROUP_ROSTER_UPDATE()
    NCEvent:Initialize()

    local joins,leaves = NemesisChat:GetRosterDelta()

    -- We left
    if #leaves > 0 and #leaves == NemesisChat:GetLength(core.runtime.groupRoster) then
        core.runtime.groupRoster = {}
    -- We joined, or we invited someone to form a group
    elseif NemesisChat:GetLength(core.runtime.groupRoster) == 0 and #joins > 0 then
        core.runtime.groupRoster = {}
        local members = NemesisChat:GetPlayersInGroup()
        local isLeader = UnitIsGroupLeader(GetMyName())

        for key,val in pairs(members) do
            if val ~= nil then
                local isNemesis = (core.db.profile.nemeses[val] ~= nil or (core.runtime.friends[val] ~= nil and core.db.profile.flagFriendsAsNemeses))
    
                core.runtime.groupRoster[val] = {
                    isFriend = (core.runtime.friends[val] ~= nil),
                    isNemesis = isNemesis,
                    role = UnitGroupRolesAssigned(val),
                }

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
                local isNemesis = (core.db.profile.nemeses[val] ~= nil or (core.runtime.friends[val] ~= nil and core.db.profile.flagFriendsAsNemeses))
    
                core.runtime.groupRoster[val] = {
                    isFriend = (core.runtime.friends[val] ~= nil),
                    isNemesis = isNemesis,
                    role = UnitGroupRolesAssigned(val),
                }
    
                if #joins <= 3 then
                    NemesisChat:PLAYER_JOINS_GROUP(val, isNemesis)
                end
            end
        end
    
        for key,val in pairs(leaves) do
            if val ~= nil then
                local player = core.runtime.groupRoster[val]
    
                if #leaves <= 3 then
                    NemesisChat:PLAYER_LEAVES_GROUP(val, player.isNemesis)
                end
    
                core.runtime.groupRoster[val] = nil
            end
        end
    end

    NemesisChat:CheckGroup()
end

-- We leverage this event for entering combat
function NemesisChat:PLAYER_REGEN_DISABLED()
    NCEvent:Initialize()
    NCCombat:Initialize()
    NCCombat:EnterCombat()

    NemesisChat:HandleEvent()
end

-- We leverage this event for exiting combat
function NemesisChat:PLAYER_REGEN_ENABLED()
    NCEvent:Initialize()
    NCCombat:LeaveCombat()

    NemesisChat:HandleEvent()

    NemesisChat:Report("COMBAT")
end
