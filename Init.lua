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
NemesisChat = LibStub("AceAddon-3.0"):NewAddon("NemesisChat", "AceConsole-3.0", "AceEvent-3.0")

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
        table.insert(returnTable, val)
    end

    return returnTable
end
-----------------------------------------------------
-- Core options
-----------------------------------------------------
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
        type = "INPUT",
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
        type = "INPUT"
    },
    {
        label = "Nemeses In Group",
        value = "NEMESES_COUNT",
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.EXTENDED_OPERATORS),
        type = "INPUT"
    },
}

if Details ~= nil then
    local conditions = {
        {
            label = "Nemesis DPS (Current)",
            value = "NEMESIS_DPS",
            operators = core.constants.EXTENDED_OPERATORS,
            type = "INPUT"
        },
        {
            label = "My DPS (Current)",
            value = "MY_DPS",
            operators = core.constants.EXTENDED_OPERATORS,
            type = "INPUT"
        },
        {
            label = "Nemesis DPS (Overall)",
            value = "NEMESIS_DPS_OVERALL",
            operators = core.constants.EXTENDED_OPERATORS,
            type = "INPUT"
        },
        {
            label = "My DPS (Overall)",
            value = "MY_DPS_OVERALL",
            operators = core.constants.EXTENDED_OPERATORS,
            type = "INPUT"
        },
    }

    for key, val in pairs(conditions) do
        table.insert(core.messageConditions, val)
    end
end

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
    ["WHISPER"] = "Whisper Nemesis",
}

core.reference = {
    replacements = {
        ["[TARGET]"] = "The target of an event. Usable on |c00ffcc00Interrupt|r and |c00ffcc00Unit Killed|r.",
        ["[SPELL]"] = "The spell which was cast or interrupted. Can be used to link feasts in feast events. Usable on |c00ffcc00Interrupt|r and |c00ffcc00Feast|r triggers.",
        ["[NEMESIS]"] = "The nemesis which was used for an event. In the case of triggers like |c00ffcc00Death|r, it'll be the |c00ffcc00Nemesis|r who died. In other cases, a random |c00ffcc00Nemesis|r will be chosen if more than one are in your party.",
        ["[SELF]"] = "Your character's name. Usable on all triggers.",
        ["[NEMESISDEATHS"] = "The number of deaths a |c00ffcc00Nemesis|r has. In the case of triggers like |c00ffcc00Death|r, it'll be the |c00ffcc00Nemesis|r who died. In other cases, a random |c00ffcc00Nemesis|r will be chosen if more than one are in your party. Usable on all triggers which do not ignore |c00ffcc00Unit|r.",
        ["[NEMESISKILLS"] = "The number of units a |c00ffcc00Nemesis|r has killed. In the case of triggers like |c00ffcc00Death|r, it'll be the |c00ffcc00Nemesis|r who died. In other cases, a random |c00ffcc00Nemesis|r will be chosen if more than one are in your party. Usable on all triggers which do not ignore |c00ffcc00Unit|r.",
        ["[DEATHS]"] = "The number of deaths you have. Usable on all triggers.",
        ["[KILLS]"] = "The number of units you have killed. Usable on all triggers.",
        ["[KEYSTONELEVEL]"] = "The level of the Mythic+ Keystone. Usable on all triggers, but may not be available.",
        ["[BOSSTIME]"] = "The duration of a boss fight in the format '|c00ffcc00X|rmin |c00ffcc00Y|rsec'. Usable on all triggers, but may not be available.",
        ["[BOSSNAME]"] = "The name of the boss. Usable on all triggers, but may not be available.",
        ["[DUNGEONTIME]"] = "The amount of time in a Mythic+ dungeon. Usable on all triggers, but may not be available.",
        ["[BYSTANDER]"] = "Name of a random bystander (non-nemesis) in the group. Usable on all triggers. Will be the player triggering any |c00ffcc00Bystander|r triggers.",
        ["[NEMESISDPS]"] = "|c00ffcc00Details! API Required|r. The chosen Nemesis's current DPS.",
        ["[DPS]"] = "|c00ffcc00Details! API Required|r. Your current DPS.",
        ["[NEMESISDPSOVERALL]"] = "|c00ffcc00Details! API Required|r. The chosen Nemesis's overall DPS.",
        ["[DPSOVERALL]"] = "|c00ffcc00Details! API Required|r. Your overall DPS.",
    },
    colors = {
        ["SAY"] = "|cffffffff",
        ["EMOTE"] = "|cffff8040",
        ["GROUP"] = "|cffaaaaff",
        ["PARTY"] = "|cffaaaaff",
        ["YELL"] = "|cffff4040",
        ["WHISPER"] = "|cffff80ff",
    }
}

-- This is janky, and is a relic from the very first iteration. To be refactored later.
core.supportedReplacements = {
    ["%[TARGET%]"] = "target",
    ["%[SPELL%]"] = "spell",
    ["%[NEMESIS%]"] = "nemesis",
    ["%[SELF%]"] = "self",
    ["%[NEMESISDEATHS%]"] = "nemesisDeaths",
    ["%[NEMESISKILLS%]"] = "nemesisKills",
    ["%[KILLS%]"] = "kills",
    ["%[DEATHS%]"] = "deaths",
    ["%[KEYSTONELEVEL%]"] = "keystoneLevel",
    ["%[BOSSTIME%]"] = "bossTime",
    ["%[BOSSNAME%]"] = "bossName",
    ["%[DUNGEONTIME%]"] = "dungeonTime",
    ["%[BYSTANDER%]"] = "bystander",
}

function NemesisChat:GetReplacementTooltip()
    local tip = ""

    for key, value in pairs(core.reference.replacements) do 
        tip = tip .. "|c00ffcc00" .. key .. "|r: " .. value .. "\n"
    end

    return tip
end

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

-----------------------------------------------------
-- Core tracking initialization
-----------------------------------------------------
core.runtimeDefaults = {
    myName = "",
    lastFeast = 0,
    lastMessage = 0,
    replacements = {},
    deathCounter = {},
    killCounter = {},
    groupRoster = {},
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
    },
    ncDungeon = {
        active = false,
        level = 0,
        startTime = 0,
        completeTime = 0,
        totalTime = 0,
        complete = false,
        success = false,
        deathCounter = {},
        killCounter = {},
    },
    ncBoss = {
        active = false,
        startTime = 0,
        name = "",
        complete = false,
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
    }
}

NCEvent = {}
NCMessage = {}
NCDungeon = {}
NCBoss = {}
NCSpell = {}
