-----------------------------------------------------
-- CONFIG
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Model for interacting with user config
-----------------------------------------------------

-- Blizzard functions
local GetTime = GetTime

NCConfig = {
    IsEnabled = function()
        return core.db.profile.enabled
    end,
    ToggleEnabled = function()
        core.db.profile.enabled = not core.db.profile.enabled
    end,
    SetEnabled = function(value)
        core.db.profile.enabled = value
    end,
    IsDebugging = function()
        return core.db.profile.dbg
    end,
    ToggleDebugging = function()
        core.db.profile.dbg = not core.db.profile.dbg
    end,
    SetDebugging = function(value)
        core.db.profile.dbg = value
    end,
    IsNonCombatMode = function()
        return core.db.profile.nonCombatMode
    end,
    ToggleNonCombatMode = function()
        core.db.profile.nonCombatMode = not core.db.profile.nonCombatMode
    end,
    SetNonCombatMode = function(value)
        core.db.profile.nonCombatMode = value
    end,
    IsAIEnabled = function()
        return core.db.profile.ai
    end,
    ToggleAI = function()
        core.db.profile.ai = not core.db.profile.ai
    end,
    SetAI = function(value)
        core.db.profile.ai = value
    end,
    IsFlaggingFriendsAsNemeses = function()
        return core.db.profile.flagFriendsAsNemeses
    end,
    ToggleFlaggingFriendsAsNemeses = function()
        core.db.profile.flagFriendsAsNemeses = not core.db.profile.flagFriendsAsNemeses
    end,
    SetFlaggingFriendsAsNemeses = function(value)
        core.db.profile.flagFriendsAsNemeses = value
    end,
    IsFlaggingGuildmatesAsNemeses = function()
        return core.db.profile.flagGuildmatesAsNemeses
    end,
    ToggleFlaggingGuildmatesAsNemeses = function()
        core.db.profile.flagGuildmatesAsNemeses = not core.db.profile.flagGuildmatesAsNemeses
    end,
    SetFlaggingGuildmatesAsNemeses = function(value)
        core.db.profile.flagGuildmatesAsNemeses = value
    end,
    GetReportChannel = function()
        return core.db.profile.reportConfig.channel
    end,
    SetReportChannel = function(value)
        core.db.profile.reportConfig.channel = value
    end,
    IsExcludingNemeses = function()
        return core.db.profile.reportConfig.excludeNemeses
    end,
    ToggleExcludingNemeses = function()
        core.db.profile.reportConfig.excludeNemeses = not core.db.profile.reportConfig.excludeNemeses
    end,
    SetExcludingNemeses = function(value)
        core.db.profile.reportConfig.excludeNemeses = value
    end,
    IsReportingLowPerformersOnWipe = function()
        return core.db.profile.reportConfig.reportLowPerformersOnWipe
    end,
    ToggleReportingLowPerformersOnWipe = function()
        core.db.profile.reportConfig.reportLowPerformersOnWipe = not core.db.profile.reportConfig.reportLowPerformersOnWipe
    end,
    SetReportingLowPerformersOnWipe = function(value)
        core.db.profile.reportConfig.reportLowPerformersOnWipe = value
    end,
    IsReportingLowPerformersOnDungeonFail = function()
        return core.db.profile.reportConfig.reportLowPerformersOnDungeonFail
    end,
    ToggleReportingLowPerformersOnDungeonFail = function()
        core.db.profile.reportConfig.reportLowPerformersOnDungeonFail = not core.db.profile.reportConfig.reportLowPerformersOnDungeonFail
    end,
    SetReportingLowPerformersOnDungeonFail = function(value)
        core.db.profile.reportConfig.reportLowPerformersOnDungeonFail = value
    end,
    IsReportingDamage_Combat = function()
        return core.db.profile.reportConfig["DAMAGE"]["COMBAT"]
    end,
    ToggleReportingDamage_Combat = function()
        core.db.profile.reportConfig["DAMAGE"]["COMBAT"] = not core.db.profile.reportConfig["DAMAGE"]["COMBAT"]
    end,
    SetReportingDamage_Combat = function(value)
        core.db.profile.reportConfig["DAMAGE"]["COMBAT"] = value
    end,
    IsReportingDamage_Boss = function()
        return core.db.profile.reportConfig["DAMAGE"]["BOSS"]
    end,
    ToggleReportingDamage_Boss = function()
        core.db.profile.reportConfig["DAMAGE"]["BOSS"] = not core.db.profile.reportConfig["DAMAGE"]["BOSS"]
    end,
    SetReportingDamage_Boss = function(value)
        core.db.profile.reportConfig["DAMAGE"]["BOSS"] = value
    end,
    IsReportingDamage_Dungeon = function()
        return core.db.profile.reportConfig["DAMAGE"]["DUNGEON"]
    end,
    ToggleReportingDamage_Dungeon = function()
        core.db.profile.reportConfig["DAMAGE"]["DUNGEON"] = not core.db.profile.reportConfig["DAMAGE"]["DUNGEON"]
    end,
    SetReportingDamage_Dungeon = function(value)
        core.db.profile.reportConfig["DAMAGE"]["DUNGEON"] = value
    end,
    IsReportingDamage_Top = function()
        return core.db.profile.reportConfig["DAMAGE"]["TOP"]
    end,
    ToggleReportingDamage_Top = function()
        core.db.profile.reportConfig["DAMAGE"]["TOP"] = not core.db.profile.reportConfig["DAMAGE"]["TOP"]
    end,
    SetReportingDamage_Top = function(value)
        core.db.profile.reportConfig["DAMAGE"]["TOP"] = value
    end,
    IsReportingDamage_Bottom = function()
        return core.db.profile.reportConfig["DAMAGE"]["BOTTOM"]
    end,
    ToggleReportingDamage_Bottom = function()
        core.db.profile.reportConfig["DAMAGE"]["BOTTOM"] = not core.db.profile.reportConfig["DAMAGE"]["BOTTOM"]
    end,
    SetReportingDamage_Bottom = function(value)
        core.db.profile.reportConfig["DAMAGE"]["BOTTOM"] = value
    end,
    IsReportingAvoidable_Combat = function()
        return core.db.profile.reportConfig["AVOIDABLE"]["COMBAT"]
    end,
    ToggleReportingAvoidable_Combat = function()
        core.db.profile.reportConfig["AVOIDABLE"]["COMBAT"] = not core.db.profile.reportConfig["AVOIDABLE"]["COMBAT"]
    end,
    SetReportingAvoidable_Combat = function(value)
        core.db.profile.reportConfig["AVOIDABLE"]["COMBAT"] = value
    end,
    IsReportingAvoidable_Boss = function()
        return core.db.profile.reportConfig["AVOIDABLE"]["BOSS"]
    end,
    ToggleReportingAvoidable_Boss = function()
        core.db.profile.reportConfig["AVOIDABLE"]["BOSS"] = not core.db.profile.reportConfig["AVOIDABLE"]["BOSS"]
    end,
    SetReportingAvoidable_Boss = function(value)
        core.db.profile.reportConfig["AVOIDABLE"]["BOSS"] = value
    end,
    IsReportingAvoidable_Dungeon = function()
        return core.db.profile.reportConfig["AVOIDABLE"]["DUNGEON"]
    end,
    ToggleReportingAvoidable_Dungeon = function()
        core.db.profile.reportConfig["AVOIDABLE"]["DUNGEON"] = not core.db.profile.reportConfig["AVOIDABLE"]["DUNGEON"]
    end,
    SetReportingAvoidable_Dungeon = function(value)
        core.db.profile.reportConfig["AVOIDABLE"]["DUNGEON"] = value
    end,
    IsReportingAvoidable_Top = function()
        return core.db.profile.reportConfig["AVOIDABLE"]["TOP"]
    end,
    ToggleReportingAvoidable_Top = function()
        core.db.profile.reportConfig["AVOIDABLE"]["TOP"] = not core.db.profile.reportConfig["AVOIDABLE"]["TOP"]
    end,
    SetReportingAvoidable_Top = function(value)
        core.db.profile.reportConfig["AVOIDABLE"]["TOP"] = value
    end,
    IsReportingAvoidable_Bottom = function()
        return core.db.profile.reportConfig["AVOIDABLE"]["BOTTOM"]
    end,
    ToggleReportingAvoidable_Bottom = function()
        core.db.profile.reportConfig["AVOIDABLE"]["BOTTOM"] = not core.db.profile.reportConfig["AVOIDABLE"]["BOTTOM"]
    end,
    SetReportingAvoidable_Bottom = function(value)
        core.db.profile.reportConfig["AVOIDABLE"]["BOTTOM"] = value
    end,
    IsReportingInterrupts_Combat = function()
        return core.db.profile.reportConfig["INTERRUPTS"]["COMBAT"]
    end,
    ToggleReportingInterrupts_Combat = function()
        core.db.profile.reportConfig["INTERRUPTS"]["COMBAT"] = not core.db.profile.reportConfig["INTERRUPTS"]["COMBAT"]
    end,
    SetReportingInterrupts_Combat = function(value)
        core.db.profile.reportConfig["INTERRUPTS"]["COMBAT"] = value
    end,
    IsReportingInterrupts_Boss = function()
        return core.db.profile.reportConfig["INTERRUPTS"]["BOSS"]
    end,
    ToggleReportingInterrupts_Boss = function()
        core.db.profile.reportConfig["INTERRUPTS"]["BOSS"] = not core.db.profile.reportConfig["INTERRUPTS"]["BOSS"]
    end,
    SetReportingInterrupts_Boss = function(value)
        core.db.profile.reportConfig["INTERRUPTS"]["BOSS"] = value
    end,
    IsReportingInterrupts_Dungeon = function()
        return core.db.profile.reportConfig["INTERRUPTS"]["DUNGEON"]
    end,
    ToggleReportingInterrupts_Dungeon = function()
        core.db.profile.reportConfig["INTERRUPTS"]["DUNGEON"] = not core.db.profile.reportConfig["INTERRUPTS"]["DUNGEON"]
    end,
    SetReportingInterrupts_Dungeon = function(value)
        core.db.profile.reportConfig["INTERRUPTS"]["DUNGEON"] = value
    end,
    IsReportingInterrupts_Top = function()
        return core.db.profile.reportConfig["INTERRUPTS"]["TOP"]
    end,
    ToggleReportingInterrupts_Top = function()
        core.db.profile.reportConfig["INTERRUPTS"]["TOP"] = not core.db.profile.reportConfig["INTERRUPTS"]["TOP"]
    end,
    SetReportingInterrupts_Top = function(value)
        core.db.profile.reportConfig["INTERRUPTS"]["TOP"] = value
    end,
    IsReportingInterrupts_Bottom = function()
        return core.db.profile.reportConfig["INTERRUPTS"]["BOTTOM"]
    end,
    ToggleReportingInterrupts_Bottom = function()
        core.db.profile.reportConfig["INTERRUPTS"]["BOTTOM"] = not core.db.profile.reportConfig["INTERRUPTS"]["BOTTOM"]
    end,
    SetReportingInterrupts_Bottom = function(value)
        core.db.profile.reportConfig["INTERRUPTS"]["BOTTOM"] = value
    end,
    IsReportingDeaths_Combat = function()
        return core.db.profile.reportConfig["DEATHS"]["COMBAT"]
    end,
    ToggleReportingDeaths_Combat = function()
        core.db.profile.reportConfig["DEATHS"]["COMBAT"] = not core.db.profile.reportConfig["DEATHS"]["COMBAT"]
    end,
    SetReportingDeaths_Combat = function(value)
        core.db.profile.reportConfig["DEATHS"]["COMBAT"] = value
    end,
    IsReportingDeaths_Boss = function()
        return core.db.profile.reportConfig["DEATHS"]["BOSS"]
    end,
    ToggleReportingDeaths_Boss = function()
        core.db.profile.reportConfig["DEATHS"]["BOSS"] = not core.db.profile.reportConfig["DEATHS"]["BOSS"]
    end,
    SetReportingDeaths_Boss = function(value)
        core.db.profile.reportConfig["DEATHS"]["BOSS"] = value
    end,
    IsReportingDeaths_Dungeon = function()
        return core.db.profile.reportConfig["DEATHS"]["DUNGEON"]
    end,
    ToggleReportingDeaths_Dungeon = function()
        core.db.profile.reportConfig["DEATHS"]["DUNGEON"] = not core.db.profile.reportConfig["DEATHS"]["DUNGEON"]
    end,
    SetReportingDeaths_Dungeon = function(value)
        core.db.profile.reportConfig["DEATHS"]["DUNGEON"] = value
    end,
    IsReportingDeaths_Top = function()
        return core.db.profile.reportConfig["DEATHS"]["TOP"]
    end,
    ToggleReportingDeaths_Top = function()
        core.db.profile.reportConfig["DEATHS"]["TOP"] = not core.db.profile.reportConfig["DEATHS"]["TOP"]
    end,
    SetReportingDeaths_Top = function(value)
        core.db.profile.reportConfig["DEATHS"]["TOP"] = value
    end,
    IsReportingDeaths_Bottom = function()
        return core.db.profile.reportConfig["DEATHS"]["BOTTOM"]
    end,
    ToggleReportingDeaths_Bottom = function()
        core.db.profile.reportConfig["DEATHS"]["BOTTOM"] = not core.db.profile.reportConfig["DEATHS"]["BOTTOM"]
    end,
    SetReportingDeaths_Bottom = function(value)
        core.db.profile.reportConfig["DEATHS"]["BOTTOM"] = value
    end,
    IsReportingOffheals_Combat = function()
        return core.db.profile.reportConfig["OFFHEALS"]["COMBAT"]
    end,
    ToggleReportingOffheals_Combat = function()
        core.db.profile.reportConfig["OFFHEALS"]["COMBAT"] = not core.db.profile.reportConfig["OFFHEALS"]["COMBAT"]
    end,
    SetReportingOffheals_Combat = function(value)
        core.db.profile.reportConfig["OFFHEALS"]["COMBAT"] = value
    end,
    IsReportingOffheals_Boss = function()
        return core.db.profile.reportConfig["OFFHEALS"]["BOSS"]
    end,
    ToggleReportingOffheals_Boss = function()
        core.db.profile.reportConfig["OFFHEALS"]["BOSS"] = not core.db.profile.reportConfig["OFFHEALS"]["BOSS"]
    end,
    SetReportingOffheals_Boss = function(value)
        core.db.profile.reportConfig["OFFHEALS"]["BOSS"] = value
    end,
    IsReportingOffheals_Dungeon = function()
        return core.db.profile.reportConfig["OFFHEALS"]["DUNGEON"]
    end,
    ToggleReportingOffheals_Dungeon = function()
        core.db.profile.reportConfig["OFFHEALS"]["DUNGEON"] = not core.db.profile.reportConfig["OFFHEALS"]["DUNGEON"]
    end,
    SetReportingOffheals_Dungeon = function(value)
        core.db.profile.reportConfig["OFFHEALS"]["DUNGEON"] = value
    end,
    IsReportingOffheals_Top = function()
        return core.db.profile.reportConfig["OFFHEALS"]["TOP"]
    end,
    ToggleReportingOffheals_Top = function()
        core.db.profile.reportConfig["OFFHEALS"]["TOP"] = not core.db.profile.reportConfig["OFFHEALS"]["TOP"]
    end,
    SetReportingOffheals_Top = function(value)
        core.db.profile.reportConfig["OFFHEALS"]["TOP"] = value
    end,
    IsReportingOffheals_Bottom = function()
        return core.db.profile.reportConfig["OFFHEALS"]["BOTTOM"]
    end,
    ToggleReportingOffheals_Bottom = function()
        core.db.profile.reportConfig["OFFHEALS"]["BOTTOM"] = not core.db.profile.reportConfig["OFFHEALS"]["BOTTOM"]
    end,
    SetReportingOffheals_Bottom = function(value)
        core.db.profile.reportConfig["OFFHEALS"]["BOTTOM"] = value
    end,
    IsReportingPulls_Combat = function()
        return core.db.profile.reportConfig["PULLS"]["COMBAT"]
    end,
    ToggleReportingPulls_Combat = function()
        core.db.profile.reportConfig["PULLS"]["COMBAT"] = not core.db.profile.reportConfig["PULLS"]["COMBAT"]
    end,
    SetReportingPulls_Combat = function(value)
        core.db.profile.reportConfig["PULLS"]["COMBAT"] = value
    end,
    IsReportingPulls_Boss = function()
        return core.db.profile.reportConfig["PULLS"]["BOSS"]
    end,
    ToggleReportingPulls_Boss = function()
        core.db.profile.reportConfig["PULLS"]["BOSS"] = not core.db.profile.reportConfig["PULLS"]["BOSS"]
    end,
    SetReportingPulls_Boss = function(value)
        core.db.profile.reportConfig["PULLS"]["BOSS"] = value
    end,
    IsReportingPulls_Dungeon = function()
        return core.db.profile.reportConfig["PULLS"]["DUNGEON"]
    end,
    ToggleReportingPulls_Dungeon = function()
        core.db.profile.reportConfig["PULLS"]["DUNGEON"] = not core.db.profile.reportConfig["PULLS"]["DUNGEON"]
    end,
    SetReportingPulls_Dungeon = function(value)
        core.db.profile.reportConfig["PULLS"]["DUNGEON"] = value
    end,
    IsReportingPulls_Top = function()
        return core.db.profile.reportConfig["PULLS"]["TOP"]
    end,
    ToggleReportingPulls_Top = function()
        core.db.profile.reportConfig["PULLS"]["TOP"] = not core.db.profile.reportConfig["PULLS"]["TOP"]
    end,
    SetReportingPulls_Top = function(value)
        core.db.profile.reportConfig["PULLS"]["TOP"] = value
    end,
    IsReportingPulls_Bottom = function()
        return core.db.profile.reportConfig["PULLS"]["BOTTOM"]
    end,
    ToggleReportingPulls_Bottom = function()
        core.db.profile.reportConfig["PULLS"]["BOTTOM"] = not core.db.profile.reportConfig["PULLS"]["BOTTOM"]
    end,
    SetReportingPulls_Bottom = function(value)
        core.db.profile.reportConfig["PULLS"]["BOTTOM"] = value
    end,
    IsReportingPulls_Realtime = function()
        return core.db.profile.reportConfig["PULLS"]["REALTIME"]
    end,
    ToggleReportingPulls_Realtime = function()
        core.db.profile.reportConfig["PULLS"]["REALTIME"] = not core.db.profile.reportConfig["PULLS"]["REALTIME"]
    end,
    SetReportingPulls_Realtime = function(value)
        core.db.profile.reportConfig["PULLS"]["REALTIME"] = value
    end,
    IsReportingNeglectedHeals_Realtime = function()
        return core.db.profile.reportConfig["NEGLECTEDHEALS"]["REALTIME"]
    end,
    ToggleReportingNeglectedHeals_Realtime = function()
        core.db.profile.reportConfig["NEGLECTEDHEALS"]["REALTIME"] = not core.db.profile.reportConfig["NEGLECTEDHEALS"]["REALTIME"]
    end,
    SetReportingNeglectedHeals_Realtime = function(value)
        core.db.profile.reportConfig["NEGLECTEDHEALS"]["REALTIME"] = value
    end,
    IsReportingAffixes_CastStart = function()
        return core.db.profile.reportConfig["AFFIXES"]["CASTSTART"]
    end,
    ToggleReportingAffixes_CastStart = function()
        core.db.profile.reportConfig["AFFIXES"]["CASTSTART"] = not core.db.profile.reportConfig["AFFIXES"]["CASTSTART"]
    end,
    SetReportingAffixes_CastStart = function(value)
        core.db.profile.reportConfig["AFFIXES"]["CASTSTART"] = value
    end,
    IsReportingAffixes_CastSuccess = function()
        return core.db.profile.reportConfig["AFFIXES"]["CASTSUCCESS"]
    end,
    ToggleReportingAffixes_CastSuccess = function()
        core.db.profile.reportConfig["AFFIXES"]["CASTSUCCESS"] = not core.db.profile.reportConfig["AFFIXES"]["CASTSUCCESS"]
    end,
    SetReportingAffixes_CastSuccess = function(value)
        core.db.profile.reportConfig["AFFIXES"]["CASTSUCCESS"] = value
    end,
    IsReportingAffixes_CastFailed = function()
        return core.db.profile.reportConfig["AFFIXES"]["CASTINTERRUPTED"]
    end,
    ToggleReportingAffixes_CastFailed = function()
        core.db.profile.reportConfig["AFFIXES"]["CASTINTERRUPTED"] = not core.db.profile.reportConfig["AFFIXES"]["CASTINTERRUPTED"]
    end,
    SetReportingAffixes_CastFailed = function(value)
        core.db.profile.reportConfig["AFFIXES"]["CASTINTERRUPTED"] = value
    end,
    IsReportingAffixes_Markers = function()
        return core.db.profile.reportConfig["AFFIXES"]["MARKERS"]
    end,
    ToggleReportingAffixes_Markers = function()
        core.db.profile.reportConfig["AFFIXES"]["MARKERS"] = not core.db.profile.reportConfig["AFFIXES"]["MARKERS"]
    end,
    SetReportingAffixes_Markers = function(value)
        core.db.profile.reportConfig["AFFIXES"]["MARKERS"] = value
    end,
    IsReportingAffixes_Boss = function()
        return core.db.profile.reportConfig["AFFIXES"]["BOSS"]
    end,
    ToggleReportingAffixes_Boss = function()
        core.db.profile.reportConfig["AFFIXES"]["BOSS"] = not core.db.profile.reportConfig["AFFIXES"]["BOSS"]
    end,
    SetReportingAffixes_Boss = function(value)
        core.db.profile.reportConfig["AFFIXES"]["BOSS"] = value
    end,
    IsReportingAffixes_Dungeon = function()
        return core.db.profile.reportConfig["AFFIXES"]["DUNGEON"]
    end,
    ToggleReportingAffixes_Dungeon = function()
        core.db.profile.reportConfig["AFFIXES"]["DUNGEON"] = not core.db.profile.reportConfig["AFFIXES"]["DUNGEON"]
    end,
    SetReportingAffixes_Dungeon = function(value)
        core.db.profile.reportConfig["AFFIXES"]["DUNGEON"] = value
    end,
    IsReportingAffixes_Top = function()
        return core.db.profile.reportConfig["AFFIXES"]["TOP"]
    end,
    ToggleReportingAffixes_Top = function()
        core.db.profile.reportConfig["AFFIXES"]["TOP"] = not core.db.profile.reportConfig["AFFIXES"]["TOP"]
    end,
    SetReportingAffixes_Top = function(value)
        core.db.profile.reportConfig["AFFIXES"]["TOP"] = value
    end,
    IsReportingAffixes_Bottom = function()
        return core.db.profile.reportConfig["AFFIXES"]["BOTTOM"]
    end,
    ToggleReportingAffixes_Bottom = function()
        core.db.profile.reportConfig["AFFIXES"]["BOTTOM"] = not core.db.profile.reportConfig["AFFIXES"]["BOTTOM"]
    end,
    SetReportingAffixes_Bottom = function(value)
        core.db.profile.reportConfig["AFFIXES"]["BOTTOM"] = value
    end,
    IsUsingGlobalChance = function()
        return core.db.profile.useGlobalChance
    end,
    ToggleUsingGlobalChance = function()
        core.db.profile.useGlobalChance = not core.db.profile.useGlobalChance
    end,
    SetUsingGlobalChance = function(value)
        core.db.profile.useGlobalChance = value
    end,
    GetGlobalChance = function()
        return core.db.profile.globalChance
    end,
    SetGlobalChance = function(value)
        core.db.profile.globalChance = value
    end,
    GetMinimumTime = function()
        return core.db.profile.minimumTime
    end,
    SetMinimumTime = function(value)
        core.db.profile.minimumTime = value
    end,
    GetNemeses = function()
        return core.db.profile.nemeses
    end,
    GetNemesis = function(name)
        return core.db.profile.nemeses[name]
    end,
    AddNemesis = function(name)
        core.db.profile.nemeses[name] = name
    end,
    RemoveNemesis = function(name)
        table.remove(core.db.profile.nemeses, name)
    end,
    GetMessages = function()
        return core.db.profile.messages
    end,
    AddMessage = function(message)
        table.insert(core.db.profile.messages, message)
    end,
    RemoveMessage = function(message)
        table.remove(core.db.profile.messages, message)
    end,
}
