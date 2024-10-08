-----------------------------------------------------
-- BASE EVENTS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local IsInInstance = IsInInstance
local GetInstanceInfo = GetInstanceInfo
local GetZoneText = GetZoneText
local C_DelvesUI = C_DelvesUI
local C_Map = C_Map
local C_ChallengeMode = C_ChallengeMode
local GetTime = GetTime
local C_LFGInfo = C_LFGInfo
local C_ScenarioInfo = C_ScenarioInfo

-- Local vars for base events
local inDelve = false
local currentDelveID = nil
local inFollowerDungeon = false
local currentFollowerDungeonID = nil
local LE_SCENARIO_TYPE_FOLLOWER_DUNGEON = 4

local function HandleLeaveDelve()
    if inDelve then  -- Only run if we are currently in a delve
        local hasDelve = C_DelvesUI.HasActiveDelve()
        if hasDelve and currentDelveID and not C_DelvesUI.IsEligibleForActiveDelveRewards("player") and NCDungeon and NCDungeon:IsActive() then
            NCDungeon:Reset()
        end
        inDelve = false
        currentDelveID = nil
    end
end

local function GetCurrentLocation()
    local inInstance, instanceType = IsInInstance()
    if inInstance then
        return GetInstanceInfo()
    else
        return GetZoneText()
    end
end

local function CheckFollowerDungeonStatus()
    local isInFollowerDungeon = C_LFGInfo.IsInLFGFollowerDungeon()
    local scenarioInfo = C_ScenarioInfo.GetScenarioInfo()

    if isInFollowerDungeon and not inFollowerDungeon then
        inFollowerDungeon = true
        currentFollowerDungeonID = scenarioInfo.scenarioID
        NCEvent:Initialize()
        NCDungeon:Start(scenarioInfo.name .. " (Follower)")
        NemesisChat:HandleEvent()
        NCInfo:UpdatePlayerDropdown()
        NemesisChat:Print("Follower Dungeon started: " .. scenarioInfo.name)
    elseif not isInFollowerDungeon and inFollowerDungeon then
        inFollowerDungeon = false
        currentFollowerDungeonID = nil
        if NCDungeon:IsActive() then
            NCEvent:Initialize()
            NCDungeon:Finish(true)
            NemesisChat:HandleEvent()
            NemesisChat:Report("DUNGEON")
            NCInfo:UpdatePlayerDropdown()
            NemesisChat:Print("Follower Dungeon completed")
        end
    end
end

local function HandleZoneChanges()
    local currentLocation = GetCurrentLocation()
    NemesisChat.CurrentPlayerLocation = currentLocation
    CheckFollowerDungeonStatus()
end

-----------------------------------------------------
-- Event handling for Blizzard events
-----------------------------------------------------

function NemesisChat:PLAYER_ENTERING_WORLD()
    if not IsNCEnabled() then return end
    NCRuntime:UpdateInitializationTime()
    NCRuntime:ClearPetOwners()
    NemesisChat:SilentGroupSync()
    HandleZoneChanges()
end

function NemesisChat:PLAYER_LEAVING_WORLD()
    if not IsNCEnabled() then return end
    if inFollowerDungeon then
        NCEvent:Initialize()
        NCDungeon:Finish(false)
        NemesisChat:Print("Follower Dungeon abandoned.")
        inFollowerDungeon = false
        currentFollowerDungeonID = nil
    end
    NCRuntime:ClearPetOwners()
    HandleLeaveDelve()
    CheckFollowerDungeonStatus()
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

function NemesisChat:SCENARIO_CRITERIA_UPDATE()
    if not IsNCEnabled() then return end
    CheckFollowerDungeonStatus()
end

function NemesisChat:SCENARIO_COMPLETED()
    if not IsNCEnabled() then return end
    NCEvent:Initialize()

    if inFollowerDungeon then
        NCDungeon:Finish(true)
        NemesisChat:HandleEvent()
        NemesisChat:Report("DUNGEON")
        inFollowerDungeon = false
        currentFollowerDungeonID = nil
        NemesisChat:Print("Follower Dungeon completed")
    else
        -- Handle other completed scenarios as before
        local scenarioInfo = C_ScenarioInfo.GetScenarioInfo()
        if scenarioInfo and scenarioInfo.isComplete then
            NCDungeon:Finish(true)
            NemesisChat:HandleEvent()
            NemesisChat:Report("DUNGEON")
        else
            NCDungeon:Reset()
        end
    end

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
    if C_DelvesUI.HasActiveDelve() and not inDelve then
        -- Player has started a delve
        inDelve = true
        currentDelveID = C_Map.GetBestMapForUnit("player")  -- Use the player's current map ID as an identifier
        NCDungeon:Start(NemesisChat.CurrentPlayerLocation)
    elseif inDelve and not C_DelvesUI.HasActiveDelve() then
        -- Delve is completed or ended normally
        inDelve = false
        currentDelveID = nil

        if NCDungeon and NCDungeon:IsActive() then
            NCDungeon:Finish()
        end
    end
end

function NemesisChat:ZONE_CHANGED_NEW_AREA()
    if not IsNCEnabled() then return end
    HandleLeaveDelve()
    HandleZoneChanges()
end