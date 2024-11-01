-----------------------------------------------------
-- MIGRATIONS
-----------------------------------------------------
-- Migrations to update certain stored data to be  --
-- compatible with current versions.               --
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-- Config restructuring migration
NCMigration:New("20241024_message_restructure")
    :SetLessThanVersion("2.0.0")
-- Combat & Integration Settings
    :AddBulkTransform({
        -- Current message state
        ["currentMessage"] = "messageSystem.globalSettings.currentMessage",
        ["currentCategory"] = "messageSystem.globalSettings.currentCategory",
        ["currentEvent"] = "messageSystem.globalSettings.currentEvent",
        ["currentTarget"] = "messageSystem.globalSettings.currentTarget",

        -- Preview settings
        ["previewSpell"] = "messageSystem.globalSettings.previewSpell",
        ["lastPreviewUpdate"] = "messageSystem.globalSettings.lastPreviewUpdate",

        -- Add to existing excludeNemeses transform
        ["reportConfig.excludeNemeses"] = "messageSystem.globalSettings.excludeNemeses",

        ["nonCombatMode"] = "messageSystem.nonCombatMode",
        ["interruptException"] = "messageSystem.interruptException",
        ["deathException"] = "messageSystem.deathException",
        ["avoidableDamageException"] = "messageSystem.avoidableDamageException",
        ["allowBrannMessages"] = "messageSystem.allowBrannMessages",
        ["flagFriendsAsNemeses"] = "messageSystem.flagFriendsAsNemeses",
        ["flagGuildmatesAsNemeses"] = "messageSystem.flagGuildmatesAsNemeses",

        -- Global Settings
        ["messagesEnabled"] = "messageSystem.enabled",
        ["rollingMessages"] = "messageSystem.globalSettings.rollingMessages",
        ["useGlobalChance"] = "messageSystem.globalSettings.useGlobalChance",
        ["globalChance"] = "messageSystem.globalSettings.globalChance",
        ["minimumTime"] = "messageSystem.globalSettings.minimumTime",
        ["reportConfig.channel"] = "messageSystem.globalSettings.defaultChannel",

        -- Combat Messages
        ["reportConfig.DAMAGE.TOP"] = "messageSystem.categories.combat.types.damage.reportTop",
        ["reportConfig.DAMAGE.BOTTOM"] = "messageSystem.categories.combat.types.damage.reportBottom",
        ["reportConfig.DAMAGE.COMBAT"] = "messageSystem.categories.combat.types.damage.triggers.afterCombat",
        ["reportConfig.DAMAGE.BOSS"] = "messageSystem.categories.combat.types.damage.triggers.afterBoss",
        ["reportConfig.DAMAGE.DUNGEON"] = "messageSystem.categories.combat.types.damage.triggers.afterDungeon",

        ["reportConfig.INTERRUPTS.TOP"] = "messageSystem.categories.combat.types.interrupts.reportTop",
        ["reportConfig.INTERRUPTS.BOTTOM"] = "messageSystem.categories.combat.types.interrupts.reportBottom",
        ["reportConfig.INTERRUPTS.COMBAT"] = "messageSystem.categories.combat.types.interrupts.triggers.afterCombat",
        ["reportConfig.INTERRUPTS.BOSS"] = "messageSystem.categories.combat.types.interrupts.triggers.afterBoss",
        ["reportConfig.INTERRUPTS.DUNGEON"] = "messageSystem.categories.combat.types.interrupts.triggers.afterDungeon",

        ["reportConfig.AVOIDABLE.TOP"] = "messageSystem.categories.combat.types.avoidable.reportTop",
        ["reportConfig.AVOIDABLE.BOTTOM"] = "messageSystem.categories.combat.types.avoidable.reportBottom",
        ["reportConfig.AVOIDABLE.COMBAT"] = "messageSystem.categories.combat.types.avoidable.triggers.afterCombat",
        ["reportConfig.AVOIDABLE.BOSS"] = "messageSystem.categories.combat.types.avoidable.triggers.afterBoss",
        ["reportConfig.AVOIDABLE.DUNGEON"] = "messageSystem.categories.combat.types.avoidable.triggers.afterDungeon",

        ["reportConfig.DEATHS.TOP"] = "messageSystem.categories.combat.types.deaths.reportTop",
        ["reportConfig.DEATHS.BOTTOM"] = "messageSystem.categories.combat.types.deaths.reportBottom",
        ["reportConfig.DEATHS.COMBAT"] = "messageSystem.categories.combat.types.deaths.triggers.afterCombat",
        ["reportConfig.DEATHS.BOSS"] = "messageSystem.categories.combat.types.deaths.triggers.afterBoss",
        ["reportConfig.DEATHS.DUNGEON"] = "messageSystem.categories.combat.types.deaths.triggers.afterDungeon",

        ["reportConfig.OFFHEALS.TOP"] = "messageSystem.categories.combat.types.offHeals.reportTop",
        ["reportConfig.OFFHEALS.BOTTOM"] = "messageSystem.categories.combat.types.offHeals.reportBottom",
        ["reportConfig.OFFHEALS.COMBAT"] = "messageSystem.categories.combat.types.offHeals.triggers.afterCombat",
        ["reportConfig.OFFHEALS.BOSS"] = "messageSystem.categories.combat.types.offHeals.triggers.afterBoss",
        ["reportConfig.OFFHEALS.DUNGEON"] = "messageSystem.categories.combat.types.offHeals.triggers.afterDungeon",

        -- Pull Messages
        ["reportConfig.PULLS.REALTIME"] = "messageSystem.categories.dungeon.types.pulls.realtime",
        ["reportConfig.PULLS.CHANNEL"] = "messageSystem.categories.dungeon.types.pulls.channel",
        ["reportConfig.PULLS.TOAST"] = "messageSystem.categories.dungeon.types.pulls.showToast",

        -- Player Messages
        ["trackLeavers"] = "messageSystem.categories.player.types.leave.trackHistory",
        ["reportLeaversOnJoin"] = "messageSystem.categories.player.types.join.reportLeaverHistory",
        ["reportLeaversOnJoinThreshold"] = "messageSystem.categories.player.types.join.leaverThreshold",
        ["trackLowPerformers"] = "messageSystem.categories.player.types.join.reportPerformanceHistory",
        ["reportLowPerformersOnJoinThreshold"] = "messageSystem.categories.player.types.join.performanceThreshold",

        -- LFG Settings to camelCase structure
        ["notifyApplicantGlobalMinItemLevel"] = "lfg.applicants.global.minItemLevel",
        ["notifyApplicantGlobalMinDungeonScore"] = "lfg.applicants.global.minDungeonScore",
        ["notifyApplicantGlobalPopupOnIgnoredApplicants"] = "lfg.applicants.global.popupOnIgnoredApplicants",
        ["notifyApplicantGlobalAllowedRealms"] = "lfg.applicants.global.allowedRealms",
        ["notifyApplicantGlobalIgnoredRealms"] = "lfg.applicants.global.ignoredRealms",
        ["notifyApplicantGlobalAllowedClasses"] = "lfg.applicants.global.allowedClasses",
        ["notifyApplicantGlobalIgnoredClasses"] = "lfg.applicants.global.ignoredClasses",
        ["notifyApplicantGlobalAllowedSpecs"] = "lfg.applicants.global.allowedSpecs",
        ["notifyApplicantGlobalIgnoredSpecs"] = "lfg.applicants.global.ignoredSpecs",

        -- Tank Settings
        ["notifyWhenTankApplies"] = "lfg.applicants.roles.tank.enabled",
        ["notifyWhenTankAppliesSound"] = "lfg.applicants.roles.tank.sound",
        ["notifyWhenTankAppliesChat"] = "lfg.applicants.roles.tank.chat",
        ["notifyWhenTankAppliesMinItemLevel"] = "lfg.applicants.roles.tank.minItemLevel",
        ["notifyWhenTankAppliesMinDungeonScore"] = "lfg.applicants.roles.tank.minDungeonScore",

        -- Healer Settings
        ["notifyWhenHealerApplies"] = "lfg.applicants.roles.healer.enabled",
        ["notifyWhenHealerAppliesSound"] = "lfg.applicants.roles.healer.sound",
        ["notifyWhenHealerAppliesChat"] = "lfg.applicants.roles.healer.chat",
        ["notifyWhenHealerAppliesMinItemLevel"] = "lfg.applicants.roles.healer.minItemLevel",
        ["notifyWhenHealerAppliesMinDungeonScore"] = "lfg.applicants.roles.healer.minDungeonScore",

        -- DPS Settings
        ["notifyWhenDPSApplies"] = "lfg.applicants.roles.dps.enabled",
        ["notifyWhenDPSAppliesSound"] = "lfg.applicants.roles.dps.sound",
        ["notifyWhenDPSAppliesChat"] = "lfg.applicants.roles.dps.chat",
        ["notifyWhenDPSAppliesMinItemLevel"] = "lfg.applicants.roles.dps.minItemLevel",
        ["notifyWhenDPSAppliesMinDungeonScore"] = "lfg.applicants.roles.dps.minDungeonScore"
    })
    :SetExec(function()
        -- Ensure default values for new fields if they don't exist
        if not core.db.profile.messageSystem.globalSettings.currentMessage then
            core.db.profile.messageSystem.globalSettings.currentMessage = ""
        end
        if not core.db.profile.messageSystem.globalSettings.currentCategory then
            core.db.profile.messageSystem.globalSettings.currentCategory = ""
        end
        if not core.db.profile.messageSystem.globalSettings.currentEvent then
            core.db.profile.messageSystem.globalSettings.currentEvent = ""
        end
        if not core.db.profile.messageSystem.globalSettings.currentTarget then
            core.db.profile.messageSystem.globalSettings.currentTarget = ""
        end
        if not core.db.profile.messageSystem.globalSettings.excludeNemeses then
            core.db.profile.messageSystem.globalSettings.excludeNemeses = false
        end
    end)

-- 2024-01-29: Wipes leavers and low performers. Many people were added while this was in development, so it's
-- necessary to wipe the data to avoid errors. This migration is only compatible with versions less than 2.0.0.
-- 2024-02-06: Reset key to wipe all data again.
NCMigration:New("20240206")
    :AddPathToErase("leavers")
    :AddPathToErase("lowPerformers")
    :SetLessThanVersion("2.0.0")
