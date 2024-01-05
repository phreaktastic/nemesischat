-----------------------------------------------------
-- NEMESIS CHAT API
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Built-in functionality w/ NC
-----------------------------------------------------

-- This replaces all the hard-coded, ugly logic that was previously defined in several files
NemesisChatAPI:AddAPI("CORE", "Core")
    :AddSubject({
        label = "Nemesis",
        value = "NEMESIS_PLAYER",
        exec = function() return NCEvent:GetNemesis() end,
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.UNIT_OPERATORS),
        type = "INPUT",
    })
    :AddSubject({
        label = "Bystander",
        value = "BYSTANDER_PLAYER",
        exec = function() return NCEvent:GetBystander() end,
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.UNIT_OPERATORS),
        type = "INPUT",
    })
    :AddSubject({
        label = "Boss Name",
        value = "BOSS_NAME",
        exec = function() return NCBoss:GetIdentifier() end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "Keystone Level",
        value = "KEYSTONE_LEVEL",
        exec = function() return NCDungeon:GetLevel() end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Dungeon Time",
        value = "DUNGEON_TIME",
        exec = function() return NCDungeon:GetStartTime() end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Boss Time",
        value = "BOSS_TIME",
        exec = function() return NCBoss:GetStartTime() end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "My Race",
        value = "RACE",
        exec = function() return UnitRace("player") end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "My Class",
        value = "CLASS",
        exec = function() return UnitClass("player") end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "My Spec",
        value = "SPEC",
        exec = function() return GetSpecializationNameForSpecID(GetSpecialization()) end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "My Item Level",
        value = "ILVL",
        exec = function() return GetAverageItemLevel() end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Nemesis Race",
        value = "NEMESIS_RACE",
        exec = function() return UnitRace(NCEvent:GetNemesis()) end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "Nemesis Class",
        value = "NEMESIS_CLASS",
        exec = function() return UnitClass(NCEvent:GetNemesis()) end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "Bystander Race",
        value = "BYSTANDER_RACE",
        exec = function() return UnitRace(NCEvent:GetBystander()) end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "Bystander Class",
        value = "BYSTANDER_CLASS",
        exec = function() return UnitClass(NCEvent:GetBystander()) end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddReplacement({
        label = "Boss Name",
        value = "BOSSNAME",
        exec = function() return NCBoss:GetIdentifier() end,
        description = "The boss's name.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Boss Time",
        value = "BOSSTIME",
        exec = function() return NemesisChat:GetDuration(NCBoss:GetStartTime()) end,
        description = "The amount of time that has passed since the boss fight started.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Bystander Deaths",
        value = "BYSTANDERDEATHS",
        exec = function() return (NCDungeon:GetDeaths(NCEvent:GetBystander()) or 0) end,
        description = "The number of times the Bystander has died in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Bystander Interrupts",
        value = "BYSTANDERINTERRUPTS",
        exec = function() return (NCCombat:GetInterrupts(NCEvent:GetBystander()) or 0) end,
        description = "The number of times the Bystander has interrupted an enemy spell cast in the current combat segment.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Bystander Interrupts (Overall)",
        value = "BYSTANDERINTERRUPTSOVERALL",
        exec = function() return (NCDungeon:GetInterrupts(NCEvent:GetBystander()) or 0) end,
        description = "The number of times the Bystander has interrupted an enemy spell cast in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Bystander Kills",
        value = "BYSTANDERKILLS",
        exec = function() return (NCDungeon:GetKills(NCEvent:GetBystander()) or 0) end,
        description = "The number of times the Bystander has killed a unit in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Bystander Name",
        value = "BYSTANDER",
        exec = function() return (Split(NCEvent:GetBystander(), "-")[1] or "") end,
        description = "The Bystander's name.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Bystander Role",
        value = "BYSTANDERROLE",
        exec = function() return GetRole(NCEvent:GetBystander()) end,
        description = "The Bystander's role.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Dungeon Time",
        value = "DUNGEONTIME",
        exec = function() return NemesisChat:GetDuration(NCDungeon:GetStartTime()) end,
        description = "The amount of time that has passed since the dungeon started.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Keystone Level",
        value = "KEYSTONELEVEL",
        exec = function() return NCDungeon:GetLevel() end,
        description = "The level of the keystone for the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "My Deaths",
        value = "DEATHS",
        exec = function() return (NCDungeon:GetDeaths(GetMyName()) or 0) end,
        description = "The number of times you have died in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "My Interrupts",
        value = "INTERRUPTS",
        exec = function() return (NCCombat:GetInterrupts(GetMyName()) or 0) end,
        description = "The number of times you have interrupted an enemy spell cast in the current combat segment.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "My Interrupts (Overall)",
        value = "INTERRUPTSOVERALL",
        exec = function() return (NCDungeon:GetInterrupts(GetMyName()) or 0) end,
        description = "The number of times you have interrupted an enemy spell cast in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "My Kills",
        value = "KILLS",
        exec = function() return (NCDungeon:GetKills(GetMyName()) or 0) end,
        description = "The number of times you have killed a unit in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "My Name",
        value = "SELF",
        exec = function() return GetMyName() end,
        description = "Your character's name.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "My Role",
        value = "ROLE",
        exec = function() return GetRole() end,
        description = "Your character's role.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Nemesis Deaths",
        value = "NEMESISDEATHS",
        exec = function() return (NCDungeon:GetDeaths(NCEvent:GetNemesis()) or 0) end,
        description = "The number of times the Nemesis has died in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Nemesis Interrupts",
        value = "NEMESISINTERRUPTS",
        exec = function() return (NCCombat:GetInterrupts(NCEvent:GetNemesis()) or 0) end,
        description = "The number of times the Nemesis has interrupted an enemy spell cast in the current combat segment.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Nemesis Interrupts (Overall)",
        value = "NEMESISINTERRUPTSOVERALL",
        exec = function() return (NCDungeon:GetInterrupts(NCEvent:GetNemesis()) or 0) end,
        description = "The number of times the Nemesis has interrupted an enemy spell cast in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Nemesis Kills",
        value = "NEMESISKILLS",
        exec = function() return (NCDungeon:GetKills(NCEvent:GetNemesis()) or 0) end,
        description = "The number of times the Nemesis has killed a unit in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Nemesis Name",
        value = "NEMESIS",
        exec = function() return (Split(NCEvent:GetNemesis(), "-")[1] or "") end,
        description = "The Nemesis's name.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Nemesis Role",
        value = "NEMESISROLE",
        exec = function() return GetRole(NCEvent:GetNemesis()) end,
        description = "The Nemesis's role.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Spell Name",
        value = "SPELL",
        exec = function() if NCEvent:GetEvent() == "INTERRUPT" then return (NCSpell:GetExtraSpellLink() or "Spell") else return (NCSpell:GetSpellLink() or NCSpell:GetExtraSpellLink() or "Spell") end end,
        description = "The name of the spell that was cast or interrupted.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Target Name",
        value = "TARGET",
        exec = function() return (Split(NCSpell:GetTarget(), "-")[1] or "") end,
        description = "The name of the target of the spell that was cast or interrupted.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Source Name",
        value = "SOURCE",
        exec = function() return (Split(NCSpell:GetSource(), "-")[1] or "") end,
        description = "The name of the source of the spell that was cast or interrupted.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "My Health",
        value = "HP",
        exec = function() return NemesisChat:FormatNumber(UnitHealth(GetMyName())) or 0 end,
        description = "The current health of your character.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "My Max Health",
        value = "MAXHP",
        exec = function() return NemesisChat:FormatNumber(UnitHealthMax(GetMyName())) or 0 end,
        description = "The maximum health of your character.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "My Health %",
        value = "HPPERCENT",
        exec = function() return math.floor((UnitHealth(GetMyName()) / UnitHealthMax(GetMyName())) * 100) .. "%" end,
        description = "The current health percentage of your character.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Bystander Health",
        value = "BYSTANDERHP",
        exec = function() return NemesisChat:FormatNumber(UnitHealth(NCEvent:GetBystander())) or 0 end,
        description = "The current health of the bystander.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Bystander Max Health",
        value = "BYSTANDERMAXHP",
        exec = function() return NemesisChat:FormatNumber(UnitHealthMax(NCEvent:GetBystander())) or 0 end,
        description = "The maximum health of the bystander.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Bystander Health %",
        value = "BYSTANDERHPPERCENT",
        exec = function() return math.floor((UnitHealth(NCEvent:GetBystander()) / UnitHealthMax(NCEvent:GetBystander())) * 100) .. "%" end,
        description = "The current health percentage of the bystander.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Nemesis Health",
        value = "NEMESISHP",
        exec = function() return NemesisChat:FormatNumber(UnitHealth(NCEvent:GetNemesis())) or 0 end,
        description = "The current health of the Nemesis.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Nemesis Max Health",
        value = "NEMESISMAXHP",
        exec = function() return NemesisChat:FormatNumber(UnitHealthMax(NCEvent:GetNemesis())) or 0 end,
        description = "The maximum health of the Nemesis.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Nemesis Health %",
        value = "NEMESISHPPERCENT",
        exec = function() return math.floor((UnitHealth(NCEvent:GetNemesis()) / UnitHealthMax(NCEvent:GetNemesis())) * 100) .. "%" end,
        description = "The current health percentage of the Nemesis.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "My Race",
        value = "RACE",
        exec = function() return UnitRace("player") end,
        description = "Your character's race.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "My Class",
        value = "CLASS",
        exec = function() return UnitClass("player") end,
        description = "Your character's class.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "My Spec",
        value = "SPEC",
        exec = function() return GetSpecializationNameForSpecID(GetSpecialization()) end,
        description = "Your character's specialization.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "My Item Level",
        value = "ILVL",
        exec = function() return GetAverageItemLevel() end,
        description = "Your character's average item level.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Nemesis Race",
        value = "NEMESISRACE",
        exec = function() return UnitRace(NCEvent:GetNemesis()) end,
        description = "The race of the Nemesis's character.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Nemesis Class",
        value = "NEMESISCLASS",
        exec = function() return UnitClass(NCEvent:GetNemesis()) end,
        description = "The class of the Nemesis's character.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Bystander Race",
        value = "BYSTANDERRACE",
        exec = function() return UnitRace(NCEvent:GetBystander()) end,
        description = "The race of the Bystander's character.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Bystander Class",
        value = "BYSTANDERCLASS",
        exec = function() return UnitClass(NCEvent:GetBystander()) end,
        description = "The class of the Bystander's character.",
        isNumeric = false,
    })
    :AddReplacement({
        value = "HP_CONDITION",
        exec = function() return UnitHealth(GetMyName()) or 0 end,
    })
    :AddReplacement({
        value = "MAXHP_CONDITION",
        exec = function() return UnitHealthMax(GetMyName()) or 0 end,
    })
    :AddReplacement({
        value = "HPPERCENT_CONDITION",
        exec = function() return math.floor((UnitHealth(GetMyName()) / UnitHealthMax(GetMyName())) * 100) end,
    })
    :AddReplacement({
        value = "BYSTANDERHP_CONDITION",
        exec = function() return UnitHealth(NCEvent:GetBystander()) or 0 end,
    })
    :AddReplacement({
        value = "BYSTANDERMAXHP_CONDITION",
        exec = function() return UnitHealthMax(NCEvent:GetBystander()) or 0 end,
    })
    :AddReplacement({
        value = "BYSTANDERHPPERCENT_CONDITION",
        exec = function() return math.floor((UnitHealth(NCEvent:GetBystander()) / UnitHealthMax(NCEvent:GetBystander())) * 100) end,
    })
    :AddReplacement({
        value = "NEMESISHP_CONDITION",
        exec = function() return UnitHealth(NCEvent:GetNemesis()) or 0 end,
    })
    :AddReplacement({
        value = "NEMESISMAXHP_CONDITION",
        exec = function() return UnitHealthMax(NCEvent:GetNemesis()) or 0 end,
    })
    :AddReplacement({
        value = "NEMESISHPPERCENT_CONDITION",
        exec = function() return math.floor((UnitHealth(NCEvent:GetNemesis()) / UnitHealthMax(NCEvent:GetNemesis())) * 100) end,
    })
