-----------------------------------------------------
-- REPORT
-----------------------------------------------------
local _, core = ...;

function NemesisChat:Report(event, success)
    if not IsNCEnabled() or not NCConfig:IsMessageSystemEnabled() then return end

    local TYPES = {
        ["DAMAGE"] = "DPS",
        ["AVOIDABLE"] = "AvoidableDamage",
        ["INTERRUPTS"] = "Interrupts",
        ["OFFHEALS"] = "Offheals",
        ["DEATHS"] = "Deaths",
        ["CROWDCONTROL"] = "CrowdControl",
    }
    local EVENTS = {
        ["COMBAT"] = true,
        ["BOSS"] = true,
        ["DUNGEON"] = true,
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
        ["CROWDCONTROL"] = {
            topMsg = "Shout out to %s with the highest CC score for %s, at %s!",
            botMsg = "Lowest CC score for %s: %s at %s.",
        },
    }

    if not EVENTS[event] then return end

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
        -- Check if reporting is enabled for this type and event
        local isEnabled = false
        if event == "COMBAT" then
            if type == "DAMAGE" then
                isEnabled = NCConfig:IsReportingDamage_Combat()
            elseif type == "AVOIDABLE" then
                isEnabled = NCConfig:IsReportingAvoidable_Combat()
            elseif type == "INTERRUPTS" then
                isEnabled = NCConfig:IsReportingInterrupts_Combat()
            elseif type == "OFFHEALS" then
                isEnabled = NCConfig:IsReportingOffheals_Combat()
            elseif type == "DEATHS" then
                isEnabled = NCConfig:IsReportingDeaths_Combat()
            elseif type == "CROWDCONTROL" then
                isEnabled = NCConfig:IsReportingCrowdControl_Combat()
            end
        elseif event == "BOSS" then
            if type == "DAMAGE" then
                isEnabled = NCConfig:IsReportingDamage_Boss()
            elseif type == "AVOIDABLE" then
                isEnabled = NCConfig:IsReportingAvoidable_Boss()
            elseif type == "INTERRUPTS" then
                isEnabled = NCConfig:IsReportingInterrupts_Boss()
            elseif type == "OFFHEALS" then
                isEnabled = NCConfig:IsReportingOffheals_Boss()
            elseif type == "DEATHS" then
                isEnabled = NCConfig:IsReportingDeaths_Boss()
            elseif type == "CROWDCONTROL" then
                isEnabled = NCConfig:IsReportingCrowdControl_Boss()
            end
        elseif event == "DUNGEON" then
            if type == "DAMAGE" then
                isEnabled = NCConfig:IsReportingDamage_Dungeon()
            elseif type == "AVOIDABLE" then
                isEnabled = NCConfig:IsReportingAvoidable_Dungeon()
            elseif type == "INTERRUPTS" then
                isEnabled = NCConfig:IsReportingInterrupts_Dungeon()
            elseif type == "OFFHEALS" then
                isEnabled = NCConfig:IsReportingOffheals_Dungeon()
            elseif type == "DEATHS" then
                isEnabled = NCConfig:IsReportingDeaths_Dungeon()
            elseif type == "CROWDCONTROL" then
                isEnabled = NCConfig:IsReportingCrowdControl_Dungeon()
            end
        end

        if isEnabled then
            local data = typeData[type]
            local topRanking = bucket.Rankings.Top[rankingType]
            local bottomRanking = bucket.Rankings.Bottom[rankingType]

            if data.preMessageHook then
                data.topMsg, data.botMsg = data.preMessageHook(topRanking.Player, data.topMsg, data.botMsg, bucket)
            end

            if not (topRanking and topRanking.Value == 0 and bottomRanking and bottomRanking.Value == 0) then
                -- Check if top reporting is enabled for this type
                local isTopEnabled = false
                if type == "DAMAGE" then
                    isTopEnabled = NCConfig:IsReportingDamage_Top()
                elseif type == "AVOIDABLE" then
                    isTopEnabled = NCConfig:IsReportingAvoidable_Top()
                elseif type == "INTERRUPTS" then
                    isTopEnabled = NCConfig:IsReportingInterrupts_Top()
                elseif type == "OFFHEALS" then
                    isTopEnabled = NCConfig:IsReportingOffheals_Top()
                elseif type == "DEATHS" then
                    isTopEnabled = NCConfig:IsReportingDeaths_Top()
                elseif type == "CROWDCONTROL" then
                    isTopEnabled = NCConfig:IsReportingCrowdControl_Top()
                end

                if isTopEnabled and topRanking and topRanking.Player then
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

                -- Check if bottom reporting is enabled for this type
                local isBottomEnabled = false
                if type == "DAMAGE" then
                    isBottomEnabled = NCConfig:IsReportingDamage_Bottom()
                elseif type == "AVOIDABLE" then
                    isBottomEnabled = NCConfig:IsReportingAvoidable_Bottom()
                elseif type == "INTERRUPTS" then
                    isBottomEnabled = NCConfig:IsReportingInterrupts_Bottom()
                elseif type == "OFFHEALS" then
                    isBottomEnabled = NCConfig:IsReportingOffheals_Bottom()
                elseif type == "DEATHS" then
                    isBottomEnabled = NCConfig:IsReportingDeaths_Bottom()
                elseif type == "CROWDCONTROL" then
                    isBottomEnabled = NCConfig:IsReportingCrowdControl_Bottom()
                end

                if isBottomEnabled and bottomRanking and bottomRanking.Player then
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
