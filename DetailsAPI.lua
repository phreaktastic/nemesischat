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
        self:Print("Details not found.")
        return false
    end

    if NCDetailsAPI == nil then
        NemesisChat:DETAILS_METHODS()
    end

    local currentPlayer = NCDetailsAPI:GetDPS(core.runtime.myName, DETAILS_SEGMENTID_CURRENT) or 0
    local currentNemesis = NCDetailsAPI:GetDPS(NCEvent:GetNemesis(), DETAILS_SEGMENTID_CURRENT) or 0
    local overallPlayer = NCDetailsAPI:GetDPS(core.runtime.myName, DETAILS_SEGMENTID_OVERALL) or 0
    local overallNemesis = NCDetailsAPI:GetDPS(NCEvent:GetNemesis(), DETAILS_SEGMENTID_OVERALL) or 0

    if currentPlayer == nil or currentNemesis == nil or overallPlayer == nil or overallNemesis == nil then
        return false
    end

    NCMessage:AddCustomReplacement("%[DPS%]", NCDetailsAPI:FormatDPS(currentPlayer))
    NCMessage:AddCustomReplacement("%[NEMESISDPS%]", NCDetailsAPI:FormatDPS(currentNemesis))
    NCMessage:AddCustomReplacement("%[DPSOVERALL%]", NCDetailsAPI:FormatDPS(overallPlayer))
    NCMessage:AddCustomReplacement("%[NEMESISDPSOVERALL%]", NCDetailsAPI:FormatDPS(overallNemesis))

    NCMessage:AddCustomReplacement("%[DPS_CONDITION%]", currentPlayer)
    NCMessage:AddCustomReplacement("%[NEMESISDPS_CONDITION%]", currentNemesis)
    NCMessage:AddCustomReplacement("%[DPSOVERALL_CONDITION%]", overallPlayer)
    NCMessage:AddCustomReplacement("%[NEMESISDPSOVERALL_CONDITION%]", overallNemesis)

    NemesisChat.DETAILS = {
        ["NEMESIS_DPS"] = function()
            if NCDetailsAPI == nil then
                NemesisChat:DETAILS_METHODS()
            end

            return NCDetailsAPI:GetDPS(NCEvent:GetNemesis(), DETAILS_SEGMENTID_CURRENT)
        end,
        ["MY_DPS"] = function()
            if NCDetailsAPI == nil then
                NemesisChat:DETAILS_METHODS()
            end
            
            return NCDetailsAPI:GetDPS(core.runtime.myName, DETAILS_SEGMENTID_CURRENT)
        end,
        ["NEMESIS_DPS_OVERALL"] = function()
            if NCDetailsAPI == nil then
                NCDetailsAPI:DETAILS_METHODS()
            end
            
            return DetailsAPI:GetDPS(NCEvent:GetNemesis(), DETAILS_SEGMENTID_OVERALL)
        end,
        ["MY_DPS_OVERALL"] = function()
            if NCDetailsAPI == nil then
                NCDetailsAPI:DETAILS_METHODS()
            end
            
            return NCDetailsAPI:GetDPS(core.runtime.myName, DETAILS_SEGMENTID_OVERALL)
        end,
    }

    return true
end

-- These will not always be available, they'll need to be declared as used.
function NemesisChat:DETAILS_METHODS()
    NCDetailsAPI = {}

    function NCDetailsAPI:GetDPS(player, segment)
        local combat = Details:GetCurrentCombat()
        local player = Details:GetActor(segment, DETAILS_ATTRIBUTE_DAMAGE, player)
    
        if player == nil then
            return 0
        end
    
        local combatTime = combat:GetCombatTime()
        local playerDamage = player.total
        local playerDps = math.floor(playerDamage / combatTime)

        return playerDps
    end

    function NCDetailsAPI:FormatDPS(dps)
        return dps / 10 / 100 .. "k"
    end
end
