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

function NemesisChat:Report(event, success)
    if IsNCEnabled() == false then
        return
    end

    local TYPES = {
        ["DAMAGE"] = "DPS",
        ["AVOIDABLE"] = "AvoidableDamage",
        ["INTERRUPTS"] = "Interrupts",
        ["OFFHEALS"] = "Offheals",
        ["DEATHS"] = "Deaths",
        ["AFFIXES"] = "Affixes",
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
            topMsg = "Highest avoidable damage taken for %s: %s at %s.",
            botMsg = "Shout out to %s with the lowest avoidable damage taken for %s, at %s!",
            inverted = true,
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
            preMessageHook = function(topMsg, botMsg, bucket)
                local ad = bucket:GetAvoidableDamage(topPlayer)
                local adFormatted = NemesisChat:FormatNumber(ad)
                local lifePercent = math.floor(ad / UnitHealthMax(topPlayer) * 10000) / 100

                if lifePercent > 100 then
                    local lifeMultiplier = math.floor(lifePercent / 10) / 10

                    topMsg = "Highest deaths for %s: %s at %s, with " .. adFormatted .. " avoidable damage taken (" .. lifeMultiplier .. "x their max health)."
                else
                    topMsg = "Highest deaths for %s: %s at %s, with " .. adFormatted .. " avoidable damage taken."
                end

                return topMsg, botMsg
            end,
            topMsg = "Shout out to %s with the lowest deaths for %s, at %s!",
            botMsg = "Most deaths for %s: %s at %s.",
            inverted = true,
        },
        ["AFFIXES"] = {
            topMsg = "Shout out to %s with the most affixes for %s, at %s!",
            botMsg = "Lowest affixes for %s: %s at %s.",
        },
    }
    local shoutOutFormat = function(message, player, segmentName, value) return string.format(message, player, segmentName, NemesisChat:FormatNumber(value)) end
    local callOutFormat = function(message, player, segmentName, value) return string.format(message, segmentName, player, NemesisChat:FormatNumber(value)) end
    
    if not tContains(EVENTS, event) then
        return
    end

    for type, rankingType in pairs(TYPES) do
        local bucket, topMsg, botMsg
        local config = core.db.profile.reportConfig[type][event]
        local segName = "this combat segment"

        if not config then
            return
        end

        if event == "COMBAT" or event == "BOSS" then
            bucket = NCCombat

            if event == "BOSS" then
                segName = NCBoss:GetIdentifier()
            end
        elseif event == "DUNGEON" then
            bucket = NCDungeon
            segName = NCDungeon:GetIdentifier()
        end

        local data = typeData[type]
        local topVal = bucket.Rankings.Top[rankingType].Value or 0
        local topPlayer = bucket.Rankings.Top[rankingType].Player or nil
        local botVal = bucket.Rankings.Bottom[rankingType].Value or 99999999
        local botPlayer = bucket.Rankings.Bottom[rankingType].Player or nil

        if topPlayer == nil then
            topMsg = nil
        else
            topMsg = data.topMsg
        end

        if botPlayer == nil then
            botMsg = nil
        else
            botMsg = data.botMsg
        end

        if data.preMessageHook ~= nil then
            topMsg, botMsg = data.preMessageHook(topMsg, botMsg, bucket)
        end

        if topMsg ~= nil then
            if data.inverted == true then
                topMsg = callOutFormat(topMsg, topPlayer, segName, topVal)
            else
                if data.topMsgSpecial and bucket.Rankings.Top and bucket.Rankings.Top[rankingType] and bucket.Rankings.Top[rankingType].DeltaPercent and bucket.Rankings.Top[rankingType].DeltaPercent >= 25 then
                    topMsg = shoutOutFormat(data.topMsgSpecial, topPlayer, segName, topVal)
                else
                    topMsg = shoutOutFormat(topMsg, topPlayer, segName, topVal)
                end
            end
        end

        if botMsg ~= nil then
            if data.inverted == true then
                botMsg = shoutOutFormat(botMsg, botPlayer, segName, botVal)
            else
                botMsg = callOutFormat(botMsg, botPlayer, segName, botVal)
            end
        end

        local channel = NemesisChat:GetChannel(NCConfig:GetReportChannel())

        if core.db.profile.reportConfig[type]["TOP"] == true and topMsg ~= nil then
            SendChatMessage("Nemesis Chat: " .. topMsg, channel)
        end

        if core.db.profile.reportConfig[type]["BOTTOM"] == true and botMsg ~= nil then
            SendChatMessage("Nemesis Chat: " .. botMsg, channel)
        end
    end


end