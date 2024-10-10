-----------------------------------------------------
-- GTFO API
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

GTFO = _G.GTFO;

-----------------------------------------------------
-- GTFO functions for altering event responses
-----------------------------------------------------

NemesisChatAPI:AddAPI("NC_GTFO", "GTFO API")
    :AddConfigOption({
        label = "Enable GTFO API",
        value = "ENABLED", -- This will read in config options as NC_GTFO_ENABLED
        description = "Enable the GTFO API for use in messages.",
        primary = true,
    })
    :AddCompatibilityCheck({
        configCheck = false,
        exec = function()
            if GTFO == nil then
                return false, "GTFO is not installed."
            end

            local test = GTFO.SpellID["447917"] -- Test for a spell ID that should exist in GTFO

            if test == nil then
                return false, "GTFO is installed, but something went wrong. This is likely due to a change on their end, which NC will need to update for."
            end

            return true, nil
        end
    })
    :AddCompatibilityCheck({
        configCheck = true,
        exec = function() 
            if not NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() then
                return false, "GTFO API is not enabled."
            end
    
            return true, nil
        end
    })
    :AddSubject({
        label = "Nem. Avoidable (Combat)",
        value = "NEMESIS_AD",
        category = "Combat",
        exec = function() return NCCombat:GetAvoidableDamage(NCEvent:GetNemesis() or "Unknown") end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Nem. Avoidable (Dungeon)",
        value = "NEMESIS_AD_OVERALL",
        category = "Combat",
        exec = function() return NCDungeon:GetAvoidableDamage(NCEvent:GetNemesis() or "Unknown") end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Bys. Avoidable (Combat)",
        value = "BYSTANDER_AD",
        category = "Combat",
        exec = function() return NCCombat:GetAvoidableDamage(NCEvent:GetBystander() or "Unknown") end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Bys. Avoidable (Dungeon)",
        value = "BYSTANDER_AD_OVERALL",
        category = "Combat",
        exec = function() return NCDungeon:GetAvoidableDamage(NCEvent:GetBystander() or "Unknown") end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "My Avoidable (Combat)",
        value = "MY_AD",
        category = "Combat",
        exec = function() return NCCombat:GetAvoidableDamage(GetMyName() or "Unknown") end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "My Avoidable (Dungeon)",
        value = "MY_AD_OVERALL",
        category = "Combat",
        exec = function() return NCDungeon:GetAvoidableDamage(GetMyName() or "Unknown") end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddReplacement({
        label = "Nemesis Avoidable Damage",
        value = "NEMESISAVOIDABLEDAMAGE",
        exec = function() return NemesisChat:FormatNumber(NCCombat:GetAvoidableDamage(NCEvent:GetNemesis() or "Unknown")) end,
        description = "The amount of avoidable damage the Nemesis has taken in the current combat segment.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(math.random(385472, 2358737)) end,
    })
    :AddReplacement({
        label = "Nemesis Avoidable Damage (Overall)",
        value = "NEMESISAVOIDABLEDAMAGEOVERALL",
        exec = function() return NemesisChat:FormatNumber(NCDungeon:GetAvoidableDamage(NCEvent:GetNemesis() or "Unknown")) end,
        description = "The amount of avoidable damage the Nemesis has taken in the current dungeon.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(math.random(385472, 2358737)) end,
    })
    :AddReplacement({
        label = "Bystander Avoidable Damage",
        value = "BYSTANDERAVOIDABLEDAMAGE",
        exec = function() return NemesisChat:FormatNumber(NCCombat:GetAvoidableDamage(NCEvent:GetBystander() or "Unknown")) end,
        description = "The amount of avoidable damage the Bystander has taken in the current combat segment.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(math.random(385472, 2358737)) end,
    })
    :AddReplacement({
        label = "Bystander Avoidable Damage (Overall)",
        value = "BYSTANDERAVOIDABLEDAMAGEOVERALL",
        exec = function() return NemesisChat:FormatNumber(NCDungeon:GetAvoidableDamage(NCEvent:GetBystander() or "Unknown")) end,
        description = "The amount of avoidable damage the Bystander has taken in the current dungeon.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(math.random(385472, 2358737)) end,
    })
    :AddReplacement({
        label = "My Avoidable Damage",
        value = "AVOIDABLEDAMAGE",
        exec = function() return NemesisChat:FormatNumber(NCCombat:GetAvoidableDamage(GetMyName() or "Unknown")) end,
        description = "The amount of avoidable damage you have taken in the current combat segment.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(math.random(385472, 2358737)) end,
    })
    :AddReplacement({
        label = "My Avoidable Damage (Overall)",
        value = "AVOIDABLEDAMAGEOVERALL",
        exec = function() return NemesisChat:FormatNumber(NCDungeon:GetAvoidableDamage(GetMyName() or "Unknown")) end,
        description = "The amount of avoidable damage you have taken in the current dungeon.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(math.random(385472, 2358737)) end,
    })
    :AddReplacement({
        value = "NEMESISAVOIDABLEDAMAGE_CONDITION",
        exec = function() return NCCombat:GetAvoidableDamage(NCEvent:GetNemesis() or "Unknown") end,
    })
    :AddReplacement({
        value = "NEMESISAVOIDABLEDAMAGEOVERALL_CONDITION",
        exec = function() return NCDungeon:GetAvoidableDamage(NCEvent:GetNemesis() or "Unknown") end,
    })
    :AddReplacement({
        value = "BYSTANDERAVOIDABLEDAMAGE_CONDITION",
        exec = function() return NCCombat:GetAvoidableDamage(NCEvent:GetBystander() or "Unknown") end,
    })
    :AddReplacement({
        value = "BYSTANDERAVOIDABLEDAMAGEOVERALL_CONDITION",
        exec = function() return NCDungeon:GetAvoidableDamage(NCEvent:GetBystander() or "Unknown") end,
    })
    :AddReplacement({
        value = "AVOIDABLEDAMAGE_CONDITION",
        exec = function() return NCCombat:GetAvoidableDamage(GetMyName() or "Unknown") end,
    })
    :AddReplacement({
        value = "AVOIDABLEDAMAGEOVERALL_CONDITION",
        exec = function() return NCDungeon:GetAvoidableDamage(GetMyName() or "Unknown") end,
    })