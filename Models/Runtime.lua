-----------------------------------------------------
-- RUNTIME
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Model for interacting with runtime data
-----------------------------------------------------

-- Blizzard functions
local GetTime = GetTime

core.runtimeDefaults = {
    myName = "",
    lastFeast = 0,
    lastFriendCheck = 0,
    lastLeaverSyncType = "GUILD",
    lastLowPerformerSyncType = "GUILD",
    lastMessage = 0,
    lastPullToast = 0,
    lastSyncType = "",
    currentMarkerIndex = 0,
    groupRoster = {},
    pulledUnits = {},
    playerStates = {},
    friends = {
        -- A simple cache for any online friends, with their character names as the key. Allows for
        -- different interactions with friends, such as whispering them when they join a group.
        -- ["CharacterName"] = 1,
    },
    petOwners = {},
    ncEvent = {
        category = "",
        event = "",
        target = "SELF",
        nemesis = "",
        bystander = "",
    },
    ncMessage = {
        channel = "SAY",
        message = "",
        target = "",
        customReplacements = {},
        excludedNemeses = {},
    },
    ncDungeon = {
        active = false,
        level = 0,
        startTime = 0,
        completeTime = 0,
        totalTime = 0,
        success = false,
        deathCounter = {},
        killCounter = {},
        avoidableDamage = {},
        interrupts = {},
    },
    ncBoss = {
        active = false,
        startTime = 0,
        name = "",
        success = false,
    },
    ncSpell = {
        active = false,
        source = "",
        target = "",
        spellId = 0,
        spellName = "",
        extraSpellId = 0,
    },
    ncCombat = {
        inCombat = false,
        interrupts = {}, -- key = string (player name), value = integer (number of interrupts)
        avoidableDamage = {}, -- key = string (player name), value = integer (avoidable damage taken)
    },
    ncApi = {
        -- Sample values provided as reference for API
        friendlyName = "",
        configOptions = {
            -- {
            --     name = "Details! API",
            --     value = "detailsApi",
            --     description = "Enable the Details! API for use in messages."
            --     primary = true, -- Flags the config option as the primary toggle for the API
            -- }
        },
        compatibilityChecks = {
            -- {
            --     configCheck = true, -- This must be TRUE for config checks, otherwise we will not be able to enable it
            --     exec = function()
            --         if not NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() then
            --             return false, "GTFO API is not enabled."
            --         end
            
            --         return true, nil
            --     end,
            -- },
            -- {
            --     configCheck = false, -- This must be FALSE, otherwise it will not be checked when enabling
            --     exec = function() 
            --         if GTFO == nil then
            --             return false, "GTFO is not installed."
            --         end
            
            --         return true, nil
            --     end,
            -- }
        },
        preMessageHooks = {},
        postMessageHooks = {},
        subjects = {
            -- {
            --     label = "Nemesis DPS",
            --     value = "NEMESIS_DPS",
            --     exec = function() return 0 end,
            --     operators = core.constants.EXTENDED_OPERATORS,
            --     type = "NUMBER",
            -- }
        },
        operators = {},
        replacements = {
            -- {
            --     label = "Nemesis DPS",
            --     value = "NEMESISDPS",
            --     exec = function() return 0 end,
            --     description = "The DPS of the Nemesis for the current fight."
            --     isNumeric = true,
            -- }
        },
        subjectMethods = {},
        replacementMethods = {},
    },
    configuredMessage = {
        label = "",
        channel = "GROUP",
        message = "",
        chance = 1.0,
        conditions = {}
    },
    messageCondition = {
        left = "NEMESIS_ROLE",
        operator = "IS",
        right = "DAMAGER",
    },
}

core.runtime = DeepCopy(core.runtimeDefaults)

NCRuntime = {
    GetLastFeast = function(self)
        return core.runtime.lastFeast
    end,
    SetLastFeast = function(self, value)
        core.runtime.lastFeast = value
    end,
    UpdateLastFeast = function(self)
        core.runtime.lastFeast = GetTime()
    end,
    GetLastFriendCheck = function(self)
        return core.runtime.lastFriendCheck
    end,
    SetLastFriendCheck = function(self, value)
        core.runtime.lastFriendCheck = value
    end,
    GetLastLeaverSyncType = function(self)
        return core.runtime.lastLeaverSyncType
    end,
    SetLastLeaverSyncType = function(self, value)
        core.runtime.lastLeaverSyncType = value
    end,
    GetLastLowPerformerSyncType = function(self)
        return core.runtime.lastLowPerformerSyncType
    end,
    SetLastLowPerformerSyncType = function(self, value)
        core.runtime.lastLowPerformerSyncType = value
    end,
    UpdateLastFriendCheck = function(self)
        core.runtime.lastFriendCheck = GetTime()
    end,
    GetLastMessage = function(self)
        return core.runtime.lastMessage
    end,
    SetLastMessage = function(self, value)
        core.runtime.lastMessage = value
    end,
    GetLastPullToast = function(self)
        return core.runtime.lastPullToast
    end,
    SetLastPullToast = function(self, value)
        core.runtime.lastPullToast = value
    end,
    UpdateLastPullToast = function(self)
        core.runtime.lastPullToast = GetTime()
    end,
    GetLastPullToastDelta = function(self)
        return GetTime() - core.runtime.lastPullToast
    end,
    UpdateLastMessage = function(self)
        core.runtime.lastMessage = GetTime()
    end,
    GetLastSyncType = function(self)
        return core.runtime.lastSyncType
    end,
    SetLastSyncType = function(self, value)
        core.runtime.lastSyncType = value
    end,
    GetCurrentMarkerIndex = function(self)
        return core.runtime.currentMarkerIndex
    end,
    SetCurrentMarkerIndex = function(self, value)
        core.runtime.currentMarkerIndex = value
    end,
    UpdateCurrentMarkerIndex = function(self)
        if core.runtime.currentMarkerIndex == #core.markers then
            core.runtime.currentMarkerIndex = 0
        end
        core.runtime.currentMarkerIndex = core.runtime.currentMarkerIndex + 1
    end,
    GetRollingMarketIndex = function(self)
        local current = core.runtime.currentMarkerIndex

        NCRuntime:UpdateCurrentMarkerIndex()

        return current
    end,
    GetGroupRoster = function(self)
        return core.runtime.groupRoster
    end,
    GetGroupRosterPlayer = function(self, playerName)
        return core.runtime.groupRoster[playerName]
    end,
    ClearGroupRoster = function(self)
        core.runtime.groupRoster = {}
    end,
    RemoveGroupRosterPlayer = function(self, playerName)
        core.runtime.groupRoster[playerName] = nil
    end,
    AddGroupRosterPlayer = function(self, playerName, data)
        core.runtime.groupRoster[playerName] = data
    end,
    GetPulledUnits = function(self)
        return core.runtime.pulledUnits
    end,
    GetPulledUnit = function(self, unitGUID)
        return core.runtime.pulledUnits[unitGUID]
    end,
    ClearPulledUnits = function(self)
        core.runtime.pulledUnits = {}
    end,
    AddPulledUnit = function(self, unitGUID)
        core.runtime.pulledUnits[unitGUID] = true
    end,
    CheckPulledUnits = function(self)
        if core.runtime.pulledUnits == nil then
            core.runtime.pulledUnits = {}
        end
    end,
    GetPlayerStates = function(self)
        return core.runtime.playerStates
    end,
    GetPlayerState = function(self, playerName)
        return core.runtime.playerStates[playerName]
    end,
    ClearPlayerStates = function(self)
        core.runtime.playerStates = {lastCheck = GetTime()}
    end,
    AddPlayerState = function(self, playerName, data)
        core.runtime.playerStates[playerName] = data
    end,
    GetPlayerStateValue = function(self, playerName, key)
        if core.runtime.playerStates[playerName] == nil then
            return nil
        end

        return core.runtime.playerStates[playerName][key]
    end,
    SetPlayerStateValue = function(self, playerName, key, value)
        if core.runtime.playerStates[playerName] == nil then
            core.runtime.playerStates[playerName] = {}
        end

        core.runtime.playerStates[playerName][key] = value
    end,
    CheckPlayerStates = function(self)
        if core.runtime.playerStates == nil then
            core.runtime.playerStates = {}
        end
    end,
    CheckPlayerState = function(self, playerName)
        if core.runtime.playerStates[playerName] == nil then
            core.runtime.playerStates[playerName] = NemesisChat:GetNewPlayerStateObject()
        end
    end,
    GetPlayerStatesLastCheck = function(self)
        return core.runtime.playerStates.lastCheck
    end,
    UpdatePlayerStatesLastCheck = function(self)
        core.runtime.playerStates.lastCheck = GetTime()
    end,
    GetPlayerStatesLastAuraCheck = function(self)
        if core.runtime.playerStates.lastAuraCheck == nil then
            core.runtime.playerStates.lastAuraCheck = 0
        end

        return core.runtime.playerStates.lastAuraCheck
    end,
    GetPlayerStatesLastAuraCheckDelta = function(self)
        return GetTime() - self:GetPlayerStatesLastAuraCheck()
    end,
    UpdatePlayerStatesLastAuraCheck = function(self)
        core.runtime.playerStates.lastAuraCheck = GetTime()
    end,
    GetFriends = function(self)
        return core.runtime.friends
    end,
    GetFriend = function(self, playerName)
        return core.runtime.friends[playerName]
    end,
    ClearFriends = function(self)
        core.runtime.friends = {}
    end,
    AddFriend = function(self, playerName)
        core.runtime.friends[playerName] = true
    end,
    IsFriend = function(self, playerName)
        return core.runtime.friends[playerName] ~= nil
    end,
    GetPetOwners = function(self)
        return core.runtime.petOwners
    end,
    GetPetOwner = function(self, petGuid)
        return core.runtime.petOwners[petGuid]
    end,
    ClearPetOwners = function(self)
        core.runtime.petOwners = {}
    end,
    AddPetOwner = function(self, petGuid, playerName)
        core.runtime.petOwners[petGuid] = playerName
    end,
    CheckPetOwners = function(self)
        if core.runtime.petOwners == nil then
            core.runtime.petOwners = {}
        end
    end,
    Get = function(self, key)
        return core.runtime[key]
    end,
    Set = function(self, key, value)
        core.runtime[key] = value
    end,
}