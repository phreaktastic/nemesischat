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
    UpdateLastFriendCheck = function(self)
        core.runtime.lastFriendCheck = GetTime()
    end,
    GetLastMessage = function(self)
        return core.runtime.lastMessage
    end,
    SetLastMessage = function(self, value)
        core.runtime.lastMessage = value
    end,
    UpdateLastMessage = function(self)
        core.runtime.lastMessage = GetTime()
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