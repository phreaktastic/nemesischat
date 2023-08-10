-----------------------------------------------------
-- REPORT
-----------------------------------------------------
-- This file is a POC / WIP. It is not pretty, but a
-- legitimate report framework will eventually take
-- its place!

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local tContains = tContains
local SendChatMessage = SendChatMessage

local DETAILS_SEGMENTID_CURRENT = DETAILS_SEGMENTID_CURRENT
local DETAILS_SEGMENTID_OVERALL = DETAILS_SEGMENTID_OVERALL

function NemesisChat:Report(event)
    if IsNCEnabled() == false then
        return
    end

    local TYPES = {
        "DAMAGE",
        "AVOIDABLE",
        "INTERRUPTS",
        "OFFHEALS",
        "DEATHS",
        "AFFIXES",
    }
    local EVENTS = {
        "COMBAT",
        "BOSS",
        "DUNGEON",
    }
    local typeData = {
        ["DAMAGE"] = {
            exec = function(player, segment) return NCDetailsAPI:GetDPS(player, segment) end,
            topMsg = "Shout out to %s with the highest DPS for %s, at %s!",
            botMsg = "Lowest DPS for %s: %s at %s.",
        },
        ["AVOIDABLE"] = {
            exec = function(player) return NCCombat:GetAvoidableDamage(player) end,
            topMsg = "Highest avoidable damage taken for %s: %s at %s.",
            botMsg = "Shout out to %s with the lowest avoidable damage taken for %s, at %s!",
        },
        ["INTERRUPTS"] = {
            exec = function(player) return NCCombat:GetInterrupts(player) end,
            topMsg = "Shout out to %s with the most interrupts for %s, at %s!",
            botMsg = "Lowest interrupts for %s: %s at %s.",
        },
        ["OFFHEALS"] = {
            exec = function(player) return NCCombat:GetOffHeals(player) end,
            topMsg = "Shout out to %s with the most off-heals for %s, at %s!",
            botMsg = "Lowest off-heals for %s: %s at %s.",
        },
        ["DEATHS"] = {
            exec = function(player) return NCCombat:GetDeaths(player) end,
            topMsg = "Shout out to %s with the lowest deaths for %s, at %s!",
            botMsg = "Most deaths for %s: %s at %s.",
        },
        ["AFFIXES"] = {
            exec = function(player) return NCDungeon:GetAffixes(player) end,
            topMsg = "Shout out to %s with the most affixes for %s, at %s!",
            botMsg = "Lowest affixes for %s: %s at %s.",
        },
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
                segName = NCBoss:GetIdentifier()
            end
        elseif event == "DUNGEON" then
            bucket = NCDungeon
            segment = DETAILS_SEGMENTID_OVERALL
            segName = "the dungeon"
        end

        if type == "DAMAGE" then
            if Details == nil or NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() == false or NCDetailsAPI == nil or NCDetailsAPI.GetDPS == nil then
                return
            end

            for player, data in pairs(NCRuntime:GetGroupRoster()) do
                local dps = NCDetailsAPI:GetDPS(player, segment)

                if data.role == "DAMAGER" then
                    if dps > topVal then
                        topVal = dps
                        topPlayer = player
                    elseif dps == topVal then
                        topPlayer = topPlayer .. " + " .. player
                    end

                    if dps < botVal then
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
            end

            if myDps < botVal then
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
            if GTFO == nil or not NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() then
                return
            end

            for player, _ in pairs(NCRuntime:GetGroupRoster()) do
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
            end
            
            if myAd < botVal then
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
        elseif type == "INTERRUPTS" then
            for player, _ in pairs(NCRuntime:GetGroupRoster()) do
                local interrupts = bucket:GetInterrupts(player)

                if interrupts > topVal then
                    topVal = interrupts
                    topPlayer = player
                elseif interrupts == topVal then
                    topPlayer = topPlayer .. " + " .. player
                end

                if interrupts < botVal then
                    botVal = interrupts
                    botPlayer = player
                end
            end

            local myInterrupts = bucket:GetInterrupts(GetMyName())

            if myInterrupts > topVal then
                topVal = myInterrupts
                topPlayer = GetMyName()
            elseif myInterrupts == topVal then
                topPlayer = topPlayer .. " + " .. GetMyName()
            end

            if myInterrupts < botVal then
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
        elseif type == "OFFHEALS" then
            for player, _ in pairs(NCRuntime:GetGroupRoster()) do
                local oh = bucket:GetOffHeals(player)

                if oh > topVal then
                    topVal = oh
                    topPlayer = player
                end
            end

            local myOh = bucket:GetOffHeals(GetMyName())

            if myOh > topVal then
                topVal = myOh
                topPlayer = GetMyName()
            end

            if topVal > 0 then
                topMsg = "Shout out to " .. topPlayer .. " with the most off-heals for " .. segName .. ", at " .. NemesisChat:FormatNumber(topVal) .. "!"
            else
                topMsg = nil
            end
        elseif type == "DEATHS" then
            for player, _ in pairs(NCRuntime:GetGroupRoster()) do
                local deaths = bucket:GetDeaths(player)

                if deaths > topVal then
                    topVal = deaths
                    topPlayer = player
                end
            end

            local myDeaths = bucket:GetDeaths(GetMyName())

            if myDeaths > topVal then
                topVal = myDeaths
                topPlayer = GetMyName()
            end

            if topVal > 0 then
                local ad = bucket:GetAvoidableDamage(topPlayer)
                local adFormatted = NemesisChat:FormatNumber(ad)
                local lifePercent = math.floor(ad / UnitHealthMax(topPlayer) * 10000) / 100

                if lifePercent > 100 then
                    local lifeMultiplier = math.floor(lifePercent / 10) / 10

                    topMsg = "Highest deaths for " .. segName .. ": " .. topPlayer .. " at " .. topVal .. ", with " .. adFormatted .. " avoidable damage taken (" .. lifeMultiplier .. "x their max health)."
                else
                    topMsg = "Highest deaths for " .. segName .. ": " .. topPlayer .. " at " .. topVal .. ", with " .. adFormatted .. " avoidable damage taken."
                end
            else
                topMsg = nil
            end
        elseif type == "AFFIXES" then
            for player, _ in pairs(NCRuntime:GetGroupRoster()) do
                local affixes = bucket:GetAffixes(player)

                if affixes > topVal then
                    topVal = affixes
                    topPlayer = player
                elseif affixes == topVal then
                    topPlayer = topPlayer .. " + " .. player
                end

                if affixes < botVal then
                    botVal = affixes
                    botPlayer = player
                elseif affixes == botVal then
                    botPlayer = botPlayer .. " + " .. player
                end
            end

            local myAffixes = bucket:GetAffixes(GetMyName())

            if myAffixes > topVal then
                topVal = myAffixes
                topPlayer = GetMyName()
            elseif myAffixes == topVal then
                topPlayer = topPlayer .. " + " .. GetMyName()
            end

            if myAffixes < botVal then
                botVal = myAffixes
                botPlayer = GetMyName()
            elseif myAffixes == botVal then
                botPlayer = botPlayer .. " + " .. GetMyName()
            end

            if topVal > 0 then
                topMsg = "Shout out to " .. topPlayer .. " who handled the most affixes for " .. segName .. ", at " .. topVal .. "!"
                botMsg = "Lowest affixes handled for " .. segName .. ": " .. botPlayer .. " at " .. botVal .. "."
            else
                topMsg = nil
                botMsg = nil
            end
        end

        local channel = NemesisChat:GetChannel(core.db.profile.reportConfig.channel)

        if core.db.profile.reportConfig[type]["TOP"] == true and topMsg ~= nil then
            SendChatMessage("Nemesis Chat: " .. topMsg, channel)
        end

        if core.db.profile.reportConfig[type]["BOTTOM"] == true and botMsg ~= nil then
            SendChatMessage("Nemesis Chat: " .. botMsg, channel)
        end
    end


end