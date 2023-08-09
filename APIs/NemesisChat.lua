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
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.NC_OPERATORS),
        type = "INPUT",
    })
    :AddSubject({
        label = "Bystander",
        value = "BYSTANDER_PLAYER",
        exec = function() return NCEvent:GetBystander() end,
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.NC_OPERATORS),
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
        operators = core.constants.EXTENDED_OPERATORS,
        type = "NUMBER",
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
        exec = function() return NCDungeon:GetDeaths(NCEvent:GetBystander()) or 0 end,
        description = "The number of times the Bystander has died in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Bystander Interrupts",
        value = "BYSTANDERINTERRUPTS",
        exec = function() return NCCombat:GetInterrupts(NCEvent:GetBystander()) or 0 end,
        description = "The number of times the Bystander has interrupted an enemy spell cast in the current combat segment.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Bystander Interrupts (Overall)",
        value = "BYSTANDERINTERRUPTSOVERALL",
        exec = function() return NCDungeon:GetInterrupts(NCEvent:GetBystander()) or 0 end,
        description = "The number of times the Bystander has interrupted an enemy spell cast in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Bystander Kills",
        value = "BYSTANDERKILLS",
        exec = function() return NCDungeon:GetKills(NCEvent:GetBystander()) or 0 end,
        description = "The number of times the Bystander has killed a unit in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Bystander Name",
        value = "BYSTANDER",
        exec = function() return NCEvent:GetBystander() end,
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
        exec = function() return NCDungeon:GetDeaths(GetMyName()) or 0 end,
        description = "The number of times you have died in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "My Interrupts",
        value = "INTERRUPTS",
        exec = function() return NCCombat:GetInterrupts(GetMyName()) or 0 end,
        description = "The number of times you have interrupted an enemy spell cast in the current combat segment.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "My Interrupts (Overall)",
        value = "INTERRUPTSOVERALL",
        exec = function() return NCDungeon:GetInterrupts(GetMyName()) or 0 end,
        description = "The number of times you have interrupted an enemy spell cast in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "My Kills",
        value = "KILLS",
        exec = function() return NCDungeon:GetKills(GetMyName()) or 0 end,
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
        exec = function() return NCDungeon:GetDeaths(NCEvent:GetNemesis()) or 0 end,
        description = "The number of times the Nemesis has died in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Nemesis Interrupts",
        value = "NEMESISINTERRUPTS",
        exec = function() return NCCombat:GetInterrupts(NCEvent:GetNemesis()) or 0 end,
        description = "The number of times the Nemesis has interrupted an enemy spell cast in the current combat segment.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Nemesis Interrupts (Overall)",
        value = "NEMESISINTERRUPTSOVERALL",
        exec = function() return NCDungeon:GetInterrupts(NCEvent:GetNemesis()) or 0 end,
        description = "The number of times the Nemesis has interrupted an enemy spell cast in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Nemesis Kills",
        value = "NEMESISKILLS",
        exec = function() return NCDungeon:GetKills(NCEvent:GetNemesis()) or 0 end,
        description = "The number of times the Nemesis has killed a unit in the current dungeon.",
        isNumeric = true,
    })
    :AddReplacement({
        label = "Nemesis Name",
        value = "NEMESIS",
        exec = function() return NCEvent:GetNemesis() end,
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
        exec = function() return NCSpell:GetSpellLink() or NCSpell:GetExtraSpellLink() or "Spell" end,
        description = "The name of the spell that was cast.",
        isNumeric = false,
    })
    :AddReplacement({
        label = "Target Name",
        value = "TARGET",
        exec = function() return NCSpell:GetTarget() end,
        description = "The name of the target of the spell that was cast.",
        isNumeric = false,
    })
    
