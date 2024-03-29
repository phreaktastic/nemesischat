-----------------------------------------------------
-- CONFIGURATION UI
-----------------------------------------------------
-- Reports Tab
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

core.options.args.reportsGroup = {
    order = 3,
    type = "group",
    name = "Reports",
    args = {
        generalHeader = {
            order = 0,
            type = "header",
            name = "General Report Settings",
        },
        generalPaddingTop = {
            order = 1,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        reportChannel = {
            order = 2,
            type = "select",
            name = "Report Channel",
            desc = "Select the channel to report to",
            descStyle = "inline",
            width = "full",
            values = function() return core.channels end,
            get = function() return core.db.profile.reportConfig.channel end,
            set = function(info, value) core.db.profile.reportConfig.channel = value end,
        },
        reportChannelPaddingBottom = {
            order = 3,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        excludeNemesesToggle = {
            order = 4,
            type = "toggle",
            name = "Exclude Nemeses",
            desc = "Exclude Nemeses from shout-outs (coming soon)",
            descStyle = "inline",
            width = "full",
            disabled = true,
            get = function() return core.db.profile.reportConfig.excludeNemeses end,
            set = function(info, value) core.db.profile.reportConfig.excludeNemeses = value end,
        },
        reportLowPerformersOnWipeToggle = {
            order = 5,
            type = "toggle",
            name = "Report Low Performers on Wipe",
            desc = "If your party wipes on a boss fight, report the lowest performers (coming soon)",
            descStyle = "inline",
            width = "full",
            disabled = true,
            get = function() return core.db.profile.reportConfig.reportLowPerformersOnWipe end,
            set = function(info, value) core.db.profile.reportConfig.reportLowPerformersOnWipe = value end,
        },
        reportLowPerformersOnDungeonFailToggle = {
            order = 6,
            type = "toggle",
            name = "Report Low Performers on M+ Failure",
            desc = "If your party fails to time a Mythic+ dungeon, report the lowest performers (coming soon)",
            descStyle = "inline",
            width = "full",
            disabled = true,
            get = function() return core.db.profile.reportConfig.reportLowPerformersOnDungeonFail end,
            set = function(info, value) core.db.profile.reportConfig.reportLowPerformersOnDungeonFail = value end,
        },
        interrupts = {
            order = 7,
            type = "group",
            name = "Interrupts",
            args = {
                interruptsHeader = {
                    order = 0,
                    type = "header",
                    name = "Interrupts Reporting",
                },
                interruptsPaddingTop = {
                    order = 1,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                what = {
                    order = 2,
                    type = "group",
                    name = "What to Report",
                    inline = true,
                    args = {
                        topInterruptsToggle = {
                            order = 1,
                            type = "toggle",
                            name = "Shout-Outs",
                            desc = "Report the highest amount of interrupts",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["INTERRUPTS"]["TOP"] end,
                            set = function(info, value) core.db.profile.reportConfig["INTERRUPTS"]["TOP"] = value end,
                        },
                        bottomInterruptsToggle = {
                            order = 2,
                            type = "toggle",
                            name = "Call-Outs",
                            desc = "Report the lowest amount of interrupts",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["INTERRUPTS"]["BOTTOM"] end,
                            set = function(info, value) core.db.profile.reportConfig["INTERRUPTS"]["BOTTOM"] = value end,
                        },
                    }
                },
                when = {
                    order = 3,
                    type = "group",
                    name = "When to Report",
                    inline = true,
                    args = {
                        combatInterruptsToggle = {
                            order = 1,
                            type = "toggle",
                            name = "After combat",
                            desc = "Report interrupts after all combat segments",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["INTERRUPTS"]["COMBAT"] end,
                            set = function(info, value) core.db.profile.reportConfig["INTERRUPTS"]["COMBAT"] = value end,
                        },
                        bossInterruptsToggle = {
                            order = 2,
                            type = "toggle",
                            name = "After bosses",
                            desc = "Report interrupts after bosses",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["INTERRUPTS"]["BOSS"] end,
                            set = function(info, value) core.db.profile.reportConfig["INTERRUPTS"]["BOSS"] = value end,
                        },
                        dungeonInterruptsToggle = {
                            order = 3,
                            type = "toggle",
                            name = "After M+ dungeons",
                            desc = "Report interrupts after M+ completion",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["INTERRUPTS"]["DUNGEON"] end,
                            set = function(info, value) core.db.profile.reportConfig["INTERRUPTS"]["DUNGEON"] = value end,
                        },
                    }
                },
                interruptsPaddingBottom = {
                    order = 4,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
            }
        },
        damage = {
            order = 8,
            type = "group",
            name = "Damage",
            args = {
                damageHeader = {
                    order = 0,
                    type = "header",
                    name = "Damage Dealt (DPS) Reporting (Details! required)",
                },
                damagePaddingTop = {
                    order = 1,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                what = {
                    order = 2,
                    type = "group",
                    name = "What to Report",
                    inline = true,
                    args = {
                        topDamageToggle = {
                            order = 1,
                            type = "toggle",
                            name = "Shout-Outs",
                            desc = "Report the highest damage dealt",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["DAMAGE"]["TOP"] end,
                            set = function(info, value) core.db.profile.reportConfig["DAMAGE"]["TOP"] = value end,
                            disabled = function() return NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() == false or not Details end,
                        },
                        bottomDamageToggle = {
                            order = 2,
                            type = "toggle",
                            name = "Call-Outs",
                            desc = "Report the lowest damage dealt",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["DAMAGE"]["BOTTOM"] end,
                            set = function(info, value) core.db.profile.reportConfig["DAMAGE"]["BOTTOM"] = value end,
                            disabled = function() return NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() == false or not Details end,
                        },
                    }
                },
                when = {
                    order = 3,
                    type = "group",
                    name = "When to Report",
                    inline = true,
                    args = {
                        combatDmgToggle = {
                            order = 1,
                            type = "toggle",
                            name = "After Combat",
                            desc = "Report damage after all combat segments",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["DAMAGE"]["COMBAT"] end,
                            set = function(info, value) core.db.profile.reportConfig["DAMAGE"]["COMBAT"] = value end,
                            disabled = function() return NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() == false or not Details end,
                        },
                        bossDmgToggle = {
                            order = 2,
                            type = "toggle",
                            name = "After Bosses",
                            desc = "Report damage after bosses",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["DAMAGE"]["BOSS"] end,
                            set = function(info, value) core.db.profile.reportConfig["DAMAGE"]["BOSS"] = value end,
                            disabled = function() return NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() == false or not Details end,
                        },
                        dungeonDmgToggle = {
                            order = 3,
                            type = "toggle",
                            name = "After M+ Dungeons",
                            desc = "Report damage after M+ completion",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["DAMAGE"]["DUNGEON"] end,
                            set = function(info, value) core.db.profile.reportConfig["DAMAGE"]["DUNGEON"] = value end,
                            disabled = function() return NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() == false or not Details end,
                        },
                    }
                },
                damagePaddingBottom = {
                    order = 7,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
            }
        },
        avoidable = {
            order = 9,
            type = "group",
            name = "Avoidable Damage",
            args = {
                adHeader = {
                    order = 0,
                    type = "header",
                    name = "Avoidable Damage Taken Reporting (GTFO required)",
                },
                adPaddingTop = {
                    order = 1,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                what = {
                    order = 2,
                    type = "group",
                    name = "What to Report",
                    inline = true,
                    args = {
                        bottomAdToggle = {
                            order = 1,
                            type = "toggle",
                            name = "Shout-Outs",
                            desc = "Report the lowest amount of avoidable damage taken",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["AVOIDABLE"]["BOTTOM"] end,
                            set = function(info, value) core.db.profile.reportConfig["AVOIDABLE"]["BOTTOM"] = value end,
                            disabled = function() return NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() == false or not GTFO end,
                        },
                        topAdToggle = {
                            order = 2,
                            type = "toggle",
                            name = "Call-Outs",
                            desc = "Report the highest amount of avoidable damage taken",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["AVOIDABLE"]["TOP"] end,
                            set = function(info, value) core.db.profile.reportConfig["AVOIDABLE"]["TOP"] = value end,
                            disabled = function() return NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() == false or not GTFO end,
                        },
                    }
                },
                when = {
                    order = 3,
                    type = "group",
                    name = "When to Report",
                    inline = true,
                    args = {
                        combatAdToggle = {
                            order = 4,
                            type = "toggle",
                            name = "After Combat",
                            desc = "Report avoidable damage after all combat segments",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["AVOIDABLE"]["COMBAT"] end,
                            set = function(info, value) core.db.profile.reportConfig["AVOIDABLE"]["COMBAT"] = value end,
                            disabled = function() return NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() == false or not GTFO end,
                        },
                        bossAdToggle = {
                            order = 5,
                            type = "toggle",
                            name = "After Bosses",
                            desc = "Report avoidable damage after bosses",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["AVOIDABLE"]["BOSS"] end,
                            set = function(info, value) core.db.profile.reportConfig["AVOIDABLE"]["BOSS"] = value end,
                            disabled = function() return NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() == false or not GTFO end,
                        },
                        dungeonAdToggle = {
                            order = 6,
                            type = "toggle",
                            name = "After M+ Dungeons",
                            desc = "Report avoidable damage after M+ completion",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["AVOIDABLE"]["DUNGEON"] end,
                            set = function(info, value) core.db.profile.reportConfig["AVOIDABLE"]["DUNGEON"] = value end,
                            disabled = function() return NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() == false or not GTFO end,
                        },
                    }
                },
                adPaddingBottom = {
                    order = 4,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
            }
        },
        deaths = {
            order = 10,
            type = "group",
            name = "Deaths",
            args = {
                deathsHeader = {
                    order = 0,
                    type = "header",
                    name = "Deaths Reporting",
                },
                deathsPaddingTop = {
                    order = 1,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                deathsToggle = {
                    order = 2,
                    type = "toggle",
                    name = "Report Top Deaths After M+ Dungeons",
                    desc = "Report the highest deaths after M+ completion",
                    descStyle = "inline",
                    width = "full",
                    get = function() return core.db.profile.reportConfig["DEATHS"]["TOP"] and core.db.profile.reportConfig["DEATHS"]["DUNGEON"] end,
                    set = function(info, value) core.db.profile.reportConfig["DEATHS"]["TOP"] = value core.db.profile.reportConfig["DEATHS"]["DUNGEON"] = value end,
                },
            }
        },
        offHeals = {
            order = 11,
            type = "group",
            name = "Off-Heals",
            args = {
                ohHeader = {
                    order = 0,
                    type = "header",
                    name = "Off-Heals Reporting",
                },
                ohPaddingTop = {
                    order = 1,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                what = {
                    order = 2,
                    type = "group",
                    name = "What to Report",
                    inline = true,
                    args = {
                        topOhToggle = {
                            order = 1,
                            type = "toggle",
                            name = "Shout-Outs",
                            desc = "Report the highest amount of off-heals",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["OFFHEALS"]["TOP"] end,
                            set = function(info, value) core.db.profile.reportConfig["OFFHEALS"]["TOP"] = value end,
                        },
                        combatOhToggle = {
                            order = 2,
                            type = "toggle",
                            name = "Call-Outs",
                            desc = "Report off-heals after all combat segments",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["OFFHEALS"]["COMBAT"] end,
                            set = function(info, value) core.db.profile.reportConfig["OFFHEALS"]["COMBAT"] = value end,
                        },
                    }
                },
                when = {
                    order = 3,
                    type = "group",
                    name = "When to Report",
                    inline = true,
                    args = {
                        bossOhToggle = {
                            order = 1,
                            type = "toggle",
                            name = "After Bosses",
                            desc = "Report off-heals after bosses",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["OFFHEALS"]["BOSS"] end,
                            set = function(info, value) core.db.profile.reportConfig["OFFHEALS"]["BOSS"] = value end,
                        },
                        dungeonOhToggle = {
                            order = 2,
                            type = "toggle",
                            name = "After M+ Dungeons",
                            desc = "Report off-heals after M+ completion",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["OFFHEALS"]["DUNGEON"] end,
                            set = function(info, value) core.db.profile.reportConfig["OFFHEALS"]["DUNGEON"] = value end,
                        },
                    }
                },
                ohPaddingBottom = {
                    order = 6,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
            }
        },
        pulls = {
            order = 12,
            type = "group",
            name = "Pulls (Beta)",
            args = {
                pullsHeader = {
                    order = 0,
                    type = "header",
                    name = "Pull Announcement",
                },
                pullsPaddingTop = {
                    order = 1,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                pullsToggle = {
                    order = 2,
                    type = "toggle",
                    name = "Announce Non-Tank Pulls",
                    desc = "Announce non-tank pulls which seem to be accidental or hazardous in nature (butt pulls and damage pulls). This will be announced in real-time as a yell.",
                    descStyle = "inline",
                    width = "full",
                    get = function() return core.db.profile.reportConfig["PULLS"]["REALTIME"] end,
                    set = function(info, value) core.db.profile.reportConfig["PULLS"]["REALTIME"] = value  end,
                },
                pullsPaddingBottom = {
                    order = 3,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                pullsDescription = {
                    order = 4,
                    type = "description",
                    fontSize = "medium",
                    name = "This feature is in beta. It is not guaranteed to work as expected. Please report any issues or feature requests in Discord. More configuration options to come as this feature matures.",
                },
            }
        },
        neglectedHeals = {
            order = 13,
            type = "group",
            name = "Neglected Heals (Beta)",
            args = {
                nhHeader = {
                    order = 0,
                    type = "header",
                    name = "Neglected Heals Reporting",
                },
                nhPaddingTop = {
                    order = 1,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                nhToggle = {
                    order = 2,
                    type = "toggle",
                    name = "Announce Neglected Heals",
                    desc = "Announce (non-healer) players who have been at or below 45% health for 2 seconds or longer without receiving a (non-self) heal. This will be yelled in real-time.",
                    descStyle = "inline",
                    width = "full",
                    get = function() return core.db.profile.reportConfig["NEGLECTEDHEALS"]["REALTIME"] end,
                    set = function(info, value) core.db.profile.reportConfig["NEGLECTEDHEALS"]["REALTIME"] = value  end,
                },
                nhPaddingBottom = {
                    order = 3,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                nhDescription = {
                    order = 4,
                    type = "description",
                    fontSize = "medium",
                    name = "This feature is in beta. It is not guaranteed to work as expected. Please report any issues or feature requests in Discord. More configuration options to come as this feature matures.",
                },
            }
        },
        affixes = {
            order = 14,
            type = "group",
            name = "Affixes (Beta)",
            args = {
                affixesHeader = {
                    order = 0,
                    type = "header",
                    name = "Affix Reporting",
                },
                affixesPaddingTop = {
                    order = 1,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                realtime = {
                    order = 2,
                    type = "group",
                    name = "Real-Time",
                    inline = true,
                    args = {
                        realtimeDescription = {
                            order = 0,
                            type = "description",
                            fontSize = "medium",
                            name = "Real-time options will be yelled in realtime. It is highly recommended that you setup chat windows to accommodate this, as it will be noisy.",
                        },
                        realtimePadding = {
                            order = 1,
                            type = "description",
                            fontSize = "large",
                            name = " ",
                        },
                        affixBeginCastingToggle = {
                            order = 2,
                            type = "toggle",
                            name = "Affix Mob Begin Casting",
                            desc = "Announce when an affix enemy begins casting their ability.",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["AFFIXES"]["CASTSTART"] end,
                            set = function(info, value) core.db.profile.reportConfig["AFFIXES"]["CASTSTART"] = value end,
                        },
                        affixInterruptedToggle = {
                            order = 3,
                            type = "toggle",
                            name = "Affix Mob Interrupted",
                            desc = "Announce when an affix enemy is interrupted, but is not incapacitated/dead (requiring more interrupts).",
                            descStyle = "inline",
                            width = "full",
                            get = function() return NCConfig:IsReportingAffixes_CastFailed() end,
                            set = function(info, value) NCConfig:SetReportingAffixes_CastFailed(value) end,
                        },
                        affixSuccessfulCastToggle = {
                            order = 4,
                            type = "toggle",
                            name = "Affix Mob Successful Cast",
                            desc = "Announce when an affix enemy successfully casts their ability.",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["AFFIXES"]["CASTSUCCESS"] end,
                            set = function(info, value) core.db.profile.reportConfig["AFFIXES"]["CASTSUCCESS"] = value end,
                        },
                        affixAuraStacksWarningToggle = {
                            order = 5,
                            type = "toggle",
                            name = "Affix Aura Stacks",
                            desc = "Announce when an enemy or party member has reached a high amount of stacks of a dangerous affix aura.",
                            descStyle = "inline",
                            width = "full",
                            get = function() return NCConfig:IsReportingAffixes_AuraStacks() end,
                            set = function(info, value) NCConfig:SetReportingAffixes_AuraStacks(value) end,
                        },
                        affixMarkersToggle = {
                            order = 6,
                            type = "toggle",
                            name = "Affix Mob Markers",
                            desc = "Mark affix mobs with a raid marker, and announce to the party that you are handling the marked mob.",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["AFFIXES"]["MARKERS"] end,
                            set = function(info, value) core.db.profile.reportConfig["AFFIXES"]["MARKERS"] = value end,
                        },
                        affixMarkerToUse = {
                            order = 7,
                            type = "select",
                            name = "Marker to Use",
                            desc = "Select the marker to use for marking affix mobs",
                            descStyle = "inline",
                            width = "full",
                            values = function() return NemesisChat:GetMarkerOptionsWithIcons() end,
                            get = function() return core.db.profile.reportConfig["AFFIXES"]["MARKER"] end,
                            set = function(info, value) core.db.profile.reportConfig["AFFIXES"]["MARKER"] = value end,
                        },
                    }
                },
                what = {
                    order = 3,
                    type = "group",
                    name = "What to Report",
                    inline = true,
                    args = {
                        topAffixesToggle = {
                            order = 1,
                            type = "toggle",
                            name = "Shout-Outs",
                            desc = "Report the highest amount of affixes handled by a player",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["AFFIXES"]["TOP"] end,
                            set = function(info, value) core.db.profile.reportConfig["AFFIXES"]["TOP"] = value end,
                        },
                        bottomAffixesToggle = {
                            order = 2,
                            type = "toggle",
                            name = "Call-Outs",
                            desc = "Report the lowest amount of affixes handled by a player",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["AFFIXES"]["BOTTOM"] end,
                            set = function(info, value) core.db.profile.reportConfig["AFFIXES"]["BOTTOM"] = value end,
                        },
                    }
                },
                when = {
                    order = 4,
                    type = "group",
                    name = "When to Report",
                    inline = true,
                    args = {
                        bossAffixesToggle = {
                            order = 1,
                            type = "toggle",
                            name = "After Bosses",
                            desc = "Report affixes after bosses",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["AFFIXES"]["BOSS"] end,
                            set = function(info, value) core.db.profile.reportConfig["AFFIXES"]["BOSS"] = value end,
                        },
                        dungeonAffixesToggle = {
                            order = 2,
                            type = "toggle",
                            name = "After M+ Dungeons",
                            desc = "Report affixes after M+ completion",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["AFFIXES"]["DUNGEON"] end,
                            set = function(info, value) core.db.profile.reportConfig["AFFIXES"]["DUNGEON"] = value end,
                        },
                    }
                },
                affixesPaddingBottom = {
                    order = 5,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                affixesDescription = {
                    order = 6,
                    type = "description",
                    fontSize = "medium",
                    name = "This feature is in beta. It is not guaranteed to work as expected. Please report any issues or feature requests in Discord. More configuration options to come as this feature matures.",
                },
            }
        }
    },
}

function NemesisChat:GetMarkerOptionsWithIcons()
    local options = {}

    for key,val in ipairs(core.markers) do
        options[key] = val.name
    end

    return options
end