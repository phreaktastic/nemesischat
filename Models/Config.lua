-----------------------------------------------------
-- CONFIG MODEL
-----------------------------------------------------
local _, core = ...;

NCConfig = {
    CoreDB = {},
    MessageSystemDB = {},
    LfgDB = {},
    NemesisDB = {},
    ApiDB = {},
    isInitialized = false,

    Initialize = function(self)
        if self.isInitialized then return end

        self.CoreDB = NCDB:New(nil)
        self.MessageSystemDB = NCDB:New("messageSystem")
        self.LfgDB = NCDB:New("lfg")
        self.NemesisDB = NCDB:New("nemeses")
        self.ApiDB = NCDB:New("api")

        core.EventSystem:Publish("DATABASE_INITIALIZED")

        self.isInitialized = true
    end,

    -----------------------------------------------------
    -- Core Settings
    -----------------------------------------------------
    IsEnabled = function(self)
        if not self.isInitialized then return true end
        return self.CoreDB:GetKey("enabled")
    end,

    SetEnabled = function(self, value)
        self.CoreDB:SetKey("enabled", value)
        if value then
            NemesisChat:Enable()
            NemesisChat:Print("Enabled.")
        else
            NemesisChat:Disable()
            NemesisChat:Print("Disabled.")
        end
        NemesisChat:CheckGroup()
    end,

    ToggleEnabled = function(self)
        self:SetEnabled(not self:IsEnabled())
    end,

    IsDebugging = function(self)
        return self.CoreDB:GetKey("debug")
    end,

    SetDebugging = function(self, value)
        self.CoreDB:SetKey("debug", value)
    end,

    ToggleDebugging = function(self)
        self.CoreDB:Toggle("debug")
    end,

    -- Reports Configuration
    IsExcludingNemeses = function(self)
        return self.MessageSystemDB:GetPath("globalSettings.excludeNemeses")
    end,

    SetExcludingNemeses = function(self, value)
        self.MessageSystemDB:SetPath("globalSettings.excludeNemeses", value)
    end,

    ToggleExcludingNemeses = function(self)
        self.MessageSystemDB:TogglePath("globalSettings.excludeNemeses")
    end,

    GetReportChannel = function(self)
        return self.MessageSystemDB:GetPath("globalSettings.defaultChannel")
    end,

    SetReportChannel = function(self, value)
        self.MessageSystemDB:SetPath("globalSettings.defaultChannel", value)
    end,

    IsReportingDamage_Combat = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.damage.triggers.afterCombat")
    end,

    IsReportingDamage_Boss = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.damage.triggers.afterBoss")
    end,

    IsReportingDamage_Dungeon = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.damage.triggers.afterDungeon")
    end,

    IsReportingDamage_Top = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.damage.reportTop")
    end,

    IsReportingDamage_Bottom = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.damage.reportBottom")
    end,

    -- Interrupt Reporting
    IsReportingInterrupts_Combat = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.interrupts.triggers.afterCombat")
    end,

    IsReportingInterrupts_Boss = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.interrupts.triggers.afterBoss")
    end,

    IsReportingInterrupts_Dungeon = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.interrupts.triggers.afterDungeon")
    end,

    IsReportingInterrupts_Top = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.interrupts.reportTop")
    end,

    IsReportingInterrupts_Bottom = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.interrupts.reportBottom")
    end,

    -- Avoidable Damage Reporting
    IsReportingAvoidable_Combat = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.avoidable.triggers.afterCombat")
    end,

    IsReportingAvoidable_Boss = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.avoidable.triggers.afterBoss")
    end,

    IsReportingAvoidable_Dungeon = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.avoidable.triggers.afterDungeon")
    end,

    IsReportingAvoidable_Top = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.avoidable.reportTop")
    end,

    IsReportingAvoidable_Bottom = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.avoidable.reportBottom")
    end,

    -- Death Reporting
    IsReportingDeaths_Combat = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.deaths.triggers.afterCombat")
    end,

    IsReportingDeaths_Boss = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.deaths.triggers.afterBoss")
    end,

    IsReportingDeaths_Dungeon = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.deaths.triggers.afterDungeon")
    end,

    IsReportingDeaths_Top = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.deaths.reportTop")
    end,

    IsReportingDeaths_Bottom = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.deaths.reportBottom")
    end,

    -- Off-Heals Reporting
    IsReportingOffheals_Combat = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.offHeals.triggers.afterCombat")
    end,

    IsReportingOffheals_Boss = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.offHeals.triggers.afterBoss")
    end,

    IsReportingOffheals_Dungeon = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.offHeals.triggers.afterDungeon")
    end,

    IsReportingOffheals_Top = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.offHeals.reportTop")
    end,

    IsReportingOffheals_Bottom = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.offHeals.reportBottom")
    end,

    IsReportingCrowdControl_Combat = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.crowdcontrol.triggers.afterCombat")
    end,

    -- Crowd Control Reporting
    IsReportingCrowdControl_Boss = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.crowdcontrol.triggers.afterBoss")
    end,

    IsReportingCrowdControl_Dungeon = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.crowdcontrol.triggers.afterDungeon")
    end,

    IsReportingCrowdControl_Top = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.crowdcontrol.reportTop")
    end,

    IsReportingCrowdControl_Bottom = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.crowdcontrol.reportBottom")
    end,

    -- Toggle methods for all types
    ToggleReportingDamage_Combat = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.damage.triggers.afterCombat")
    end,

    ToggleReportingDamage_Boss = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.damage.triggers.afterBoss")
    end,

    ToggleReportingDamage_Dungeon = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.damage.triggers.afterDungeon")
    end,

    ToggleReportingDamage_Top = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.damage.reportTop")
    end,

    ToggleReportingDamage_Bottom = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.damage.reportBottom")
    end,

    ToggleReportingInterrupts_Combat = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.interrupts.triggers.afterCombat")
    end,

    ToggleReportingInterrupts_Boss = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.interrupts.triggers.afterBoss")
    end,

    ToggleReportingInterrupts_Dungeon = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.interrupts.triggers.afterDungeon")
    end,

    ToggleReportingInterrupts_Top = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.interrupts.reportTop")
    end,

    ToggleReportingInterrupts_Bottom = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.interrupts.reportBottom")
    end,

    ToggleReportingAvoidable_Combat = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.avoidable.triggers.afterCombat")
    end,

    ToggleReportingAvoidable_Boss = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.avoidable.triggers.afterBoss")
    end,

    ToggleReportingAvoidable_Dungeon = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.avoidable.triggers.afterDungeon")
    end,

    ToggleReportingAvoidable_Top = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.avoidable.reportTop")
    end,

    ToggleReportingAvoidable_Bottom = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.avoidable.reportBottom")
    end,

    ToggleReportingDeaths_Combat = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.deaths.triggers.afterCombat")
    end,

    ToggleReportingDeaths_Boss = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.deaths.triggers.afterBoss")
    end,

    ToggleReportingDeaths_Dungeon = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.deaths.triggers.afterDungeon")
    end,

    ToggleReportingDeaths_Top = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.deaths.reportTop")
    end,

    ToggleReportingDeaths_Bottom = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.deaths.reportBottom")
    end,

    ToggleReportingOffheals_Combat = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.offHeals.triggers.afterCombat")
    end,

    ToggleReportingOffheals_Boss = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.offHeals.triggers.afterBoss")
    end,

    ToggleReportingOffheals_Dungeon = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.offHeals.triggers.afterDungeon")
    end,

    ToggleReportingOffheals_Top = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.offHeals.reportTop")
    end,

    ToggleReportingOffheals_Bottom = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.offHeals.reportBottom")
    end,

    ToggleReportingCrowdControl_Combat = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.crowdcontrol.triggers.afterCombat")
    end,

    ToggleReportingCrowdControl_Boss = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.crowdcontrol.triggers.afterBoss")
    end,

    ToggleReportingCrowdControl_Dungeon = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.crowdcontrol.triggers.afterDungeon")
    end,

    ToggleReportingCrowdControl_Top = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.crowdcontrol.reportTop")
    end,

    ToggleReportingCrowdControl_Bottom = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.crowdcontrol.reportBottom")
    end,

    -- Pull reporting found in Reports.lua
    IsReportingPulls_Realtime = function(self)
        return self.MessageSystemDB:GetPath("categories.dungeon.types.pulls.realtime")
    end,

    SetReportingPulls_Realtime = function(self, value)
        self.MessageSystemDB:SetPath("categories.dungeon.types.pulls.realtime", value)
    end,

    ToggleReportingPulls_Realtime = function(self)
        self.MessageSystemDB:TogglePath("categories.dungeon.types.pulls.realtime")
    end,

    GetReportingPulls_Channel = function(self)
        return self.MessageSystemDB:GetPath("categories.dungeon.types.pulls.channel")
    end,

    SetReportingPulls_Channel = function(self, value)
        self.MessageSystemDB:SetPath("categories.dungeon.types.pulls.channel", value)
    end,

    IsReportingPulls_Toast = function(self)
        return self.MessageSystemDB:GetPath("categories.dungeon.types.pulls.showToast")
    end,

    ToggleReportingPulls_Toast = function(self)
        self.MessageSystemDB:TogglePath("categories.dungeon.types.pulls.showToast")
    end,

    SetReportingPulls_Toast = function(self, value)
        self.MessageSystemDB:SetPath("categories.dungeon.types.pulls.showToast", value)
    end,

    -----------------------------------------------------
    -- Message System
    -----------------------------------------------------
    IsMessageSystemEnabled = function(self)
        return self.MessageSystemDB:GetPath("enabled")
    end,

    SetMessageSystemEnabled = function(self, value)
        self.MessageSystemDB:SetPath("enabled", value)
    end,

    ToggleMessageSystemEnabled = function(self)
        self.MessageSystemDB:TogglePath("enabled")
    end,

    -- Player Tracking & Reporting
    IsTrackingLeavers = function(self)
        return self.MessageSystemDB:GetPath("categories.player.types.leave.trackHistory")
    end,

    SetTrackingLeavers = function(self, value)
        self.MessageSystemDB:SetPath("categories.player.types.leave.trackHistory", value)
    end,

    IsReportingLeaversOnJoin = function(self)
        return self.MessageSystemDB:GetPath("categories.player.types.join.reportLeaverHistory")
    end,

    SetReportingLeaversOnJoin = function(self, value)
        self.MessageSystemDB:SetPath("categories.player.types.join.reportLeaverHistory", value)
    end,

    GetReportingLeaversOnJoinThreshold = function(self)
        return self.MessageSystemDB:GetPath("categories.player.types.join.leaverThreshold")
    end,

    SetReportingLeaversOnJoinThreshold = function(self, value)
        if type(value) ~= "number" or value < 1 or value > 50 then
            value = 5
        end
        self.MessageSystemDB:SetPath("categories.player.types.join.leaverThreshold", value)
    end,

    IsTrackingLowPerformers = function(self)
        return self.MessageSystemDB:GetPath("categories.player.types.join.reportPerformanceHistory")
    end,

    SetTrackingLowPerformers = function(self, value)
        self.MessageSystemDB:SetPath("categories.player.types.join.reportPerformanceHistory", value)
    end,

    IsReportingLowPerformersOnJoin = function(self)
        return self.MessageSystemDB:GetPath("categories.player.types.join.reportPerformanceHistory")
    end,

    SetReportingLowPerformersOnJoin = function(self, value)
        self.MessageSystemDB:SetPath("categories.player.types.join.reportPerformanceHistory", value)
    end,

    GetReportingLowPerformersOnJoinThreshold = function(self)
        return self.MessageSystemDB:GetPath("categories.player.types.join.performanceThreshold")
    end,

    SetReportingLowPerformersOnJoinThreshold = function(self, value)
        if value < 1 or value > 50 then
            value = 5
        end
        self.MessageSystemDB:SetPath("categories.player.types.join.performanceThreshold", value)
    end,

    -- Global Settings
    GetGlobalSettings = function(self)
        return self.MessageSystemDB:GetPath("globalSettings")
    end,

    GetGlobalChance = function(self)
        return self.MessageSystemDB:GetPath("globalSettings.globalChance")
    end,

    SetGlobalChance = function(self, value)
        self.MessageSystemDB:SetPath("globalSettings.globalChance", value)
    end,

    IsGlobalChanceEnabled = function(self)
        return self.MessageSystemDB:GetPath("globalSettings.useGlobalChance")
    end,

    SetGlobalChanceEnabled = function(self, value)
        self.MessageSystemDB:SetPath("globalSettings.useGlobalChance", value)
    end,

    ToggleGlobalChanceEnabled = function(self)
        self.MessageSystemDB:TogglePath("globalSettings.useGlobalChance")
    end,

    GetMinimumTime = function(self)
        return self.MessageSystemDB:GetPath("globalSettings.minimumTime")
    end,

    SetMinimumTime = function(self, value)
        self.MessageSystemDB:SetPath("globalSettings.minimumTime", value)
    end,

    IsRollingMessages = function(self)
        return self.MessageSystemDB:GetPath("globalSettings.rollingMessages")
    end,

    ToggleRollingMessages = function(self)
        self.MessageSystemDB:TogglePath("globalSettings.rollingMessages")
    end,

    SetRollingMessages = function(self, value)
        self.MessageSystemDB:SetPath("globalSettings.rollingMessages", value)
    end,

    -- Combat Settings
    IsNonCombatMode = function(self)
        return self.MessageSystemDB:GetPath("nonCombatMode")
    end,

    SetNonCombatMode = function(self, value)
        self.MessageSystemDB:SetPath("nonCombatMode", value)
    end,

    IsInterruptException = function(self)
        return self.MessageSystemDB:GetPath("interruptException")
    end,

    SetInterruptException = function(self, value)
        self.MessageSystemDB:SetPath("interruptException", value)
    end,

    IsDeathException = function(self)
        return self.MessageSystemDB:GetPath("deathException")
    end,

    SetDeathException = function(self, value)
        self.MessageSystemDB:SetPath("deathException", value)
    end,

    IsAvoidableDamageException = function(self)
        return self.MessageSystemDB:GetPath("avoidableDamageException")
    end,

    SetAvoidableDamageException = function(self, value)
        self.MessageSystemDB:SetPath("avoidableDamageException", value)
    end,

    -- Game Integration
    IsAllowingBrannMessages = function(self)
        return self.MessageSystemDB:GetPath("allowBrannMessages")
    end,

    SetAllowingBrannMessages = function(self, value)
        self.MessageSystemDB:SetPath("allowBrannMessages", value)
    end,

    IsFlaggingFriendsAsNemeses = function(self)
        return self.MessageSystemDB:GetPath("flagFriendsAsNemeses")
    end,

    SetFlaggingFriendsAsNemeses = function(self, value)
        self.MessageSystemDB:SetPath("flagFriendsAsNemeses", value)
    end,

    IsFlaggingGuildmatesAsNemeses = function(self)
        return self.MessageSystemDB:GetPath("flagGuildmatesAsNemeses")
    end,

    SetFlaggingGuildmatesAsNemeses = function(self, value)
        self.MessageSystemDB:SetPath("flagGuildmatesAsNemeses", value)
    end,

    -- Category Settings
    IsCategoryEnabled = function(self, category)
        return self.MessageSystemDB:GetPath("categories." .. category .. ".enabled")
    end,

    SetCategoryEnabled = function(self, category, value)
        self.MessageSystemDB:SetPath("categories." .. category .. ".enabled", value)
    end,

    -- Combat Messages
    GetCombatMessageSettings = function(self, messageType)
        return self.MessageSystemDB:GetPath("categories.combat.types." .. messageType)
    end,

    IsCombatMessageEnabled = function(self, messageType)
        return self.MessageSystemDB:GetPath("categories.combat.types." .. messageType .. ".enabled")
    end,

    SetCombatMessageEnabled = function(self, messageType, value)
        self.MessageSystemDB:SetPath("categories.combat.types." .. messageType .. ".enabled", value)
    end,

    IsCombatMessageTopReporting = function(self, messageType)
        return self.MessageSystemDB:GetPath("categories.combat.types." .. messageType .. ".reportTop")
    end,

    SetCombatMessageTopReporting = function(self, messageType, value)
        self.MessageSystemDB:SetPath("categories.combat.types." .. messageType .. ".reportTop", value)
    end,

    IsCombatMessageBottomReporting = function(self, messageType)
        return self.MessageSystemDB:GetPath("categories.combat.types." .. messageType .. ".reportBottom")
    end,

    SetCombatMessageBottomReporting = function(self, messageType, value)
        self.MessageSystemDB:SetPath("categories.combat.types." .. messageType .. ".reportBottom", value)
    end,

    IsCombatMessageTrigger = function(self, messageType, trigger)
        return self.MessageSystemDB:GetPath("categories.combat.types." .. messageType .. ".triggers." .. trigger)
    end,

    SetCombatMessageTrigger = function(self, messageType, trigger, value)
        self.MessageSystemDB:SetPath("categories.combat.types." .. messageType .. ".triggers." .. trigger, value)
    end,

    -----------------------------------------------------
    -- LFG Settings
    -----------------------------------------------------
    GetLfgApplicantSettings = function(self)
        return self.LfgDB:GetPath("applicants")
    end,

    -- Global Applicant Settings
    GetApplicantMinItemLevel = function(self)
        return self.LfgDB:GetPath("applicants.global.minItemLevel")
    end,

    SetApplicantMinItemLevel = function(self, value)
        self.LfgDB:SetPath("applicants.global.minItemLevel", value)
    end,

    GetApplicantMinDungeonScore = function(self)
        return self.LfgDB:GetPath("applicants.global.minDungeonScore")
    end,

    SetApplicantMinDungeonScore = function(self, value)
        self.LfgDB:SetPath("applicants.global.minDungeonScore", value)
    end,

    IsPopupOnIgnoredApplicants = function(self)
        return self.LfgDB:GetPath("applicants.global.popupOnIgnoredApplicants")
    end,

    SetPopupOnIgnoredApplicants = function(self, value)
        self.LfgDB:SetPath("applicants.global.popupOnIgnoredApplicants", value)
    end,

    TogglePopupOnIgnoredApplicants = function(self)
        self.LfgDB:TogglePath("applicants.global.popupOnIgnoredApplicants")
    end,

    IsDisableFiltersWhenNotLeader = function(self)
        return self.LfgDB:GetPath("applicants.global.disableFiltersWhenNotLeader")
    end,

    SetDisableFiltersWhenNotLeader = function(self, value)
        self.LfgDB:SetPath("applicants.global.disableFiltersWhenNotLeader", value)
    end,

    ToggleDisableFiltersWhenNotLeader = function(self)
        self.LfgDB:TogglePath("applicants.global.disableFiltersWhenNotLeader")
    end,

    IsShowNotificationsWhenFiltered = function(self)
        return self.LfgDB:GetPath("applicants.global.showNotificationsWhenFiltered")
    end,

    SetShowNotificationsWhenFiltered = function(self, value)
        self.LfgDB:SetPath("applicants.global.showNotificationsWhenFiltered", value)
    end,

    ToggleShowNotificationsWhenFiltered = function(self)
        self.LfgDB:TogglePath("applicants.global.showNotificationsWhenFiltered")
    end,

    -- Realm Settings
    GetAllowedRealms = function(self)
        return self.LfgDB:GetPath("applicants.global.allowedRealms")
    end,

    SetAllowedRealms = function(self, value)
        self.LfgDB:SetPath("applicants.global.allowedRealms", value)
    end,

    GetIgnoredRealms = function(self)
        return self.LfgDB:GetPath("applicants.global.ignoredRealms")
    end,

    SetIgnoredRealms = function(self, value)
        self.LfgDB:SetPath("applicants.global.ignoredRealms", value)
    end,

    -- Class Settings
    GetAllowedClasses = function(self)
        return self.LfgDB:GetPath("applicants.global.allowedClasses")
    end,

    SetAllowedClasses = function(self, value)
        self.LfgDB:SetPath("applicants.global.allowedClasses", value)
    end,

    GetIgnoredClasses = function(self)
        return self.LfgDB:GetPath("applicants.global.ignoredClasses")
    end,

    SetIgnoredClasses = function(self, value)
        self.LfgDB:SetPath("applicants.global.ignoredClasses", value)
    end,

    -- Spec Settings
    GetAllowedSpecs = function(self)
        return self.LfgDB:GetPath("applicants.global.allowedSpecs")
    end,

    SetAllowedSpecs = function(self, value)
        self.LfgDB:SetPath("applicants.global.allowedSpecs", value)
    end,

    GetIgnoredSpecs = function(self)
        return self.LfgDB:GetPath("applicants.global.ignoredSpecs")
    end,

    SetIgnoredSpecs = function(self, value)
        self.LfgDB:SetPath("applicants.global.ignoredSpecs", value)
    end,

    -- Helper methods for array operations (these were also missing)
    AddAllowedRealm = function(self, realm)
        local realms = self:GetAllowedRealms() or {}
        table.insert(realms, realm)
        self:SetAllowedRealms(realms)
    end,

    RemoveAllowedRealm = function(self, realm)
        local realms = self:GetAllowedRealms() or {}
        for i, v in ipairs(realms) do
            if v == realm then
                table.remove(realms, i)
                break
            end
        end
        self:SetAllowedRealms(realms)
    end,

    AddIgnoredRealm = function(self, realm)
        local realms = self:GetIgnoredRealms() or {}
        table.insert(realms, realm)
        self:SetIgnoredRealms(realms)
    end,

    RemoveIgnoredRealm = function(self, realm)
        local realms = self:GetIgnoredRealms() or {}
        for i, v in ipairs(realms) do
            if v == realm then
                table.remove(realms, i)
                break
            end
        end
        self:SetIgnoredRealms(realms)
    end,

    -- Similar helpers for classes and specs
    AddAllowedClass = function(self, class)
        local classes = self:GetAllowedClasses() or {}
        table.insert(classes, class)
        self:SetAllowedClasses(classes)
    end,

    RemoveAllowedClass = function(self, class)
        local classes = self:GetAllowedClasses() or {}
        for i, v in ipairs(classes) do
            if v == class then
                table.remove(classes, i)
                break
            end
        end
        self:SetAllowedClasses(classes)
    end,

    AddIgnoredClass = function(self, class)
        local classes = self:GetIgnoredClasses() or {}
        table.insert(classes, class)
        self:SetIgnoredClasses(classes)
    end,

    RemoveIgnoredClass = function(self, class)
        local classes = self:GetIgnoredClasses() or {}
        for i, v in ipairs(classes) do
            if v == class then
                table.remove(classes, i)
                break
            end
        end
        self:SetIgnoredClasses(classes)
    end,

    AddAllowedSpec = function(self, spec)
        local specs = self:GetAllowedSpecs() or {}
        table.insert(specs, spec)
        self:SetAllowedSpecs(specs)
    end,

    RemoveAllowedSpec = function(self, spec)
        local specs = self:GetAllowedSpecs() or {}
        for i, v in ipairs(specs) do
            if v == spec then
                table.remove(specs, i)
                break
            end
        end
        self:SetAllowedSpecs(specs)
    end,

    AddIgnoredSpec = function(self, spec)
        local specs = self:GetIgnoredSpecs() or {}
        table.insert(specs, spec)
        self:SetIgnoredSpecs(specs)
    end,

    RemoveIgnoredSpec = function(self, spec)
        local specs = self:GetIgnoredSpecs() or {}
        for i, v in ipairs(specs) do
            if v == spec then
                table.remove(specs, i)
                break
            end
        end
        self:SetIgnoredSpecs(specs)
    end,

    -- Role-specific Settings
    IsRoleEnabled = function(self, role)
        return self.LfgDB:GetPath("applicants.roles." .. role .. ".enabled")
    end,

    SetRoleEnabled = function(self, role, value)
        self.LfgDB:SetPath("applicants.roles." .. role .. ".enabled", value)
    end,

    ToggleRoleEnabled = function(self, role)
        self.LfgDB:TogglePath("applicants.roles." .. role .. ".enabled")
    end,

    GetRoleSound = function(self, role)
        return self.LfgDB:GetPath("applicants.roles." .. role .. ".sound")
    end,

    SetRoleSound = function(self, role, value)
        self.LfgDB:SetPath("applicants.roles." .. role .. ".sound", value)
    end,

    IsRoleChatEnabled = function(self, role)
        return self.LfgDB:GetPath("applicants.roles." .. role .. ".chat")
    end,

    SetRoleChatEnabled = function(self, role, value)
        self.LfgDB:SetPath("applicants.roles." .. role .. ".chat", value)
    end,

    ToggleRoleChatEnabled = function(self, role)
        self.LfgDB:TogglePath("applicants.roles." .. role .. ".chat")
    end,

    GetRoleMinItemLevel = function(self, role)
        return self.LfgDB:GetPath("applicants.roles." .. role .. ".minItemLevel")
    end,

    SetRoleMinItemLevel = function(self, role, value)
        self.LfgDB:SetPath("applicants.roles." .. role .. ".minItemLevel", value)
    end,

    GetRoleMinDungeonScore = function(self, role)
        return self.LfgDB:GetPath("applicants.roles." .. role .. ".minDungeonScore")
    end,

    SetRoleMinDungeonScore = function(self, role, value)
        self.LfgDB:SetPath("applicants.roles." .. role .. ".minDungeonScore", value)
    end,

    -----------------------------------------------------
    -- Nemeses Management
    -----------------------------------------------------
    GetNemeses = function(self)
        return self.NemesisDB:Get()
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

    ToggleNemesis = function(self, name)
        if self:GetNemesis(name) then
            self:RemoveNemesis(name)
        else
            self:AddNemesis(name)
        end

        core.EventSystem:Publish("NEMESIS_TOGGLED")
    end,

    RenameNemesis = function(self, oldName, newName)
        self.NemesisDB:SetKey(newName, newName)
        self.NemesisDB:DeleteKey(oldName)
    end,

    -----------------------------------------------------
    -- Stats Frame
    -----------------------------------------------------
    ShouldShowInfoFrame = function(self)
        return self.CoreDB:GetKey("showInfoFrame")
    end,

    SetShowInfoFrame = function(self, value)
        self.CoreDB:SetKey("showInfoFrame", value)
    end,

    -----------------------------------------------------
    -- API Integration
    -----------------------------------------------------
    GetAPI = function(self, name)
        return self.ApiDB:GetKey(name)
    end,

    SetAPI = function(self, name, value)
        self.ApiDB:SetKey(name, value)
    end,

    -----------------------------------------------------
    -- Low Performer Reporting
    -----------------------------------------------------
    IsReportingLowPerformersOnWipe = function(self)
        return self.MessageSystemDB:GetPath("categories.combat.types.wipe.reportLowPerformers")
    end,

    SetReportingLowPerformersOnWipe = function(self, value)
        self.MessageSystemDB:SetPath("categories.combat.types.wipe.reportLowPerformers", value)
    end,

    ToggleReportingLowPerformersOnWipe = function(self)
        self.MessageSystemDB:TogglePath("categories.combat.types.wipe.reportLowPerformers")
    end,

    IsReportingLowPerformersOnDungeonFail = function(self)
        return self.MessageSystemDB:GetPath("categories.dungeon.types.failure.reportLowPerformers")
    end,

    SetReportingLowPerformersOnDungeonFail = function(self, value)
        self.MessageSystemDB:SetPath("categories.dungeon.types.failure.reportLowPerformers", value)
    end,

    ToggleReportingLowPerformersOnDungeonFail = function(self)
        self.MessageSystemDB:TogglePath("categories.dungeon.types.failure.reportLowPerformers")
    end,

    -----------------------------------------------------
    -- Message Methods
    -----------------------------------------------------
    GetMessages = function(self)
        return self.CoreDB:GetKey("messages")
    end,

    GetMessagesByPath = function(self, path)
        return self.CoreDB:GetPath("messages." .. path)
    end,

    SetMessagesByPath = function(self, path, value)
        self.CoreDB:SetPath("messages." .. path, value)
    end,

    AddMessage = function(self, message)
        self.CoreDB:InsertIntoArray("messages", message)
    end,

    AddMessageByPath = function(self, path, message)
        self.CoreDB:PathInsert("messages." .. path, message)
    end,

    RemoveMessage = function(self, message)
        self.CoreDB:DeleteFromArray("messages", message)
    end,

    -----------------------------------------------------
    -- Cache Helper Methods
    -----------------------------------------------------
    ---@param key string Accepts a simple key or a path
    ---@return any
    GetCacheValue = function(self, key)
        return self.CoreDB:GetPath("cache." .. key)
    end,

    SetCacheValue = function(self, key, value)
        self.CoreDB:SetPath("cache." .. key, value)
    end,

    GetCacheTime = function(self, key)
        return self.CoreDB:GetPath("cache." .. key .. "Time")
    end,

    SetCacheTime = function(self, key, value)
        self.CoreDB:SetPath("cache." .. key .. "Time", value)
    end,

    -----------------------------------------------------
    -- Data Migration Methods
    -----------------------------------------------------
    NeedsMigration = function(self)
        return not self:GetPath("profile.schemaVersion") or
            self:GetPath("profile.schemaVersion") < NCMigration.currentVersion
    end,

    GetMigrations = function(self)
        return self.CoreDB:GetKey("migrations")
    end,

    SetMigrations = function(self, value)
        self.CoreDB:SetKey("migrations", value)
    end,

    AddMigration = function(self, migration)
        self.CoreDB:PathInsert("migrations", migration)
    end,

    -----------------------------------------------------
    -- Message Preview Methods
    -----------------------------------------------------
    GetReplacements = function(self)
        return core.reference.replacements
    end,

    UpdateMessagePreview = function(self)
        if not self:GetMessages() or #self:GetMessages() == 0 then
            return "Select/enter a message to see the preview"
        end

        if self:GetNemesesLength() == 0 then
            return ""
        end

        local spacer = ": "
        local channel = self:GetReportChannel()
        local color = core.reference.colors[channel] or core.reference.colors["SAY"]

        if channel == "EMOTE" then
            spacer = " "
        end

        local chatMsg = NCController:GetExampleString(self:GetCurrentMessage())
        return color .. UnitName("player") .. spacer .. chatMsg .. "|r"
    end,

    -----------------------------------------------------
    -- Message Selection Methods
    -----------------------------------------------------
    GetNemesesLength = function(self)
        return self.NemesisDB:GetLength() or 0
    end,

    GetCurrentMessage = function(self)
        return self.MessageSystemDB:GetPath("globalSettings.currentMessage")
    end,

    SetCurrentMessage = function(self, message)
        self.MessageSystemDB:SetPath("globalSettings.currentMessage", message)
    end,

    -----------------------------------------------------
    -- Event/Condition Methods
    -----------------------------------------------------
    HasConditions = function(self)
        local category = self:GetCurrentCategory()
        local event = self:GetCurrentEvent()
        local target = self:GetCurrentTarget()
        local message = self:GetCurrentMessage()

        if not category or not event or not target or not message then
            return false
        end

        local conditions = self.MessageSystemDB:GetPath(
            string.format("categories.%s.events.%s.targets.%s.messages.%s.conditions",
                category, event, target, message)
        )

        return conditions and #conditions > 0
    end,

    GetCurrentCategory = function(self)
        return self.MessageSystemDB:GetPath("globalSettings.currentCategory")
    end,

    SetCurrentCategory = function(self, category)
        self.MessageSystemDB:SetPath("globalSettings.currentCategory", category)
    end,

    GetCurrentEvent = function(self)
        return self.MessageSystemDB:GetPath("globalSettings.currentEvent")
    end,

    SetCurrentEvent = function(self, event)
        self.MessageSystemDB:SetPath("globalSettings.currentEvent", event)
    end,

    GetCurrentTarget = function(self)
        return self.MessageSystemDB:GetPath("globalSettings.currentTarget")
    end,

    SetCurrentTarget = function(self, target)
        self.MessageSystemDB:SetPath("globalSettings.currentTarget", target)
    end,

    -----------------------------------------------------
    -- Leaver/Low Performer Methods
    -----------------------------------------------------
    GetLeavers = function(self)
        return self.CoreDB:GetKey("leavers")
    end,

    GetLeaversCount = function(self)
        return self.CoreDB:GetLength("leavers")
    end,

    AddLeaver = function(self, guid)
        self.CoreDB:PathInsert("leavers." .. guid, math.ceil(GetTime() / 10) * 10)
    end,

    GetLeaverCount = function(self, guid)
        return self.CoreDB:GetPathLength("leavers." .. guid)
    end,

    SetLeavers = function(self, value)
        self.CoreDB:SetKey("leavers", value)
    end,

    GetLowPerformers = function(self)
        return self.CoreDB:GetKey("lowPerformers")
    end,

    GetLowPerformersCount = function(self)
        return self.CoreDB:GetLength("lowPerformers")
    end,

    AddLowPerformer = function(self, guid)
        self.CoreDB:PathInsert("lowPerformers." .. guid, math.ceil(GetTime() / 10) * 10)
    end,

    GetLowPerformerCount = function(self, guid)
        return self.CoreDB:GetPathLength("lowPerformers." .. guid)
    end,

    SetLowPerformers = function(self, value)
        self.CoreDB:SetKey("lowPerformers", value)
    end,

    GetLeaversEncoded = function(self)
        return self.CoreDB:GetKey("leaversEncoded")
    end,

    SetLeaversEncoded = function(self, value)
        self.CoreDB:SetKey("leaversEncoded", value)
    end,

    GetLeaversSerialized = function(self)
        return self.CoreDB:GetKey("leaversSerialized")
    end,

    SetLeaversSerialized = function(self, value)
        self.CoreDB:SetKey("leaversSerialized", value)
    end,

    GetLeaversCompressed = function(self)
        return self.CoreDB:GetKey("leaversCompressed")
    end,

    SetLeaversCompressed = function(self, value)
        self.CoreDB:SetKey("leaversCompressed", value)
    end,

    GetLowPerformersEncoded = function(self)
        return self.CoreDB:GetKey("lowPerformersEncoded")
    end,

    SetLowPerformersEncoded = function(self, value)
        self.CoreDB:SetKey("lowPerformersEncoded", value)
    end,

    GetLowPerformersSerialized = function(self)
        return self.CoreDB:GetKey("lowPerformersSerialized")
    end,

    SetLowPerformersSerialized = function(self, value)
        self.CoreDB:SetKey("lowPerformersSerialized", value)
    end,

    GetLowPerformersCompressed = function(self)
        return self.CoreDB:GetKey("lowPerformersCompressed")
    end,

    SetLowPerformersCompressed = function(self, value)
        self.CoreDB:SetKey("lowPerformersCompressed", value)
    end,

    -----------------------------------------------------
    -- UI Modifications
    -----------------------------------------------------
    IsContextMenuEnabled = function(self)
        return self.CoreDB:GetPath("ui.contextMenuEnabled")
    end,

    SetContextMenuEnabled = function(self, value)
        self.CoreDB:SetPath("ui.contextMenuEnabled", value)
        self:PublishContextMenuToggled()
    end,

    ToggleContextMenuEnabled = function(self)
        self.CoreDB:TogglePath("ui.contextMenuEnabled")
        self:PublishContextMenuToggled()
    end,

    -----------------------------------------------------
    --- General Helper Methods
    -----------------------------------------------------
    Get = function(self, key)
        return self.CoreDB:GetKey(key)
    end,

    GetPath = function(self, path)
        return self.CoreDB:GetPath(path)
    end,

    Set = function(self, key, value)
        self.CoreDB:SetKey(key, value)
    end,

    SetPath = function(self, path, value)
        self.CoreDB:SetPath(path, value)
    end,

    PublishContextMenuToggled = function(self)
        core.EventSystem:Publish("NC_CONTEXT_MENU_TOGGLED", self.CoreDB:GetPath("ui.contextMenuEnabled"))
    end,
}

return NCConfig
