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

function NemesisChat:Report(event, success)
    if IsNCEnabled() == false then
        return
    end

    local TYPES = {
        ["DAMAGE"] = "DPS",
        ["AVOIDABLE"] = "AvoidableDamage",
        ["INTERRUPTS"] = "Interrupts",
        ["OFFHEALS"] = "OffHeals",
        ["DEATHS"] = "Deaths",
    }
    local EVENTS = {
        "COMBAT",
        "BOSS",
        "DUNGEON",
    }
    local typeData = {
        ["DAMAGE"] = {
            topMsg = "Shout out to %s with the highest DPS for %s, at %s!",
            topMsgSpecial = "Special shout out to %s with AWESOME DPS for %s, at %s!",
            botMsg = "Lowest DPS for %s: %s at %s.",
        },
        ["AVOIDABLE"] = {
            topMsg = "Shout out to %s with the lowest avoidable damage taken for %s, at %s!",
            botMsg = "Highest avoidable damage taken for %s: %s at %s.",
        },
        ["INTERRUPTS"] = {
            topMsg = "Shout out to %s with the most interrupts for %s, at %s!",
            botMsg = "Lowest interrupts for %s: %s at %s.",
        },
        ["OFFHEALS"] = {
            topMsg = "Shout out to %s with the most off-heals for %s, at %s!",
            botMsg = "Lowest off-heals for %s: %s at %s.",
        },
        ["DEATHS"] = {
            preMessageHook = function(topPlayer, topMsg, botMsg, bucket)
                local ad = bucket:GetAvoidableDamage(topPlayer)
                local adFormatted = NemesisChat:FormatNumber(ad)
                local lifePercent = math.floor(ad / UnitHealthMax(topPlayer) * 10000) / 100

                if lifePercent > 100 then
                    local lifeMultiplier = math.floor(lifePercent / 10) / 10

                    botMsg = "Most deaths for %s: %s at %s, with " ..
                        adFormatted .. " avoidable damage taken (" .. lifeMultiplier .. "x their max health)."
                else
                    botMsg = "Most deaths for %s: %s at %s, with " .. adFormatted .. " avoidable damage taken."
                end

                return topMsg, botMsg
            end,
            topMsg = "Shout out to %s with the lowest deaths for %s, at %s!",
            botMsg = "Most deaths for %s: %s at %s.",
        },
    }
    local shoutOutFormat = function(message, player, segmentName, value)
        return string.format(message, player,
            segmentName, NemesisChat:FormatNumber(value))
    end
    local callOutFormat = function(message, player, segmentName, value)
        return string.format(message, segmentName, player,
            NemesisChat:FormatNumber(value))
    end

    if not tContains(EVENTS, event) then
        return
    end

    for type, rankingType in pairs(TYPES) do
        local bucket, topMsg, botMsg
        local config = core.db.profile.reportConfig[type][event]
        local segName = "this combat segment"

        if config then
            bucket = NCCombat

            if event == "BOSS" then
                bucket = NCBoss
                segName = NCBoss:GetIdentifier()
            elseif event == "DUNGEON" then
                bucket = NCDungeon
                segName = NCDungeon:GetIdentifier()
            end

            local data = typeData[type]
            local topRanking = bucket.Rankings.Top and bucket.Rankings.Top[rankingType]
            local bottomRanking = bucket.Rankings.Bottom and bucket.Rankings.Bottom[rankingType]

            local topVal, topPlayer, botVal, botPlayer

            topVal = topRanking and topRanking.Value or 0
            topPlayer = topRanking and topRanking.Player
            botVal = bottomRanking and bottomRanking.Value or 0
            botPlayer = bottomRanking and bottomRanking.Player

            if topPlayer then
                topMsg = data.topMsg
            end

            if botPlayer then
                botMsg = data.botMsg
            end

            if data.preMessageHook and topPlayer then
                topMsg, botMsg = data.preMessageHook(topPlayer, topMsg, botMsg, bucket)
            end

            if topMsg then
                if data.topMsgSpecial and topRanking and topRanking.DeltaPercent and topRanking.DeltaPercent >= 25 then
                    topMsg = shoutOutFormat(data.topMsgSpecial, topPlayer, segName, topVal)
                else
                    topMsg = shoutOutFormat(topMsg, topPlayer, segName, topVal)
                end
            end

            if botMsg then
                botMsg = callOutFormat(botMsg, botPlayer, segName, botVal)
            end

            local channel = NemesisChat:GetActualChannel(NCConfig:GetReportChannel())

            if core.db.profile.reportConfig[type]["TOP"] and topMsg then
                SendChatMessage("Nemesis Chat: " .. topMsg, channel)
            end

            if core.db.profile.reportConfig[type]["BOTTOM"] and botMsg then
                SendChatMessage("Nemesis Chat: " .. botMsg, channel)
            end
        end
    end
end
