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

function NemesisChat:DETAILS_REPLACEMENTS()
    if Details == nil then
        return false
    end

    NemesisChat:DETAILS_METHODS()

    local currentPlayer = GetDPS(core.runtime.myName, DETAILS_SEGMENTID_CURRENT)
    local currentNemesis = GetDPS(NCEvent:GetNemesis(), DETAILS_SEGMENTID_CURRENT)
    local overallPlayer = GetDPS(core.runtime.myName, DETAILS_SEGMENTID_OVERALL)
    local overallNemesis = GetDPS(NCEvent:GetNemesis(), DETAILS_SEGMENTID_OVERALL)

    if currentPlayer == nil or currentNemesis == nil or overallPlayer == nil or overallNemesis == nil then
        return false
    end

    NCMessage:AddCustomReplacement("%[DPS%]", FormatDPS(currentPlayer))
    NCMessage:AddCustomReplacement("%[DEMESISDPS%]", FormatDPS(currentNemesis))
    NCMessage:AddCustomReplacement("%[DPSOVERALL%]", FormatDPS(overallPlayer))
    NCMessage:AddCustomReplacement("%[NEMESISDPSOVERALL%]", FormatDPS(overallNemesis))

    NCMessage:AddCustomReplacement("%[DPS_CONDITION%]", currentPlayer)
    NCMessage:AddCustomReplacement("%[DEMESISDPS_CONDITION%]", currentNemesis)
    NCMessage:AddCustomReplacement("%[DPSOVERALL_CONDITION%]", overallPlayer)
    NCMessage:AddCustomReplacement("%[NEMESISDPSOVERALL_CONDITION%]", overallNemesis)

    NemesisChat.DETAILS = {
        ["NEMESIS_DPS"] = function()
            NemesisChat:DETAILS_METHODS()
            return GetDPS(NCEvent:GetNemesis(), DETAILS_SEGMENTID_CURRENT)
        end,
        ["MY_DPS"] = function()
            NemesisChat:DETAILS_METHODS()
            return GetDPS(core.runtime.myName, DETAILS_SEGMENTID_CURRENT)
        end,
        ["NEMESIS_DPS_OVERALL"] = function()
            NemesisChat:DETAILS_METHODS()
            return GetDPS(NCEvent:GetNemesis(), DETAILS_SEGMENTID_OVERALL)
        end,
        ["MY_DPS_OVERALL"] = function()
            NemesisChat:DETAILS_METHODS()
            return GetDPS(core.runtime.myName, DETAILS_SEGMENTID_OVERALL)
        end,
    }

    return true
end

-- These will not always be available, they'll need to be declared as used.
function NemesisChat:DETAILS_METHODS()
    function GetDPS(player, segment)
        local combat = Details:GetCurrentCombat()
        local player = Details:GetActor(segment, DETAILS_ATTRIBUTE_DAMAGE, player)
    
        if player == nil then
            return nil
        end
    
        local combatTime = combat:GetCombatTime()
        local playerDamage = player.total
        local playerDps = math.floor(playerDamage / combatTime)

        return playerDps
    end

    function FormatDPS(dps)
        return dps / 10 / 100 .. "k"
    end
end
