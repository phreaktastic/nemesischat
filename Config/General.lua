-----------------------------------------------------
-- CONFIGURATION UI
-----------------------------------------------------
-- General Tab
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local soundTable, soundTableSortKeys = GetSoundTable()
local playingSound = 0

core.options.args.generalGroup = {
    order = 1,
    type = "group",
    name = "General Settings",
    args = {
        -- dbg = {
        --     order = 0,
        --     type = "toggle",
        --     name = "Debug",
        --     desc = "Shows debug information",
        --     get = "IsDebug",
        --     set = "ToggleDebug",
        -- },
        core = {
            order = 1,
            type = "group",
            name = "Core",
            inline = true,
            args = {
                enabled = {
                    order = 1,
                    type = "toggle",
                    name = "Enable",
                    desc = "Toggle Nemesis Chat",
                    get = function() return NCConfig:IsEnabled() end,
                    set = function() NCConfig:ToggleEnabled() end,
                },
                flagFriendsAsNemeses = {
                    order = 2,
                    type = "toggle",
                    name = "Flag Friends as Nemeses",
                    desc = "If a person within your group is on your friends list, they will be flagged as a Nemesis.",
                    get = function() return NCConfig:IsFlaggingFriendsAsNemeses() end,
                    set = function(_, value) NCConfig:SetFlaggingFriendsAsNemeses(value) end,
                },
                flagGuildiesAsNemeses = {
                    order = 3,
                    type = "toggle",
                    name = "Flag Guildmates as Nemeses",
                    desc = "If a person within your group is in your guild, they will be flagged as a Nemesis.",
                    get = function() return NCConfig:IsFlaggingGuildmatesAsNemeses() end,
                    set = function(_, value) NCConfig:SetFlaggingGuildmatesAsNemeses(value) end,
                },
                globalChanceToggle = {
                    order = 4,
                    type = "toggle",
                    name = "Use Global Chance",
                    desc =
                    "Toggle Global Chance. This allows you to ensure that messages will only be sent a percentage of the time. NOTE: This does not apply for reports.",
                    get = function() return NCConfig:IsUsingGlobalChance() end,
                    set = function(_, value) return NCConfig:SetUsingGlobalChance(value) end,
                },
                globalChanceSlider = {
                    order = 5,
                    type = "range",
                    min = 0.0,
                    max = 1.0,
                    step = 0.05,
                    name = "Global Chance",
                    desc = "A chance can be 0.0 (0%) to 1.0 (100%).",
                    get = function() return NCConfig:GetGlobalChance() end,
                    set = function(_, value) return NCConfig:SetGlobalChance(value) end,
                    disabled = function() return NCConfig:IsUsingGlobalChance() ~= true end,
                },
                minimumTimeSlider = {
                    order = 6,
                    type = "range",
                    min = 1,
                    max = 300,
                    step = 1,
                    name = "Minimum Time",
                    desc = "The minimum time (in seconds) between messages. NOTE: This does not apply for reports.",
                    get = function() return NCConfig:GetMinimumTime() end,
                    set = function(_, value) return NCConfig:SetMinimumTime(value) end,
                },
                rollingMessagesCheckbox = {
                    order = 7,
                    type = "toggle",
                    name = "Rolling Messages",
                    desc = "This allows you to cycle through messages, rather than sending a random message.",
                    get = function() return NCConfig:IsRollingMessages() end,
                    set = function(_, value) return NCConfig:ToggleRollingMessages() end,
                },
            }
        },
        lfgQoL = {
            order = 2,
            type = "group",
            name = "LFG QoL",
            inline = true,
            args = {
                notifyWhenTankApplies = {
                    order = 1,
                    type = "toggle",
                    name = "Notify When Tank Applies",
                    desc = "Display a message and play a sound when a tank applies to your group.",
                    get = function() return NCConfig:GetNotifyWhenTankApplies() end,
                    set = function(_, value) NCConfig:ToggleNotifyWhenTankApplies() end,
                },
                notifyWhenTankAppliesSound = {
                    order = 2,
                    type = "select",
                    name = "Tank Sound",
                    desc = "Select the sound to play when a tank applies to your group.",
                    values = soundTable,
                    sorting = soundTableSortKeys,
                    get = function() return NCConfig:GetNotifyWhenTankAppliesSound() end,
                    set = function(_, value)
                        -- Stop the currently playing sound, if any
                        if playingSound then
                            StopSound(playingSound)
                        end

                        -- Short delay to clear the audio buffer
                        C_Timer.After(0.1, function()
                            playingSound = select(2, PlaySound(value, "Master"))
                        end)

                        -- Save the sound to the DB
                        NCConfig:SetNotifyWhenTankAppliesSound(value)
                    end,
                    disabled = function() return not NCConfig:GetNotifyWhenTankApplies() end,
                },
                notifyWhenHealerApplies = {
                    order = 3,
                    type = "toggle",
                    name = "Notify When Healer Applies",
                    desc = "Display a message and play a sound when a healer applies to your group.",
                    get = function() return NCConfig:GetNotifyWhenHealerApplies() end,
                    set = function(_, value) NCConfig:ToggleNotifyWhenHealerApplies() end,
                },
                notifyWhenHealerAppliesSound = {
                    order = 4,
                    type = "select",
                    name = "Healer Sound",
                    desc = "Select the sound to play when a healer applies to your group.",
                    values = soundTable,
                    sorting = soundTableSortKeys,
                    get = function() return NCConfig:GetNotifyWhenHealerAppliesSound() end,
                    set = function(_, value)
                        -- Stop the currently playing sound, if any
                        if playingSound then
                            StopSound(playingSound)
                        end

                        -- Play the new sound and store its handle
                        playingSound = select(2, PlaySound(value, "Master"))

                        -- Save the sound to the DB
                        NCConfig:SetNotifyWhenHealerAppliesSound(value)
                    end,
                    disabled = function() return not NCConfig:GetNotifyWhenHealerApplies() end,
                },
                notifyWhenDPSApplies = {
                    order = 5,
                    type = "toggle",
                    name = "Notify When DPS Applies",
                    desc = "Display a message and play a sound when a DPS applies to your group.",
                    get = function() return NCConfig:GetNotifyWhenDPSApplies() end,
                    set = function(_, value) NCConfig:ToggleNotifyWhenDPSApplies() end,
                },
                notifyWhenDPSAppliesSound = {
                    order = 6,
                    type = "select",
                    name = "DPS Sound",
                    desc = "Select the sound to play when a DPS applies to your group.",
                    values = soundTable,
                    sorting = soundTableSortKeys,
                    get = function() return NCConfig:GetNotifyWhenDPSAppliesSound() end,
                    set = function(_, value)
                        -- Stop the currently playing sound, if any
                        if playingSound then
                            StopSound(playingSound)
                        end

                        -- Play the new sound and store its handle
                        playingSound = select(2, PlaySound(value, "Master"))

                        -- Save the sound to the DB
                        NCConfig:SetNotifyWhenDPSAppliesSound(value)
                    end,
                    disabled = function() return not NCConfig:GetNotifyWhenDPSApplies() end,
                },
                groupMessageOnApplication = {
                    order = 7,
                    type = "toggle",
                    name = "Group Message on Application",
                    desc = "Also send a group message when a player applies to your group.",
                    get = function() return NCConfig:GetGroupMessageOnApplication() end,
                    set = function() NCConfig:ToggleGroupMessageOnApplication() end,
                    disabled = function() return not (NCConfig:GetNotifyWhenTankApplies() or NCConfig:GetNotifyWhenHealerApplies() or NCConfig:GetNotifyWhenDPSApplies()) end,
                },
                disclaimer = {
                    order = 8,
                    type = "description",
                    fontSize = "medium",
                    name = "These features are a work in progress, and will likely grow/mature over time.",
                }
            },
        },
        nonCombatMode = {
            order = 3,
            type = "group",
            name = "Non-Combat Mode",
            inline = true,
            args = {
                nonCombatMode = {
                    order = 1,
                    type = "toggle",
                    name = "Non-Combat Mode",
                    width = "full",
                    descStyle = "inline",
                    desc = "Toggle Non-Combat Mode. This restricts Nemesis Chat from messaging while in combat.",
                    get = function() return NCConfig:IsNonCombatMode() end,
                    set = function(_, value) return NCConfig:SetNonCombatMode(value) end,
                },
                allowInterrupts = {
                    order = 2,
                    type = "toggle",
                    name = "Allow Interrupts",
                    desc = "Allow interrupt events while in Non-Combat Mode.",
                    get = function() return NCConfig:IsInterruptException() end,
                    set = function(_, value) NCConfig:SetInterruptException(value) end,
                    disabled = function() return not NCConfig:IsNonCombatMode() end,
                },
                allowDeaths = {
                    order = 3,
                    type = "toggle",
                    name = "Allow Deaths",
                    desc = "Allow death events while in Non-Combat Mode.",
                    get = function() return NCConfig:IsDeathException() end,
                    set = function(_, value) NCConfig:SetDeathException(value) end,
                    disabled = function() return not NCConfig:IsNonCombatMode() end,
                },
                disclaimerPadding = {
                    order = 4,
                    type = "description",
                    fontSize = "medium",
                    name = " ",
                },
                disclaimer = {
                    order = 5,
                    type = "description",
                    fontSize = "medium",
                    name =
                    "NOTE: Non-Combat Mode will still allow some messages to fire, such as messages triggered by mobs or bosses.",
                },
            }
        },
        delves = {
            order = 4,
            type = "group",
            name = "Delve Configuration",
            inline = true,
            args = {
                allowBrannMessages = {
                    order = 1,
                    type = "toggle",
                    name = "Allow Brann Messages",
                    desc = "Allow messages to reference Brann Bronzebeard (either as a Nemesis or Bystander).",
                    get = function() return NCConfig:IsAllowingBrannMessages() end,
                    set = function(_, value) return NCConfig:SetAllowingBrannMessages(value) end,
                },
                delveInfoDescription = {
                    order = 2,
                    type = "description",
                    fontSize = "medium",
                    name = "NOTE: In order to see any stats in a solo delve, you MUST allow Brann Messages.",
                }
            }
        },
        mPlusPerformance = {
            order = 5,
            type = "group",
            name = "Mythic+ Tracking & Announcing",
            inline = true,
            args = {
                trackLeavers = {
                    order = 1,
                    type = "toggle",
                    name = "Track Leavers",
                    width = "full",
                    descStyle = "inline",
                    desc =
                    "Track players who leave/disconnect during an unfinished Mythic+ (+20 or higher) dungeon, with more than 6 minutes remaining.",
                    get = function() return NCConfig:IsTrackingLeavers() end,
                    set = function(_, value) return NCConfig:SetTrackingLeavers(value) end,
                },
                reportLeaversOnJoin = {
                    order = 2,
                    type = "toggle",
                    name = "Announce Leavers on Join",
                    desc = "Announce when someone joins the party who has bailed on a M+ in progress.",
                    get = function() return NCConfig:IsReportingLeaversOnJoin() end,
                    set = function(_, value) return NCConfig:SetReportingLeaversOnJoin(value) end,
                    disabled = function() return not NCConfig:IsTrackingLeavers() end,
                },
                reportLeaversOnJoinThreshold = {
                    order = 3,
                    type = "range",
                    min = 1,
                    max = 50,
                    step = 1,
                    name = "Threshold",
                    desc = "The number of leaves required to trigger an announcement.",
                    get = function() return NCConfig:GetReportingLeaversOnJoinThreshold() end,
                    set = function(_, value) return NCConfig:SetReportingLeaversOnJoinThreshold(value) end,
                    disabled = function()
                        return not NCConfig:IsTrackingLeavers() or
                            not NCConfig:IsReportingLeaversOnJoin()
                    end,
                },
                trackLowPerformers = {
                    order = 4,
                    type = "toggle",
                    name = "Track Low Performers",
                    width = "full",
                    descStyle = "inline",
                    desc = "Track players who underperform during a Mythic+ dungeon.",
                    get = function() return NCConfig:IsTrackingLowPerformers() end,
                    set = function(_, value) return NCConfig:SetTrackingLowPerformers(value) end,
                },
                reportLowPerformersOnJoin = {
                    order = 5,
                    type = "toggle",
                    name = "Announce Low Performers on Join",
                    desc = "Announce when someone joins the party who has underperformed in a M+.",
                    get = function() return NCConfig:IsReportingLowPerformersOnJoin() end,
                    set = function(_, value) return NCConfig:SetReportingLowPerformersOnJoin(value) end,
                    disabled = function() return not NCConfig:IsTrackingLowPerformers() end,
                },
                reportLowPerformersOnJoinThreshold = {
                    order = 6,
                    type = "range",
                    min = 1,
                    max = 50,
                    step = 1,
                    name = "Threshold",
                    desc = "The number of underperformances required to trigger an announcement.",
                    get = function() return NCConfig:GetReportingLowPerformersOnJoinThreshold() end,
                    set = function(_, value) return NCConfig:SetReportingLowPerformersOnJoinThreshold(value) end,
                    disabled = function()
                        return not NCConfig:IsTrackingLowPerformers() or
                            not NCConfig:IsReportingLowPerformersOnJoin()
                    end,
                },
            }
        },
        apis = {
            order = 6,
            type = "group",
            name = "Plugins",
            inline = false,
            hidden = function() return core.apiConfigOptions == {} end,
        },
    }
}
