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

NCConfig = {
    CoreDB = {},
    ReportDB = {},
    NemesisDB = {},
    isInitialized = false,

    Initialize = function(self)
        if self.isInitialized then return end

        self.CoreDB = NCDB:New(nil)
        self.ReportDB = NCDB:New("reportConfig")
        self.NemesisDB = NCDB:New("nemeses")

        self.isInitialized = true
    end,
    IsEnabled = function(self)
        return self.CoreDB:GetKey("enabled")
    end,
    ToggleEnabled = function(self)
        self.CoreDB:Toggle("enabled")

        NemesisChat:CheckGroup()

        if self.CoreDB:GetKey("enabled") then
            NemesisChat:Enable()
            NemesisChat:Print("Enabled.")
        else
            NemesisChat:Disable()
            NemesisChat:Print("Disabled.")
        end
    end,
    SetEnabled = function(self, value)
        self.CoreDB:SetKey("enabled", value)

        NemesisChat:CheckGroup()

        if value then
            NemesisChat:Enable()
            NemesisChat:Print("Enabled.")
        else
            NemesisChat:Disable()
            NemesisChat:Print("Disabled.")
        end
    end,
    IsDebugging = function(self)
        return self.CoreDB:GetKey("dbg")
    end,
    ToggleDebugging = function(self)
        self.CoreDB:Toggle("dbg")
    end,
    SetDebugging = function(self, value)
        self.CoreDB:SetKey("dbg", value)
    end,
    IsNonCombatMode = function(self)
        return self.CoreDB:GetKey("nonCombatMode")
    end,
    ToggleNonCombatMode = function(self)
        self.CoreDB:Toggle("nonCombatMode")
    end,
    SetNonCombatMode = function(self, value)
        self.CoreDB:SetKey("nonCombatMode", value)
    end,
    IsInterruptException = function(self)
        return self.CoreDB:GetKey("interruptException")
    end,
    ToggleInterruptException = function(self)
        self.CoreDB:Toggle("interruptException")
    end,
    SetInterruptException = function(self, value)
        self.CoreDB:SetKey("interruptException", value)
    end,
    IsDeathException = function(self)
        return self.CoreDB:GetKey("deathException")
    end,
    ToggleDeathException = function(self)
        self.CoreDB:Toggle("deathException")
    end,
    SetDeathException = function(self, value)
        self.CoreDB:SetKey("deathException", value)
    end,
    IsAllowingBrannMessages = function(self)
        return self.CoreDB:GetKey("allowBrannMessages")
    end,
    ToggleAllowingBrannMessages = function(self)
        self.CoreDB:Toggle("allowBrannMessages")
    end,
    SetAllowingBrannMessages = function(self, value)
        self.CoreDB:SetKey("allowBrannMessages", value)
    end,
    IsTrackingLeavers = function(self)
        return self.CoreDB:GetKey("trackLeavers")
    end,
    ToggleTrackingLeavers = function(self)
        self.CoreDB:Toggle("trackLeavers")
    end,
    SetTrackingLeavers = function(self, value)
        self.CoreDB:SetKey("trackLeavers", value)
    end,
    IsReportingLeaversOnJoin = function(self)
        return self.ReportDB:GetKey("reportLeaversOnJoin")
    end,
    ToggleReportingLeaversOnJoin = function(self)
        self.ReportDB:Toggle("reportLeaversOnJoin")
    end,
    SetReportingLeaversOnJoin = function(self, value)
        self.ReportDB:SetKey("reportLeaversOnJoin", value)
    end,
    GetReportingLeaversOnJoinThreshold = function(self)
        return self.ReportDB:GetKey("reportLeaversOnJoinThreshold")
    end,
    SetReportingLeaversOnJoinThreshold = function(self, value)
        if type(value) ~= "number" or value < 1 or value > 50 then
            value = 5
        end
        self.ReportDB:SetKey("reportLeaversOnJoinThreshold", value)
    end,
    IsTrackingLowPerformers = function(self)
        return self.CoreDB:GetKey("trackLowPerformers")
    end,
    ToggleTrackingLowPerformers = function(self)
        self.CoreDB:Toggle("trackLowPerformers")
    end,
    SetTrackingLowPerformers = function(self, value)
        self.CoreDB:SetKey("trackLowPerformers", value)
    end,
    IsReportingLowPerformersOnJoin = function(self)
        return self.ReportDB:GetKey("reportLowPerformersOnJoin")
    end,
    ToggleReportingLowPerformersOnJoin = function(self)
        self.ReportDB:Toggle("reportLowPerformersOnJoin")
    end,
    SetReportingLowPerformersOnJoin = function(self, value)
        self.ReportDB:SetKey("reportLowPerformersOnJoin", value)
    end,
    GetReportingLowPerformersOnJoinThreshold = function(self)
        local value = self.ReportDB:GetKey("reportLowPerformersOnJoinThreshold")

        if not value or value < 1 or value > 50 then
            value = 5
        end

        return value
    end,
    SetReportingLowPerformersOnJoinThreshold = function(self, value)
        if value < 1 or value > 50 then
            value = 5
        end
        self.ReportDB:SetKey("reportLowPerformersOnJoinThreshold", value)
    end,
    IsRollingMessages = function(self)
        return self.CoreDB:GetKey("rollingMessages")
    end,
    ToggleRollingMessages = function(self)
        self.CoreDB:Toggle("rollingMessages")
    end,
    SetRollingMessages = function(self, value)
        self.CoreDB:SetKey("rollingMessages", value)
    end,
    IsAIEnabled = function(self)
        return self.CoreDB:GetKey("ai")
    end,
    ToggleAI = function(self)
        self.CoreDB:Toggle("ai")
    end,
    SetAI = function(self, value)
        self.CoreDB:SetKey("ai", value)
    end,
    IsFlaggingFriendsAsNemeses = function(self)
        return self.CoreDB:GetKey("flagFriendsAsNemeses")
    end,
    ToggleFlaggingFriendsAsNemeses = function(self)
        self.CoreDB:Toggle("flagFriendsAsNemeses")
    end,
    SetFlaggingFriendsAsNemeses = function(self, value)
        self.CoreDB:SetKey("flagFriendsAsNemeses", value)
    end,
    IsFlaggingGuildmatesAsNemeses = function(self)
        return self.CoreDB:GetKey("flagGuildmatesAsNemeses")
    end,
    ToggleFlaggingGuildmatesAsNemeses = function(self)
        self.CoreDB:Toggle("flagGuildmatesAsNemeses")
    end,
    SetFlaggingGuildmatesAsNemeses = function(self, value)
        self.CoreDB:SetKey("flagGuildmatesAsNemeses", value)
    end,
    GetReportChannel = function(self)
        return self.ReportDB:GetKey("channel")
    end,
    SetReportChannel = function(self, value)
        self.ReportDB:SetKey("channel", value)
    end,
    IsExcludingNemeses = function(self)
        return self.ReportDB:GetKey("excludeNemeses")
    end,
    ToggleExcludingNemeses = function(self)
        self.ReportDB:Toggle("excludeNemeses")
    end,
    SetExcludingNemeses = function(self, value)
        self.ReportDB:SetKey("excludeNemeses", value)
    end,
    IsReportingLowPerformersOnWipe = function(self)
        return self.ReportDB:GetKey("reportLowPerformersOnWipe")
    end,
    ToggleReportingLowPerformersOnWipe = function(self)
        self.ReportDB:Toggle("reportLowPerformersOnWipe")
    end,
    SetReportingLowPerformersOnWipe = function(self, value)
        self.ReportDB:SetKey("reportLowPerformersOnWipe", value)
    end,
    IsReportingLowPerformersOnDungeonFail = function(self)
        return self.ReportDB:GetKey("reportLowPerformersOnDungeonFail")
    end,
    ToggleReportingLowPerformersOnDungeonFail = function(self)
        self.ReportDB:Toggle("reportLowPerformersOnDungeonFail")
    end,
    SetReportingLowPerformersOnDungeonFail = function(self, value)
        self.ReportDB:SetKey("reportLowPerformersOnDungeonFail", value)
    end,
    IsReportingDamage_Combat = function(self)
        return self.ReportDB:GetPath("DAMAGE.COMBAT")
    end,
    ToggleReportingDamage_Combat = function(self)
        self.ReportDB:TogglePath("DAMAGE.COMBAT")
    end,
    SetReportingDamage_Combat = function(self, value)
        self.ReportDB:SetPath("DAMAGE.COMBAT", value)
    end,
    IsReportingDamage_Boss = function(self)
        return self.ReportDB:GetPath("DAMAGE.BOSS")
    end,
    ToggleReportingDamage_Boss = function(self)
        self.ReportDB:TogglePath("DAMAGE.BOSS")
    end,
    SetReportingDamage_Boss = function(self, value)
        self.ReportDB:SetPath("DAMAGE.BOSS", value)
    end,
    IsReportingDamage_Dungeon = function(self)
        return self.ReportDB:GetPath("DAMAGE.DUNGEON")
    end,
    ToggleReportingDamage_Dungeon = function(self)
        self.ReportDB:TogglePath("DAMAGE.DUNGEON")
    end,
    SetReportingDamage_Dungeon = function(self, value)
        self.ReportDB:SetPath("DAMAGE.DUNGEON", value)
    end,
    IsReportingDamage_Top = function(self)
        return self.ReportDB:GetPath("DAMAGE.TOP")
    end,
    ToggleReportingDamage_Top = function(self)
        self.ReportDB:TogglePath("DAMAGE.TOP")
    end,
    SetReportingDamage_Top = function(self, value)
        self.ReportDB:SetPath("DAMAGE.TOP", value)
    end,
    IsReportingDamage_Bottom = function(self)
        return self.ReportDB:GetPath("DAMAGE.BOTTOM")
    end,
    ToggleReportingDamage_Bottom = function(self)
        self.ReportDB:TogglePath("DAMAGE.BOTTOM")
    end,
    SetReportingDamage_Bottom = function(self, value)
        self.ReportDB:SetPath("DAMAGE.BOTTOM", value)
    end,
    IsReportingAvoidable_Combat = function(self)
        return self.ReportDB:GetPath("AVOIDABLE.COMBAT")
    end,
    ToggleReportingAvoidable_Combat = function(self)
        self.ReportDB:TogglePath("AVOIDABLE.COMBAT")
    end,
    SetReportingAvoidable_Combat = function(self, value)
        self.ReportDB:SetPath("AVOIDABLE.COMBAT", value)
    end,
    IsReportingAvoidable_Boss = function(self)
        return self.ReportDB:GetPath("AVOIDABLE.BOSS")
    end,
    ToggleReportingAvoidable_Boss = function(self)
        self.ReportDB:TogglePath("AVOIDABLE.BOSS")
    end,
    SetReportingAvoidable_Boss = function(self, value)
        self.ReportDB:SetPath("AVOIDABLE.BOSS", value)
    end,
    IsReportingAvoidable_Dungeon = function(self)
        return self.ReportDB:GetPath("AVOIDABLE.DUNGEON")
    end,
    ToggleReportingAvoidable_Dungeon = function(self)
        self.ReportDB:TogglePath("AVOIDABLE.DUNGEON")
    end,
    SetReportingAvoidable_Dungeon = function(self, value)
        self.ReportDB:SetPath("AVOIDABLE.DUNGEON", value)
    end,
    IsReportingAvoidable_Top = function(self)
        return self.ReportDB:GetPath("AVOIDABLE.TOP")
    end,
    ToggleReportingAvoidable_Top = function(self)
        self.ReportDB:TogglePath("AVOIDABLE.TOP")
    end,
    SetReportingAvoidable_Top = function(self, value)
        self.ReportDB:SetPath("AVOIDABLE.TOP", value)
    end,
    IsReportingAvoidable_Bottom = function(self)
        return self.ReportDB:GetPath("AVOIDABLE.BOTTOM")
    end,
    ToggleReportingAvoidable_Bottom = function(self)
        self.ReportDB:TogglePath("AVOIDABLE.BOTTOM")
    end,
    SetReportingAvoidable_Bottom = function(self, value)
        self.ReportDB:SetPath("AVOIDABLE.BOTTOM", value)
    end,
    IsReportingInterrupts_Combat = function(self)
        return self.ReportDB:GetPath("INTERRUPTS.COMBAT")
    end,
    ToggleReportingInterrupts_Combat = function(self)
        self.ReportDB:TogglePath("INTERRUPTS.COMBAT")
    end,
    SetReportingInterrupts_Combat = function(self, value)
        self.ReportDB:SetPath("INTERRUPTS.COMBAT", value)
    end,
    IsReportingInterrupts_Boss = function(self)
        return self.ReportDB:GetPath("INTERRUPTS.BOSS")
    end,
    ToggleReportingInterrupts_Boss = function(self)
        self.ReportDB:TogglePath("INTERRUPTS.BOSS")
    end,
    SetReportingInterrupts_Boss = function(self, value)
        self.ReportDB:SetPath("INTERRUPTS.BOSS", value)
    end,
    IsReportingInterrupts_Dungeon = function(self)
        return self.ReportDB:GetPath("INTERRUPTS.DUNGEON")
    end,
    ToggleReportingInterrupts_Dungeon = function(self)
        self.ReportDB:TogglePath("INTERRUPTS.DUNGEON")
    end,
    SetReportingInterrupts_Dungeon = function(self, value)
        self.ReportDB:SetPath("INTERRUPTS.DUNGEON", value)
    end,
    IsReportingInterrupts_Top = function(self)
        return self.ReportDB:GetPath("INTERRUPTS.TOP")
    end,
    ToggleReportingInterrupts_Top = function(self)
        self.ReportDB:TogglePath("INTERRUPTS.TOP")
    end,
    SetReportingInterrupts_Top = function(self, value)
        self.ReportDB:SetPath("INTERRUPTS.TOP", value)
    end,
    IsReportingInterrupts_Bottom = function(self)
        return self.ReportDB:GetPath("INTERRUPTS.BOTTOM")
    end,
    ToggleReportingInterrupts_Bottom = function(self)
        self.ReportDB:TogglePath("INTERRUPTS.BOTTOM")
    end,
    SetReportingInterrupts_Bottom = function(self, value)
        self.ReportDB:SetPath("INTERRUPTS.BOTTOM", value)
    end,
    IsReportingDeaths_Combat = function(self)
        return self.ReportDB:GetPath("DEATHS.COMBAT")
    end,
    ToggleReportingDeaths_Combat = function(self)
        self.ReportDB:TogglePath("DEATHS.COMBAT")
    end,
    SetReportingDeaths_Combat = function(self, value)
        self.ReportDB:SetPath("DEATHS.COMBAT", value)
    end,
    IsReportingDeaths_Boss = function(self)
        return self.ReportDB:GetPath("DEATHS.BOSS")
    end,
    ToggleReportingDeaths_Boss = function(self)
        self.ReportDB:TogglePath("DEATHS.BOSS")
    end,
    SetReportingDeaths_Boss = function(self, value)
        self.ReportDB:SetPath("DEATHS.BOSS", value)
    end,
    IsReportingDeaths_Dungeon = function(self)
        return self.ReportDB:GetPath("DEATHS.DUNGEON")
    end,
    ToggleReportingDeaths_Dungeon = function(self)
        self.ReportDB:TogglePath("DEATHS.DUNGEON")
    end,
    SetReportingDeaths_Dungeon = function(self, value)
        self.ReportDB:SetPath("DEATHS.DUNGEON", value)
    end,
    IsReportingDeaths_Top = function(self)
        return self.ReportDB:GetPath("DEATHS.TOP")
    end,
    ToggleReportingDeaths_Top = function(self)
        self.ReportDB:TogglePath("DEATHS.TOP")
    end,
    SetReportingDeaths_Top = function(self, value)
        self.ReportDB:SetPath("DEATHS.TOP", value)
    end,
    IsReportingDeaths_Bottom = function(self)
        return self.ReportDB:GetPath("DEATHS.BOTTOM")
    end,
    ToggleReportingDeaths_Bottom = function(self)
        self.ReportDB:TogglePath("DEATHS.BOTTOM")
    end,
    SetReportingDeaths_Bottom = function(self, value)
        self.ReportDB:SetPath("DEATHS.BOTTOM", value)
    end,
    IsReportingOffheals_Combat = function(self)
        return self.ReportDB:GetPath("OFFHEALS.COMBAT")
    end,
    ToggleReportingOffheals_Combat = function(self)
        self.ReportDB:TogglePath("OFFHEALS.COMBAT")
    end,
    SetReportingOffheals_Combat = function(self, value)
        self.ReportDB:SetPath("OFFHEALS.COMBAT", value)
    end,
    IsReportingOffheals_Boss = function(self)
        return self.ReportDB:GetPath("OFFHEALS.BOSS")
    end,
    ToggleReportingOffheals_Boss = function(self)
        self.ReportDB:TogglePath("OFFHEALS.BOSS")
    end,
    SetReportingOffheals_Boss = function(self, value)
        self.ReportDB:SetPath("OFFHEALS.BOSS", value)
    end,
    IsReportingOffheals_Dungeon = function(self)
        return self.ReportDB:GetPath("OFFHEALS.DUNGEON")
    end,
    ToggleReportingOffheals_Dungeon = function(self)
        self.ReportDB:TogglePath("OFFHEALS.DUNGEON")
    end,
    SetReportingOffheals_Dungeon = function(self, value)
        self.ReportDB:SetPath("OFFHEALS.DUNGEON", value)
    end,
    IsReportingOffheals_Top = function(self)
        return self.ReportDB:GetPath("OFFHEALS.TOP")
    end,
    ToggleReportingOffheals_Top = function(self)
        self.ReportDB:TogglePath("OFFHEALS.TOP")
    end,
    SetReportingOffheals_Top = function(self, value)
        self.ReportDB:SetPath("OFFHEALS.TOP", value)
    end,
    IsReportingOffheals_Bottom = function(self)
        return self.ReportDB:GetPath("OFFHEALS.BOTTOM")
    end,
    ToggleReportingOffheals_Bottom = function(self)
        self.ReportDB:TogglePath("OFFHEALS.BOTTOM")
    end,
    SetReportingOffheals_Bottom = function(self, value)
        self.ReportDB:SetPath("OFFHEALS.BOTTOM", value)
    end,
    IsReportingPulls_Combat = function(self)
        return self.ReportDB:GetPath("PULLS.COMBAT")
    end,
    ToggleReportingPulls_Combat = function(self)
        self.ReportDB:TogglePath("PULLS.COMBAT")
    end,
    SetReportingPulls_Combat = function(self, value)
        self.ReportDB:SetPath("PULLS.COMBAT", value)
    end,
    IsReportingPulls_Boss = function(self)
        return self.ReportDB:GetPath("PULLS.BOSS")
    end,
    ToggleReportingPulls_Boss = function(self)
        self.ReportDB:TogglePath("PULLS.BOSS")
    end,
    SetReportingPulls_Boss = function(self, value)
        self.ReportDB:SetPath("PULLS.BOSS", value)
    end,
    IsReportingPulls_Dungeon = function(self)
        return self.ReportDB:GetPath("PULLS.DUNGEON")
    end,
    ToggleReportingPulls_Dungeon = function(self)
        self.ReportDB:TogglePath("PULLS.DUNGEON")
    end,
    SetReportingPulls_Dungeon = function(self, value)
        self.ReportDB:SetPath("PULLS.DUNGEON", value)
    end,
    IsReportingPulls_Top = function(self)
        return self.ReportDB:GetPath("PULLS.TOP")
    end,
    ToggleReportingPulls_Top = function(self)
        self.ReportDB:TogglePath("PULLS.TOP")
    end,
    SetReportingPulls_Top = function(self, value)
        self.ReportDB:SetPath("PULLS.TOP", value)
    end,
    IsReportingPulls_Bottom = function(self)
        return self.ReportDB:GetPath("PULLS.BOTTOM")
    end,
    ToggleReportingPulls_Bottom = function(self)
        self.ReportDB:TogglePath("PULLS.BOTTOM")
    end,
    SetReportingPulls_Bottom = function(self, value)
        self.ReportDB:SetPath("PULLS.BOTTOM", value)
    end,
    IsReportingPulls_Realtime = function(self)
        return self.ReportDB:GetPath("PULLS.REALTIME")
    end,
    ToggleReportingPulls_Realtime = function(self)
        self.ReportDB:TogglePath("PULLS.REALTIME")
    end,
    SetReportingPulls_Realtime = function(self, value)
        self.ReportDB:SetPath("PULLS.REALTIME", value)
    end,
    IsReportingPulls_Toast = function(self)
        return self.ReportDB:GetPath("PULLS.TOAST")
    end,
    ToggleReportingPulls_Toast = function(self)
        self.ReportDB:TogglePath("PULLS.TOAST")
    end,
    SetReportingPulls_Toast = function(self, value)
        self.ReportDB:SetPath("PULLS.TOAST", value)
    end,
    GetReportingPulls_Channel = function(self)
        return self.ReportDB:GetPath("PULLS.CHANNEL")
    end,
    SetReportingPulls_Channel = function(self, value)
        self.ReportDB:SetPath("PULLS.CHANNEL", value)
    end,
    IsReportingNeglectedHeals_Combat = function(self)
        return self.ReportDB:GetPath("NEGLECTEDHEALS.COMBAT")
    end,
    IsReportingNeglectedHeals_Realtime = function(self)
        return self.ReportDB:GetPath("NEGLECTEDHEALS.REALTIME")
    end,
    ToggleReportingNeglectedHeals_Realtime = function(self)
        self.ReportDB:TogglePath("NEGLECTEDHEALS.REALTIME")
    end,
    SetReportingNeglectedHeals_Realtime = function(self, value)
        self.ReportDB:SetPath("NEGLECTEDHEALS.REALTIME", value)
    end,
    IsReportingAffixes_CastStart = function(self)
        return self.ReportDB:GetPath("AFFIXES.CASTSTART")
    end,
    ToggleReportingAffixes_CastStart = function(self)
        self.ReportDB:TogglePath("AFFIXES.CASTSTART")
    end,
    SetReportingAffixes_CastStart = function(self, value)
        self.ReportDB:SetPath("AFFIXES.CASTSTART", value)
    end,
    IsReportingAffixes_CastSuccess = function(self)
        return self.ReportDB:GetPath("AFFIXES.CASTSUCCESS")
    end,
    ToggleReportingAffixes_CastSuccess = function(self)
        self.ReportDB:TogglePath("AFFIXES.CASTSUCCESS")
    end,
    SetReportingAffixes_CastSuccess = function(self, value)
        self.ReportDB:SetPath("AFFIXES.CASTSUCCESS", value)
    end,
    IsReportingAffixes_CastFailed = function(self)
        return self.ReportDB:GetPath("AFFIXES.CASTINTERRUPTED")
    end,
    ToggleReportingAffixes_CastFailed = function(self)
        self.ReportDB:TogglePath("AFFIXES.CASTINTERRUPTED")
    end,
    SetReportingAffixes_CastFailed = function(self, value)
        self.ReportDB:SetPath("AFFIXES.CASTINTERRUPTED", value)
    end,
    IsReportingAffixes_AuraStacks = function(self)
        return self.ReportDB:GetPath("AFFIXES.AURASTACKS")
    end,
    ToggleReportingAffixes_AuraStacks = function(self)
        self.ReportDB:TogglePath("AFFIXES.AURASTACKS")
    end,
    SetReportingAffixes_AuraStacks = function(self, value)
        self.ReportDB:SetPath("AFFIXES.AURASTACKS", value)
    end,
    IsReportingAffixes_Markers = function(self)
        return self.ReportDB:GetPath("AFFIXES.MARKERS")
    end,
    ToggleReportingAffixes_Markers = function(self)
        self.ReportDB:TogglePath("AFFIXES.MARKERS")
    end,
    SetReportingAffixes_Markers = function(self, value)
        self.ReportDB:SetPath("AFFIXES.MARKERS", value)
    end,
    IsReportingAffixes_Boss = function(self)
        return self.ReportDB:GetPath("AFFIXES.BOSS")
    end,
    ToggleReportingAffixes_Boss = function(self)
        self.ReportDB:TogglePath("AFFIXES.BOSS")
    end,
    SetReportingAffixes_Boss = function(self, value)
        self.ReportDB:SetPath("AFFIXES.BOSS", value)
    end,
    IsReportingAffixes_Dungeon = function(self)
        return self.ReportDB:GetPath("AFFIXES.DUNGEON")
    end,
    ToggleReportingAffixes_Dungeon = function(self)
        self.ReportDB:TogglePath("AFFIXES.DUNGEON")
    end,
    SetReportingAffixes_Dungeon = function(self, value)
        self.ReportDB:SetPath("AFFIXES.DUNGEON", value)
    end,
    IsReportingAffixes_Top = function(self)
        return self.ReportDB:GetPath("AFFIXES.TOP")
    end,
    ToggleReportingAffixes_Top = function(self)
        self.ReportDB:TogglePath("AFFIXES.TOP")
    end,
    SetReportingAffixes_Top = function(self, value)
        self.ReportDB:SetPath("AFFIXES.TOP", value)
    end,
    IsReportingAffixes_Bottom = function(self)
        return self.ReportDB:GetPath("AFFIXES.BOTTOM")
    end,
    ToggleReportingAffixes_Bottom = function(self)
        self.ReportDB:TogglePath("AFFIXES.BOTTOM")
    end,
    SetReportingAffixes_Bottom = function(self, value)
        self.ReportDB:SetPath("AFFIXES.BOTTOM", value)
    end,
    IsUsingGlobalChance = function(self)
        return self.CoreDB:GetKey("useGlobalChance")
    end,
    ToggleUsingGlobalChance = function(self)
        self.CoreDB:Toggle("useGlobalChance")
    end,
    SetUsingGlobalChance = function(self, value)
        self.CoreDB:SetKey("useGlobalChance", value)
    end,
    GetGlobalChance = function(self)
        return self.CoreDB:GetKey("globalChance")
    end,
    SetGlobalChance = function(self, value)
        self.CoreDB:SetKey("globalChance", value)
    end,
    GetMinimumTime = function(self)
        return self.CoreDB:GetKey("minimumTime")
    end,
    SetMinimumTime = function(self, value)
        self.CoreDB:SetKey("minimumTime", value)
    end,
    GetNemeses = function(self)
        return self.NemesisDB:Get();
    end,
    GetNemesis = function(self, name)
        return self.NemesisDB:GetKey(name)
    end,
    AddNemesis = function(self, name)
        self.NemesisDB:SetKey(name, name)
    end,
    RemoveNemesis = function(self, name)
        self.NemesisDB:DeleteKey(name)
    end,
    GetMessages = function(self)
        return self.CoreDB:GetKey("messages")
    end,
    AddMessage = function(self, message)
        self.CoreDB:InsertIntoArray("messages", message)
    end,
    RemoveMessage = function(self, message)
        self.CoreDB:DeleteFromArray("messages", message)
    end,
    ShouldShowInfoFrame = function(self)
        return self.CoreDB:GetKey("showInfoFrame")
    end,
    ToggleShowInfoFrame = function(self)
        self.CoreDB:Toggle("showInfoFrame")
    end,
    SetShowInfoFrame = function(self, value)
        self.CoreDB:SetKey("showInfoFrame", value)
    end,
    GetNotifyWhenTankApplies = function(self)
        return self.CoreDB:GetKey("notifyWhenTankApplies")
    end,
    ToggleNotifyWhenTankApplies = function(self)
        self.CoreDB:Toggle("notifyWhenTankApplies")
    end,
    SetNotifyWhenTankApplies = function(self, value)
        self.CoreDB:SetKey("notifyWhenTankApplies", value)
    end,
    GetNotifyWhenTankAppliesSound = function(self)
        return self.CoreDB:GetKey("notifyWhenTankAppliesSound")
    end,
    SetNotifyWhenTankAppliesSound = function(self, value)
        self.CoreDB:SetKey("notifyWhenTankAppliesSound", value)
    end,
    GetNotifyWhenHealerApplies = function(self)
        return self.CoreDB:GetKey("notifyWhenHealerApplies")
    end,
    ToggleNotifyWhenHealerApplies = function(self)
        self.CoreDB:Toggle("notifyWhenHealerApplies")
    end,
    SetNotifyWhenHealerApplies = function(self, value)
        self.CoreDB:SetKey("notifyWhenHealerApplies", value)
    end,
    GetNotifyWhenHealerAppliesSound = function(self)
        return self.CoreDB:GetKey("notifyWhenHealerAppliesSound")
    end,
    SetNotifyWhenHealerAppliesSound = function(self, value)
        self.CoreDB:SetKey("notifyWhenHealerAppliesSound", value)
    end,
    GetNotifyWhenDPSApplies = function(self)
        return self.CoreDB:GetKey("notifyWhenDPSApplies")
    end,
    ToggleNotifyWhenDPSApplies = function(self)
        self.CoreDB:Toggle("notifyWhenDPSApplies")
    end,
    SetNotifyWhenDPSApplies = function(self, value)
        self.CoreDB:SetKey("notifyWhenDPSApplies", value)
    end,
    GetNotifyWhenDPSAppliesSound = function(self)
        return self.CoreDB:GetKey("notifyWhenDPSAppliesSound")
    end,
    SetNotifyWhenDPSAppliesSound = function(self, value)
        self.CoreDB:SetKey("notifyWhenDPSAppliesSound", value)
    end,
    GetGroupMessageOnApplication = function(self)
        return self.CoreDB:GetKey("groupMessageOnApplication")
    end,
    ToggleGroupMessageOnApplication = function(self)
        self.CoreDB:Toggle("groupMessageOnApplication")
    end,
    SetGroupMessageOnApplication = function(self, value)
        self.CoreDB:SetKey("groupMessageOnApplication", value)
    end,
}
