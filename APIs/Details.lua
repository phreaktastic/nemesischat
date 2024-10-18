-----------------------------------------------------
-- DETAILS API
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Details functions for altering event responses
-----------------------------------------------------

DETAILS = _G.Details;

NemesisChatAPI:AddAPI("NC_DETAILS", "Details!")
    :AddConfigOption({
        label = "Enable Details! Plugin",
        value = "ENABLED", -- This will read in config options as NC_DETAILS_ENABLED
        description = "Enable the Details! Plugin for use in messages.",
        primary = true,
    })
    :AddCompatibilityCheck({
        configCheck = false,
        exec = function() 
            if Details == nil then
                return false, "Details! is not installed."
            end
    
            return true, nil
        end
    })
    :AddCompatibilityCheck({
        configCheck = true,
        exec = function() 
            if not NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() then
                return false, "Details! API is not enabled."
            end
    
            return true, nil
        end
    })
    :AddSubject({
        label = "Nem. DPS (Current)",
        value = "NEMESIS_DPS",
        category = "DPS",
        exec = function() return NCDetailsAPI:GetDPS(NCEvent:GetNemesis() or "Unknown", DETAILS_SEGMENTID_CURRENT) end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Bys. DPS (Current)",
        value = "BYSTANDER_DPS",
        category = "DPS",
        exec = function() return NCDetailsAPI:GetDPS(NCEvent:GetBystander() or "Unknown", DETAILS_SEGMENTID_CURRENT) end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "My DPS (Current)",
        value = "MY_DPS",
        category = "DPS",
        exec = function() return NCDetailsAPI:GetDPS(GetMyName() or "Unknown", DETAILS_SEGMENTID_CURRENT) end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Nem. DPS (Overall)",
        value = "NEMESIS_DPS_OVERALL",
        category = "DPS",
        exec = function() return NCDetailsAPI:GetDPS(NCEvent:GetNemesis() or "Unknown", DETAILS_SEGMENTID_OVERALL) end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "My DPS (Overall)",
        value = "MY_DPS_OVERALL",
        category = "DPS",
        exec = function() return NCDetailsAPI:GetDPS(GetMyName() or "Unknown", DETAILS_SEGMENTID_OVERALL) end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddSubject({
        label = "Bys. DPS (Overall)",
        value = "BYSTANDER_DPS_OVERALL",
        category = "DPS",
        exec = function() return NCDetailsAPI:GetDPS(NCEvent:GetBystander() or "Unknown", DETAILS_SEGMENTID_OVERALL) end,
        operators = core.constants.NUMERIC_OPERATORS,
        type = "NUMBER",
    })
    :AddReplacement({
        label = "Nemesis DPS",
        value = "NEMESISDPS",
        exec = function() return NemesisChat:FormatNumber(NCDetailsAPI:GetDPS((NCEvent:GetNemesis() or "Unknown"), DETAILS_SEGMENTID_CURRENT)) end,
        description = "The DPS of the Nemesis for the current fight.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(math.random(38472, 584736)) end,
    })
    :AddReplacement({
        label = "Bystander DPS",
        value = "BYSTANDERDPS",
        exec = function() return NemesisChat:FormatNumber(NCDetailsAPI:GetDPS((NCEvent:GetBystander() or "Unknown"), DETAILS_SEGMENTID_CURRENT)) end,
        description = "The DPS of the Bystander for the current fight.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(math.random(38472, 584736)) end,
    })
    :AddReplacement({
        label = "My DPS",
        value = "DPS",
        exec = function() return NemesisChat:FormatNumber(NCDetailsAPI:GetDPS((GetMyName() or "Unknown"), DETAILS_SEGMENTID_CURRENT)) end,
        description = "Your DPS for the current fight.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(math.random(38472, 584736)) end,
    })
    :AddReplacement({
        label = "Nemesis DPS (Overall)",
        value = "NEMESISDPSOVERALL",
        exec = function() return NemesisChat:FormatNumber(NCDetailsAPI:GetDPS((NCEvent:GetNemesis() or "Unknown"), DETAILS_SEGMENTID_OVERALL)) end,
        description = "The DPS of the Nemesis overall.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(math.random(38472, 235873)) end,
    })
    :AddReplacement({
        label = "Bystander DPS (Overall)",
        value = "BYSTANDERDPSOVERALL",
        exec = function() return NemesisChat:FormatNumber(NCDetailsAPI:GetDPS((NCEvent:GetBystander() or "Unknown"), DETAILS_SEGMENTID_OVERALL)) end,
        description = "The DPS of the Bystander overall.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(math.random(38472, 235873)) end,
    })
    :AddReplacement({
        label = "My DPS Overall",
        value = "DPSOVERALL",
        exec = function() return NemesisChat:FormatNumber(NCDetailsAPI:GetDPS((GetMyName() or "Unknown"), DETAILS_SEGMENTID_OVERALL)) end,
        description = "Your DPS overall.",
        isNumeric = true,
        example = function() return NemesisChat:FormatNumber(math.random(38472, 235873)) end,
    })
    :AddReplacement({
        value = "NEMESISDPS_CONDITION",
        exec = function() return NCDetailsAPI:GetDPS((NCEvent:GetNemesis() or "Unknown"), DETAILS_SEGMENTID_CURRENT) end,
    })
    :AddReplacement({
        value = "BYSTANDERDPS_CONDITION",
        exec = function() return NCDetailsAPI:GetDPS((NCEvent:GetBystander() or "Unknown"), DETAILS_SEGMENTID_CURRENT) end,
    })
    :AddReplacement({
        value = "DPS_CONDITION",
        exec = function() return NCDetailsAPI:GetDPS((GetMyName() or "Unknown"), DETAILS_SEGMENTID_CURRENT) end,
    })
    :AddReplacement({
        value = "NEMESISDPSOVERALL_CONDITION",
        exec = function() return NCDetailsAPI:GetDPS((NCEvent:GetNemesis() or "Unknown"), DETAILS_SEGMENTID_OVERALL) end,
    })
    :AddReplacement({
        value = "BYSTANDERDPSOVERALL_CONDITION",
        exec = function() return NCDetailsAPI:GetDPS((NCEvent:GetBystander() or "Unknown"), DETAILS_SEGMENTID_OVERALL) end,
    })
    :AddReplacement({
        value = "DPSOVERALL_CONDITION",
        exec = function() return NCDetailsAPI:GetDPS((GetMyName() or "Unknown"), DETAILS_SEGMENTID_OVERALL) end,
    })

-- This is a good example of reusable functionality while leveraging the NC API
NCDetailsAPI = {}

function NCDetailsAPI:GetDPS(player, segment)
    local combat
    local player = Details:GetActor(segment, DETAILS_ATTRIBUTE_DAMAGE, player)

    if segment == DETAILS_SEGMENTID_CURRENT then
        combat = Details:GetCombat(0)
    else
        combat = Details:GetCombat(-1)
    end

    if player == nil or combat == nil then
        return 0
    end

    local combatTime = combat:GetCombatTime()
    local playerDamage = player.total
    local playerDps = math.floor(playerDamage / combatTime)

    return playerDps
end