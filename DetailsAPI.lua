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

    local currentPlayer = GetDPS(UnitName("player"), DETAILS_SEGMENTID_CURRENT)
    local currentNemesis = GetDPS(NCEvent:GetNemesis(), DETAILS_SEGMENTID_CURRENT)
    local overallPlayer = GetDPS(UnitName("player"), DETAILS_SEGMENTID_OVERALL)
    local overallNemesis = GetDPS(NCEvent:GetNemesis(), DETAILS_SEGMENTID_OVERALL)

    if currentPlayer == nil or currentNemesis == nil or overallPlayer == nil or overallNemesis == nil then
        return false
    end

    NCMessage:AddCustomReplacement("%[DPS%]", currentPlayer .. "K")
    NCMessage:AddCustomReplacement("%[DEMESISDPS%]", currentNemesis .. "K")
    NCMessage:AddCustomReplacement("%[DPSOVERALL%]", overallPlayer .. "K")
    NCMessage:AddCustomReplacement("%[DEMESISDPSOVERALL%]", overallNemesis .. "K")

    local function GetDPS(player, segment)
        local combat = Details:GetCurrentCombat()
        local player = Details:GetActor(segment, DETAILS_ATTRIBUTE_DAMAGE, player)
    
        if player == nil then
            return nil
        end
    
        local combatTime = combat:GetCombatTime()
        local playerDamage = player.total
        local playerDps = math.floor(playerDamage / combatTime / 10) / 100 -- Round to 2 digits, ie 74.86k

        return playerDps
    end

    return true
end