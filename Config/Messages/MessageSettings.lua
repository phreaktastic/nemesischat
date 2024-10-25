-----------------------------------------------------
-- Message Behavior Configuration
-----------------------------------------------------
local _, core = ...;

core.options.args.messagesGroup.args.messageSettings = {
    order = 3,
    type = "group",
    name = "Message Settings",
    args = {
        behaviorSettings = {
            order = 1,
            type = "group",
            name = "Message Behavior",
            inline = true,
            args = {
                timing = {
                    order = 1,
                    type = "group",
                    name = "Timing Controls",
                    inline = true,
                    args = {
                        minimumTime = {
                            order = 1,
                            type = "range",
                            name = "Minimum Interval",
                            desc = "Minimum time (in seconds) between messages",
                            width = "full",
                            min = 1,
                            max = 300,
                            step = 1,
                            get = function() return NCConfig:GetMinimumTime() end,
                            set = function(_, value) return NCConfig:SetMinimumTime(value) end,
                        },
                        messageOrder = {
                            order = 2,
                            type = "toggle",
                            name = "Sequential Messages",
                            desc = "Send messages in sequential order instead of randomly",
                            width = "full",
                            get = function() return NCConfig:IsRollingMessages() end,
                            set = function(_, value) return NCConfig:ToggleRollingMessages() end,
                        },
                    }
                },
                probability = {
                    order = 2,
                    type = "group",
                    name = "Message Probability",
                    inline = true,
                    args = {
                        globalChanceEnabled = {
                            order = 1,
                            type = "toggle",
                            name = "Use Global Probability",
                            desc = "Apply a global probability to all message triggers",
                            width = "full",
                            get = function() return NCConfig:IsGlobalChanceEnabled() end,
                            set = function(_, value) return NCConfig:SetUsingGlobalChance(value) end,
                        },
                        globalChance = {
                            order = 2,
                            type = "range",
                            name = "Global Probability",
                            desc = "Chance of any message being sent when conditions are met",
                            width = "full",
                            min = 0.0,
                            max = 1.0,
                            step = 0.05,
                            get = function() return NCConfig:GetGlobalChance() end,
                            set = function(_, value) return NCConfig:SetGlobalChance(value) end,
                            disabled = function() return not NCConfig:IsGlobalChanceEnabled() end,
                        },
                    }
                },
                combatBehavior = {
                    order = 3,
                    type = "group",
                    name = "Combat Behavior",
                    inline = true,
                    args = {
                        restrictInCombat = {
                            order = 1,
                            type = "toggle",
                            name = "Restrict During Combat",
                            desc = "Limit message sending during combat",
                            width = "full",
                            get = function() return NCConfig:IsNonCombatMode() end,
                            set = function(_, value) return NCConfig:SetNonCombatMode(value) end,
                        },
                        combatExceptions = {
                            order = 2,
                            type = "group",
                            name = "Combat Exceptions",
                            inline = true,
                            hidden = function() return not NCConfig:IsNonCombatMode() end,
                            args = {
                                description = {
                                    order = 1,
                                    type = "description",
                                    fontSize = "medium",
                                    name = "Allow specific types of messages during combat:",
                                },
                                interrupts = {
                                    order = 2,
                                    type = "toggle",
                                    name = "Interrupt Messages",
                                    width = "full",
                                    get = function() return NCConfig:IsInterruptException() end,
                                    set = function(_, value) NCConfig:SetInterruptException(value) end,
                                },
                                deaths = {
                                    order = 3,
                                    type = "toggle",
                                    name = "Death Messages",
                                    width = "full",
                                    get = function() return NCConfig:IsDeathException() end,
                                    set = function(_, value) NCConfig:SetDeathException(value) end,
                                },
                                avoidable = {
                                    order = 4,
                                    type = "toggle",
                                    name = "Avoidable Damage Messages",
                                    width = "full",
                                    get = function() return NCConfig:IsAvoidableDamageException() end,
                                    set = function(_, value) NCConfig:SetAvoidableDamageException(value) end,
                                },
                            }
                        }
                    }
                }
            }
        }
    }
}
