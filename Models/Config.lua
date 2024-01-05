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
    IsEnabled = function(self)
        return core.db.profile.default.enabled
    end,
    ToggleEnabled = function(self)
        core.db.profile.default.enabled = not core.db.profile.default.enabled
    end,
    SetEnabled = function(self, value)
        core.db.profile.default.enabled = value

        if value then
            NemesisChat:Enable()
            NemesisChat:Print("Enabled.")
        else
            NemesisChat:Disable()
            NemesisChat:Print("Disabled.")
        end
    end,
    IsDebugging = function(self)
        return core.db.profile.default.dbg
    end,
    ToggleDebugging = function(self)
        core.db.profile.default.dbg = not core.db.profile.default.dbg
    end,
    SetDebugging = function(self, value)
        core.db.profile.default.dbg = value
    end,
    IsNonCombatMode = function(self)
        return core.db.profile.default.nonCombatMode
    end,
    ToggleNonCombatMode = function(self)
        core.db.profile.default.nonCombatMode = not core.db.profile.default.nonCombatMode
    end,
    SetNonCombatMode = function(self, value)
        core.db.profile.default.nonCombatMode = value
    end,
    IsInterruptException = function(self)
        return core.db.profile.default.interruptException
    end,
    ToggleInterruptException = function(self)
        core.db.profile.default.interruptException = not core.db.profile.default.interruptException
    end,
    SetInterruptException = function(self, value)
        core.db.profile.default.interruptException = value
    end,
    IsDeathException = function(self)
        return core.db.profile.default.deathException
    end,
    ToggleDeathException = function(self)
        core.db.profile.default.deathException = not core.db.profile.default.deathException
    end,
    SetDeathException = function(self, value)
        core.db.profile.default.deathException = value
    end,
    IsAIEnabled = function(self)
        return core.db.profile.default.ai
    end,
    ToggleAI = function(self)
        core.db.profile.default.ai = not core.db.profile.default.ai
    end,
    SetAI = function(self, value)
        core.db.profile.default.ai = value
    end,
    IsFlaggingFriendsAsNemeses = function(self)
        return core.db.profile.default.flagFriendsAsNemeses
    end,
    ToggleFlaggingFriendsAsNemeses = function(self)
        core.db.profile.default.flagFriendsAsNemeses = not core.db.profile.default.flagFriendsAsNemeses
    end,
    SetFlaggingFriendsAsNemeses = function(self, value)
        core.db.profile.default.flagFriendsAsNemeses = value
    end,
    IsFlaggingGuildmatesAsNemeses = function(self)
        return core.db.profile.default.flagGuildmatesAsNemeses
    end,
    ToggleFlaggingGuildmatesAsNemeses = function(self)
        core.db.profile.default.flagGuildmatesAsNemeses = not core.db.profile.default.flagGuildmatesAsNemeses
    end,
    SetFlaggingGuildmatesAsNemeses = function(self, value)
        core.db.profile.default.flagGuildmatesAsNemeses = value
    end,
    GetReportChannel = function(self)
        return core.db.profile.default.reportConfig.channel
    end,
    SetReportChannel = function(self, value)
        core.db.profile.default.reportConfig.channel = value
    end,
    IsExcludingNemeses = function(self)
        return core.db.profile.default.reportConfig.excludeNemeses
    end,
    ToggleExcludingNemeses = function(self)
        core.db.profile.default.reportConfig.excludeNemeses = not core.db.profile.default.reportConfig.excludeNemeses
    end,
    SetExcludingNemeses = function(self, value)
        core.db.profile.default.reportConfig.excludeNemeses = value
    end,
    IsReportingLowPerformersOnWipe = function(self)
        return core.db.profile.default.reportConfig.reportLowPerformersOnWipe
    end,
    ToggleReportingLowPerformersOnWipe = function(self)
        core.db.profile.default.reportConfig.reportLowPerformersOnWipe = not core.db.profile.default.reportConfig.reportLowPerformersOnWipe
    end,
    SetReportingLowPerformersOnWipe = function(self, value)
        core.db.profile.default.reportConfig.reportLowPerformersOnWipe = value
    end,
    IsReportingLowPerformersOnDungeonFail = function(self)
        return core.db.profile.default.reportConfig.reportLowPerformersOnDungeonFail
    end,
    ToggleReportingLowPerformersOnDungeonFail = function(self)
        core.db.profile.default.reportConfig.reportLowPerformersOnDungeonFail = not core.db.profile.default.reportConfig.reportLowPerformersOnDungeonFail
    end,
    SetReportingLowPerformersOnDungeonFail = function(self, value)
        core.db.profile.default.reportConfig.reportLowPerformersOnDungeonFail = value
    end,
    IsReportingDamage_Combat = function(self)
        return core.db.profile.default.reportConfig["DAMAGE"]["COMBAT"]
    end,
    ToggleReportingDamage_Combat = function(self)
        core.db.profile.default.reportConfig["DAMAGE"]["COMBAT"] = not core.db.profile.default.reportConfig["DAMAGE"]["COMBAT"]
    end,
    SetReportingDamage_Combat = function(self, value)
        core.db.profile.default.reportConfig["DAMAGE"]["COMBAT"] = value
    end,
    IsReportingDamage_Boss = function(self)
        return core.db.profile.default.reportConfig["DAMAGE"]["BOSS"]
    end,
    ToggleReportingDamage_Boss = function(self)
        core.db.profile.default.reportConfig["DAMAGE"]["BOSS"] = not core.db.profile.default.reportConfig["DAMAGE"]["BOSS"]
    end,
    SetReportingDamage_Boss = function(self, value)
        core.db.profile.default.reportConfig["DAMAGE"]["BOSS"] = value
    end,
    IsReportingDamage_Dungeon = function(self)
        return core.db.profile.default.reportConfig["DAMAGE"]["DUNGEON"]
    end,
    ToggleReportingDamage_Dungeon = function(self)
        core.db.profile.default.reportConfig["DAMAGE"]["DUNGEON"] = not core.db.profile.default.reportConfig["DAMAGE"]["DUNGEON"]
    end,
    SetReportingDamage_Dungeon = function(self, value)
        core.db.profile.default.reportConfig["DAMAGE"]["DUNGEON"] = value
    end,
    IsReportingDamage_Top = function(self)
        return core.db.profile.default.reportConfig["DAMAGE"]["TOP"]
    end,
    ToggleReportingDamage_Top = function(self)
        core.db.profile.default.reportConfig["DAMAGE"]["TOP"] = not core.db.profile.default.reportConfig["DAMAGE"]["TOP"]
    end,
    SetReportingDamage_Top = function(self, value)
        core.db.profile.default.reportConfig["DAMAGE"]["TOP"] = value
    end,
    IsReportingDamage_Bottom = function(self)
        return core.db.profile.default.reportConfig["DAMAGE"]["BOTTOM"]
    end,
    ToggleReportingDamage_Bottom = function(self)
        core.db.profile.default.reportConfig["DAMAGE"]["BOTTOM"] = not core.db.profile.default.reportConfig["DAMAGE"]["BOTTOM"]
    end,
    SetReportingDamage_Bottom = function(self, value)
        core.db.profile.default.reportConfig["DAMAGE"]["BOTTOM"] = value
    end,
    IsReportingAvoidable_Combat = function(self)
        return core.db.profile.default.reportConfig["AVOIDABLE"]["COMBAT"]
    end,
    ToggleReportingAvoidable_Combat = function(self)
        core.db.profile.default.reportConfig["AVOIDABLE"]["COMBAT"] = not core.db.profile.default.reportConfig["AVOIDABLE"]["COMBAT"]
    end,
    SetReportingAvoidable_Combat = function(self, value)
        core.db.profile.default.reportConfig["AVOIDABLE"]["COMBAT"] = value
    end,
    IsReportingAvoidable_Boss = function(self)
        return core.db.profile.default.reportConfig["AVOIDABLE"]["BOSS"]
    end,
    ToggleReportingAvoidable_Boss = function(self)
        core.db.profile.default.reportConfig["AVOIDABLE"]["BOSS"] = not core.db.profile.default.reportConfig["AVOIDABLE"]["BOSS"]
    end,
    SetReportingAvoidable_Boss = function(self, value)
        core.db.profile.default.reportConfig["AVOIDABLE"]["BOSS"] = value
    end,
    IsReportingAvoidable_Dungeon = function(self)
        return core.db.profile.default.reportConfig["AVOIDABLE"]["DUNGEON"]
    end,
    ToggleReportingAvoidable_Dungeon = function(self)
        core.db.profile.default.reportConfig["AVOIDABLE"]["DUNGEON"] = not core.db.profile.default.reportConfig["AVOIDABLE"]["DUNGEON"]
    end,
    SetReportingAvoidable_Dungeon = function(self, value)
        core.db.profile.default.reportConfig["AVOIDABLE"]["DUNGEON"] = value
    end,
    IsReportingAvoidable_Top = function(self)
        return core.db.profile.default.reportConfig["AVOIDABLE"]["TOP"]
    end,
    ToggleReportingAvoidable_Top = function(self)
        core.db.profile.default.reportConfig["AVOIDABLE"]["TOP"] = not core.db.profile.default.reportConfig["AVOIDABLE"]["TOP"]
    end,
    SetReportingAvoidable_Top = function(self, value)
        core.db.profile.default.reportConfig["AVOIDABLE"]["TOP"] = value
    end,
    IsReportingAvoidable_Bottom = function(self)
        return core.db.profile.default.reportConfig["AVOIDABLE"]["BOTTOM"]
    end,
    ToggleReportingAvoidable_Bottom = function(self)
        core.db.profile.default.reportConfig["AVOIDABLE"]["BOTTOM"] = not core.db.profile.default.reportConfig["AVOIDABLE"]["BOTTOM"]
    end,
    SetReportingAvoidable_Bottom = function(self, value)
        core.db.profile.default.reportConfig["AVOIDABLE"]["BOTTOM"] = value
    end,
    IsReportingInterrupts_Combat = function(self)
        return core.db.profile.default.reportConfig["INTERRUPTS"]["COMBAT"]
    end,
    ToggleReportingInterrupts_Combat = function(self)
        core.db.profile.default.reportConfig["INTERRUPTS"]["COMBAT"] = not core.db.profile.default.reportConfig["INTERRUPTS"]["COMBAT"]
    end,
    SetReportingInterrupts_Combat = function(self, value)
        core.db.profile.default.reportConfig["INTERRUPTS"]["COMBAT"] = value
    end,
    IsReportingInterrupts_Boss = function(self)
        return core.db.profile.default.reportConfig["INTERRUPTS"]["BOSS"]
    end,
    ToggleReportingInterrupts_Boss = function(self)
        core.db.profile.default.reportConfig["INTERRUPTS"]["BOSS"] = not core.db.profile.default.reportConfig["INTERRUPTS"]["BOSS"]
    end,
    SetReportingInterrupts_Boss = function(self, value)
        core.db.profile.default.reportConfig["INTERRUPTS"]["BOSS"] = value
    end,
    IsReportingInterrupts_Dungeon = function(self)
        return core.db.profile.default.reportConfig["INTERRUPTS"]["DUNGEON"]
    end,
    ToggleReportingInterrupts_Dungeon = function(self)
        core.db.profile.default.reportConfig["INTERRUPTS"]["DUNGEON"] = not core.db.profile.default.reportConfig["INTERRUPTS"]["DUNGEON"]
    end,
    SetReportingInterrupts_Dungeon = function(self, value)
        core.db.profile.default.reportConfig["INTERRUPTS"]["DUNGEON"] = value
    end,
    IsReportingInterrupts_Top = function(self)
        return core.db.profile.default.reportConfig["INTERRUPTS"]["TOP"]
    end,
    ToggleReportingInterrupts_Top = function(self)
        core.db.profile.default.reportConfig["INTERRUPTS"]["TOP"] = not core.db.profile.default.reportConfig["INTERRUPTS"]["TOP"]
    end,
    SetReportingInterrupts_Top = function(self, value)
        core.db.profile.default.reportConfig["INTERRUPTS"]["TOP"] = value
    end,
    IsReportingInterrupts_Bottom = function(self)
        return core.db.profile.default.reportConfig["INTERRUPTS"]["BOTTOM"]
    end,
    ToggleReportingInterrupts_Bottom = function(self)
        core.db.profile.default.reportConfig["INTERRUPTS"]["BOTTOM"] = not core.db.profile.default.reportConfig["INTERRUPTS"]["BOTTOM"]
    end,
    SetReportingInterrupts_Bottom = function(self, value)
        core.db.profile.default.reportConfig["INTERRUPTS"]["BOTTOM"] = value
    end,
    IsReportingDeaths_Combat = function(self)
        return core.db.profile.default.reportConfig["DEATHS"]["COMBAT"]
    end,
    ToggleReportingDeaths_Combat = function(self)
        core.db.profile.default.reportConfig["DEATHS"]["COMBAT"] = not core.db.profile.default.reportConfig["DEATHS"]["COMBAT"]
    end,
    SetReportingDeaths_Combat = function(self, value)
        core.db.profile.default.reportConfig["DEATHS"]["COMBAT"] = value
    end,
    IsReportingDeaths_Boss = function(self)
        return core.db.profile.default.reportConfig["DEATHS"]["BOSS"]
    end,
    ToggleReportingDeaths_Boss = function(self)
        core.db.profile.default.reportConfig["DEATHS"]["BOSS"] = not core.db.profile.default.reportConfig["DEATHS"]["BOSS"]
    end,
    SetReportingDeaths_Boss = function(self, value)
        core.db.profile.default.reportConfig["DEATHS"]["BOSS"] = value
    end,
    IsReportingDeaths_Dungeon = function(self)
        return core.db.profile.default.reportConfig["DEATHS"]["DUNGEON"]
    end,
    ToggleReportingDeaths_Dungeon = function(self)
        core.db.profile.default.reportConfig["DEATHS"]["DUNGEON"] = not core.db.profile.default.reportConfig["DEATHS"]["DUNGEON"]
    end,
    SetReportingDeaths_Dungeon = function(self, value)
        core.db.profile.default.reportConfig["DEATHS"]["DUNGEON"] = value
    end,
    IsReportingDeaths_Top = function(self)
        return core.db.profile.default.reportConfig["DEATHS"]["TOP"]
    end,
    ToggleReportingDeaths_Top = function(self)
        core.db.profile.default.reportConfig["DEATHS"]["TOP"] = not core.db.profile.default.reportConfig["DEATHS"]["TOP"]
    end,
    SetReportingDeaths_Top = function(self, value)
        core.db.profile.default.reportConfig["DEATHS"]["TOP"] = value
    end,
    IsReportingDeaths_Bottom = function(self)
        return core.db.profile.default.reportConfig["DEATHS"]["BOTTOM"]
    end,
    ToggleReportingDeaths_Bottom = function(self)
        core.db.profile.default.reportConfig["DEATHS"]["BOTTOM"] = not core.db.profile.default.reportConfig["DEATHS"]["BOTTOM"]
    end,
    SetReportingDeaths_Bottom = function(self, value)
        core.db.profile.default.reportConfig["DEATHS"]["BOTTOM"] = value
    end,
    IsReportingOffheals_Combat = function(self)
        return core.db.profile.default.reportConfig["OFFHEALS"]["COMBAT"]
    end,
    ToggleReportingOffheals_Combat = function(self)
        core.db.profile.default.reportConfig["OFFHEALS"]["COMBAT"] = not core.db.profile.default.reportConfig["OFFHEALS"]["COMBAT"]
    end,
    SetReportingOffheals_Combat = function(self, value)
        core.db.profile.default.reportConfig["OFFHEALS"]["COMBAT"] = value
    end,
    IsReportingOffheals_Boss = function(self)
        return core.db.profile.default.reportConfig["OFFHEALS"]["BOSS"]
    end,
    ToggleReportingOffheals_Boss = function(self)
        core.db.profile.default.reportConfig["OFFHEALS"]["BOSS"] = not core.db.profile.default.reportConfig["OFFHEALS"]["BOSS"]
    end,
    SetReportingOffheals_Boss = function(self, value)
        core.db.profile.default.reportConfig["OFFHEALS"]["BOSS"] = value
    end,
    IsReportingOffheals_Dungeon = function(self)
        return core.db.profile.default.reportConfig["OFFHEALS"]["DUNGEON"]
    end,
    ToggleReportingOffheals_Dungeon = function(self)
        core.db.profile.default.reportConfig["OFFHEALS"]["DUNGEON"] = not core.db.profile.default.reportConfig["OFFHEALS"]["DUNGEON"]
    end,
    SetReportingOffheals_Dungeon = function(self, value)
        core.db.profile.default.reportConfig["OFFHEALS"]["DUNGEON"] = value
    end,
    IsReportingOffheals_Top = function(self)
        return core.db.profile.default.reportConfig["OFFHEALS"]["TOP"]
    end,
    ToggleReportingOffheals_Top = function(self)
        core.db.profile.default.reportConfig["OFFHEALS"]["TOP"] = not core.db.profile.default.reportConfig["OFFHEALS"]["TOP"]
    end,
    SetReportingOffheals_Top = function(self, value)
        core.db.profile.default.reportConfig["OFFHEALS"]["TOP"] = value
    end,
    IsReportingOffheals_Bottom = function(self)
        return core.db.profile.default.reportConfig["OFFHEALS"]["BOTTOM"]
    end,
    ToggleReportingOffheals_Bottom = function(self)
        core.db.profile.default.reportConfig["OFFHEALS"]["BOTTOM"] = not core.db.profile.default.reportConfig["OFFHEALS"]["BOTTOM"]
    end,
    SetReportingOffheals_Bottom = function(self, value)
        core.db.profile.default.reportConfig["OFFHEALS"]["BOTTOM"] = value
    end,
    IsReportingPulls_Combat = function(self)
        return core.db.profile.default.reportConfig["PULLS"]["COMBAT"]
    end,
    ToggleReportingPulls_Combat = function(self)
        core.db.profile.default.reportConfig["PULLS"]["COMBAT"] = not core.db.profile.default.reportConfig["PULLS"]["COMBAT"]
    end,
    SetReportingPulls_Combat = function(self, value)
        core.db.profile.default.reportConfig["PULLS"]["COMBAT"] = value
    end,
    IsReportingPulls_Boss = function(self)
        return core.db.profile.default.reportConfig["PULLS"]["BOSS"]
    end,
    ToggleReportingPulls_Boss = function(self)
        core.db.profile.default.reportConfig["PULLS"]["BOSS"] = not core.db.profile.default.reportConfig["PULLS"]["BOSS"]
    end,
    SetReportingPulls_Boss = function(self, value)
        core.db.profile.default.reportConfig["PULLS"]["BOSS"] = value
    end,
    IsReportingPulls_Dungeon = function(self)
        return core.db.profile.default.reportConfig["PULLS"]["DUNGEON"]
    end,
    ToggleReportingPulls_Dungeon = function(self)
        core.db.profile.default.reportConfig["PULLS"]["DUNGEON"] = not core.db.profile.default.reportConfig["PULLS"]["DUNGEON"]
    end,
    SetReportingPulls_Dungeon = function(self, value)
        core.db.profile.default.reportConfig["PULLS"]["DUNGEON"] = value
    end,
    IsReportingPulls_Top = function(self)
        return core.db.profile.default.reportConfig["PULLS"]["TOP"]
    end,
    ToggleReportingPulls_Top = function(self)
        core.db.profile.default.reportConfig["PULLS"]["TOP"] = not core.db.profile.default.reportConfig["PULLS"]["TOP"]
    end,
    SetReportingPulls_Top = function(self, value)
        core.db.profile.default.reportConfig["PULLS"]["TOP"] = value
    end,
    IsReportingPulls_Bottom = function(self)
        return core.db.profile.default.reportConfig["PULLS"]["BOTTOM"]
    end,
    ToggleReportingPulls_Bottom = function(self)
        core.db.profile.default.reportConfig["PULLS"]["BOTTOM"] = not core.db.profile.default.reportConfig["PULLS"]["BOTTOM"]
    end,
    SetReportingPulls_Bottom = function(self, value)
        core.db.profile.default.reportConfig["PULLS"]["BOTTOM"] = value
    end,
    IsReportingPulls_Realtime = function(self)
        return core.db.profile.default.reportConfig["PULLS"]["REALTIME"]
    end,
    ToggleReportingPulls_Realtime = function(self)
        core.db.profile.default.reportConfig["PULLS"]["REALTIME"] = not core.db.profile.default.reportConfig["PULLS"]["REALTIME"]
    end,
    SetReportingPulls_Realtime = function(self, value)
        core.db.profile.default.reportConfig["PULLS"]["REALTIME"] = value
    end,
    IsReportingNeglectedHeals_Realtime = function(self)
        return core.db.profile.default.reportConfig["NEGLECTEDHEALS"]["REALTIME"]
    end,
    ToggleReportingNeglectedHeals_Realtime = function(self)
        core.db.profile.default.reportConfig["NEGLECTEDHEALS"]["REALTIME"] = not core.db.profile.default.reportConfig["NEGLECTEDHEALS"]["REALTIME"]
    end,
    SetReportingNeglectedHeals_Realtime = function(self, value)
        core.db.profile.default.reportConfig["NEGLECTEDHEALS"]["REALTIME"] = value
    end,
    IsReportingAffixes_CastStart = function(self)
        return core.db.profile.default.reportConfig["AFFIXES"]["CASTSTART"]
    end,
    ToggleReportingAffixes_CastStart = function(self)
        core.db.profile.default.reportConfig["AFFIXES"]["CASTSTART"] = not core.db.profile.default.reportConfig["AFFIXES"]["CASTSTART"]
    end,
    SetReportingAffixes_CastStart = function(self, value)
        core.db.profile.default.reportConfig["AFFIXES"]["CASTSTART"] = value
    end,
    IsReportingAffixes_CastSuccess = function(self)
        return core.db.profile.default.reportConfig["AFFIXES"]["CASTSUCCESS"]
    end,
    ToggleReportingAffixes_CastSuccess = function(self)
        core.db.profile.default.reportConfig["AFFIXES"]["CASTSUCCESS"] = not core.db.profile.default.reportConfig["AFFIXES"]["CASTSUCCESS"]
    end,
    SetReportingAffixes_CastSuccess = function(self, value)
        core.db.profile.default.reportConfig["AFFIXES"]["CASTSUCCESS"] = value
    end,
    IsReportingAffixes_CastFailed = function(self)
        return core.db.profile.default.reportConfig["AFFIXES"]["CASTINTERRUPTED"]
    end,
    ToggleReportingAffixes_CastFailed = function(self)
        core.db.profile.default.reportConfig["AFFIXES"]["CASTINTERRUPTED"] = not core.db.profile.default.reportConfig["AFFIXES"]["CASTINTERRUPTED"]
    end,
    SetReportingAffixes_CastFailed = function(self, value)
        core.db.profile.default.reportConfig["AFFIXES"]["CASTINTERRUPTED"] = value
    end,
    IsReportingAffixes_AuraStacks = function(self)
        return core.db.profile.default.reportConfig["AFFIXES"]["AURASTACKS"]
    end,
    ToggleReportingAffixes_AuraStacks = function(self)
        core.db.profile.default.reportConfig["AFFIXES"]["AURASTACKS"] = not core.db.profile.default.reportConfig["AFFIXES"]["AURASTACKS"]
    end,
    SetReportingAffixes_AuraStacks = function(self, value)
        core.db.profile.default.reportConfig["AFFIXES"]["AURASTACKS"] = value
    end,
    IsReportingAffixes_Markers = function(self)
        return core.db.profile.default.reportConfig["AFFIXES"]["MARKERS"]
    end,
    ToggleReportingAffixes_Markers = function(self)
        core.db.profile.default.reportConfig["AFFIXES"]["MARKERS"] = not core.db.profile.default.reportConfig["AFFIXES"]["MARKERS"]
    end,
    SetReportingAffixes_Markers = function(self, value)
        core.db.profile.default.reportConfig["AFFIXES"]["MARKERS"] = value
    end,
    IsReportingAffixes_Boss = function(self)
        return core.db.profile.default.reportConfig["AFFIXES"]["BOSS"]
    end,
    ToggleReportingAffixes_Boss = function(self)
        core.db.profile.default.reportConfig["AFFIXES"]["BOSS"] = not core.db.profile.default.reportConfig["AFFIXES"]["BOSS"]
    end,
    SetReportingAffixes_Boss = function(self, value)
        core.db.profile.default.reportConfig["AFFIXES"]["BOSS"] = value
    end,
    IsReportingAffixes_Dungeon = function(self)
        return core.db.profile.default.reportConfig["AFFIXES"]["DUNGEON"]
    end,
    ToggleReportingAffixes_Dungeon = function(self)
        core.db.profile.default.reportConfig["AFFIXES"]["DUNGEON"] = not core.db.profile.default.reportConfig["AFFIXES"]["DUNGEON"]
    end,
    SetReportingAffixes_Dungeon = function(self, value)
        core.db.profile.default.reportConfig["AFFIXES"]["DUNGEON"] = value
    end,
    IsReportingAffixes_Top = function(self)
        return core.db.profile.default.reportConfig["AFFIXES"]["TOP"]
    end,
    ToggleReportingAffixes_Top = function(self)
        core.db.profile.default.reportConfig["AFFIXES"]["TOP"] = not core.db.profile.default.reportConfig["AFFIXES"]["TOP"]
    end,
    SetReportingAffixes_Top = function(self, value)
        core.db.profile.default.reportConfig["AFFIXES"]["TOP"] = value
    end,
    IsReportingAffixes_Bottom = function(self)
        return core.db.profile.default.reportConfig["AFFIXES"]["BOTTOM"]
    end,
    ToggleReportingAffixes_Bottom = function(self)
        core.db.profile.default.reportConfig["AFFIXES"]["BOTTOM"] = not core.db.profile.default.reportConfig["AFFIXES"]["BOTTOM"]
    end,
    SetReportingAffixes_Bottom = function(self, value)
        core.db.profile.default.reportConfig["AFFIXES"]["BOTTOM"] = value
    end,
    IsUsingGlobalChance = function(self)
        return core.db.profile.default.useGlobalChance
    end,
    ToggleUsingGlobalChance = function(self)
        core.db.profile.default.useGlobalChance = not core.db.profile.default.useGlobalChance
    end,
    SetUsingGlobalChance = function(self, value)
        core.db.profile.default.useGlobalChance = value
    end,
    GetGlobalChance = function(self)
        return core.db.profile.default.globalChance
    end,
    SetGlobalChance = function(self, value)
        core.db.profile.default.globalChance = value
    end,
    GetMinimumTime = function(self)
        return core.db.profile.default.minimumTime
    end,
    SetMinimumTime = function(self, value)
        core.db.profile.default.minimumTime = value
    end,
    GetNemeses = function(self)
        return core.db.profile.default.nemeses
    end,
    GetNemesis = function(self, name)
        return core.db.profile.default.nemeses[name]
    end,
    AddNemesis = function(self, name)
        core.db.profile.default.nemeses[name] = name
    end,
    RemoveNemesis = function(self, name)
        table.remove(core.db.profile.default.nemeses, name)
    end,
    GetMessages = function(self)
        return core.db.profile.default.messages
    end,
    AddMessage = function(self, message)
        table.insert(core.db.profile.default.messages, message)
    end,
    RemoveMessage = function(self, message)
        table.remove(core.db.profile.default.messages, message)
    end,
    ShouldShowInfoFrame = function(self)
        return core.db.profile.default.showInfoFrame
    end,
    ToggleShowInfoFrame = function(self)
        core.db.profile.default.showInfoFrame = not core.db.profile.default.showInfoFrame
    end,
    SetShowInfoFrame = function(self, value)
        core.db.profile.default.showInfoFrame = value
    end,
}
