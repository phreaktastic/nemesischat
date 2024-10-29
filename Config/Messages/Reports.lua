-----------------------------------------------------
-- CONFIGURATION UI
-----------------------------------------------------
-- Reports Tab
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

core.options.args.messagesGroup.args.segmentMessages = {
    order = 3,
    type = "group",
    name = "Segment Summaries",
    childGroups = "tree",
    args = {
        generalHeader = {
            order = 0,
            type = "header",
            name = "Segment Summary Settings",
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
            name = "Summary Channel",
            desc = "Select the chat channel to report summaries to",
            descStyle = "inline",
            width = "full",
            values = function() return core.channels end,
            get = function() return NCConfig:GetReportChannel() end,
            set = function(info, value) NCConfig:SetReportChannel(value) end,
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
            hidden = true,
            get = function() return NCConfig:IsExcludingNemeses() end,
            set = function(info, value) NCConfig:SetExcludingNemeses(value) end,
        },
        reportLowPerformersOnWipeToggle = {
            order = 5,
            type = "toggle",
            name = "Report Low Performers on Wipe",
            desc = "If your party wipes on a boss fight, report the lowest performers (coming soon)",
            descStyle = "inline",
            width = "full",
            disabled = true,
            hidden = true,
            get = function() return NCConfig:IsReportingLowPerformersOnWipe() end,
            set = function(info, value) NCConfig:ToggleReportingLowPerformersOnWipe(value) end,
        },
        reportLowPerformersOnDungeonFailToggle = {
            order = 6,
            type = "toggle",
            name = "Report Low Performers on M+ Failure",
            desc = "If your party fails to time a Mythic+ dungeon, report the lowest performers (coming soon)",
            descStyle = "inline",
            width = "full",
            disabled = true,
            hidden = true,
            get = function() return NCConfig:IsReportingLowPerformersOnDungeonFail() end,
            set = function(info, value) NCConfig:ToggleReportingLowPerformersOnDungeonFail(value) end,
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
                            get = function() return NCConfig:IsReportingInterrupts_Top() end,
                            set = function() NCConfig:ToggleReportingInterrupts_Top() end,
                        },
                        bottomInterruptsToggle = {
                            order = 2,
                            type = "toggle",
                            name = "Call-Outs",
                            desc = "Report the lowest amount of interrupts",
                            descStyle = "inline",
                            width = "full",
                            get = function() return NCConfig:IsReportingInterrupts_Bottom() end,
                            set = function() NCConfig:ToggleReportingInterrupts_Bottom() end,
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
                            get = function() return NCConfig:IsReportingInterrupts_Combat() end,
                            set = function() NCConfig:ToggleReportingInterrupts_Combat() end,
                        },
                        bossInterruptsToggle = {
                            order = 2,
                            type = "toggle",
                            name = "After bosses",
                            desc = "Report interrupts after bosses",
                            descStyle = "inline",
                            width = "full",
                            get = function() return NCConfig:IsReportingInterrupts_Boss() end,
                            set = function() NCConfig:ToggleReportingInterrupts_Boss() end,
                        },
                        dungeonInterruptsToggle = {
                            order = 3,
                            type = "toggle",
                            name = "After dungeons",
                            desc = "Report interrupts after dungeon completion",
                            descStyle = "inline",
                            width = "full",
                            get = function() return NCConfig:IsReportingInterrupts_Dungeon() end,
                            set = function() NCConfig:ToggleReportingInterrupts_Dungeon() end,
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
                            get = function() return NCConfig:IsReportingDamage_Top() end,
                            set = function() NCConfig:ToggleReportingDamage_Top() end,
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
                            get = function() return NCConfig:IsReportingDamage_Bottom() end,
                            set = function() NCConfig:ToggleReportingDamage_Bottom() end,
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
                            get = function() return NCConfig:IsReportingDamage_Combat() end,
                            set = function() NCConfig:ToggleReportingDamage_Combat() end,
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
                            get = function() return NCConfig:IsReportingDamage_Boss() end,
                            set = function() NCConfig:ToggleReportingDamage_Boss() end,
                            disabled = function()
                                return NemesisChatAPI:GetAPI("NC_DETAILS"):IsEnabled() == false or
                                    not Details
                            end,
                        },
                        dungeonDmgToggle = {
                            order = 3,
                            type = "toggle",
                            name = "After Dungeons",
                            desc = "Report damage after dungeon completion",
                            descStyle = "inline",
                            width = "full",
                            get = function() return NCConfig:IsReportingDamage_Dungeon() end,
                            set = function() NCConfig:ToggleReportingDamage_Dungeon() end,
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
                            get = function() return NCConfig:IsReportingAvoidable_Top() end,
                            set = function(info, value) NCConfig:ToggleReportingAvoidable_Top() end,
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
                            get = function() return NCConfig:IsReportingAvoidable_Bottom() end,
                            set = function(info, value) NCConfig:ToggleReportingAvoidable_Bottom() end,
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
                            get = function() return NCConfig:IsReportingAvoidable_Combat() end,
                            set = function(info, value) NCConfig:ToggleReportingAvoidable_Combat() end,
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
                            get = function() return NCConfig:IsReportingAvoidable_Boss() end,
                            set = function(info, value) NCConfig:ToggleReportingAvoidable_Boss() end,
                            disabled = function()
                                return NemesisChatAPI:GetAPI("NC_GTFO"):IsEnabled() == false or
                                    not GTFO
                            end,
                        },
                        dungeonAdToggle = {
                            order = 6,
                            type = "toggle",
                            name = "After Dungeons",
                            desc = "Report avoidable damage after dungeon completion",
                            descStyle = "inline",
                            width = "full",
                            get = function() return NCConfig:IsReportingAvoidable_Dungeon() end,
                            set = function(info, value) NCConfig:ToggleReportingAvoidable_Dungeon() end,
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
                    name = "Deaths",
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
                    name = "Report Highest Deaths After Dungeons",
                    desc = "Report the highest deaths after completion",
                    descStyle = "inline",
                    width = "full",
                    get = function() NCConfig:IsReportingDeaths_Bottom() end,
                    set = function(info, value) NCConfig:ToggleReportingDeaths_Bottom() end,
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
                            desc = "Report the player with highest amount of off-heals",
                            descStyle = "inline",
                            width = "full",
                            get = function() return NCConfig:IsReportingOffheals_Top() end,
                            set = function(info, value) NCConfig:ToggleReportingOffheals_Top() end,
                        },
                        combatOhToggle = {
                            order = 2,
                            type = "toggle",
                            name = "Call-Outs",
                            desc = "Report the player with lowest amount of off-heals",
                            descStyle = "inline",
                            width = "full",
                            get = function() return NCConfig:IsReportingOffheals_Bottom() end,
                            set = function(info, value) NCConfig:ToggleReportingOffheals_Bottom() end,
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
                            get = function() return NCConfig:IsReportingOffheals_Boss() end,
                            set = function(info, value) NCConfig:ToggleReportingOffheals_Boss() end,
                        },
                        dungeonOhToggle = {
                            order = 2,
                            type = "toggle",
                            name = "After Dungeons",
                            desc = "Report off-heals after dungeon completion",
                            descStyle = "inline",
                            width = "full",
                            get = function() return NCConfig:IsReportingOffheals_Dungeon() end,
                            set = function(info, value) NCConfig:ToggleReportingOffheals_Dungeon() end,
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
    },
}

function NemesisChat:GetMarkerOptionsWithIcons()
    local options = setmetatable({}, { __mode = "kv" })

    for key, val in ipairs(core.markers) do
        options[key] = val.name
    end

    return options
end
