-----------------------------------------------------
-- INITIALIZATION
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local addonName, core = ...;

core.version = GetAddOnMetadata(addonName, 'Version')

-----------------------------------------------------
-- Register global NemesisChat
-----------------------------------------------------
NemesisChat = LibStub("AceAddon-3.0"):NewAddon("NemesisChat", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceTimer-3.0", "LibToast-1.0")

-----------------------------------------------------
-- Global functions
-----------------------------------------------------

-- When we don't want a reference (ie, resetting to refaults)
function DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[DeepCopy(orig_key)] = DeepCopy(orig_value)
        end
        setmetatable(copy, DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function ArrayMerge(tableA, tableB)
    local returnTable = {}

    for key, val in pairs(tableA) do
        table.insert(returnTable, val)
    end

    for key, val in pairs(tableB) do
        if not tContains(returnTable, val) then
            table.insert(returnTable, val)
        end
    end

    return returnTable
end

function MapMerge(map1, map2)
    local mergedMap = {}
    
    -- Merge values from map1
    for key, value in pairs(map1) do
        mergedMap[key] = value
    end
    
    -- Merge values from map2, overriding existing values
    for key, value in pairs(map2) do
        mergedMap[key] = value
    end
    
    return mergedMap
end

function GetMyName()
    return core.runtime.myName
end

function IsNCEnabled()
    return core.db.profile.enabled
end

function GetRole(player)
    local role 

    if player == nil or player == GetMyName() then
        role = UnitGroupRolesAssigned("player")
    else
        if NCRuntime:GetGroupRosterPlayer(player) == nil then
            return "party animal"
        end

        role = NCRuntime:GetGroupRosterPlayer(player).role
    end

    for key, val in pairs(core.roles) do
        if val.value == role then
            return val.label
        end
    end

    return "party animal"
end

-----------------------------------------------------
-- Core options
-----------------------------------------------------
core.apiConfigOptions = {}
core.units = {
    {
        label = "N/A",
        value = "NA"
    },
    {
        label = "Self",
        value = "SELF"
    },
    {
        label = "Nemesis",
        value = "NEMESIS"
    },
    {
        label = "Bystander",
        value = "BYSTANDER"
    }
}
core.constants = {}
core.constants.NA = { 1 }
core.constants.STANDARD = { 2, 3, 4, }
core.constants.OTHERS = { 3, 4, }
core.constants.OPERATORS = {
    {
        label = "is",
        value = "IS"
    },
    {
        label = "is NOT",
        value = "IS_NOT"
    }
}
core.constants.EXTENDED_OPERATORS = {
    {
        label = ">",
        value = "GT"
    },
    {
        label = "<",
        value = "LT"
    }
}
core.constants.NC_OPERATORS = {
    {
        label = "is a Nemesis",
        value = "IS_NEMESIS"
    },
    {
        label = "NOT a Nemesis",
        value = "NOT_NEMESIS"
    },
    {
        label = "is a friend",
        value = "IS_FRIEND",
    },
    {
        label = "NOT a friend",
        value = "NOT_FRIEND",
    },
    {
        label = "is a guildmate",
        value = "IS_GUILDMATE",
    },
    {
        label = "NOT a guildmate",
        value = "NOT_GUILDMATE",
    }
}
core.events = {
    env = {
        {
            label = "Start",
            value = "START",
            options = core.constants.NA
        },
        {
            label = "Death",
            value = "DEATH",
            options = core.constants.STANDARD
        },
        {
            label = "Fail",
            value = "FAIL",
            options = core.constants.NA
        },
        {
            label = "Success",
            value = "SUCCESS",
            options = core.constants.NA
        },
    },
    group = {
        {
            label = "Join",
            value = "JOIN",
            options = core.constants.STANDARD
        },
        {
            label = "Leave",
            value = "LEAVE",
            options = core.constants.OTHERS
        }
    },
    combatLog = {
        {
            label = "Spell Cast Success",
            value = "SPELL_CAST_SUCCESS",
            options = core.constants.STANDARD
        },
        {
            label = "Interrupt",
            value = "INTERRUPT",
            options = core.constants.STANDARD
        },
        {
            label = "Place Current Feast",
            value = "FEAST",
            options = core.constants.STANDARD
        },
        {
            label = "Place Old Feast",
            value = "OLDFEAST",
            options = core.constants.STANDARD
        },
        {
            label = "Re-Feast",
            value = "REFEAST",
            options = core.constants.STANDARD
        },
        {
            label = "Heal",
            value = "HEAL",
            options = core.constants.STANDARD
        },
        {
            label = "Combat Start",
            value = "COMBAT_START",
            options = core.constants.NA
        },
        {
            label = "Combat End",
            value = "COMBAT_END",
            options = core.constants.NA
        },
    }
}
core.roles = {
    {
        label = "DPS",
        value = "DAMAGER",
    },
    {
        label = "Tank",
        value = "TANK",
    },
    {
        label = "Healer",
        value = "HEALER",
    },
}
core.messageConditions = {
    {
        label = "Nemesis Role",
        value = "NEMESIS_ROLE",
        operators = core.constants.OPERATORS,
        type = "SELECT",
        options = DeepCopy(core.roles),
    },
    {
        label = "Spell ID",
        value = "SPELL_ID",
        operators = core.constants.OPERATORS,
        type = "NUMBER", 
    },
    {
        label = "Spell Name",
        value = "SPELL_NAME",
        operators = core.constants.OPERATORS,
        type = "INPUT",
    },
    {
        label = "Spell Target",
        value = "SPELL_TARGET",
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.NC_OPERATORS),
        type = "INPUT",
    },
    {
        label = "Players In Group",
        value = "GROUP_COUNT",
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.EXTENDED_OPERATORS),
        type = "NUMBER", 
    },
    {
        label = "Nemeses In Group",
        value = "NEMESES_COUNT",
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.EXTENDED_OPERATORS),
        type = "NUMBER", 
    },
    {
        label = "My Interrupts (Combat)",
        value = "INTERRUPTS",
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.EXTENDED_OPERATORS),
        type = "NUMBER", 
    },
    {
        label = "Nem. Interrupts (Combat)",
        value = "NEMESIS_INTERRUPTS",
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.EXTENDED_OPERATORS),
        type = "NUMBER", 
    },
    {
        label = "My Interrupts (Overall)",
        value = "INTERRUPTS_OVERALL",
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.EXTENDED_OPERATORS),
        type = "NUMBER", 
    },
    {
        label = "Nem. Interrupts (Overall)",
        value = "NEMESIS_INTERRUPTS_OVERALL",
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.EXTENDED_OPERATORS),
        type = "NUMBER", 
    },
}

-- This is what the configuration screen is built from.
core.configTree = {
    ["BOSS"] = {
        label = "Boss Fight",
        events = DeepCopy(core.events.env)
    },
    ["COMBATLOG"] = {
        label = "General",
        events = DeepCopy(core.events.combatLog)
    },
    ["GROUP"] = {
        label = "Group",
        events = DeepCopy(core.events.group)
    },
    ["RAID"] = {
        label = "Raid",
        events = DeepCopy(core.events.group)
    },
    ["CHALLENGE"] = {
        label = "Mythic+ Dungeon",
        events = DeepCopy(core.events.env)
    },
}
core.channels = {
    ["GROUP"] = "Group (party/instance/raid)",
    ["PARTY"] = "Party",
    ["SAY"] = "Say",
    ["EMOTE"] = "Emote",
    ["YELL"] = "Yell",
}
core.channelsExtended = {
    ["WHISPER"] = "Whisper Nemesis (|c00ff0000May be unavailable|r)",
}
core.channelsExplicit = {
    ["WHISPER_NEMESIS"] = "Whisper Nemesis (|c00ff0000May be unavailable|r)",
    ["WHISPER_BYSTANDER"] = "Whisper Bystander (|c00ff0000May be unavailable|r)",
}

core.reference = {
    colors = {
        ["SAY"] = "|cffffffff",
        ["EMOTE"] = "|cffff8040",
        ["GROUP"] = "|cffaaaaff",
        ["PARTY"] = "|cffaaaaff",
        ["YELL"] = "|cffff4040",
        ["WHISPER"] = "|cffff80ff",
        ["WHISPER_NEMESIS"] = "|cffff80ff",
        ["WHISPER_BYSTANDER"] = "|cffff80ff",
    }
}

-- Numeric value replacements, for number validation
core.numericReplacementsCore = {}
core.numericReplacements = {}

-- Credit for feast IDs goes to: Addon "FeastDrop" -- Original addon from Morsker (Dinnerbell) updated by Kyrgune
-- NemesisChat modifications: Setting old xpac feasts to 0, current to 1. Allows for taunting people when they drop old feasts :)
core.feastIDs = {
	[57301] = 0, -- Great Feast (WotLK)
	[57426] = 0, -- Fish Feast (WotLK)
	[66476] = 0, -- Bountiful Feast (Pilgrim's Bounty)
	[87643] = 0, -- Broiled Dragon Feast (Cata)
	[87644] = 0, -- Seafood Magnifique Feast (Cata)
	[87915] = 0, -- Goblin Barbecue (Cata)
	[104958] = 0, -- Pandaren Banquet (MoP)
	[105193] = 0, -- Great Pandaren Banquet (MoP)
	[126492] = 0, -- Banquet of the Grill (MoP)
	[126494] = 0, -- Great Banquet of the Grill (MoP)
	[126495] = 0, -- Banquet of the Wok (MoP)
	[126496] = 0, -- Great Banquet of the Wok (MoP)
	[126497] = 0, -- Banquet of the Pot (MoP)
	[126498] = 0, -- Great Banquet of the Pot (MoP)
	[126499] = 0, -- Banquet of the Steamer (MoP)
	[126500] = 0, -- Great Banquet of the Steamer (MoP)
	[126501] = 0, -- Banquet of the Oven (MoP)
	[126502] = 0, -- Great Banquet of the Oven (MoP)
	[126503] = 0, -- Banquet of the Brew (MoP)
	[126504] = 0, -- Great Banquet of the Brew (MoP)
	-- Additions from Kyrgune Below --
	
	[216333] = 0, -- Potato Stew Feast (BattleGround (Legion))
	[216347] = 0, -- Feast of Ribs (Battleground (Legion)) 
	[58465] = 0, -- Gigantic Feast (WotLK)
	[58474] = 0, -- Small Feast (WotLK)
	[185709] = 0, -- Sugar-Crusted Fish Feast (Darkmoon Faire)
	[185706] = 0, -- Fancy Darkmoon Feast (Darkmoon Faire)
	[160740] = 0, -- Feast of Blood (WoD)
	[160914] = 0, -- Feast of the Waters (WoD)
	[251254] = 0, -- Feast of the Fishes (Legion)
	[201352] = 0, -- Lavish Suramar Feast (Legion)
	[201351] = 0, -- Hearty Feast (Legion)
	[259409] = 0, -- Gallery Banquet (BFA)
	[259410] = 0, -- Bountiful Captain's Feast (BFA)
	[286050] = 0, -- Sanguinated Feast (BFA)
	[297048] = 0, -- Famine Evaluator And Snack Table (BFA)
	[308458] = 0, -- Surprisingly Palatable Feast (SL)
	[308462] = 0, -- Feast of Gluttonous Hedonism (SL)
	[359333] = 0, -- Empty Kettle of Stone Soup (SL)  (Doesn't Work)
	[382427] = 1, -- Grand Banquet of the Kalu'ak (DF)
	[382423] = 1, -- Yusa's Hearty Stew (DF)
	[383063] = 1, -- Hoard of Draconic Delicacies (DF)
}

-- It's probably time to build a model for affix functionality

-- All affix mobs
core.affixMobs = {
    "Spiteful Shade",
    "Incorporeal",
    "Afflicted Soul",
}

-- Affix mobs of interest
core.affixMobsMarker = {
    "Incorporeal",
    "Afflicted Soul",
}

-- Ways to handle affix mobs
core.affixMobsHandles = {
    ["Afflicted Soul"] = {
        "HEAL",
        "DISPEL",
    },
}

-- Auras applied by affix mobs
core.affixMobsAuras = {
    {
        name = "Bursting",
        spellName = "Burst",
        spellId = 240443,
        highStacks = 7,
    }
}

-- Raid markers to use for affix mobs (currently unused)
core.markers = {
    1,
    5,
    7,
    8,
}

-----------------------------------------------------
-- Core tracking initialization
-----------------------------------------------------
core.runtimeDefaults = {
    myName = "",
    lastFeast = 0,
    lastFriendCheck = 0,
    lastLeaverSyncType = "GUILD",
    lastLowPerformerSyncType = "GUILD",
    lastMessage = 0,
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
            --     configCheck = true, -- This must be true for config checks, otherwise we will not be able to enable it
            --     exec = function()
            --         if not core.db.profile.API[self.configOptions[1].value] then
            --             return false, "GTFO API is not enabled."
            --         end
            
            --         return true, nil
            --     end,
            -- },
            -- {
            --     configCheck = false, -- This must be true, otherwise it will not be checked when enabling
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

NCEvent = {}
NCMessage = {}
NCDungeon = {}
NCBoss = {}
NCSpell = {}
NCCombat = {}
