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
    myName = "",
    lastFeast = 0,
    lastMessage = 0,
    currentMarkerIndex = 0,
    petOwners = {},
    NCEvent = {
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
    NCSpell = {
        active = false,
        source = "",
        target = "",
        spellId = 0,
        spellName = "",
        extraSpellId = 0,
        damage = 0,
    },
    NCApi = {
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
}