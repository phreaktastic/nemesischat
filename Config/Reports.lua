-----------------------------------------------------
-- CONFIGURATION UI
-----------------------------------------------------
-- Reports Tab
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

core.options.args.reportsGroup = {
    order = 3,
    type = "group",
    name = "Reports",
    args = {
        -- Damage Reporting
        damageHeader = {
            order = 0,
            type = "header",
            name = "Damage Dealt (DPS) Reporting (Details! required)",
        },
        damagePaddingTop = {
            order = 1,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        topDamageToggle = {
            order = 2,
            type = "toggle",
            name = "Report Top Damage",
            desc = "Toggle reporting the highest damage dealt",
            get = function() return core.db.profile.reportConfig["DAMAGE"]["TOP"] end,
            set = function(info, value) core.db.profile.reportConfig["DAMAGE"]["TOP"] = value end,
            disabled = function() return core.db.profile.detailsAPI == false end,
        },
        bottomDamageToggle = {
            order = 3,
            type = "toggle",
            name = "Report Bottom Damage",
            desc = "Toggle reporting the lowest damage dealt",
            get = function() return core.db.profile.reportConfig["DAMAGE"]["BOTTOM"] end,
            set = function(info, value) core.db.profile.reportConfig["DAMAGE"]["BOTTOM"] = value end,
            disabled = function() return core.db.profile.detailsAPI == false end,
        },
        combatDmgToggle = {
            order = 4,
            type = "toggle",
            name = "Report After Combat",
            desc = "Toggle reporting damage after all combat segments",
            get = function() return core.db.profile.reportConfig["DAMAGE"]["COMBAT"] end,
            set = function(info, value) core.db.profile.reportConfig["DAMAGE"]["COMBAT"] = value end,
            disabled = function() return core.db.profile.detailsAPI == false end,
        },
        bossDmgToggle = {
            order = 5,
            type = "toggle",
            name = "Report After Bosses",
            desc = "Toggle reporting damage after bosses",
            get = function() return core.db.profile.reportConfig["DAMAGE"]["BOSS"] end,
            set = function(info, value) core.db.profile.reportConfig["DAMAGE"]["BOSS"] = value end,
            disabled = function() return core.db.profile.detailsAPI == false end,
        },
        dungeonDmgToggle = {
            order = 6,
            type = "toggle",
            name = "Report After M+ Dungeons",
            desc = "Toggle reporting damage after M+ completion",
            get = function() return core.db.profile.reportConfig["DAMAGE"]["DUNGEON"] end,
            set = function(info, value) core.db.profile.reportConfig["DAMAGE"]["DUNGEON"] = value end,
            disabled = function() return core.db.profile.detailsAPI == false end,
        },
        damagePaddingBottom = {
            order = 7,
            type = "description",
            fontSize = "large",
            name = " ",
        },

        -- Avoidable Damage Reporting
        adHeader = {
            order = 8,
            type = "header",
            name = "Avoidable Damage Taken Reporting (GTFO required)",
        },
        adPaddingTop = {
            order = 9,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        topAdToggle = {
            order = 10,
            type = "toggle",
            name = "Report Top Avoidable Damage Taken",
            desc = "Toggle reporting the highest amount of avoidable damage taken",
            get = function() return core.db.profile.reportConfig["AVOIDABLE"]["TOP"] end,
            set = function(info, value) core.db.profile.reportConfig["AVOIDABLE"]["TOP"] = value end,
            disabled = function() return core.db.profile.gtfoAPI == false end,
        },
        bottomAdToggle = {
            order = 11,
            type = "toggle",
            name = "Report Bottom Avoidable Damage Taken",
            desc = "Toggle reporting the lowest amount of avoidable damage taken",
            get = function() return core.db.profile.reportConfig["AVOIDABLE"]["BOTTOM"] end,
            set = function(info, value) core.db.profile.reportConfig["AVOIDABLE"]["BOTTOM"] = value end,
            disabled = function() return core.db.profile.gtfoAPI == false end,
        },
        combatAdToggle = {
            order = 12,
            type = "toggle",
            name = "Report After Combat",
            desc = "Toggle reporting avoidable damage after all combat segments",
            get = function() return core.db.profile.reportConfig["AVOIDABLE"]["COMBAT"] end,
            set = function(info, value) core.db.profile.reportConfig["AVOIDABLE"]["COMBAT"] = value end,
            disabled = function() return core.db.profile.gtfoAPI == false end,
        },
        bossAdToggle = {
            order = 13,
            type = "toggle",
            name = "Report After Bosses",
            desc = "Toggle reporting avoidable damage after bosses",
            get = function() return core.db.profile.reportConfig["AVOIDABLE"]["BOSS"] end,
            set = function(info, value) core.db.profile.reportConfig["AVOIDABLE"]["BOSS"] = value end,
            disabled = function() return core.db.profile.gtfoAPI == false end,
        },
        dungeonAdToggle = {
            order = 14,
            type = "toggle",
            name = "Report After M+ Dungeons",
            desc = "Toggle reporting avoidable damage after M+ completion",
            get = function() return core.db.profile.reportConfig["AVOIDABLE"]["DUNGEON"] end,
            set = function(info, value) core.db.profile.reportConfig["AVOIDABLE"]["DUNGEON"] = value end,
            disabled = function() return core.db.profile.gtfoAPI == false end,
        },
        adPaddingBottom = {
            order = 15,
            type = "description",
            fontSize = "large",
            name = " ",
        },

        -- Interrupts Reporting
        interruptsHeader = {
            order = 16,
            type = "header",
            name = "Interrupts Reporting",
        },
        interruptsPaddingTop = {
            order = 17,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        topInterruptsToggle = {
            order = 18,
            type = "toggle",
            name = "Report Top Interrupts",
            desc = "Toggle reporting the highest amount of interrupts",
            get = function() return core.db.profile.reportConfig["INTERRUPTS"]["TOP"] end,
            set = function(info, value) core.db.profile.reportConfig["INTERRUPTS"]["TOP"] = value end,
        },
        bottomInterruptsToggle = {
            order = 19,
            type = "toggle",
            name = "Report Bottom Interrupts",
            desc = "Toggle reporting the lowest amount of interrupts",
            get = function() return core.db.profile.reportConfig["INTERRUPTS"]["BOTTOM"] end,
            set = function(info, value) core.db.profile.reportConfig["INTERRUPTS"]["BOTTOM"] = value end,
        },
        combatInterruptsToggle = {
            order = 20,
            type = "toggle",
            name = "Report After Combat",
            desc = "Toggle reporting interrupts after all combat segments",
            get = function() return core.db.profile.reportConfig["INTERRUPTS"]["COMBAT"] end,
            set = function(info, value) core.db.profile.reportConfig["INTERRUPTS"]["COMBAT"] = value end,
        },
        bossInterruptsToggle = {
            order = 21,
            type = "toggle",
            name = "Report After Bosses",
            desc = "Toggle reporting interrupts after bosses",
            get = function() return core.db.profile.reportConfig["INTERRUPTS"]["BOSS"] end,
            set = function(info, value) core.db.profile.reportConfig["INTERRUPTS"]["BOSS"] = value end,
        },
        dungeonInterruptsToggle = {
            order = 22,
            type = "toggle",
            name = "Report After M+ Dungeons",
            desc = "Toggle reporting interrupts after M+ completion",
            get = function() return core.db.profile.reportConfig["INTERRUPTS"]["DUNGEON"] end,
            set = function(info, value) core.db.profile.reportConfig["INTERRUPTS"]["DUNGEON"] = value end,
        },
        interruptsPaddingBottom = {
            order = 23,
            type = "description",
            fontSize = "large",
            name = " ",
        },
    },
}