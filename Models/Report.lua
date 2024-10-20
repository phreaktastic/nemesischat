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
    if not IsNCEnabled() then return end

    local TYPES = {
        ["DAMAGE"] = "DPS",
        ["AVOIDABLE"] = "AvoidableDamage",
        ["INTERRUPTS"] = "Interrupts",
        ["OFFHEALS"] = "Offheals",
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

    if not tContains(EVENTS, event) then return end

    local bucket = NCCombat
    local segName = "this combat segment"

    if event == "BOSS" then
        bucket = NCBoss
        segName = NCBoss:GetIdentifier()
    elseif event == "DUNGEON" then
        bucket = NCDungeon
        segName = NCDungeon:GetIdentifier()
    end

    local channel = NemesisChat:GetActualChannel(NCConfig:GetReportChannel())

    for type, rankingType in pairs(TYPES) do
        local config = core.db.profile.reportConfig[type][event]
        if config then
            local data = typeData[type]
            local topRanking = bucket.Rankings.Top[rankingType]
            local bottomRanking = bucket.Rankings.Bottom[rankingType]

            if data.preMessageHook then
                data.topMsg, data.botMsg = data.preMessageHook(topRanking.Player, data.topMsg, data.botMsg, bucket)
            end

            if not (topRanking and topRanking.Value == 0 and bottomRanking and bottomRanking.Value == 0) then
                if core.db.profile.reportConfig[type]["TOP"] and topRanking and topRanking.Player then
                    local msg = data.topMsgSpecial and topRanking.DeltaPercent >= 25 and data.topMsgSpecial or
                        data.topMsg
                    local formattedMsg = string.format(msg, topRanking.Player, segName,
                        NemesisChat:FormatNumber(topRanking.Value))

                    if IsInGroup() then
                        SendChatMessage("Nemesis Chat: " .. formattedMsg, channel)
                    else
                        print("Nemesis Chat: " .. formattedMsg)
                    end
                end

                if core.db.profile.reportConfig[type]["BOTTOM"] and bottomRanking and bottomRanking.Player then
                    local formattedMsg = string.format(data.botMsg, segName, bottomRanking.Player,
                        NemesisChat:FormatNumber(bottomRanking.Value))

                    if IsInGroup() then
                        SendChatMessage("Nemesis Chat: " .. formattedMsg, channel)
                    else
                        print("Nemesis Chat: " .. formattedMsg)
                    end
                end
            end
        end
    end
end
