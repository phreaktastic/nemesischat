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
    if IsNCEnabled() == false then
        return
    end

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
                    elseif dps == topVal then
                        topPlayer = topPlayer .. " + " .. player
                    elseif dps < botVal then
                        botVal = dps
                        botPlayer = player
                    end
                end
            end

            local myDps = NCDetailsAPI:GetDPS(GetMyName(), segment)

            if myDps > topVal then
                topVal = myDps
                topPlayer = GetMyName()
            elseif myDps == topVal then
                topPlayer = topPlayer .. " + " .. GetMyName()
            elseif myDps < botVal then
                botVal = myDps
                botPlayer = GetMyName()
            end

            if topVal == 0 then
                topMsg = nil
            else
                topMsg = "Shout out to " .. topPlayer .. " with the highest DPS for " .. segName .. ", at " .. NemesisChat:FormatNumber(topVal) .. "!"
            end

            if botVal == 99999999 then
                botMsg = nil
            else
                botMsg = "Lowest DPS for " .. segName .. ": " .. botPlayer .. " at " .. NemesisChat:FormatNumber(botVal) .. "."
            end
        elseif type == "AVOIDABLE" then
            if GTFO == nil or not core.db.profile.gtfoAPI then
                return
            end

            for player, _ in pairs(core.runtime.groupRoster) do
                local ad = bucket:GetAvoidableDamage(player)

                if ad > topVal then
                    topVal = ad
                    topPlayer = player
                elseif ad == topVal then
                    topPlayer = topPlayer .. " + " .. player
                elseif ad < botVal then
                    botVal = ad
                    botPlayer = player
                elseif ad == botVal then
                    botPlayer = botPlayer .. " + " .. player
                end
            end

            local myAd = bucket:GetAvoidableDamage(GetMyName())

            if myAd > topVal then
                topVal = myAd
                topPlayer = GetMyName()
            elseif myAd < botVal then
                botVal = myAd
                botPlayer = GetMyName()
            elseif myAd == botVal then
                botPlayer = botPlayer .. " + " .. GetMyName()
            end

            if topVal == 0 then
                topMsg = nil
            else
                topMsg = "Highest avoidable damage taken for " .. segName .. ": " .. topPlayer .. " at " .. NemesisChat:FormatNumber(topVal) .. "."
            end

            if botVal == 99999999 then
                botMsg = nil
            else
                botMsg = "Shout out to " .. botPlayer .. " with the lowest avoidable damage taken for " .. segName .. ", at " .. NemesisChat:FormatNumber(botVal) .. "!"
            end
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

            local myInterrupts = bucket:GetInterrupts(GetMyName())

            if myInterrupts > topVal then
                topVal = myInterrupts
                topPlayer = GetMyName()
            elseif myInterrupts < botVal then
                botVal = myInterrupts
                botPlayer = GetMyName()
            end

            if topVal > 0 then
                topMsg = "Shout out to " .. topPlayer .. " with the most interrupts for " .. segName .. ", at " .. topVal .. "!"
                botMsg = "Lowest interrupts for " .. segName .. ": " .. botPlayer .. " at " .. botVal .. "."
            else
                topMsg = nil
                botMsg = nil
            end
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

        if core.db.profile.reportConfig[type]["BOTTOM"] == true and botMsg ~= nil then
            SendChatMessage("Nemesis Chat: " .. botMsg, channel)
        end
    end


end