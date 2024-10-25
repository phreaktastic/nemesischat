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
local C_ChallengeMode = C_ChallengeMode
local GetTime = GetTime
local C_LFGInfo = C_LFGInfo
local C_ScenarioInfo = C_ScenarioInfo

-- Local vars for base events
local inFollowerDungeon = false
local inNormalDungeon = false
local applicantIdCache = setmetatable({}, { __mode = "kv" })

local function GetCurrentLocation()
    local inInstance = IsInInstance()
    if inInstance then
        return GetInstanceInfo()
    else
        return GetZoneText()
    end
end

local function HandleZoneChanges()
    local currentLocation = GetCurrentLocation()
    NemesisChat.CurrentPlayerLocation = currentLocation
end

-----------------------------------------------------
-- Event handling for Blizzard events
-----------------------------------------------------

function NemesisChat:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    if not IsNCEnabled() then return end
    NCRuntime:ClearPetOwners()
    NemesisChat:RegisterStaticEvents()

    core.DungeonHandler:OnPlayerEnteringWorld(isInitialLogin, isReloadingUi)

    if isInitialLogin or isReloadingUi then
        self:CheckGroup()
    end
end

function NemesisChat:PLAYER_LEAVING_WORLD()
    if not IsNCEnabled() then return end
    core.DungeonHandler:OnPlayerLeavingWorld()
    NCRuntime:ClearPetOwners()
end

function NemesisChat:CHALLENGE_MODE_START()
    if not IsNCEnabled() then return end
    core.DungeonHandler:OnChallengeModeStart()
end

function NemesisChat:CHALLENGE_MODE_COMPLETED()
    if not IsNCEnabled() then return end
    core.DungeonHandler:OnChallengeModeCompleted()
end

function NemesisChat:WORLD_STATE_TIMER_START()
    if not IsNCEnabled() then return end
    core.DungeonHandler:OnWorldStateTimerStart()
end

function NemesisChat:CHALLENGE_MODE_RESET()
    if not IsNCEnabled() then return end
    core.DungeonHandler:OnChallengeModeReset()
end

function NemesisChat:SCENARIO_CRITERIA_UPDATE()
    if not IsNCEnabled() then return end
    core.DungeonHandler:OnScenarioCriteriaUpdate()
end

function NemesisChat:SCENARIO_COMPLETED()
    if not IsNCEnabled() then return end
    core.DungeonHandler:OnScenarioCompleted()
end

function NemesisChat:ENCOUNTER_START(_, encounterID, encounterName, difficultyID, groupSize, instanceID)
    if not IsNCEnabled() then return end
    NCEvent:Reset()
    NCBoss:Reset(encounterName, true)
    self:HandleEvent()
end

function NemesisChat:ENCOUNTER_END(_, encounterID, encounterName, difficultyID, groupSize, success, fightTime)
    if not IsNCEnabled() then return end
    NCEvent:Reset()
    NCBoss:Finish(success == 1)
    self:HandleEvent()
    self:Report("BOSS")
    if success == 1 then
        core.DungeonHandler:OnBossKill(encounterID, encounterName, difficultyID, groupSize, success)
    end
end

function NemesisChat:GROUP_ROSTER_UPDATE()
    if not IsNCEnabled() then return end

    core.LFGHandler:UpdatePermissions()

    -- Group roster events will fire when traversing delves and such, which can cause spam.
    if (NCRuntime:TimeSinceInitialization() < 1) then
        return
    end

    local success, err = pcall(NemesisChat.HandleRosterUpdate, NemesisChat)
    if not success then
        self:HandleError(err)
    end
end

function NemesisChat:PLAYER_REGEN_DISABLED()
    if not IsNCEnabled() then return end
    NCEvent:Reset()
    NCCombat:Reset("Combat Segment " .. GetTime(), true)
    NCRuntime:ClearPlayerStates()
    self:HandleEvent()
end

function NemesisChat:PLAYER_REGEN_ENABLED()
    if not IsNCEnabled() then return end
    NCEvent:Reset()
    NCCombat:Finish()
    self:HandleEvent()
    self:Report("COMBAT")
end

function NemesisChat:PLAYER_ROLES_ASSIGNED()
    if not IsNCEnabled() then return end
    NCEvent:Reset()
    NCRuntime:UpdateGroupRosterRoles()
    self:CheckGroup()
end

function NemesisChat:CHAT_MSG_ADDON(_, prefix, payload, distribution, sender)
    if not IsNCEnabled() then return end
    core.AddonCommunication:OnCommReceived(prefix, payload, distribution, sender)
end

function NemesisChat:ACTIVE_DELVE_DATA_UPDATE()
    if not IsNCEnabled() then return end
    core.DungeonHandler:OnActiveDelveDataUpdate()
end

function NemesisChat:ZONE_CHANGED_NEW_AREA()
    if not IsNCEnabled() then return end
    core.DungeonHandler:OnZoneChangedNewArea()
end

function NemesisChat:INSPECT_READY(event, guid)
    if not IsNCEnabled() then return end

    self.InspectQueueManager:OnInspectReady(guid)

    local unit = NCRuntime:GetPlayerFromGuid(guid)
    if unit then
        local specID = GetInspectSpecialization(unit.token)
        if specID and specID > 0 then
            local id, specName, description, icon, role, classFile, className = GetSpecializationInfoByID(specID)
            if specName and specName ~= "Unknown" then
                unit.spec = specName
            end
        end
    end
end

function NemesisChat:LFG_LIST_APPLICANT_UPDATED(event, applicantID)
    C_Timer.After(0.1, function()
        core.LFGHandler:OnApplicantUpdated(applicantID)
    end)
end

function NemesisChat:LFG_LIST_ACTIVE_ENTRY_UPDATE(event, entryID)
    core.LFGHandler:UpdatePermissions()
end

function NemesisChat:COMBAT_LOG_EVENT_UNFILTERED()
    if not IsNCEnabled() then return end

    core.CombatEventHandler:Fire()
end

function NemesisChat:ADDON_LOADED(addonName)
    if not IsNCEnabled() then return end
    if addonName == "NemesisChat" then
        core.LFGHandler:Initialize()
    end
end

function NemesisChat:LFG_COMPLETION_REWARD()
    if not IsNCEnabled() then return end
    core.LFGHandler:OnCompletionReward()
end
