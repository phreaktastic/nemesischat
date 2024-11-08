local _, core = ...;
core.DungeonHandler = {
    keystoneLevel = 0,
    keystoneAffixes = {},
    dungeonTimeLimit = 0,
};
NemesisChat.DungeonHandler = core.DungeonHandler
local DungeonHandler = core.DungeonHandler

-- Localize frequently used functions for performance
local GetInstanceInfo = GetInstanceInfo
local IsInInstance, GetTime = IsInInstance, GetTime
local C_LFGInfo, C_ScenarioInfo = C_LFGInfo, C_ScenarioInfo
local C_ChallengeMode = C_ChallengeMode
local wipe = wipe
local C_Scenario = C_Scenario

-- Use a single table for dungeon states with weak keys
DungeonHandler.dungeonStates = setmetatable({
    normal = false,
    heroic = false,
    mythic = false,
    mythicplus = false,
    follower = false,
    delve = false,
    timewalking = false,
    lastDelveTime = 0,
    currentDelveMapID = nil,
    currentDifficulty = nil
}, { __mode = "k" })

local DIFFICULTY_MAP = {
    [DifficultyUtil.ID.DungeonNormal] = { name = "Normal", state = "normal" },
    [DifficultyUtil.ID.DungeonHeroic] = { name = "Heroic", state = "heroic" },
    [DifficultyUtil.ID.DungeonMythic] = { name = "Mythic", state = "mythic" },
    [DifficultyUtil.ID.DungeonChallenge] = { name = "Mythic+", state = "mythicplus" },
    [DifficultyUtil.ID.DungeonTimewalker] = { name = "Timewalking", state = "timewalking" },
}

function DungeonHandler:Fire()
    self:CheckDungeonStatus()
end

function DungeonHandler:CheckDungeonStatus()
    local dungeonInfo = self:GetDungeonInfo()
    local inInstance, instanceType = IsInInstance()

    -- Add timewalking check
    if self.dungeonStates.timewalking and dungeonInfo.state ~= "timewalking" then
        self:EndDungeon("DUNGEON", false)
    end

    -- Clear states if we're not in an instance
    if not inInstance then
        if self:IsInStandardDungeon() then
            self:CheckStandardDungeonEnd()
        end
        if self.dungeonStates.delve then
            self:CheckDelveEnd(dungeonInfo)
        end
        if self.dungeonStates.follower then
            self:EndDungeon("FOLLOWER", false)
        end
        return
    end

    -- Only handle party/raid instances
    if instanceType ~= "party" and instanceType ~= "raid" then
        return
    end

    -- Clear any existing states if difficulty changed
    if dungeonInfo.difficultyName ~= self.dungeonStates.currentDifficulty then
        self:ClearStandardDungeonStates()
    end

    -- Priority order for dungeon type detection
    if C_ChallengeMode.IsChallengeModeActive() then
        self:StartMythicPlus(dungeonInfo)
    elseif C_LFGInfo.IsInLFGFollowerDungeon() then
        self:CheckFollowerDungeon()
    elseif IsInLFGDungeon() then
        self:StartLFGDungeon(dungeonInfo)
    elseif dungeonInfo.state == "delve" then
        self:CheckDelveStart(dungeonInfo)
    else
        self:StartStandardDungeon(dungeonInfo)
    end
end

function DungeonHandler:CheckNormalDungeon(inInstance, difficultyName, name)
    local isInStandardDungeon = difficultyName == "Normal" or difficultyName == "Heroic" or difficultyName == "Mythic" or
        difficultyName == "Mythic Keystone"

    if inInstance and isInStandardDungeon and not self:IsInStandardDungeon() then
        local dungeonName = name .. " (" .. difficultyName .. ")"
        self.dungeonStates.currentDifficulty = difficultyName:lower()
        self.dungeonStates[difficultyName:gsub("%s+", ""):lower()] = true
        self:StartDungeon(dungeonName, "DUNGEON")
    elseif not inInstance and self:IsInStandardDungeon() then
        if not C_ChallengeMode.IsChallengeModeActive() then
            local scenarioInfo = C_ScenarioInfo.GetScenarioInfo()
            if not scenarioInfo or scenarioInfo.completed then
                self:EndDungeon("DUNGEON", scenarioInfo and scenarioInfo.completed or false)
            end
        end
    end
end

function DungeonHandler:IsInStandardDungeon()
    return self.dungeonStates.normal or self.dungeonStates.heroic or self.dungeonStates.mythic or
        self.dungeonStates.mythicplus or self.dungeonStates.lfg
end

function DungeonHandler:ClearStandardDungeonStates()
    self.dungeonStates.normal = false
    self.dungeonStates.heroic = false
    self.dungeonStates.mythic = false
    self.dungeonStates.mythicplus = false
    self.dungeonStates.lfg = false
    self.dungeonStates.timewalking = false
    self.dungeonStates.currentDifficulty = nil
end

function DungeonHandler:CheckFollowerDungeon()
    local isInFollowerDungeon = C_LFGInfo.IsInLFGFollowerDungeon()

    if isInFollowerDungeon and not self.dungeonStates.follower then
        local scenarioInfo = C_ScenarioInfo.GetScenarioInfo()
        if scenarioInfo and not scenarioInfo.completed then
            self:StartDungeon(scenarioInfo.name .. " (Follower)", "FOLLOWER")
        end
    elseif not isInFollowerDungeon and self.dungeonStates.follower then
        local scenarioInfo = C_ScenarioInfo.GetScenarioInfo()
        if not scenarioInfo or scenarioInfo.completed then
            self:EndDungeon("FOLLOWER", scenarioInfo and scenarioInfo.completed or false)
        end
    end
end

function DungeonHandler:CheckDelve(difficultyName, instanceID, inInstance)
    if difficultyName == "Delves" and instanceID and inInstance then
        if not self.dungeonStates.delve or self.dungeonStates.currentDelveMapID ~= instanceID then
            -- End previous delve if exists
            if self.dungeonStates.delve then
                self:EndDelve()
            end
            self.dungeonStates.currentDelveMapID = instanceID
            self:StartDungeon(select(1, GetInstanceInfo()), "DELVES")
        end
    elseif self.dungeonStates.delve then
        if difficultyName ~= "Delves" or not C_DelvesUI.HasActiveDelve(self.dungeonStates.currentDelveMapID) then
            self:EndDelve()
        end
    end
end

function DungeonHandler:EndDelve()
    local success = false
    if self.dungeonStates.currentDelveMapID then
        success = not C_DelvesUI.HasActiveDelve(self.dungeonStates.currentDelveMapID)
    end
    self:EndDungeon("DELVES", success)
    self.dungeonStates.currentDelveMapID = nil
end

function DungeonHandler:OnBossKill(encounterID, encounterName, difficultyID, groupSize, success)
    if not self:IsInStandardDungeon() then return end

    -- Add check for M+ to prevent duplicate completion
    if self.dungeonStates.mythicplus then return end

    local _, instanceType, _, _, _, _, _, instanceID = GetInstanceInfo()
    if not instanceID or instanceType ~= "party" then return end

    -- Get encounters for this map
    local encounters = C_EncounterJournal.GetEncountersOnMap(instanceID)
    if not encounters or #encounters == 0 then
        -- Fallback to manual EJ check if map data isn't available
        return self:CheckEncounterJournalBoss(encounterID, difficultyID, instanceID, success)
    end

    -- Sort encounters by order to ensure we get the final boss
    table.sort(encounters, function(a, b) return a.order < b.order end)

    -- Check if this was the final boss
    local finalBoss = encounters[#encounters]
    if finalBoss and finalBoss.encounterID == encounterID then
        self:EndDungeon("DUNGEON", success == 1)
        return true
    end

    return false
end

function DungeonHandler:CheckEncounterJournalBoss(encounterID, difficultyID, instanceID, success)
    if not C_EncounterJournal then return false end
    if not instanceID then return false end

    -- Set difficulty first
    EJ_SetDifficulty(difficultyID)

    -- Protect against invalid instance IDs
    local success, errorMsg = pcall(function()
        return EJ_SelectInstance(instanceID)
    end)

    if not success then
        -- Silent fail - this is expected for some instances
        return false
    end

    local index = 1
    local lastBossID

    while true do
        local _, _, _, _, _, _, eID = EJ_GetEncounterInfoByIndex(index)
        if not eID then break end
        lastBossID = eID
        index = index + 1
    end

    if lastBossID and encounterID == lastBossID then
        self:EndDungeon("DUNGEON", success == 1)
        return true
    end

    return false
end

function DungeonHandler:OnPlayerEnteringWorld(isInitialLogin, isReloadingUi)
    if not (isInitialLogin or isReloadingUi) then
        self:CheckDungeonStatus()
    end
end

function DungeonHandler:OnPlayerLeavingWorld()
    if self:IsInAnyDungeon() then
        local category = NCEvent:GetCategory()
        self:EndDungeon(category, false)
    end
end

function DungeonHandler:OnCompletionReward()
    if not (self:IsInStandardDungeon() or self:IsLFGDungeon()) then return end

    -- LFG completion reward is a definitive sign of dungeon completion
    self:EndDungeon("DUNGEON", true)
end

function DungeonHandler:OnScenarioCriteriaUpdate()
    if not self:IsInStandardDungeon() then return end

    local scenarioInfo = C_Scenario.GetInfo()
    if scenarioInfo and scenarioInfo.completed then
        -- Scenario completion can be a reliable indicator for dungeon completion
        self:EndDungeon("DUNGEON", true)
    end
end

function DungeonHandler:OnScenarioCompleted()
    -- Add check for standard dungeons
    if self:IsInStandardDungeon() and not self.dungeonStates.mythicplus then
        self:EndDungeon("DUNGEON", true)
        return
    end

    if self.dungeonStates.follower then
        local scenarioInfo = C_ScenarioInfo.GetScenarioInfo()
        if scenarioInfo and scenarioInfo.completed then
            self:EndDungeon("FOLLOWER", true)
        end
    end
end

function DungeonHandler:OnActiveDelveDataUpdate()
    C_Timer.After(2, function()
        local dungeonInfo = self:GetDungeonInfo()
        if dungeonInfo.instanceID then
            self:CheckDelveStart(dungeonInfo)
        else
            self:CheckDelveEnd(dungeonInfo)
        end
    end)
end

function DungeonHandler:OnZoneChangedNewArea()
    C_Timer.After(2, function()
        local dungeonInfo = self:GetDungeonInfo()
        if dungeonInfo.instanceID then
            self:CheckDelveStart(dungeonInfo)
        else
            self:CheckDelveEnd(dungeonInfo)
        end
        self:CheckDungeonStatus()
    end)
end

function DungeonHandler:StartDungeon(name, category)
    self:SetupDungeonInfo(category)

    NCEvent:SetCategory(category)
    NCEvent:SetEvent("START")
    NCEvent:SetTarget("NA")
    NCEvent:RandomNemesis()
    NCEvent:RandomBystander()

    NCDungeon:Reset(name, true)

    NemesisChat:HandleEvent()
    NemesisChat:Print(category .. " started: " .. name)

    self.dungeonStates[category:lower()] = true

    NCRuntime:ClearPetOwners()
    NCRuntime:ClearLastCompletedDungeon()
    NCInfo:UpdatePlayerDropdown()
    NCInfo:Update()
end

function DungeonHandler:SetupDungeonInfo(category)
    if category == "DUNGEON" then
        local _, _, difficultyID = GetInstanceInfo()
        if difficultyID == 8 then -- Mythic Keystone
            self:SetupMythicPlusDungeon()
        else
            self:ResetDungeonInfo()
        end
    else
        self:ResetDungeonInfo()
    end
end

function DungeonHandler:SetupMythicPlusDungeon()
    -- Get active challenge map ID first
    local mapID = C_ChallengeMode.GetActiveChallengeMapID()
    if not mapID then return end

    -- Get keystone info
    self.keystoneLevel, self.keystoneAffixes = C_ChallengeMode.GetActiveKeystoneInfo()

    -- Get time limit with proper error handling
    local timeLimit = select(3, C_ChallengeMode.GetMapUIInfo(mapID))
    self.dungeonTimeLimit = timeLimit or 0
end

function DungeonHandler:ResetMythicPlusInfo()
    self.keystoneLevel = 0
    wipe(self.keystoneAffixes)
    self.dungeonTimeLimit = 0
end

function DungeonHandler:EndDungeon(category, isSuccess)
    -- Clear states before processing to prevent re-entry
    if category == "DUNGEON" then
        self:ClearStandardDungeonStates()
    else
        self.dungeonStates[category:lower()] = false
    end

    NCEvent:SetCategory(category)
    NCEvent:SetEvent(isSuccess and "SUCCESS" or "FAIL")
    NCEvent:SetTarget("NA")
    NCEvent:RandomNemesis()
    NCEvent:RandomBystander()

    NemesisChat:Report("DUNGEON", isSuccess)
    NCDungeon:Finish(isSuccess)
    NemesisChat:HandleEvent()

    NemesisChat:Print(category .. " " .. (isSuccess and "completed" or "abandoned"))

    -- Update timestamps and cleanup
    if category == "DELVES" then
        self.dungeonStates.lastDelveTime = GetTime()
    end

    self:ResetDungeonInfo()
    NCRuntime:ClearPetOwners()
    NCRuntime:SetLastCompletedDungeon(NCDungeon)
    NCInfo:Update()
end

function DungeonHandler:ResetDungeonInfo()
    self.keystoneLevel = 0
    wipe(self.keystoneAffixes)
    self.dungeonTimeLimit = 0
end

function DungeonHandler:IsInAnyDungeon()
    if IsInLFGDungeon() then
        return true
    end
    if C_LFGInfo.IsInLFGFollowerDungeon() then
        return true
    end
    if C_DelvesUI and C_DelvesUI.HasActiveDelve() then
        return true
    end
    return self:IsInStandardDungeon() or self.dungeonStates.follower
end

function DungeonHandler:ResetDungeonStatus()
    for k in pairs(self.dungeonStates) do
        self.dungeonStates[k] = false
    end
    self.dungeonStates.lastDelveTime = GetTime()
end

function DungeonHandler:OnChallengeModeStart()
    local dungeonInfo = self:GetDungeonInfo()
    self:StartMythicPlus(dungeonInfo)
end

function DungeonHandler:OnChallengeModeCompleted()
    if self.dungeonStates.mythicplus then
        -- Cache the completion status immediately when the event fires
        local _, _, _, _, _, _, _, _, _, completionCode = C_ChallengeMode.GetCompletionInfo()
        C_Timer.After(0.5, function()
            self:EndDungeon("DUNGEON", completionCode == 1)
        end)
    end
end

function DungeonHandler:OnChallengeModeReset()
    if self.dungeonStates.currentDifficulty then
        self:EndDungeon("DUNGEON", false)
        -- Restart dungeon tracking if still in instance
        local dungeonInfo = self:GetDungeonInfo()
        if dungeonInfo.state then
            self:StartDungeon(dungeonInfo.name, "DUNGEON")
        end
    end
end

function DungeonHandler:OnWorldStateTimerStart()
    if self.dungeonStates.normal and C_ChallengeMode.IsChallengeModeActive() then
        local mapID = C_ChallengeMode.GetActiveChallengeMapID()
        if mapID then
            self.dungeonTimeLimit = select(3, C_ChallengeMode.GetMapUIInfo(mapID))
        end
    end
end

function DungeonHandler:GetDungeonInfo()
    local name, _, difficultyID, difficultyName, _, _, _, instanceID = GetInstanceInfo()

    -- Check if difficulty is in Delve range (201-212)
    if difficultyID >= 201 and difficultyID <= 212 then
        return {
            name = name,
            difficultyName = "Delves",
            state = "delve",
            instanceID = instanceID
        }
    end

    local difficulty = DIFFICULTY_MAP[difficultyID]
    return {
        name = name,
        difficultyName = difficulty and difficulty.name or "Unknown",
        state = difficulty and difficulty.state or nil,
        instanceID = instanceID
    }
end

function DungeonHandler:StartStandardDungeon(dungeonInfo)
    if not dungeonInfo.state or self.dungeonStates[dungeonInfo.state] then return end

    -- Special handling for timewalking
    if dungeonInfo.state == "timewalking" then
        self.dungeonStates.timewalking = true
        self.dungeonStates.currentDifficulty = "timewalking"
    else
        self.dungeonStates[dungeonInfo.state] = true
        self.dungeonStates.currentDifficulty = dungeonInfo.state
    end

    local dungeonName = string.format("%s (%s)", dungeonInfo.name, dungeonInfo.difficultyName)
    self:StartDungeon(dungeonName, "DUNGEON")
end

function DungeonHandler:IsInProgressDungeon()
    -- Get criteria info for the current scenario/dungeon
    local _, _, numCriteria = C_Scenario.GetStepInfo()
    if not numCriteria then return false end

    -- Check if any criteria are already completed
    for i = 1, numCriteria do
        local criteriaInfo = C_ScenarioInfo.GetCriteriaInfo(i)
        if criteriaInfo.completed then
            return true
        end
    end

    -- Also check for any defeated bosses
    local numEncounters = select(3, GetInstanceInfo())
    if numEncounters then
        for i = 1, numEncounters do
            local _, _, isKilled = GetInstanceLockTimeRemainingEncounter(i)
            if isKilled then
                return true
            end
        end
    end

    return false
end

function DungeonHandler:CheckStandardDungeonEnd()
    if not self:IsInStandardDungeon() then return end

    local inInstance, instanceType = IsInInstance()
    if not inInstance then
        -- Handle both normal dungeons and LFG dungeons
        if (self.dungeonStates.currentDifficulty and not C_ChallengeMode.IsChallengeModeActive()) or
           (self.dungeonStates.lfg and not IsInLFGDungeon()) then
            self:EndDungeon("DUNGEON", false) -- Left instance without completion
        end
    end
end

function DungeonHandler:StartMythicPlus(dungeonInfo)
    if self.dungeonStates[self.dungeonStates.currentDifficulty] then
        self:ClearStandardDungeonStates()
    end

    -- Get the keystone level
    local keystoneLevel = C_ChallengeMode.GetActiveKeystoneInfo()
    local dungeonName = string.format("%s (Mythic+ %d)", dungeonInfo.name, keystoneLevel)

    self.dungeonStates.mythicplus = true
    self.dungeonStates.currentDifficulty = "mythicplus"
    self:StartDungeon(dungeonName, "DUNGEON")
end

function DungeonHandler:CheckDelveStart(dungeonInfo)
    if not dungeonInfo.instanceID or not C_DelvesUI then return end

    local hasActiveDelve = C_DelvesUI.HasActiveDelve()
    if hasActiveDelve then
        if not self.dungeonStates.delve or self.dungeonStates.currentDelveMapID ~= dungeonInfo.instanceID then
            if self.dungeonStates.delve then
                self:EndDelve()
            end
            self.dungeonStates.delve = true
            self.dungeonStates.currentDelveMapID = dungeonInfo.instanceID
            self:StartDungeon(dungeonInfo.name, "DELVES")
        end
    end
end

function DungeonHandler:CheckDelveEnd(dungeonInfo)
    if not self.dungeonStates.delve then return end

    local isActive = C_DelvesUI and C_DelvesUI.HasActiveDelve(self.dungeonStates.currentDelveMapID)
    local _, instanceType = IsInInstance()
    if not isActive or dungeonInfo.difficultyName ~= "Delves" or instanceType ~= "party" then
        self:EndDelve()
    end
end

function DungeonHandler:StartLFGDungeon(dungeonInfo)
    if self.dungeonStates.lfg then return end

    local dungeonName = string.format("%s (%s)", dungeonInfo.name, dungeonInfo.difficultyName)
    self.dungeonStates.lfg = true
    self.dungeonStates.currentDifficulty = "lfg"
    self:StartDungeon(dungeonName, "DUNGEON")
end

function DungeonHandler:OnLFGComplete()
    if self.dungeonStates.lfg then
        self:EndDungeon("DUNGEON", true)
    end
end

-- Add this helper function for clarity
function DungeonHandler:IsLFGDungeon()
    return self.dungeonStates.lfg
end
