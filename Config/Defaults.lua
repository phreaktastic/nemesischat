-----------------------------------------------------
-- DEFAULTS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local addonName, core = ...;

core.defaults = {
	profile = {
		enabled = true,
        dbg = false,
        nonCombatMode = true,
        interruptException = true,
        deathException = true,
        ai = false,
        flagFriendsAsNemeses = false,
        flagGuildmatesAsNemeses = false,
        reportConfig = {
            channel = "GROUP",
            excludeNemeses = false,
            reportLowPerformersOnWipe = false,
            reportLowPerformersOnDungeonFail = false,
            ["DAMAGE"] = {
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["COMBAT"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
            },
            ["AVOIDABLE"] = {
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["COMBAT"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
            },
            ["INTERRUPTS"] = {
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["COMBAT"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
            },
            ["DEATHS"] = {
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["COMBAT"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
            },
            ["OFFHEALS"] = {
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["COMBAT"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
            },
            ["PULLS"] = {
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["COMBAT"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
                ["REALTIME"] = false,
            },
            ["NEGLECTEDHEALS"] = {
                ["REALTIME"] = false,
            },
            ["AFFIXES"] = {
                ["CASTSTART"] = false,
                ["CASTINTERRUPTED"] = false,
                ["CASTSUCCESS"] = false,
                ["MARKERS"] = false,
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
                ["AURASTACKS"] = false,
            }
        },
        aiConfig = {
            selected = "taunts",
            overrides = {}
        },
        useGlobalChance = false,
        globalChance = 0.5,
        minimumTime = 1,
        nemeses = {},
        messages = {},
        API = {},
        leavers = {},
        lowPerformers = {},
        statsFrame = {},
        cache = {
            guild = {},
            guildTime = 0,
            friends = {},
            friendsTime = 0,
            groupRoster = {},
            groupRosterTime = 0,
            NCDungeon = {},
            NCDungeonTime = 0,
        },
	},
}