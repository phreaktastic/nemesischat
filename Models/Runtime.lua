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

core.runtimeDefaults = {
    dbCacheExpiration = 600, -- 10 minutes
    myName = "",
    lastFeast = 0,
    lastFriendCheck = 0,
    lastLeaverSyncType = "GUILD",
    lastLowPerformerSyncType = "GUILD",
    lastMessage = 0,
    lastUnsafePullToast = 0,
    lastUnsafePullName = "",
    lastUnsafePullMob = "",
    lastUnsafePullCount = 0,
    lastSyncType = "",
    currentMarkerIndex = 0,
    groupTank = nil,
    groupHealer = nil,
    groupRosterCount = 1,
    groupRoster = {},
    pulledUnits = {},
    playerStates = {},
    friends = {
        -- A simple cache for any online friends, with their character names as the key. Allows for
        -- different interactions with friends, such as whispering them when they join a group.
        -- ["CharacterName"] = 1,
    },
    guild = {
        -- A simple cache for any online guild members, with their character names as the key. Allows for
        -- different interactions with guild members, such as whispering them when they join a group.
        -- ["characterName"] = {"guid" = guid, "isNemesis" = true/false},
    },
    lastSync = {
        -- A simple cache for the last time we synced with a particular player, with their character names as the key.
        -- ["CharacterName-Realm"] = 0,
    },
    petOwners = {},
    ncEvent = {
        category = "",
        event = "",
        target = "SELF",
        nemesis = "",
        bystander = "",
    },
    NCController = {
        channel = "SAY",
        message = "",
        target = "",
        customReplacements = {},
        customReplacementExamples = {},
        excludedNemeses = {},
        excludedBystanders = {},
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
        damage = 0,
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
        subjects = {
            -- {
            --     label = "Nemesis DPS",
            --     value = "NEMESIS_DPS",
            --     exec = function() return 0 end,
            --     operators = core.constants.NUMERIC_OPERATORS,
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
        leftCategory = "Nemesis",
        left = "NEMESIS_ROLE",
        operator = "IS",
        right = "DAMAGER",
    },
    initializationTime = nil,
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
    GetLastUnsafePullToast = function(self)
        return core.runtime.lastUnsafePullToast
    end,
    SetLastUnsafePullToast = function(self, value)
        core.runtime.lastUnsafePullToast = value
    end,
    UpdateLastUnsafePullToast = function(self)
        core.runtime.lastUnsafePullToast = GetTime()
    end,
    GetLastUnsafePullToastDelta = function(self)
        return GetTime() - core.runtime.lastUnsafePullToast
    end,
    GetLastUnsafePullName = function(self)
        return core.runtime.lastUnsafePullName
    end,
    SetLastUnsafePullName = function(self, value)
        core.runtime.lastUnsafePullName = value
    end,
    GetLastUnsafePullMob = function(self)
        return core.runtime.lastUnsafePullMob
    end,
    SetLastUnsafePullMob = function(self, value)
        core.runtime.lastUnsafePullMob = value
    end,
    GetLastUnsafePullCount = function(self)
        return core.runtime.lastUnsafePullCount
    end,
    SetLastUnsafePullCount = function(self, value)
        core.runtime.lastUnsafePullCount = value
    end,
    UpdateLastUnsafePullCount = function(self)
        if not core.runtime.lastUnsafePullCount then
            core.runtime.lastUnsafePullCount = 0
        end

        core.runtime.lastUnsafePullCount = core.runtime.lastUnsafePullCount + 1
    end,
    SetLastUnsafePull = function(self, name, mob)
        core.runtime.lastUnsafePullMob = mob

        if not core.runtime.lastUnsafePullCount then
            core.runtime.lastUnsafePullCount = 0
        end

        if core.runtime.lastUnsafePullName == name then
            core.runtime.lastUnsafePullCount = core.runtime.lastUnsafePullCount + 1
            return
        end

        core.runtime.lastUnsafePullCount = 1
        core.runtime.lastUnsafePullName = name
    end,
    GetLastUnsafePull = function(self)
        return core.runtime.lastUnsafePullName, core.runtime.lastUnsafePullMob, core.runtime.lastUnsafePullCount
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
    GetRollingMarkerIndex = function(self)
        local current = core.runtime.currentMarkerIndex

        NCRuntime:UpdateCurrentMarkerIndex()

        return current
    end,
    GetGroupTank = function(self)
        return core.runtime.groupTank
    end,
    GetGroupHealer = function(self)
        return core.runtime.groupHealer
    end,
    GetGroupLead = function(self)
        return core.runtime.groupLead
    end,
    GetGroupRoster = function(self)
        return core.runtime.groupRoster
    end,
    GetGroupRosterCount = function(self)
        return core.runtime.groupRosterCount
    end,
    GetGroupRosterCountOthers = function(self)
        return core.runtime.groupRosterCount - 1
    end,
    GetGroupRosterPlayer = function(self, playerName)
        return core.runtime.groupRoster[playerName]
    end,
    ClearGroupRoster = function(self)
        core.runtime.groupRoster = {}
        core.runtime.groupRosterCount = 0
        core.runtime.groupTank = nil
        core.runtime.groupHealer = nil
        core.runtime.groupLead = nil

        -- We're at least one of the members
        self:AddGroupRosterPlayer(GetMyName())
    end,
    RemoveGroupRosterPlayer = function(self, playerName)
        core.runtime.groupRoster[playerName] = nil
        core.runtime.groupRosterCount = core.runtime.groupRosterCount - 1

        if NCInfo.CurrentPlayer == playerName then
            NCInfo.CurrentPlayer = GetMyName()
            NCInfo:UpdatePlayerDropdown()
        end

        self:CacheGroupRoster()
    end,
    AddGroupRosterPlayer = function(self, playerName)
        if playerName == "Brann Bronzebeard" and not NCConfig:IsAllowingBrannMessages() then
            return
        end

        local isInGuild = UnitIsInMyGuild(playerName) ~= nil and playerName ~= GetMyName()
        local isNemesis = (NCConfig:GetNemesis(playerName) ~= nil or (NCRuntime:GetFriend(playerName) ~= nil and NCConfig:IsFlaggingFriendsAsNemeses()) or (isInGuild and NCConfig:IsFlaggingGuildmatesAsNemeses())) and playerName ~= GetMyName()
        local itemLevel = NemesisChat:GetItemLevel(playerName)
        local groupLead = UnitIsGroupLeader(playerName) ~= nil
        local class, rawClass = UnitClass(playerName)
        local data =  {
            guid = UnitGUID(playerName),
            isGuildmate = isInGuild,
            isFriend = NCRuntime:IsFriend(playerName),
            isNemesis = isNemesis,
            role = UnitGroupRolesAssigned(playerName),
            itemLevel = itemLevel,
            race = UnitRace(playerName),
            class = class,
            rawClass = rawClass,
            groupLead = groupLead,
            name = playerName,
            token = self:GetUnitTokenFromName(UnitName(playerName)),
        }

        core.runtime.groupRoster[playerName] = data
        core.runtime.groupRosterCount = core.runtime.groupRosterCount + 1

        if data.role == "TANK" then
            core.runtime.groupTank = playerName
        elseif data.role == "HEALER" then
            core.runtime.groupHealer = playerName
        end

        if groupLead then
            core.runtime.groupLead = playerName
        end

        NCInfo:UpdatePlayerDropdown()

        self:CacheGroupRoster()

        return data
    end,
    UpdateGroupRosterRoles = function(self)
        for key,val in pairs(core.runtime.groupRoster) do
            val.role = UnitGroupRolesAssigned(key)
            val.groupLead = UnitIsGroupLeader(key) ~= nil

            -- Re-attempt to get the item level
            if not val.itemLevel then
                val.itemLevel = NemesisChat:GetItemLevel(key)
            end
        end
    end,
    CacheGroupRoster = function(self)
        core.db.profile.cache.groupRoster = DeepCopy(core.runtime.groupRoster)
        core.db.profile.cache.groupRosterTime = GetTime()
    end,
    GetGuildRoster = function(self)
        return core.runtime.guild
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
    GetPlayerStatesLastCheckDelta = function(self)
        return GetTime() - (self:GetPlayerStatesLastCheck() or 0)
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

        self:CacheFriends()
    end,
    AddFriend = function(self, playerName)
        core.runtime.friends[playerName] = true

        self:CacheFriends()
    end,
    IsFriend = function(self, playerName)
        return core.runtime.friends[playerName] ~= nil
    end,
    CacheFriends = function(self)
        core.db.profile.cache.friends = DeepCopy(core.runtime.friends)
        core.db.profile.cache.friendsTime = GetTime()
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
    SetInitializationTime = function(self, value)
        core.runtime.initializationTime = value
    end,
    UpdateInitializationTime = function(self)
        core.runtime.initializationTime = GetTime()
    end,
    GetInitializationTime = function(self)
        return core.runtime.initializationTime
    end,
    TimeSinceInitialization = function(self)
        return GetTime() - (core.runtime.initializationTime or 0)
    end,
    Get = function(self, key)
        return core.runtime[key]
    end,
    Set = function(self, key, value)
        core.runtime[key] = value
    end,
    GetUnitTokenFromName = function(self, playerName)
        if not self.playerNameToToken then
            self.playerNameToToken = {}
            for i = 1, 40 do
                local token = (i > 1) and ("raid" .. i) or "player"
                local name = UnitName(token)
                if name then self.playerNameToToken[name] = token end
            end
        end
        return self.playerNameToToken[playerName]
    end,
}