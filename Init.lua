-----------------------------------------------------
-- INITIALIZATION
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local addonName, core = ...;

core.version = C_AddOns.GetAddOnMetadata(addonName, 'Version')

-----------------------------------------------------
-- Register global NemesisChat
-----------------------------------------------------
NemesisChat = LibStub("AceAddon-3.0"):NewAddon("NemesisChat", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0",
    "AceTimer-3.0", "LibToast-1.0")
LibPlayerSpells = LibStub('LibPlayerSpells-1.0')

-----------------------------------------------------
-- Global functions
-----------------------------------------------------

-- When we don't want a reference (ie, resetting to refaults)
function DeepCopy(orig)
    local orig_type = type(orig)
    if orig_type ~= 'table' then return orig end
    local copy = {}
    for orig_key, orig_value in pairs(orig) do
        if type(orig_value) == 'table' then
            copy[orig_key] = DeepCopy(orig_value)
        else
            copy[orig_key] = orig_value
        end
    end
    return copy
end

function ArrayMerge(...)
    local returnTable = {}
    local tables = { ... }

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
    local maps = { ... }

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
    return NCConfig:IsEnabled()
end

function GetRole(player)
    local role

    if NCRuntime:GetGroupRosterPlayer(player) == nil then
        role = UnitGroupRolesAssigned(player)
    else
        role = NCRuntime:GetGroupRosterPlayer(player).role
    end

    for key, val in pairs(core.roles) do
        if val.value == role then
            return val.label
        end
    end

    return nil
end

function GetKeysSortedByValue(tbl, sortFunction)
    local keys = setmetatable({}, { __mode = "kv" })
    for key in pairs(tbl) do
        table.insert(keys, key)
    end

    table.sort(keys, function(a, b)
        return sortFunction(tbl[a], tbl[b])
    end)

    return keys
end

function Split(str, sep)
    local result = setmetatable({}, { __mode = "kv" })
    local regex = ("([^%s]+)"):format(sep)

    for each in str:gmatch(regex) do
        table.insert(result, each)
    end

    return result
end

function ShuffleTable(t)
    local tbl = setmetatable({}, { __mode = "kv" })
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
    local keys = setmetatable({}, { __mode = "kv" })

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
    [57301] = 0,  -- Great Feast (WotLK)
    [57426] = 0,  -- Fish Feast (WotLK)
    [66476] = 0,  -- Bountiful Feast (Pilgrim's Bounty)
    [87643] = 0,  -- Broiled Dragon Feast (Cata)
    [87644] = 0,  -- Seafood Magnifique Feast (Cata)
    [87915] = 0,  -- Goblin Barbecue (Cata)
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
    [58465] = 0,  -- Gigantic Feast (WotLK)
    [58474] = 0,  -- Small Feast (WotLK)
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
    [382427] = 0, -- Grand Banquet of the Kalu'ak (DF)
    [382423] = 0, -- Yusa's Hearty Stew (DF)
    [383063] = 0, -- Hoard of Draconic Delicacies (DF)
    -- Additions from NemesisChat Below --

    -- The War Within
    [222735] = 1, -- Everything Stew
    [222734] = 1, -- Village Potluck
    [222733] = 1, -- Feast of the Midnight Masquerade
    [222732] = 1, -- Feast of the Divine Day
    [222720] = 1, -- The Sushi Special
}

-- Cache core.roles to avoid repeated lookups
core.rolesLookup = {}

for _, val in pairs(core.roles) do
    core.rolesLookup[val.value] = val.label
end

-- Raid markers
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

NC_PULL_EVENT_ATTACK = 0
NC_PULL_EVENT_AGGRO = 1
NC_PULL_EVENT_PET = 2

NC_EVENT_TYPE_GROUP = 0
NC_EVENT_TYPE_GUILD = 1
NC_EVENT_TYPE_MAXIMUM = 1 -- Used for logic that validates event types, increase as more are added

-- We reference this in a few areas, if Details is not installed, we need to set these to something
if not DETAILS_SEGMENTID_OVERALL then
    DETAILS_SEGMENTID_OVERALL = -1
    DETAILS_SEGMENTID_CURRENT = 0
end

-- NCEvent = {}
-- NCController = {}
-- NCSpell = {}

C_Timer.NewTicker(0.1, function() if IsNCEnabled() then NemesisChat:CheckGuild() end end)
-- This was a fun experiment, it might be fun to expose it to users
-- C_Timer.NewTicker(0.25, function()
--     if NemesisChat:HasPartyNemeses() and not IsInInstance() then
--         local nemesisName = NemesisChat:GetRandomPartyNemesis()
--         local nemesis = NCRuntime:GetGroupRosterPlayer(nemesisName)
--         SetRaidTarget(nemesis.token, math.random(8))
--     end
-- end)
C_Timer.NewTicker(5, function() if IsNCEnabled() then NemesisChat:LowPriorityTimer() end end)
C_Timer.NewTicker(60, function()
    if not NCCombat or not NCCombat.IsActive then
        return
    end
    if not NCCombat:IsActive() then
        local count = 0

        for key, val in pairs(core.db.global.lastSync) do
            if GetTime() - val > 1800 then
                count = count + 1

                core.db.global.lastSync[key] = nil
            end

            if count > 100 then
                break
            end
        end
    end
end)
