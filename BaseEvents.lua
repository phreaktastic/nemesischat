-----------------------------------------------------
-- BASE EVENTS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

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
    -- We joined
    elseif NemesisChat:GetLength(core.runtime.groupRoster) == 0 and #joins > 0 then
        core.runtime.groupRoster = {}
        local members = NemesisChat:GetPlayersInGroup()

        for key,val in pairs(members) do
            if val ~= nil then
                local isNemesis = (core.db.profile.nemeses[val] ~= nil)
    
                core.runtime.groupRoster[val] = {
                    isNemesis = isNemesis
                }
            end
        end

        NemesisChat:PLAYER_JOINS_GROUP(GetMyName(), false)
    else
        for key,val in pairs(joins) do
            if val ~= nil then
                local isNemesis = (core.db.profile.nemeses[val] ~= nil)
    
                core.runtime.groupRoster[val] = {
                    isNemesis = isNemesis
                }
    
                NemesisChat:PLAYER_JOINS_GROUP(val, isNemesis)
            end
        end
    
        for key,val in pairs(leaves) do
            if val ~= nil then
                local player = core.runtime.groupRoster[val]
    
                NemesisChat:PLAYER_LEAVES_GROUP(val, player.isNemesis)
    
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
