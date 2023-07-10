-----------------------------------------------------
-- REPORT
-----------------------------------------------------
-- This file in a POC / WIP. It is not pretty, but a
-- legitimate report framework will eventually take
-- its place!

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

function NemesisChat:Report(event)
    local TYPES = {
        "DAMAGE",
        "AVOIDABLE",
        "INTERRUPTS",
    }
    local EVENTS = {
        "COMBAT",
        "BOSS",
        "DUNGEON",
    }
    
    if not tContains(EVENTS, event) then
        return
    end

    for _, type in pairs(TYPES) do
        local bucket, var, segment, topMsg, botMsg
        local config = core.db.profile.reportConfig[type][event]
        local topPlayer = ""
        local botPlayer = ""
        local topVal = 0
        local botVal = 99999999
        local segName = "this combat segment"

        if not config then
            return
        end

        if event == "COMBAT" or event == "BOSS" then
            bucket = NCCombat
            segment = DETAILS_SEGMENTID_CURRENT

            if event == "BOSS" then
                segName = NCBoss:GetName()
            end
        elseif event == "DUNGEON" then
            bucket = NCDungeon
            segment = DETAILS_SEGMENTID_OVERALL
            segName = "the dungeon"
        end

        if type == "DAMAGE" then
            if Details == nil or not core.db.profile.detailsAPI then
                return
            end

            if NCDetailsAPI == nil then
                NemesisChat:DETAILS_METHODS()
            end

            for player, data in pairs(core.runtime.groupRoster) do
                local dps = NCDetailsAPI:GetDPS(player, segment)

                if data.role == "DAMAGER" then
                    if dps > topVal then
                        topVal = dps
                        topPlayer = player
                    elseif dps < botVal then
                        botVal = dps
                        botPlayer = player
                    end
                end
            end

            local myDps = NCDetailsAPI:GetDPS(core.runtime.myName, segment)

            if myDps > topVal then
                topVal = myDps
                topPlayer = core.runtime.myName
            elseif myDps < botVal then
                botVal = myDps
                botPlayer = core.runtime.myName
            end

            topMsg = "Shout out to " .. topPlayer .. " with the highest DPS for " .. segName .. ", at " .. NemesisChat:FormatNumber(topVal) .. "!"
            botMsg = "Lowest DPS for " .. segName .. ": " .. botPlayer .. " at " .. NemesisChat:FormatNumber(botVal) .. "."
        elseif type == "AVOIDABLE" then
            if GTFO == nil or not core.db.profile.gtfoAPI then
                return
            end

            for player, _ in pairs(core.runtime.groupRoster) do
                local ad = bucket:GetAvoidableDamage(player)

                if ad > topVal then
                    topVal = ad
                    topPlayer = player
                elseif ad < botVal then
                    botVal = ad
                    botPlayer = player
                end
            end

            local myAd = bucket:GetAvoidableDamage(core.runtime.myName)

            if myAd > topVal then
                topVal = myAd
                topPlayer = core.runtime.myName
            elseif myAd < botVal then
                botVal = myAd
                botPlayer = core.runtime.myName
            end

            botMsg = "Shout out to " .. botPlayer .. " with the lowest avoidable damage taken for " .. segName .. ", at " .. NemesisChat:FormatNumber(botVal) .. "!"
            topMsg = "Highest avoidable damage taken for " .. segName .. ": " .. topPlayer .. " at " .. NemesisChat:FormatNumber(topVal) .. "."
        else
            for player, _ in pairs(core.runtime.groupRoster) do
                local interrupts = bucket:GetInterrupts(player)

                if interrupts > topVal then
                    topVal = interrupts
                    topPlayer = player
                elseif interrupts < botVal then
                    botVal = interrupts
                    botPlayer = player
                end
            end

            local myInterrupts = bucket:GetInterrupts(core.runtime.myName)

            if myInterrupts > topVal then
                topVal = myInterrupts
                topPlayer = core.runtime.myName
            elseif myInterrupts < botVal then
                botVal = myInterrupts
                botPlayer = core.runtime.myName
            end

            if topVal > 0 then
                topMsg = "Shout out to " .. topPlayer .. " with the most interrupts for " .. segName .. ", at " .. topVal .. "!"
            else
                topMsg = nil
            end
            
            botMsg = "Lowest interrupts for " .. segName .. ": " .. botPlayer .. " at " .. botVal .. "."
        end

        -- Default to party chat
        local channel = "PARTY"

        -- In an instance
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then channel = "INSTANCE_CHAT" end
        
        -- In a raid
        if IsInRaid() then channel = "RAID" end

        if core.db.profile.reportConfig[type]["TOP"] == true and topMsg ~= nil then
            SendChatMessage("Nemesis Chat: " .. topMsg, channel)
        end

        if core.db.profile.reportConfig[type]["BOTTOM"] == true then
            SendChatMessage("Nemesis Chat: " .. botMsg, channel)
        end
    end


end