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
        category = "Nemesis",
        exec = function() return NCEvent:GetNemesis() end,
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.UNIT_OPERATORS),
        type = "INPUT",
    })
    :AddSubject({
        label = "Bystander",
        value = "BYSTANDER_PLAYER",
        category = "Bystander",
        exec = function() return NCEvent:GetBystander() end,
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.UNIT_OPERATORS),
        type = "INPUT",
    })
    :AddSubject({
        label = "Boss Name",
        value = "BOSS_NAME",
        category = "Dungeon / Encounter",
        exec = function() return NCBoss:GetIdentifier() end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "Keystone Level",
        value = "KEYSTONE_LEVEL",
        category = "Dungeon / Encounter",
        exec = function() return NCDungeon:GetLevel() end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Dungeon Time",
        value = "DUNGEON_TIME",
        category = "Dungeon / Encounter",
        exec = function() return NCDungeon:GetStartTime() end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Boss Time",
        value = "BOSS_TIME",
        category = "Dungeon / Encounter",
        exec = function() return NCBoss:GetStartTime() end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "My Race",
        value = "RACE",
        category = "Me",
        exec = function() return UnitRace("player") end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "My Class",
        value = "CLASS",
        category = "Me",
        exec = function() return UnitClass("player") end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "My Spec",
        value = "SPEC",
        category = "Me",
        exec = function() return GetSpecializationNameForSpecID(GetSpecialization()) end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "My Item Level",
        value = "ILVL",
        category = "Me",
        exec = function() return GetAverageItemLevel() end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Nemesis Race",
        value = "NEMESIS_RACE",
        category = "Nemesis",
        exec = function() return UnitRace(NCEvent:GetNemesis()) end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "Nemesis Class",
        value = "NEMESIS_CLASS",
        category = "Nemesis",
        exec = function() return UnitClass(NCEvent:GetNemesis()) end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "Bystander Race",
        value = "BYSTANDER_RACE",
        category = "Bystander",
        exec = function() return UnitRace(NCEvent:GetBystander()) end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "Nemesis Role",
        value = "NEMESIS_ROLE",
        category = "Nemesis",
        exec = function() return GetRole(NCEvent:GetNemesis()) end,
        operators = core.constants.OPERATORS,
        type = "SELECT",
        options = DeepCopy(core.roles)
    })
    :AddSubject({
        label = "Bystander Role",
        value = "BYSTANDER_ROLE",
        category = "Bystander",
        exec = function() return UnitGroupRolesAssigned(NCEvent:GetBystander()) end,
        operators = core.constants.OPERATORS,
        type = "SELECT",
        options = DeepCopy(core.roles)
    })
    :AddSubject({
        label = "My Role",
        value = "ROLE",
        category = "Me",
        exec = function() return GetRole() end,
        operators = core.constants.OPERATORS,
        type = "SELECT",
        options = DeepCopy(core.roles)
    })
    :AddSubject({
        label = "Spell ID",
        value = "SPELL_ID",
        category = "Spell",
        exec = function() return NCSpell:GetSpellId() .. "" end,
        operators = core.constants.OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Spell Name",
        value = "SPELL_NAME",
        category = "Spell",
        exec = function() return NCSpell:GetSpellName() or "Spell" end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "Spell Target",
        value = "SPELL_TARGET",
        category = "Spell",
        exec = function() return NCSpell:GetTarget() end,
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.UNIT_OPERATORS),
        type = "INPUT",
    })
    :AddSubject({
        label = "Spell Source",
        value = "SPELL_SOURCE",
        category = "Spell",
        exec = function() return NCSpell:GetSource() end,
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.UNIT_OPERATORS),
        type = "INPUT",
    })
    :AddSubject({
        label = "Players in Group",
        value = "GROUP_COUNT",
        category = "Group",
        exec = function() return NCRuntime:GetGroupRosterCount() or 0 end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Group Lead",
        value = "GROUP_LEAD",
        category = "Group",
        exec = function() return NCRuntime:GetGroupLead() end,
        operators = ArrayMerge(core.constants.OPERATORS, core.constants.UNIT_OPERATORS),
        type = "INPUT",
    })
    :AddSubject({
        label = "Nemeses in Group",
        value = "NEMESES_COUNT",
        category = "Group",
        exec = function() return NemesisChat:GetPartyNemesesCount() .. "" end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Bystanders in Group",
        value = "BYSTANDERS_COUNT",
        category = "Group",
        exec = function() return NemesisChat:GetPartyBystandersCount() .. "" end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "My Interrupts (Combat)",
        value = "INTERRUPTS",
        category = "Combat",
        exec = function() return (NCCombat:GetInterrupts(GetMyName()) or 0) .. "" end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "My Interrupts (Dungeon)",
        value = "INTERRUPTS_OVERALL",
        category = "Combat",
        exec = function() return (NCDungeon:GetInterrupts(GetMyName()) or 0) .. "" end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Nem. Interrupts (Combat)",
        value = "NEMESIS_INTERRUPTS",
        category = "Combat",
        exec = function() return (NCCombat:GetInterrupts(NCEvent:GetNemesis()) or 0) .. "" end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Nem. Interrupts (Dungeon)",
        value = "NEMESIS_INTERRUPTS_OVERALL",
        category = "Combat",
        exec = function() return (NCDungeon:GetInterrupts(NCEvent:GetNemesis()) or 0) .. "" end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Bys. Interrupts (Combat)",
        value = "BYSTANDER_INTERRUPTS",
        category = "Combat",
        exec = function() return (NCCombat:GetInterrupts(NCEvent:GetBystander()) or 0) .. "" end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Bys. Interrupts (Dungeon)",
        value = "BYSTANDER_INTERRUPTS_OVERALL",
        category = "Combat",
        exec = function() return (NCDungeon:GetInterrupts(NCEvent:GetBystander()) or 0) .. "" end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Bystander Class",
        value = "BYSTANDER_CLASS",
        category = "Bystander",
        exec = function() return UnitClass(NCEvent:GetBystander()) end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "Spell Damage",
        value = "DAMAGE_SUBJECT",
        category = "Spell",
        exec = function() return NCSpell:GetDamage() end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "My Health",
        value = "HP",
        category = "Me",
        exec = function() return UnitHealth("player") end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "My Max Health",
        value = "MAX_HP",
        category = "Me",
        exec = function() return UnitHealthMax("player") end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "My Health %",
        value = "HP_PERCENT",
        category = "Me",
        exec = function() return math.floor((UnitHealth("player") / UnitHealthMax("player")) * 100) end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Bystander Health",
        value = "BYSTANDER_HP",
        category = "Bystander",
        exec = function() return UnitHealth(NCEvent:GetBystander()) end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Bystander Max Health",
        value = "BYSTANDER_MAX_HP",
        category = "Bystander",
        exec = function() return UnitHealthMax(NCEvent:GetBystander()) end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Bystander Health %",
        value = "BYSTANDER_HP_PERCENT",
        category = "Bystander",
        exec = function() return math.floor((UnitHealth(NCEvent:GetBystander()) / UnitHealthMax(NCEvent:GetBystander())) * 100) end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Nemesis Health",
        value = "NEMESIS_HP",
        category = "Nemesis",
        exec = function() return UnitHealth(NCEvent:GetNemesis()) end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Nemesis Max Health",
        value = "NEMESIS_MAX_HP",
        category = "Nemesis",
        exec = function() return UnitHealthMax(NCEvent:GetNemesis()) end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Nemesis Health %",
        value = "NEMESIS_HP_PERCENT",
        category = "Nemesis",
        exec = function() return math.floor((UnitHealth(NCEvent:GetNemesis()) / UnitHealthMax(NCEvent:GetNemesis())) * 100) end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Boss Health %",
        value = "BOSS_HP_PERCENT",
        category = "Dungeon / Encounter",
        exec = function() if not NCBoss:IsActive() then return 0 end return math.floor((UnitHealth(NCBoss:GetIdentifier()) / UnitHealthMax(NCBoss:GetIdentifier())) * 100) end,
        operators = ArrayMerge(core.constants.NUMERIC_OPERATORS, core.constants.OPERATORS),
        type = "NUMBER",
    })
    :AddSubject({
        label = "Dungeon",
        value = "DUNGEON",
        category = "Dungeon / Encounter",
        exec = function() return NCDungeon:GetIdentifier() end,
        operators = core.constants.OPERATORS,
        type = "INPUT",
    })
    :AddSubject({
        label = "In M+ Dungeon",
        value = "DUNGEON_ACTIVE",
        category = "Dungeon / Encounter",
        exec = function() return NCDungeon:IsActive() end,
        operators = core.constants.IS,
        type = "SELECT",
        options = DeepCopy(core.constants.BOOLEAN_OPTIONS)
    })
    :AddSubject({
        label = "In Boss Fight",
        value = "BOSS_ACTIVE",
        category = "Dungeon / Encounter",
        exec = function() return NCBoss:IsActive() end,
        operators = core.constants.IS,
        type = "SELECT",
        options = DeepCopy(core.constants.BOOLEAN_OPTIONS)
    })
    :AddSubject({
        label = "In Combat",
        value = "COMBAT_ACTIVE",
        category = "Combat",
        exec = function() return NCCombat:IsActive() end,
        operators = core.constants.IS,
        type = "SELECT",
        options = DeepCopy(core.constants.BOOLEAN_OPTIONS)
    })
    :AddReplacement({
        label = "Boss Name",
        value = "BOSSNAME",
        exec = function() return NCBoss:GetIdentifier() end,
        description = "The boss's name.",
        isNumeric = false,
        example = function()
            local examples = {
                "Magmorax",
                "Ragnaros",
                "Kel'Thuzad",
                "Illidan Stormrage",
                "Arthas Menethil",
                "Deathwing",
                "Garrosh Hellscream",
                "Gul'dan",
                "Kil'jaeden",
                "Argus the Unmaker",
                "Jaina Proudmoore",
                "Sylvanas Windrunner",
                "Queen Azshara",
                "N'Zoth the Corruptor",
            }

            return examples[math.random(1, #examples)]
        end,
    })
    :AddReplacement({
        label = "Boss Time",
        value = "BOSSTIME",
        exec = function() return NemesisChat:GetDuration(NCBoss:GetStartTime()) end,
        description = "The amount of time that has passed since the boss fight started.",
        isNumeric = false,
        example = function() return NemesisChat:GetDuration(GetTime() - math.random(101, 276)) end,
    })
    :AddReplacement({
        label = "Bystander Deaths",
        value = "BYSTANDERDEATHS",
        exec = function() return (NCDungeon:GetDeaths(NCEvent:GetBystander()) or 0) end,
        description = "The number of times the Bystander has died in the current dungeon.",
        isNumeric = true,
        example = function() return math.random(1, 10) end,
    })
    :AddReplacement({
        label = "Bystander Interrupts",
        value = "BYSTANDERINTERRUPTS",
        exec = function() return (NCCombat:GetInterrupts(NCEvent:GetBystander()) or 0) end,
        description = "The number of times the Bystander has interrupted an enemy spell cast in the current combat segment.",
        isNumeric = true,
        example = function() return math.random(1, 3) end,
    })
    :AddReplacement({
        label = "Bystander Interrupts (Overall)",
        value = "BYSTANDERINTERRUPTSOVERALL",
        exec = function() return (NCDungeon:GetInterrupts(NCEvent:GetBystander()) or 0) end,
        description = "The number of times the Bystander has interrupted an enemy spell cast in the current dungeon.",
        isNumeric = true,
        example = function() return math.random(1, 350) end,
    })
    :AddReplacement({
        label = "Bystander Kills",
        value = "BYSTANDERKILLS",
        exec = function() return (NCDungeon:GetKills(NCEvent:GetBystander()) or 0) end,
        description = "The number of times the Bystander has killed a unit in the current dungeon.",
        isNumeric = true,
        example = function() return math.random(1, 100) end,
    })
    :AddReplacement({
        label = "Bystander Name",
        value = "BYSTANDER",
        exec = function() return (Ambiguate(NCEvent:GetBystander(), "short") or "") end,
        description = "The Bystander's name.",
        isNumeric = false,
        example = function() return NemesisChat:GetRandomPartyBystander() or "ShmoopleDoop" end,
    })
    :AddReplacement({
        label = "Bystander Role",
        value = "BYSTANDERROLE",
        exec = function() return GetRole(NCEvent:GetBystander()) end,
        description = "The Bystander's role.",
        isNumeric = false,
        example = function()
            local examples = {
                "TANK",
                "HEALER",
                "DAMAGER",
            }

            return GetRole(NCEvent:GetBystander()) or core.rolesLookup[examples[math.random(1, #examples)]] or "DPS"
        end,
    })
    :AddReplacement({
        label = "Dungeon Time",
        value = "DUNGEONTIME",
        exec = function() return NemesisChat:GetDuration(NCDungeon:GetStartTime()) end,
        description = "The amount of time that has passed since the dungeon started.",
        isNumeric = false,
        example = function() return NemesisChat:GetDuration(GetTime() - math.random(101, 1276)) end,
    })
    :AddReplacement({
        label = "Keystone Level",
        value = "KEYSTONELEVEL",
        exec = function() return NCDungeon:GetLevel() end,
        description = "The level of the keystone for the current dungeon.",
        isNumeric = true,
        example = function()
            local iLevel = GetAverageItemLevel()

            -- This is AI generated, there's no real logic behind it
            if iLevel <= 440 then
                return math.random(1, 11)
            elseif iLevel <= 450 then
                return math.random(7, 13)
            elseif iLevel <= 460 then
                return math.random(11, 17)
            elseif iLevel <= 470 then
                return math.random(15, 19)
            elseif iLevel <= 480 then
                return math.random(18, 21)
            elseif iLevel <= 490 then
                return math.random(21, 28)
            end

            return math.random(1, 30)
        end,
    })
    :AddReplacement({
        label = "My Deaths",
        value = "DEATHS",
        exec = function() return (NCDungeon:GetDeaths(GetMyName()) or 0) end,
        description = "The number of times you have died in the current dungeon.",
        isNumeric = true,
        example = function() return math.random(1, 10) end,
    })
    :AddReplacement({
        label = "My Interrupts",
        value = "INTERRUPTS",
        exec = function() return (NCCombat:GetInterrupts(GetMyName()) or 0) end,
        description = "The number of times you have interrupted an enemy spell cast in the current combat segment.",
        isNumeric = true,
        example = function() return math.random(1, 3) end,
    })
    :AddReplacement({
        label = "My Interrupts (Overall)",
        value = "INTERRUPTSOVERALL",
        exec = function() return (NCDungeon:GetInterrupts(GetMyName()) or 0) end,
        description = "The number of times you have interrupted an enemy spell cast in the current dungeon.",
        isNumeric = true,
        example = function() return math.random(1, 350) end,
    })
    :AddReplacement({
        label = "My Kills",
        value = "KILLS",
        exec = function() return (NCDungeon:GetKills(GetMyName()) or 0) end,
        description = "The number of times you have killed a unit in the current dungeon.",
        isNumeric = true,
        example = function() return math.random(1, 100) end,
    })
    :AddReplacement({
        label = "My Name",
        value = "SELF",
        exec = function() return GetMyName() end,
        description = "Your character's name.",
        isNumeric = false,
        example = function() return GetMyName() end,
    })
    :AddReplacement({
        label = "My Role",
        value = "ROLE",
        exec = function() return GetRole() end,
        description = "Your character's role.",
        isNumeric = false,
        example = function() GetRole() end,
    })
    :AddReplacement({
        label = "Nemesis Deaths",
        value = "NEMESISDEATHS",
        exec = function() return (NCDungeon:GetDeaths(NCEvent:GetNemesis()) or 0) end,
        description = "The number of times the Nemesis has died in the current dungeon.",
        isNumeric = true,
        example = function() return math.random(10, 100) end,
    })
    :AddReplacement({
        label = "Nemesis Interrupts",
        value = "NEMESISINTERRUPTS",
        exec = function() return (NCCombat:GetInterrupts(NCEvent:GetNemesis()) or 0) end,
        description = "The number of times the Nemesis has interrupted an enemy spell cast in the current combat segment.",
        isNumeric = true,
        example = function() return math.random(0, 2) end,
    })
    :AddReplacement({
        label = "Nemesis Interrupts (Overall)",
        value = "NEMESISINTERRUPTSOVERALL",
        exec = function() return (NCDungeon:GetInterrupts(NCEvent:GetNemesis()) or 0) end,
        description = "The number of times the Nemesis has interrupted an enemy spell cast in the current dungeon.",
        isNumeric = true,
        example = function() return math.random(1, 350) end,
    })
    :AddReplacement({
        label = "Nemesis Kills",
        value = "NEMESISKILLS",
        exec = function() return (NCDungeon:GetKills(NCEvent:GetNemesis()) or 0) end,
        description = "The number of times the Nemesis has killed a unit in the current dungeon.",
        isNumeric = true,
        example = function() return math.random(1, 100) end,
    })
    :AddReplacement({
        label = "Nemesis Name",
        value = "NEMESIS",
        exec = function() return (Split(NCEvent:GetNemesis(), "-")[1] or "") end,
        description = "The Nemesis's name.",
        isNumeric = false,
        example = function() return NemesisChat:GetRandomPartyNemesis() or NemesisChat:GetRandomGuildNemesis() or "YoloSwagNoScope" end,
    })
    :AddReplacement({
        label = "Nemesis Role",
        value = "NEMESISROLE",
        exec = function() return GetRole(NCEvent:GetNemesis()) end,
        description = "The Nemesis's role.",
        isNumeric = false,
        example = function() 
            local examples = {
                "TANK",
                "HEALER",
                "DAMAGER",
            }

            return core.rolesLookup[examples[math.random(1, #examples)]] or "DPS"
        end,
    })
    :AddReplacement({
        label = "Spell Name",
        value = "SPELL",
        exec = function() if NCEvent:GetEvent() == "INTERRUPT" then return (NCSpell:GetExtraSpellLink() or "Spell") else return (NCSpell:GetSpellLink() or NCSpell:GetExtraSpellLink() or "Spell") end end,
        description = "The name of the spell that was cast or interrupted.",
        isNumeric = false,
        example = function()
            if NCRuntime.previewSpell then
                return GetSpellLink(NCRuntime.previewSpell) or "!!INVALID SPELL!!"
            end

            local examples = {
                204243,
                200642,
                200658,
                225562,
                225573,
                201399,
                201839,
            }

            return GetSpellLink(examples[math.random(1, #examples)])
        end,
    })
    :AddReplacement({
        label = "Target Name",
        value = "TARGET",
        exec = function() return (Split(NCSpell:GetTarget(), "-")[1] or "") end,
        description = "The name of the target of the spell that was cast or interrupted.",
        isNumeric = false,
        example = function() return "Poor Unfortunate Soul" end,
    })
    :AddReplacement({
        label = "Source Name",
        value = "SOURCE",
        exec = function() return (Split(NCSpell:GetSource(), "-")[1] or "") end,
        description = "The name of the source of the spell that was cast or interrupted.",
        isNumeric = false,
        example = function()
            local examples = {
                "Dreadfire Imp",
                "Taintheart Summoner",
                "Bloodtainted Burster",
                "Infinite Timebender",
                "Infinite Chronomancer",
                "Time-Lost Waveshaper"
            }

            return examples[math.random(1, #examples)]
        end,
    })
    :AddReplacement({
        label = "My Health",
        value = "HP",
        exec = function() return NemesisChat:FormatNumber(UnitHealth("player")) or 0 end,
        description = "The current health of your character.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(UnitHealth("player")) or 0 end,
    })
    :AddReplacement({
        label = "My Max Health",
        value = "MAXHP",
        exec = function() return NemesisChat:FormatNumber(UnitHealthMax("player")) or 0 end,
        description = "The maximum health of your character.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(UnitHealthMax("player")) or 0 end,
    })
    :AddReplacement({
        label = "My Health %",
        value = "HPPERCENT",
        exec = function() return math.floor((UnitHealth("player") / UnitHealthMax("player")) * 100) .. "%" end,
        description = "The current health percentage of your character.",
        isNumeric = true,
        example = function() return math.floor((UnitHealth("player") / UnitHealthMax("player")) * 100) .. "%" end,
    })
    :AddReplacement({
        label = "Bystander Health",
        value = "BYSTANDERHP",
        exec = function() return NemesisChat:FormatNumber(UnitHealth(NCEvent:GetBystander())) or 0 end,
        description = "The current health of the bystander.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(UnitHealth(NemesisChat:GetRandomPartyBystander() or NemesisChat:GetRandomGuildBystander()) or math.random(1, 1305725)) end,
    })
    :AddReplacement({
        label = "Bystander Max Health",
        value = "BYSTANDERMAXHP",
        exec = function() return NemesisChat:FormatNumber(UnitHealthMax(NCEvent:GetBystander())) or 0 end,
        description = "The maximum health of the bystander.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(UnitHealthMax(NemesisChat:GetRandomPartyBystander() or NemesisChat:GetRandomGuildBystander()) or math.random(642765, 1305725)) end,
    })
    :AddReplacement({
        label = "Bystander Health %",
        value = "BYSTANDERHPPERCENT",
        exec = function() return math.floor((UnitHealth(NCEvent:GetBystander()) / UnitHealthMax(NCEvent:GetBystander())) * 100) .. "%" end,
        description = "The current health percentage of the bystander.",
        isNumeric = true,
        example = function() return math.random(1, 100) .. "%" end,
    })
    :AddReplacement({
        label = "Nemesis Health",
        value = "NEMESISHP",
        exec = function() return NemesisChat:FormatNumber(UnitHealth(NCEvent:GetNemesis())) or 0 end,
        description = "The current health of the Nemesis.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(UnitHealth(NemesisChat:GetRandomPartyNemesis() or NemesisChat:GetRandomGuildNemesis()) or math.random(1, 1305725)) end,
    })
    :AddReplacement({
        label = "Nemesis Max Health",
        value = "NEMESISMAXHP",
        exec = function() return NemesisChat:FormatNumber(UnitHealthMax(NCEvent:GetNemesis())) or 0 end,
        description = "The maximum health of the Nemesis.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(UnitHealthMax(NemesisChat:GetRandomPartyNemesis() or NemesisChat:GetRandomGuildNemesis()) or math.random(642765, 1305725)) end,
    })
    :AddReplacement({
        label = "Nemesis Health %",
        value = "NEMESISHPPERCENT",
        exec = function() return math.floor((UnitHealth(NCEvent:GetNemesis()) / UnitHealthMax(NCEvent:GetNemesis())) * 100) .. "%" end,
        description = "The current health percentage of the Nemesis.",
        isNumeric = true,
        example = function() return math.random(1, 100) .. "%" end,
    })
    :AddReplacement({
        label = "My Race",
        value = "RACE",
        exec = function() return UnitRace("player") end,
        description = "Your character's race.",
        isNumeric = false,
        example = function() return UnitRace("player") end,
    })
    :AddReplacement({
        label = "My Class",
        value = "CLASS",
        exec = function() return UnitClass("player") end,
        description = "Your character's class.",
        isNumeric = false,
        example = function() return UnitClass("player") end,
    })
    :AddReplacement({
        label = "My Spec",
        value = "SPEC",
        exec = function() return GetSpecializationNameForSpecID(GetSpecialization()) end,
        description = "Your character's specialization.",
        isNumeric = false,
        example = function() return GetSpecializationNameForSpecID(GetSpecialization()) end,
    })
    :AddReplacement({
        label = "My Item Level",
        value = "ILVL",
        exec = function() return GetAverageItemLevel() end,
        description = "Your character's average item level.",
        isNumeric = true,
        example = function() return GetAverageItemLevel() end,
    })
    :AddReplacement({
        label = "Nemesis Race",
        value = "NEMESISRACE",
        exec = function() return UnitRace(NCEvent:GetNemesis()) end,
        description = "The race of the Nemesis's character.",
        isNumeric = false,
        example = function()
            local exampleRaces = {
                "Human",
                "Dwarf",
                "Night Elf",
                "Gnome",
                "Draenei",
                "Worgen",
                "Pandaren",
                "Orc",
                "Undead",
                "Tauren",
                "Troll",
                "Blood Elf",
                "Goblin",
                "Nightborne",
                "Highmountain Tauren",
                "Void Elf",
                "Lightforged Draenei",
                "Zandalari Troll",
                "Kul Tiran",
                "Dark Iron Dwarf",
                "Vulpera",
                "Mag'har Orc",
                "Mechagnome",
            }

            return exampleRaces[math.random(1, #exampleRaces)]
        end,
    })
    :AddReplacement({
        label = "Nemesis Class",
        value = "NEMESISCLASS",
        exec = function() return UnitClass(NCEvent:GetNemesis()) end,
        description = "The class of the Nemesis's character.",
        isNumeric = false,
        example = function()
            local exampleClasses = {
                "Warrior",
                "Paladin",
                "Hunter",
                "Rogue",
                "Priest",
                "Death Knight",
                "Shaman",
                "Mage",
                "Warlock",
                "Monk",
                "Druid",
                "Demon Hunter",
            }

            return exampleClasses[math.random(1, #exampleClasses)]
        end,
    })
    :AddReplacement({
        label = "Bystander Race",
        value = "BYSTANDERRACE",
        exec = function() return UnitRace(NCEvent:GetBystander()) end,
        description = "The race of the Bystander's character.",
        isNumeric = false,
        example = function()
            local exampleRaces = {
                "Human",
                "Dwarf",
                "Night Elf",
                "Gnome",
                "Draenei",
                "Worgen",
                "Pandaren",
                "Orc",
                "Undead",
                "Tauren",
                "Troll",
                "Blood Elf",
                "Goblin",
                "Nightborne",
                "Highmountain Tauren",
                "Void Elf",
                "Lightforged Draenei",
                "Zandalari Troll",
                "Kul Tiran",
                "Dark Iron Dwarf",
                "Vulpera",
                "Mag'har Orc",
                "Mechagnome",
            }

            return exampleRaces[math.random(1, #exampleRaces)]
        end,
    })
    :AddReplacement({
        label = "Bystander Class",
        value = "BYSTANDERCLASS",
        exec = function() return UnitClass(NCEvent:GetBystander()) end,
        description = "The class of the Bystander's character.",
        isNumeric = false,
        example = function()
            local exampleClasses = {
                "Warrior",
                "Paladin",
                "Hunter",
                "Rogue",
                "Priest",
                "Death Knight",
                "Shaman",
                "Mage",
                "Warlock",
                "Monk",
                "Druid",
                "Demon Hunter",
            }

            return exampleClasses[math.random(1, #exampleClasses)]
        end,
    })
    :AddReplacement({
        label = "Damage",
        value = "DAMAGE",
        exec = function() return NemesisChat:FormatNumber(NCSpell:GetDamage()) or 0 end,
        description = "The amount of damage dealt by the spell that was cast.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(math.random(1, 1000000)) end,
    })
    :AddReplacement({
        label = "Group Lead",
        value = "GROUPLEAD",
        exec = function() return NCRuntime:GetGroupLead() end,
        description = "The name of the player who is the leader of the group.",
        isNumeric = false,
        example = function() return NCRuntime:GetGroupLead() or "GroupLeeeedz" end,
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
