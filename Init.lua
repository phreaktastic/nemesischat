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
LibPlayerSpells = LibStub('LibPlayerSpells-1.0')

-----------------------------------------------------
-- Global functions
-----------------------------------------------------

NemesisChat._globalPrefixes = {}

function NemesisChat:RegisterGlobalLookup(prefix, name)
    tinsert(NemesisChat._globalPrefixes, { prefix = prefix, name = name })
end

-- When we don't want a reference (ie, resetting to refaults)
function DeepCopy(orig, skipPseudoPrivate)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            if (skipPseudoPrivate and string.match(orig_key, "^_")) then
                copy[orig_key] = nil
            else
                copy[DeepCopy(orig_key, skipPseudoPrivate)] = DeepCopy(orig_value, skipPseudoPrivate)
            end
        end
        setmetatable(copy, DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function ArrayMerge(...)
    local returnTable = {}
    local tables = {...}

    if not tables then
        return returnTable
    end

    for _, t in pairs(tables) do
        for _, val in pairs(t) do
            if not tContains(returnTable, val) then
                table.insert(returnTable, val)
            end
        end
    end

    return returnTable
end

function MapMerge(...)
    local mergedMap = {}
    local maps = {...}

    if not maps then
        return mergedMap
    end

    for _, map in pairs(maps) do
        for key, val in pairs(map) do
            mergedMap[key] = val
        end
    end

    return mergedMap
end

function GetMyName()
    return NemesisChat:GetMyName()
end

function IsNCEnabled()
    return core.db.profile.enabled
end

function GetRole(player)
    local role

    if NCState:GetPlayerState(player) == nil then
        role = UnitGroupRolesAssigned(player)
    else
        role = NCState:GetPlayerState(player).role
    end

    for key, val in pairs(core.roles) do
        if val.value == role then
            return val.label
        end
    end

    return nil
end

function GetKeysSortedByValue(tbl, sortFunction)
    local keys = {}
    for key in pairs(tbl) do
        table.insert(keys, key)
    end

    table.sort(keys, function(a, b)
        return sortFunction(tbl[a], tbl[b])
    end)

    return keys
end

function Split(str, sep)
    local result = {}
    local regex = ("([^%s]+)"):format(sep)

    for each in str:gmatch(regex) do
        table.insert(result, each)
    end

    return result
 end

 function ShuffleTable(t)
    local tbl = {}
    for i = 1, #t do
      tbl[i] = t[i]
    end
    for i = #tbl, 2, -1 do
      local j = math.random(i)
      tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
  end

function GetHashmapKeys(hashmap)
    local keys = {}

    if hashmap == nil then
        return keys
    end

    for key, _ in pairs(hashmap) do
        table.insert(keys, key)
    end

    return keys
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
    },
    {
        label = "Affix Mob",
        value = "AFFIX_MOB"
    },
    {
        label = "Any Mob",
        value = "ANY_MOB",
    },
    {
        label = "Boss",
        value = "BOSS",
    },
}
core.constants = {}
core.constants.BOOLEAN_OPTIONS = {
    {
        label = "True",
        value = true
    },
    {
        label = "False",
        value = false
    }
}
core.constants.NA = { 1 }
core.constants.STANDARD = { 2, 3, 4, }
core.constants.OTHERS = { 3, 4, }
core.constants.AFFIXMOBS = { 5 }
core.constants.ENEMIES = { 5, 6, 7 }
core.constants.ALLUNITS = { 2, 3, 4, 5, 6, 7 }
core.constants.IS = {
    {
        label = "is",
        value = "IS"
    },
}
core.constants.OPERATORS = {
    {
        label = "is",
        value = "IS"
    },
    {
        label = "is NOT",
        value = "IS_NOT"
    },
}
core.constants.NUMERIC_OPERATORS = {
    {
        label = ">",
        value = "GT"
    },
    {
        label = "<",
        value = "LT"
    }
}
core.constants.UNIT_OPERATORS = {
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
    },
    {
        label = "is underperformer",
        value = "IS_UNDERPERFORMER",
    },
    {
        label = "is overperformer",
        value = "IS_OVERPERFORMER",
    },
    {
        label = "is alive",
        value = "IS_ALIVE",
    },
    {
        label = "is dead",
        value = "IS_DEAD",
    },
    {
        label = "is an affix mob",
        value = "IS_AFFIX_MOB",
    },
    {
        label = "is NOT an affix mob",
        value = "NOT_AFFIX_MOB",
    },
    {
        label = "is an affix caster",
        value = "IS_AFFIX_CASTER",
    },
    {
        label = "is NOT an affix caster",
        value = "NOT_AFFIX_CASTER",
    },
    {
        label = "is group lead",
        value = "IS_GROUP_LEAD",
    },
    {
        label = "is NOT group lead",
        value = "NOT_GROUP_LEAD",
    },
    {
        label = "has buff",
        value = "HAS_BUFF",
    },
    {
        label = "does NOT have buff",
        value = "NOT_HAS_BUFF",
    },
    {
        label = "has debuff",
        value = "HAS_DEBUFF",
    },
    {
        label = "does NOT have debuff",
        value = "NOT_HAS_DEBUFF",
    },
}
core.events = {
    segment = {
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
            label = "Death (Avoidable)",
            value = "AVOIDABLE_DEATH",
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
    guild = {
        {
            label = "Login",
            value = "LOGIN",
            options = core.constants.STANDARD
        },
        {
            label = "Logout",
            value = "LOGOUT",
            options = core.constants.OTHERS
        },
    },
    combatLog = {
        {
            label = "Spell Cast Success",
            value = "SPELL_CAST_SUCCESS",
            options = core.constants.ALLUNITS
        },
        {
            label = "Begin Spellcasting",
            value = "SPELL_CAST_START",
            options = core.constants.ALLUNITS
        },
        {
            label = "Aura Applied",
            value = "AURA_APPLIED",
            options = core.constants.ALLUNITS
        },
        {
            label = "Receive Avoidable Damage",
            value = "AVOIDABLE_DAMAGE",
            options = core.constants.STANDARD
        },
        {
            label = "Receive Damage",
            value = "DAMAGE",
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

-- This will be populated upon bootstrapping APIs
core.messageConditions = {}

-- This is what the configuration screen is built from.
core.configTree = {
    ["BOSS"] = {
        label = "Boss Fight",
        events = DeepCopy(core.events.segment)
    },
    ["COMBATLOG"] = {
        label = "General",
        events = DeepCopy(core.events.combatLog)
    },
    ["GROUP"] = {
        label = "Group",
        events = DeepCopy(core.events.group)
    },
    ["GUILD"] = {
        label = "Guild",
        events = DeepCopy(core.events.guild)
    },
    ["CHALLENGE"] = {
        label = "Mythic+ Dungeon",
        events = DeepCopy(core.events.segment)
    },
    ["RAID"] = {
        label = "Raid",
        events = DeepCopy(core.events.group)
    },
}
core.channels = {
    ["GROUP"] = "Group (party/instance/raid)",
    ["PARTY"] = "Party",
    ["SAY"] = "Say",
    ["EMOTE"] = "Emote",
    ["YELL"] = "Yell",
    ["GUILD"] = "Guild",
    ["OFFICER"] = "Officer",
    ["RAID_WARNING"] = "Raid Warning",
    -- ["VOICE_TEXT"] = "TTS / Voice Text",
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
        ["GUILD"] = "|cff40ff40",
        ["OFFICER"] = "|cff40c040",
        ["RAID"] = "|cffff7f00",
        ["RAID_WARNING"] = "|cffff4800",
        ["VOICE_TEXT"] = "|cffcccccc",
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
    "Incorporeal Being",
    "Afflicted Soul",
}

-- Affix mobs that cast
core.affixMobsCasters = {
    "Incorporeal Being",
    "Afflicted Soul",
}

-- Ways to handle affix mobs
core.affixMobsHandles = {
    ["Afflicted Soul"] = {
        "HEAL",
        "DISPEL",
    },
    ["Incorporeal Being"] = {
        "CROWD_CONTROL",
        "INTERRUPT"
    },
    ["Spiteful Shade"] = {
        "CROWD_CONTROL",
    },
}

-- Auras applied by affix mobs
core.affixMobsAuras = {
    {
        type = "HARMFUL",
        name = "Bursting",
        spellName = "Burst",
        spellId = 240443,
        highStacks = 3,
    },
    {
        type = "HELPFUL",
        name = "Bolstering",
        spellName = "Bolster",
        spellId = 209859,
        highStacks = 5,
    }
}

-- Cache the affix mob aura spells to avoid repeated lookups
core.affixMobsAuraSpells = {}

for _, val in pairs(core.affixMobsAuras) do
    core.affixMobsAuraSpells[val.spellId] = val
    core.affixMobsAuraSpells[val.spellName] = val
end

-- Cache the affix mobs that cast to avoid repeated lookups
core.affixMobsCastersLookup = {}

for _, val in pairs(core.affixMobsCasters) do
    core.affixMobsCastersLookup[val] = true
end

-- Cache the affix mobs to avoid repeated lookups
core.affixMobsLookup = {}

for _, val in pairs(core.affixMobs) do
    core.affixMobsLookup[val] = true
end

-- Cache core.roles to avoid repeated lookups
core.rolesLookup = {}

for _, val in pairs(core.roles) do
    core.rolesLookup[val.value] = val.label
end

-- Raid markers to use for affix mobs
core.markers = {
    {
        index = 1,
        name = "Star",
        value = "star",
        icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1",
    },
    {
        index = 2,
        name = "Circle",
        value = "circle",
        icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_2",
    },
    {
        index = 3,
        name = "Diamond",
        value = "diamond",
        icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_3",
    },
    {
        index = 4,
        name = "Triangle",
        value = "triangle",
        icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_4",
    },
    {
        index = 5,
        name = "Moon",
        value = "moon",
        icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_5",
    },
    {
        index = 6,
        name = "Square",
        value = "square",
        icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_6",
    },
    {
        index = 7,
        name = "Cross",
        value = "cross",
        icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_7",
    },
    {
        index = 8,
        name = "Skull",
        value = "skull",
        icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8",
    },
}

-- Incorporeal Beings count as every creature type. List of all players' crowd control spells that work on them, which will fear, incapacitate, or stun for 8 seconds or more:
core.incorporealBeingCCSpells = {
    5782, -- Fear
    8122, -- Psychic Scream
    6358, -- Seduction
    115268, -- Mesmerize
    115078, -- Paralysis
    20066, -- Repentance
    9484, -- Shackle Undead
    605, -- Mind Control
    2094, -- Blind
    1776, -- Gouge
    6770, -- Sap
    51514, -- Hex
    217832, -- Imprison
    118, -- Polymorph
    28272, -- Polymorph (pig)
    28271, -- Polymorph (turtle)
    61305, -- Polymorph (black cat)
    61721, -- Polymorph (rabbit)
    61780, -- Polymorph (turkey)
    161353, -- Polymorph (bear cub)
    161354, -- Polymorph (monkey)
    161355, -- Polymorph (penguin)
    161372, -- Polymorph (peacock)
    277787, -- Polymorph (baby direhorn)
    277792, -- Polymorph (bumblebee)
    10326, -- Turn Evil
    1513, -- Scare Beast
    14326, -- Scare Beast
    14327, -- Scare Beast
    14328, -- Scare Beast
    14329, -- Scare Beast
    27044, -- Scare Beast
    49050, -- Scare Beast
    50519, -- Scare Beast
    50520, -- Scare Beast
}

core.eventSubscriptions = {
    -- Enter / exit combat
    "PLAYER_REGEN_ENABLED", -- Exit Combat
    "PLAYER_REGEN_DISABLED", -- Enter Combat

    -- Group
    "PLAYER_ROLES_ASSIGNED", -- Role change
    "ENCOUNTER_START", -- Boss start
    "ENCOUNTER_END", -- Boss end
    "CHALLENGE_MODE_START", -- M+ start
    "CHALLENGE_MODE_COMPLETED", -- M+ complete

    -- Unit Actions
    "UNIT_SPELLCAST_START",
    "UNIT_SPELLCAST_SUCCEEDED",
    "UNIT_SPELLCAST_INTERRUPTED",

    -- Self
    "PLAYER_TARGET_CHANGED",
    "COMBAT_LOG_EVENT_UNFILTERED",

    -- Battle.net friends
    "BN_FRIEND_INFO_CHANGED",
}

NC_EVENT_TYPE_GROUP = 0
NC_EVENT_TYPE_GUILD = 1
NC_EVENT_TYPE_MAXIMUM = 1 -- Used for logic that validates event types, increase as more are added

NemesisChat:RegisterGlobalLookup("NC_EVENT_TYPE_", "Events")

-- We reference this in a few areas, if Details is not installed, we need to set these to something
if not DETAILS_SEGMENTID_OVERALL then
    DETAILS_SEGMENTID_OVERALL = -1
    DETAILS_SEGMENTID_CURRENT = 0
end

NCEvent = {}
NCController = {}
NCSpell = {}

core.db = DeepCopy(core.defaults)
