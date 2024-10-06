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
        local hasDelve = C_DelvesUI.HasActiveDelve()
        if hasDelve and currentDelveID and not C_DelvesUI.IsEligibleForActiveDelveRewards("player") then
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
    if not IsNCEnabled() then return end
    NCRuntime:UpdateInitializationTime()
    NemesisChat:InstantiateCore()
    NemesisChat:SilentGroupSync()
    NemesisChat:CheckGroup()
    NCRuntime:ClearPetOwners()
end

function NemesisChat:PLAYER_LEAVING_WORLD()
    if not IsNCEnabled() then return end
    NCRuntime:ClearPetOwners()
    HandleLeaveDelve()
end

function NemesisChat:COMBAT_LOG_EVENT_UNFILTERED()
    if not IsNCEnabled() then return end
    NemesisChat:PopulateCombatEventDetails()
end

function NemesisChat:CHALLENGE_MODE_START()
    if not IsNCEnabled() then return end
    NemesisChat:CheckGroup()
    NCEvent:Initialize()
    NCDungeon:Reset("M+ Dungeon", true)
    NemesisChat:HandleEvent()
end

function NemesisChat:CHALLENGE_MODE_COMPLETED()
    if not IsNCEnabled() then return end
    local _, _, _, onTime = C_ChallengeMode.GetCompletionInfo()
    NCEvent:Initialize()
    NCDungeon:Finish(onTime)
    NemesisChat:HandleEvent()
    NemesisChat:Report("DUNGEON")
    NCRuntime:ClearPetOwners()
end

function NemesisChat:CHALLENGE_MODE_RESET()
    if not IsNCEnabled() then return end
    NCEvent:Initialize()
    NCDungeon:Reset()
    NCRuntime:ClearPetOwners()
end

function NemesisChat:ENCOUNTER_START(_, encounterID, encounterName, difficultyID, groupSize, instanceID)
    if not IsNCEnabled() then return end
    NCEvent:Initialize()
    NCBoss:Reset(encounterName, true)
    NemesisChat:HandleEvent()
end

function NemesisChat:ENCOUNTER_END(_, encounterID, encounterName, difficultyID, groupSize, success, fightTime)
    if not IsNCEnabled() then return end
    NCEvent:Initialize()
    NCBoss:Finish(success == 1)
    NemesisChat:HandleEvent()
    NemesisChat:Report("BOSS")
end

function NemesisChat:GROUP_ROSTER_UPDATE()
    if not IsNCEnabled() then return end
    -- Group roster events will fire when traversing delves and such, which can cause spam.
    if (NCRuntime:TimeSinceInitialization() < 1) then
        return
    end

    local success, error = pcall(NemesisChat.HandleRosterUpdate, NemesisChat)
    if not success then
        NemesisChat:Print("Error in HandleRosterUpdate:", error)
    end
end

function NemesisChat:PLAYER_REGEN_DISABLED()
    if not IsNCEnabled() then return end
    NCEvent:Initialize()
    NCCombat:Reset("Combat Segment " .. GetTime(), true)
    NCRuntime:ClearPlayerStates()
    NemesisChat:HandleEvent()
end

function NemesisChat:PLAYER_REGEN_ENABLED()
    if not IsNCEnabled() then return end
    NCEvent:Initialize()
    NCCombat:Finish()
    NemesisChat:HandleEvent()
    NemesisChat:Report("COMBAT")
end

function NemesisChat:PLAYER_ROLES_ASSIGNED()
    if not IsNCEnabled() then return end
    NCEvent:Initialize()
    NCRuntime:UpdateGroupRosterRoles()
    NemesisChat:CheckGroup()
end

function NemesisChat:CHAT_MSG_ADDON(_, prefix, payload, distribution, sender)
    if not IsNCEnabled() then return end
    NemesisChat:OnCommReceived(prefix, payload, distribution, sender)
end

function NemesisChat:ACTIVE_DELVE_DATA_UPDATE()
    if not IsNCEnabled() then return end
    if C_DelvesUI.HasActiveDelve() then
        -- Player has started or continued a delve
        inDelve = true
        currentDelveID = C_Map.GetBestMapForUnit("player")  -- Use the player's current map ID as an identifier
        NCDungeon:Start()
    else
        -- Delve is completed or ended normally
        inDelve = false
        NCDungeon:End()
    end
end

function NemesisChat:ZONE_CHANGED_NEW_AREA()
    if not IsNCEnabled() then return end
    HandleLeaveDelve()
end