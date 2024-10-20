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
                            disabled = function()
                                return NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() == false or
                                    not Details
                            end,
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
                            disabled = function()
                                return NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() == false or
                                    not Details
                            end,
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
                            disabled = function()
                                return NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() == false or
                                    not Details
                            end,
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
                            disabled = function()
                                return NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() == false or
                                    not Details
                            end,
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
                            disabled = function()
                                return NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() == false or
                                    not Details
                            end,
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
                            get = function() return core.db.profile.reportConfig["AVOIDABLE"]["TOP"] end,
                            set = function(info, value) core.db.profile.reportConfig["AVOIDABLE"]["TOP"] = value end,
                            disabled = function()
                                return NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() == false or
                                    not GTFO
                            end,
                        },
                        topAdToggle = {
                            order = 2,
                            type = "toggle",
                            name = "Call-Outs",
                            desc = "Report the highest amount of avoidable damage taken",
                            descStyle = "inline",
                            width = "full",
                            get = function() return core.db.profile.reportConfig["AVOIDABLE"]["BOTTOM"] end,
                            set = function(info, value) core.db.profile.reportConfig["AVOIDABLE"]["BOTTOM"] = value end,
                            disabled = function()
                                return NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() == false or
                                    not GTFO
                            end,
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
                            disabled = function()
                                return NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() == false or
                                    not GTFO
                            end,
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
                            disabled = function()
                                return NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() == false or
                                    not GTFO
                            end,
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
                            disabled = function()
                                return NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() == false or
                                    not GTFO
                            end,
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
                    name = "Report Highest Deaths After M+ Dungeons",
                    desc = "Report the highest deaths after M+ completion",
                    descStyle = "inline",
                    width = "full",
                    get = function()
                        return core.db.profile.reportConfig["DEATHS"]["BOTTOM"] and
                            core.db.profile.reportConfig["DEATHS"]["DUNGEON"]
                    end,
                    set = function(info, value)
                        core.db.profile.reportConfig["DEATHS"]["BOTTOM"] = value
                        core.db.profile.reportConfig["DEATHS"]["DUNGEON"] = value
                    end,
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
            name = "Pulls",
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
                    desc =
                    "Announce non-tank pulls which seem to be accidental or hazardous in nature (butt pulls and damage pulls). This will be announced in real-time.",
                    descStyle = "inline",
                    width = "full",
                    get = function() return NCConfig:IsReportingPulls_Realtime() end,
                    set = function() NCConfig:ToggleReportingPulls_Realtime() end,
                },
                pullsChannel = {
                    order = 3,
                    type = "select",
                    name = "Announcement Channel",
                    desc = "Select the channel to report pulls to",
                    descStyle = "inline",
                    width = "full",
                    values = function() return core.channels end,
                    get = function() return NCConfig:GetReportingPulls_Channel() end,
                    set = function(info, value) NCConfig:SetReportingPulls_Channel(value) end,
                },
                pullsToastToggle = {
                    order = 4,
                    type = "toggle",
                    name = "Toast Non-Tank Pulls",
                    desc =
                    "Show a toast notification for non-tank pulls which seem to be accidental or hazardous in nature (butt pulls and damage pulls).",
                    descStyle = "inline",
                    width = "full",
                    get = function() return NCConfig:IsReportingPulls_Toast() end,
                    set = function() NCConfig:ToggleReportingPulls_Toast() end,
                },
            }
        },
    },
}

function NemesisChat:GetMarkerOptionsWithIcons()
    local options = setmetatable({}, { __mode = "kv" })

    for key, val in ipairs(core.markers) do
        options[key] = val.name
    end

    return options
end
