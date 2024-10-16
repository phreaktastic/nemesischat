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

--- @class NCRuntime
core.runtimeDefaults = {
    --- @type boolean
    initialized = false,
    --- @type number
    dbCacheExpiration = 600, -- 10 minutes
    --- @type string
    myName = "",
    --- @type number
    lastFeast = 0,
    --- @type number
    lastFriendCheck = 0,
    --- @type string
    lastLeaverSyncType = "GUILD",
    --- @type string
    lastLowPerformerSyncType = "GUILD",
    --- @type number
    lastMessage = 0,
    --- @type number
    lastUnsafePullToast = 0,
    --- @type string
    lastUnsafePullName = "",
    --- @type string
    lastUnsafePullMob = "",
    --- @type number
    lastUnsafePullCount = 0,
    --- @type string
    lastSyncType = "",
    --- @type number
    currentMarkerIndex = 0,
    --- @type string|nil
    groupTank = nil,
    --- @type string|nil
    groupHealer = nil,
    --- @type number
    groupRosterCount = 1,
    --- @type boolean
    hasNemesis = false,
    --- @type boolean
    hasBystander = false,
    --- @type table
    nemeses = {},
    --- @type table
    bystanders = {},
    --- @type table<string, GroupRosterPlayer>
    groupRoster = {},
    --- @type table<string, string>
    playerNameToToken = {},  -- Cache for unit token lookups by player name
    --- @type table<string, GroupRosterPlayer>
    playerGuidToRoster = {}, -- Cache for player lookups by GUID
    --- @type table|nil
    lastCompletedDungeon = nil,
    --- @type table<string, boolean>
    pulledUnits = {},

    --- @type table<string, PlayerState>
    playerStates = {},

    --- @type table<string, number>
    friends = {
        -- A simple cache for any online friends, with their character names as the key. Allows for
        -- different interactions with friends, such as whispering them when they join a group.
        -- ["CharacterName"] = 1,
    },
    --- @type GuildCache
    guild = {},
    --- @type table<string, number>
    lastSync = {
        -- A simple cache for the last time we synced with a particular player, with their character names as the key.
        -- ["CharacterName-Realm"] = 0,
    },
    --- @type table<string, string>
    petOwners = {},
    --- @type table
    ncSpell = {
        active = false,
        source = "",
        target = "",
        spellId = 0,
        spellName = "",
        extraSpellId = 0,
        damage = 0,
    },
    --- @type table
    ncApi = {
        -- Sample values provided as reference for API
        friendlyName = "",
        configOptions = {},
        compatibilityChecks = {},
        subjects = {},
        operators = {},
        replacements = {},
        subjectMethods = {},
        replacementMethods = {},
    },
    --- @type ConfiguredMessage
    configuredMessage = {
        label = "",
        channel = "GROUP",
        message = "",
        chance = 1.0,
        conditions = {}
    },
    --- @type MessageCondition
    messageCondition = {
        leftCategory = "Nemesis",
        left = "NEMESIS_ROLE",
        operator = "IS",
        right = "DAMAGER",
    },
    --- @type number|nil
    initializationTime = nil,
}

--- @class NCRuntime
core.runtime = DeepCopy(core.runtimeDefaults)

NCRuntime = {
    IsInitialized = function(self)
        return core.runtime.initialized
    end,
    SetInitialized = function(self, value)
        core.runtime.initialized = value
    end,
    HasNemesis = function(self)
        return core.runtime.hasNemesis
    end,
    HasBystander = function(self)
        return core.runtime.hasBystander
    end,
    GetNemeses = function(self)
        return core.runtime.nemeses
    end,
    GetBystanders = function(self)
        return core.runtime.bystanders
    end,
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
        wipe(core.runtime.groupRoster)
        wipe(core.runtime.playerNameToToken)
        wipe(core.runtime.playerGuidToRoster)
        wipe(core.runtime.pulledUnits)
        wipe(core.runtime.nemeses)
        wipe(core.runtime.bystanders)
        core.runtime.groupRosterCount = 0
        core.runtime.groupTank = nil
        core.runtime.groupHealer = nil
        core.runtime.groupLead = nil
        core.runtime.hasNemesis = false
        core.runtime.hasBystander = false

        -- We're at least one of the members
        self:AddGroupRosterPlayer(GetMyName())
    end,
    RemoveGroupRosterPlayer = function(self, playerName)
        if core.runtime.groupRoster[playerName] == nil then
            return nil
        end

        local player = core.runtime.groupRoster[playerName]

        if player.isNemesis then
            if tContains(core.runtime.nemeses, playerName) then
                tDeleteItem(core.runtime.nemeses, playerName)
            end

            if not NemesisChat:HasPartyNemeses(true) then
                core.runtime.hasNemesis = false
            end
        else
            if tContains(core.runtime.bystanders, playerName) then
                tDeleteItem(core.runtime.bystanders, playerName)
            end

            if not NemesisChat:HasPartyBystanders(true) then
                core.runtime.hasBystander = false
            end
        end

        core.runtime.groupRoster[playerName] = nil
        core.runtime.groupRosterCount = core.runtime.groupRosterCount - 1

        if NCInfo.CurrentPlayer == playerName then
            NCInfo.CurrentPlayer = GetMyName()
            NCInfo:UpdatePlayerDropdown()
        end

        wipe(core.runtime.playerNameToToken)

        self:CacheGroupRoster()
    end,
    AddGroupRosterPlayer = function(self, playerName)
        if playerName == "Brann Bronzebeard" and not NCConfig:IsAllowingBrannMessages() then
            return nil
        end

        local isInGuild = playerName ~= GetMyName() and UnitIsInMyGuild(playerName) ~= nil
        local isNemesis = playerName ~= GetMyName() and
            (NCConfig:GetNemesis(playerName) ~= nil or (NCRuntime:GetFriend(playerName) ~= nil and NCConfig:IsFlaggingFriendsAsNemeses()) or (isInGuild and NCConfig:IsFlaggingGuildmatesAsNemeses()))
        local itemLevel = NemesisChat:GetItemLevel(playerName)

        local class, rawClass = "Unknown", "UNKNOWN"
        local race = "Unknown"
        local role = "NONE"
        local guid = nil

        -- Use pcall to catch any errors when calling WoW API functions
        pcall(function()
            if UnitExists(playerName) then
                class, rawClass = UnitClass(playerName)
                race = UnitRace(playerName) or "Unknown"
                role = UnitGroupRolesAssigned(playerName)
                guid = UnitGUID(playerName)
            end
        end)

        local data = {
            guid = guid,
            isGuildmate = isInGuild,
            isFriend = NCRuntime:IsFriend(playerName),
            isNemesis = isNemesis,
            role = role,
            itemLevel = itemLevel,
            race = race,
            class = class,
            rawClass = rawClass,
            spec = nil,
            groupLead = false,
            name = playerName,
            token = self:GetUnitTokenFromName(playerName),
            group = 0,
        }

        if isNemesis then
            core.runtime.hasNemesis = true
            tinsert(core.runtime.nemeses, playerName)
        else
            core.runtime.hasBystander = true
            tinsert(core.runtime.bystanders, playerName)
        end

        if data.token then
            local success, isGroupLead = pcall(UnitIsGroupLeader, playerName)
            if success and isGroupLead == true then
                data.groupLead = true
                core.runtime.groupLead = playerName
            end
        end

        core.runtime.groupRoster[playerName] = data
        core.runtime.groupRosterCount = core.runtime.groupRosterCount + 1

        if data.role == "TANK" then
            core.runtime.groupTank = playerName
        elseif data.role == "HEALER" then
            core.runtime.groupHealer = playerName
        end

        self:AttemptRetrieveSpec(data)
        self:CacheGroupRoster()

        NCInfo:UpdatePlayerDropdown()

        if playerName ~= GetMyName() and guid then
            core.runtime.playerGuidToRoster[guid] = data

            if not data.spec then
                NemesisChat.InspectQueueManager:QueuePlayerForInspect(guid)
            end
        end

        return data
    end,
    UpdateGroupRosterRoles = function(self)
        for key, val in pairs(core.runtime.groupRoster) do
            val.role = UnitGroupRolesAssigned(key)
            val.groupLead = UnitIsGroupLeader(key) ~= nil

            -- Re-attempt to get the item level
            if not val.itemLevel then
                val.itemLevel = NemesisChat:GetItemLevel(key)
            end

            -- Re-attempt to get the token
            if not val.token then
                val.token = self:GetUnitTokenFromName(key)
            end

            -- Attempt to get specialization information
            self:AttemptRetrieveSpec(val)
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

    --- Gets the player state for the specified player name.
    --- @param self table
    --- @param playerName string The name of the player
    --- @return PlayerState The player state for the specified player
    GetPlayerState = function(self, playerName)
        return core.runtime.playerStates[playerName]
    end,
    ClearPlayerStates = function(self)
        core.runtime.playerStates = { lastCheck = GetTime() }
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
    SetLastCompletedDungeon = function(self, dungeonData)
        local stats = {
            Affixes = dungeonData:GetAffixes(),
            AvoidableDamage = dungeonData:GetAvoidableDamage(),
            CrowdControl = dungeonData:GetCrowdControls(),
            Deaths = dungeonData:GetDeaths(),
            Defensives = dungeonData:GetDefensives(),
            Dispells = dungeonData:GetDispells(),
            Interrupts = dungeonData:GetInterrupts(),
            Offheals = dungeonData:GetOffHeals(),
            Pulls = dungeonData:GetPulls(),
            DPS = {}
        }

        -- Populate DPS for each player
        for playerName, _ in pairs(dungeonData.RosterSnapshot) do
            stats.DPS[playerName] = dungeonData:GetDps(playerName)
        end

        core.runtime.lastCompletedDungeon = {
            Identifier = dungeonData:GetIdentifier(),
            Level = dungeonData:GetLevel(),
            RosterSnapshot = dungeonData.RosterSnapshot,
            Stats = stats
        }
    end,
    GetLastCompletedDungeon = function(self)
        return core.runtime.lastCompletedDungeon or nil
    end,
    ClearLastCompletedDungeon = function(self)
        core.runtime.lastCompletedDungeon = nil
    end,
    Get = function(self, key)
        return core.runtime[key]
    end,
    Set = function(self, key, value)
        core.runtime[key] = value
    end,
    GetUnitTokenFromName = function(self, playerName)
        if next(core.runtime.playerNameToToken) == nil or not core.runtime.playerNameToToken[playerName] then
            -- Always include the player
            local myName = UnitName("player")
            if myName then
                core.runtime.playerNameToToken[Ambiguate(myName, "none")] = "player"
            end

            if IsInRaid() then
                -- In a raid group
                local numGroupMembers = GetNumGroupMembers()
                for i = 1, numGroupMembers do
                    local unit = "raid" .. i
                    local name = Ambiguate(UnitName(unit), "none")
                    if name then
                        core.runtime.playerNameToToken[name] = unit
                        local rosterPlayer = NCRuntime:GetGroupRosterPlayer(name)
                        if rosterPlayer then
                            rosterPlayer.group = select(2, GetRaidRosterInfo(i))
                        end
                    end
                end
            elseif IsInGroup() then
                -- In a party (not a raid)
                for i = 1, GetNumGroupMembers() - 1 do
                    local unit = "party" .. i
                    local name = Ambiguate(UnitName(unit), "none")
                    if name then
                        core.runtime.playerNameToToken[name] = unit
                    end
                end
            else
                return core.runtime.playerNameToToken[Ambiguate(UnitName(playerName), "none")]
            end
        end
        return core.runtime.playerNameToToken[Ambiguate(UnitName(playerName), "none")]
    end,
    AttemptRetrieveSpec = function(self, unit)
        if unit.token and UnitExists(unit.token) and UnitIsConnected(unit.token) then
            if UnitIsUnit(unit.token, "player") then
                -- For the player character, use GetSpecialization()
                local specIndex = GetSpecialization()
                if specIndex then
                    local id, specName, description, icon, role, classFile, className = GetSpecializationInfo(specIndex)
                    if specName then
                        unit.spec = specName
                    end
                end
            else
                -- For other players, use inspection
                local specID = GetInspectSpecialization(unit.token)
                if specID and specID > 0 then
                    -- Spec data is available
                    local id, specName, description, icon, role, classFile, className = GetSpecializationInfoByID(specID)
                    if specName and specName ~= "Unknown" then
                        unit.spec = specName
                    end
                else
                    -- Wait for INSPECT_READY event
                end
            end
        end
    end,
    GetPlayerFromGuid = function(self, guid)
        return core.runtime.playerGuidToRoster[guid]
    end,
    ClearPlayerGuidToRoster = function(self)
        wipe(core.runtime.playerGuidToRoster)
    end,
}
