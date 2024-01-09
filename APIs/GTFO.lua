-----------------------------------------------------
-- GTFO API
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

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
        exec = function() return NCCombat:GetAvoidableDamage(NCEvent:GetNemesis() or "Unknown") end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Nem. Avoidable (Overall)",
        value = "NEMESIS_AD_OVERALL",
        exec = function() return NCDungeon:GetAvoidableDamage(NCEvent:GetNemesis() or "Unknown") end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Bys. Avoidable (Combat)",
        value = "BYSTANDER_AD",
        exec = function() return NCCombat:GetAvoidableDamage(NCEvent:GetBystander() or "Unknown") end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Bys. Avoidable (Overall)",
        value = "BYSTANDER_AD_OVERALL",
        exec = function() return NCDungeon:GetAvoidableDamage(NCEvent:GetBystander() or "Unknown") end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "My Avoidable (Combat)",
        value = "MY_AD",
        exec = function() return NCCombat:GetAvoidableDamage(GetMyName() or "Unknown") end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "My Avoidable (Overall)",
        value = "MY_AD_OVERALL",
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