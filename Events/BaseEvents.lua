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
local inDelve = false
local lastDelveTime = 0
local inFollowerDungeon = false
local inNormalDungeon = false
local applicantIdCache = setmetatable({}, { __mode = "kv" })

local function HandleLeaveDelve()
    if inDelve then
        inDelve = false
        lastDelveTime = GetTime()
        if NCDungeon and NCDungeon:IsActive() then
            NCDungeon:Finish(false)
            NemesisChat:Print("Delve ended.")
        end
    end
end

local function CheckAndUpdateDelveStatus()
    local name, _, difficultyIndex, _, _,
    _, _, _, lfgID = GetInstanceInfo()
    local dName, instanceType = GetDifficultyInfo(difficultyIndex);

    -- After leaving a delve, these parameters will all still be true (for a brief moment), therefor we need to check the lastDelveTime as well
    if dName == "Delves" and not inDelve and lfgID and instanceType and instanceType == "scenario" and GetTime() - lastDelveTime > 3 and IsInInstance() then
        inDelve = true
        C_Timer.After(2, function()
            if IsInInstance() then
                NCDungeon:Start(name .. " (Delve)")
                NemesisChat:Print("Delve started: " .. name)
            else
                HandleLeaveDelve()
            end
        end)
    elseif dName ~= "Delves" and inDelve then
        HandleLeaveDelve()
    end
end

local function GetCurrentLocation()
    local inInstance = IsInInstance()
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
        NCEvent:Reset()
        NCDungeon:Start(scenarioInfo.name .. " (Follower)")
        NemesisChat:HandleEvent()
        NCInfo:UpdatePlayerDropdown()
        NemesisChat:Print("Follower Dungeon started: " .. scenarioInfo.name)
    elseif not isInFollowerDungeon and inFollowerDungeon then
        inFollowerDungeon = false
        if NCDungeon:IsActive() then
            NCEvent:Reset()
            NCDungeon:Finish(true)
            NemesisChat:HandleEvent()
            NemesisChat:Report("DUNGEON")
            NCInfo:UpdatePlayerDropdown()
            NemesisChat:Print("Follower Dungeon completed")
        end
    elseif isInFollowerDungeon and inFollowerDungeon and scenarioInfo.isComplete then
        if NCDungeon:IsActive() then
            NCEvent:Reset()
            NCDungeon:Finish(true)
            NemesisChat:HandleEvent()
            NemesisChat:Report("DUNGEON")
            NCInfo:UpdatePlayerDropdown()
            NemesisChat:Print("Follower Dungeon completed")
        end
    end
end

local function CheckNormalDungeonStatus()
    local name, _, difficultyIndex = GetInstanceInfo()
    local dName, instanceType = GetDifficultyInfo(difficultyIndex);

    if IsInInstance() and (dName == "Normal" or dName == "Heroic") and not inNormalDungeon and instanceType and instanceType == "party" then
        inNormalDungeon = true
        NCDungeon:Start(name)
        NemesisChat:HandleEvent()
        NCInfo:UpdatePlayerDropdown()
        NemesisChat:Print("Dungeon started: " .. name)
    elseif not IsInInstance() and not (dName == "Normal" or dName == "Heroic") and inNormalDungeon then
        inNormalDungeon = false
        if NCDungeon:IsActive() then
            NCDungeon:Finish(true)
            NemesisChat:HandleEvent()
            NemesisChat:Report("DUNGEON")
            NCInfo:UpdatePlayerDropdown()
            NemesisChat:Print("Dungeon completed")
        end
    end
end

local function HandleZoneChanges()
    local currentLocation = GetCurrentLocation()
    NemesisChat.CurrentPlayerLocation = currentLocation
    CheckFollowerDungeonStatus()
    CheckNormalDungeonStatus()
end

-----------------------------------------------------
-- Event handling for Blizzard events
-----------------------------------------------------

function NemesisChat:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    if not IsNCEnabled() then return end
    if not NCRuntime:IsInitialized() then
        self:InitializeCore()
    end
    NCRuntime:ClearPetOwners()
    NemesisChat:RegisterStaticEvents()

    if isInitialLogin or isReloadingUi then
        self:CheckGroup()
    else
        HandleZoneChanges()
        CheckAndUpdateDelveStatus()
    end
end

function NemesisChat:PLAYER_LEAVING_WORLD()
    if not IsNCEnabled() then return end
    if inFollowerDungeon then
        NCEvent:Reset()
        NCDungeon:Finish(false)
        self:Print("Follower Dungeon abandoned.")
        inFollowerDungeon = false
    end
    if inDelve and NCDungeon:IsActive() then
        NCEvent:Reset()
        NCDungeon:Finish(false)
        self:Print("Delve abandoned.")
        inDelve = false
        lastDelveTime = GetTime()
    elseif inDelve and not NCDungeon:IsActive() then
        inDelve = false
        lastDelveTime = GetTime()
        self:Print("Delve completed.")
    end
    NCRuntime:ClearPetOwners()
    CheckFollowerDungeonStatus()
end

function NemesisChat:CHALLENGE_MODE_START()
    if not IsNCEnabled() then return end
    self:CheckGroup()
    NCEvent:Reset()
    NCDungeon:Reset("M+ Dungeon", true)
    self:HandleEvent()
end

function NemesisChat:CHALLENGE_MODE_COMPLETED()
    if not IsNCEnabled() then return end
    local _, _, _, onTime = C_ChallengeMode.GetCompletionInfo()
    NCEvent:Reset()
    NCDungeon:Finish(onTime)
    self:HandleEvent()
    self:Report("DUNGEON")
    NCRuntime:ClearPetOwners()
end

function NemesisChat:CHALLENGE_MODE_RESET()
    if not IsNCEnabled() then return end
    NCEvent:Reset()
    NCDungeon:Reset()
    NCRuntime:ClearPetOwners()
end

function NemesisChat:SCENARIO_CRITERIA_UPDATE()
    if not IsNCEnabled() then return end
    CheckFollowerDungeonStatus()
end

function NemesisChat:SCENARIO_COMPLETED()
    if not IsNCEnabled() then return end
    NCEvent:Reset()

    if inFollowerDungeon then
        NCDungeon:Finish(true)
        self:HandleEvent()
        self:Report("DUNGEON")
        inFollowerDungeon = false
        self:Print("Follower Dungeon completed")
    elseif inDelve then
        NCDungeon:Finish(true)
        self:HandleEvent()
        self:Report("DUNGEON")
        inDelve = false
        lastDelveTime = GetTime()
        self:Print("Delve completed.")
    end

    NCRuntime:ClearPetOwners()
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
end

function NemesisChat:GROUP_ROSTER_UPDATE()
    if not IsNCEnabled() then return end
    -- Group roster events will fire when traversing delves and such, which can cause spam.
    if (NCRuntime:TimeSinceInitialization() < 1) then
        return
    end

    CheckAndUpdateDelveStatus()

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
    CheckAndUpdateDelveStatus()
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

    CheckAndUpdateDelveStatus()
end

function NemesisChat:ZONE_CHANGED_NEW_AREA()
    if not IsNCEnabled() then return end
    CheckAndUpdateDelveStatus()
    HandleZoneChanges()
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

-- WIP. Needs a handler.
function NemesisChat:LFG_LIST_APPLICANT_UPDATED(event, applicantID)
    -- Check if any notification feature is enabled
    if not (NCConfig:GetNotifyWhenTankApplies() or NCConfig:GetNotifyWhenHealerApplies() or NCConfig:GetNotifyWhenDPSApplies()) then
        return
    end

    local function processApplicant()
        local applicantInfo = C_LFGList.GetApplicantInfo(applicantID)
        if not applicantInfo then return end
        if not applicantInfo.applicationStatus or applicantInfo.applicationStatus == "none" then return end
        if not applicantInfo.isNew or applicantIdCache[applicantID] == true then return end

        applicantIdCache[applicantID] = true

        local retries = 0
        local function tryGetApplicantInfo()
            local formattedGroupMembers = {}
            local plainGroupMembers = {}
            local highestPrioritySound = nil
            local serverName = nil

            for i = 1, applicantInfo.numMembers do
                local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship, dungeonScore, pvpItemLevel, factionGroup, raceID, specID =
                    C_LFGList.GetApplicantMemberInfo(applicantID, i)

                if name then
                    local fullName = applicantInfo.applicationStatus == "applied" and applicantInfo.name or name
                    local _, realm = strsplit("-", fullName)
                    serverName = realm or GetRealmName()

                    if itemLevel and itemLevel > 0 then
                        local roleMessage, sound
                        local _, specName, _, icon = GetSpecializationInfoByID(specID)
                        specName = specName or "Unknown"

                        if healer and NCConfig:GetNotifyWhenHealerApplies() then
                            roleMessage, sound = "healer", NCConfig:GetNotifyWhenHealerAppliesSound()
                        elseif tank and NCConfig:GetNotifyWhenTankApplies() then
                            roleMessage, sound = "tank", NCConfig:GetNotifyWhenTankAppliesSound()
                        elseif damage and NCConfig:GetNotifyWhenDPSApplies() then
                            roleMessage, sound = "DPS", NCConfig:GetNotifyWhenDPSAppliesSound()
                        end

                        if not highestPrioritySound and sound then
                            highestPrioritySound = sound
                        end

                        itemLevel = math.floor(itemLevel)

                        if not dungeonScore then
                            dungeonScore = "UNKNOWN"
                        end

                        if roleMessage then
                            local roleIcon = icon and "|T" .. icon .. ":16:16:0:0:64:64:5:59:5:59|t" or ""
                            local formattedMemberInfo = string.format("%s %s %s %s (%s) - %s",
                                NCColors.Emphasize(itemLevel),
                                NCColors.ClassColor(class, specName),
                                NCColors.ClassColor(class, localizedClass),
                                roleIcon,
                                NCColors.Emphasize(dungeonScore) .. " IO",
                                NCColors.Emphasize(serverName))

                            local plainMemberInfo = string.format("%d %s %s (%s IO) - %s",
                                itemLevel,
                                specName,
                                localizedClass,
                                dungeonScore,
                                serverName)

                            table.insert(formattedGroupMembers, formattedMemberInfo)
                            table.insert(plainGroupMembers, plainMemberInfo)
                        end
                    end
                elseif retries < 3 then
                    retries = retries + 1
                    C_Timer.After(0.5, tryGetApplicantInfo)
                    return
                end
            end

            local formattedMessage, plainMessage

            if #plainGroupMembers == 1 then
                formattedMessage = string.format("New applicant: %s", formattedGroupMembers[1])
                plainMessage = string.format("New applicant: %s", plainGroupMembers[1])
            else
                formattedMessage = string.format("A group of %d has applied:", #formattedGroupMembers)
                plainMessage = string.format("A group of %d has applied: ", #plainGroupMembers)

                -- For formatted message (printed to player's frame)
                for i, memberInfo in ipairs(formattedGroupMembers) do
                    formattedMessage = formattedMessage .. "\n" .. memberInfo
                end

                -- For plain message (sent to group chat)
                for i, memberInfo in ipairs(plainGroupMembers) do
                    plainMessage = plainMessage .. "(" .. memberInfo .. ")"
                end
            end

            -- For printing to the player's frames
            self:Print(formattedMessage)

            -- For sending to group chat
            if NCConfig:GetGroupMessageOnApplication() and IsInGroup(LE_PARTY_CATEGORY_HOME) then
                -- Split long messages if necessary
                local maxLength = 255 -- Max chat message length
                while #plainMessage > 0 do
                    local chunk = plainMessage:sub(1, maxLength)
                    local lastSpace = chunk:find("%s[^%s]*$")

                    if #plainMessage > maxLength and lastSpace then
                        chunk = plainMessage:sub(1, lastSpace - 1)
                    end

                    SendChatMessage("NemesisChat: " .. chunk, "PARTY")
                    plainMessage = plainMessage:sub(#chunk + 1):gsub("^%s*", "")
                end
            end

            if highestPrioritySound then
                PlaySound(highestPrioritySound, "Master")
            end
        end

        tryGetApplicantInfo()
    end

    C_Timer.After(0.1, processApplicant)
end

function NemesisChat:COMBAT_LOG_EVENT_UNFILTERED()
    if not IsNCEnabled() then return end

    core.CombatEventHandler:Fire()
end
