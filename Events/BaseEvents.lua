-----------------------------------------------------
-- BASE EVENTS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-- Local vars for base events
local inDelve = false
local currentDelveID = nil

local function HandleLeaveDelve()
    if inDelve then  -- Only run if we are currently in a delve
        local delveInfo = C_Delves.GetCurrentDelveInfo()
        if delveInfo and delveInfo.delveID == currentDelveID and not delveInfo.isCompleted then
            NCDungeon:Reset()
        end
        inDelve = false
        currentDelveID = nil
    end
end

-----------------------------------------------------
-- Event handling for Blizzard events
-----------------------------------------------------

function NemesisChat:PLAYER_ENTERING_WORLD()
    NCRuntime:UpdateInitializationTime()
    NemesisChat:InstantiateCore()
    NemesisChat:SilentGroupSync()
    NemesisChat:CheckGroup()
    NCRuntime:ClearPetOwners()
end

function NemesisChat:PLAYER_LEAVING_WORLD()
    NCRuntime:ClearPetOwners()

    HandleLeaveDelve()
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
    local _, _, _, onTime = C_ChallengeMode.GetCompletionInfo()
    NCEvent:Initialize()
    NCDungeon:Finish(onTime)

    NemesisChat:HandleEvent()

    NemesisChat:Report("DUNGEON")
    NCRuntime:ClearPetOwners()
end

function NemesisChat:CHALLENGE_MODE_RESET()
    NCEvent:Initialize()
    NCDungeon:Reset()
    NCRuntime:ClearPetOwners()
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
    -- Group roster events will fire when traversing delves and such, which can cause spam.
    if (NCRuntime:TimeSinceInitialization() < 1) then
        return
    end

    local success, error = pcall(NemesisChat.HandleRosterUpdate, NemesisChat)
    if not success then
        NemesisChat:Print("Error in HandleRosterUpdate:", error)
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

function NemesisChat:ACTIVE_DELVE_DATA_UPDATE()
    local delveInfo = C_Delves.GetCurrentDelveInfo()

    if delveInfo and delveInfo.isInProgress then
        -- Player has started a delve
        inDelve = true
        currentDelveID = delveInfo.delveID
        NCDungeon:Start()
    elseif delveInfo and delveInfo.isCompleted then
        -- Delve is completed normally
        inDelve = false
        NCDungeon:End()
    else
        -- Delve ended or was not completed
        inDelve = false
    end
end

function NemesisChat:ZONE_CHANGED_NEW_AREA()
    HandleLeaveDelve()
end


