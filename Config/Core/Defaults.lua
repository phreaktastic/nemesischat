local _, core = ...;

-----------------------------------------------------
-- Defaults for the Nemesis Chat database          --
-----------------------------------------------------

-- Centralize all defaults
core.defaults = {
    profile = {
        -- Core Settings
        enabled = true,
        debug = false,

        -- Message System
        messageSystem = {
            enabled = true,

            -- Combat Settings
            nonCombatMode = true,
            interruptException = true,
            deathException = true,
            avoidableDamageException = true,

            -- Game Integration
            allowBrannMessages = true,
            flagFriendsAsNemeses = false,
            flagGuildmatesAsNemeses = false,

            globalSettings = {
                useGlobalChance = false,
                globalChance = 0.5,
                minimumTime = 1,
                rollingMessages = true,
                defaultChannel = "GROUP",
                excludeNemeses = false,

                -- UI State Settings
                currentMessage = "",
                currentCategory = "",
                currentEvent = "",
                currentTarget = "",

                -- Preview Settings
                previewSpell = nil,
                lastPreviewUpdate = 0
            },
            categories = {
                combat = {
                    enabled = true,
                    types = {
                        damage = {
                            enabled = true,
                            reportTop = false,
                            reportBottom = false,
                            triggers = {
                                afterCombat = false,
                                afterBoss = false,
                                afterDungeon = false
                            }
                        },
                        interrupts = {
                            enabled = true,
                            reportTop = false,
                            reportBottom = false,
                            triggers = {
                                afterCombat = false,
                                afterBoss = false,
                                afterDungeon = false
                            }
                        },
                        avoidable = {
                            enabled = true,
                            reportTop = false,
                            reportBottom = false,
                            triggers = {
                                afterCombat = false,
                                afterBoss = false,
                                afterDungeon = false
                            }
                        },
                        deaths = {
                            enabled = true,
                            reportTop = false,
                            reportBottom = false,
                            triggers = {
                                afterCombat = false,
                                afterBoss = false,
                                afterDungeon = false
                            }
                        },
                        offHeals = {
                            enabled = true,
                            reportTop = false,
                            reportBottom = false,
                            triggers = {
                                afterCombat = false,
                                afterBoss = false,
                                afterDungeon = false
                            }
                        },
                        crowdcontrol = {
                            enabled = true,
                            reportTop = false,
                            reportBottom = false,
                            triggers = {
                                afterCombat = false,
                                afterBoss = false,
                                afterDungeon = false
                            }
                        }
                    }
                },
                dungeon = {
                    enabled = true,
                    types = {
                        pulls = {
                            enabled = true,
                            realtime = false,
                            channel = "SAY",
                            showToast = false
                        },
                        completion = {
                            enabled = true,
                            reportStats = true,
                            reportLowPerformers = false
                        },
                        failure = {
                            enabled = true,
                            reportStats = true,
                            reportLowPerformers = true
                        }
                    }
                },
                player = {
                    enabled = true,
                    types = {
                        join = {
                            enabled = true,
                            reportLeaverHistory = true,
                            leaverThreshold = 5,
                            reportPerformanceHistory = true,
                            performanceThreshold = 5
                        },
                        leave = {
                            enabled = true,
                            trackHistory = true
                        }
                    }
                }
            }
        },

        -- LFG Settings
        lfg = {
            applicants = {
                global = {
                    minItemLevel = 0,
                    minDungeonScore = 0,
                    popupOnIgnoredApplicants = false,
                    allowedRealms = {},
                    ignoredRealms = {},
                    allowedClasses = {},
                    ignoredClasses = {},
                    allowedSpecs = {},
                    ignoredSpecs = {},
                },
                roles = {
                    tank = {
                        enabled = true,
                        sound = 8959,
                        chat = true,
                        minItemLevel = 0,
                        minDungeonScore = 0,
                    },
                    healer = {
                        enabled = true,
                        sound = 8959,
                        chat = true,
                        minItemLevel = 0,
                        minDungeonScore = 0,
                    },
                    dps = {
                        enabled = true,
                        sound = 18019,
                        chat = true,
                        minItemLevel = 0,
                        minDungeonScore = 0,
                    }
                }
            }
        },

        -- UI Modifications
        ui = {
            contextMenuEnabled = false,
        },

        -- Storage
        messages = {},
        nemeses = {},
        api = {},
        leavers = {},
        lowPerformers = {},
        migrations = {},

        -- UI Settings
        statsFrame = {
            point = "CENTER",
            relativeTo = "UIParent",
            relativePoint = "CENTER",
            xOfs = 0,
            yOfs = 0,
            width = 400,
            height = 400,
        },

        -- Cache
        cache = {
            guild = {},
            guildTime = 0,
            friends = {},
            friendsTime = 0,
            groupRoster = {},
            groupRosterTime = 0,
            ncDungeon = {},
            dungeonRankings = {},
            ncDungeonTime = 0,
        },

        nemesisIcons = {
            enabled = true,
            frames = {
                party = { enabled = true, iconIndex = 1, size = 16, point = "CENTER", xOffset = 0, yOffset = 0 },
                nameplate = { enabled = true, iconIndex = 1, size = 16, point = "CENTER", xOffset = 0, yOffset = 0 },
                target = { enabled = true, iconIndex = 1, size = 16, point = "CENTER", xOffset = 0, yOffset = 0 },
            }
        },
    },
}
