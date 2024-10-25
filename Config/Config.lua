-----------------------------------------------------
-- Core Configuration Management
-- Handles central config initialization and management
-----------------------------------------------------
local _, core = ...;
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

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

        -- Storage
        messages = {},
        nemeses = {},
        api = {},
        leavers = {},
        lowPerformers = {},

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
    },
}

-- Main options table structure
local _, core = ...;

core.options = {
    name = "Nemesis Chat",
    handler = NemesisChat,
    type = "group",
    childGroups = "tab",
    args = {
        messagesGroup = {
            order = 1,
            type = "group",
            name = "Messages & Broadcasts",
            childGroups = "tab",
            args = {
                eventMessages = {
                    order = 1,
                    type = "group",
                    name = "Event Messages",
                    args = {} -- Will contain current triggered messages functionality
                },
                segmentMessages = {
                    order = 2,
                    type = "group",
                    name = "Segment Summaries",
                    args = {} -- Will contain current reports functionality
                },
                messageSettings = {
                    order = 3,
                    type = "group",
                    name = "Message Settings",
                    args = {} -- Will contain non-combat mode, channels, etc.
                },
                referenceGroup = {
                    order = 4,
                    type = "group",
                    name = "Message Replacements",
                    args = {} -- Will contain message reference and documentation
                }
            }
        },
        dungeonGroup = {
            order = 2,
            type = "group",
            name = "Dungeon Features",
            childGroups = "tab",
            args = {
                mythicPlus = {
                    order = 1,
                    type = "group",
                    name = "Mythic+",
                    args = {} -- Will contain M+ settings and tracking
                },
                lfgTools = {
                    order = 2,
                    type = "group",
                    name = "Group Finder",
                    args = {} -- Will contain LFG related settings
                },
                delves = {
                    order = 3,
                    type = "group",
                    name = "Delves",
                    args = {} -- Will contain delves configuration
                }
            }
        },
        coreGroup = {
            order = 3,
            type = "group",
            name = "Core Settings",
            args = {
                nemeses = {
                    order = 1,
                    type = "group",
                    name = "Nemeses",
                    args = {} -- Will contain nemeses management
                },
                general = {
                    order = 2,
                    type = "group",
                    name = "General Settings",
                    args = {} -- Will contain basic addon settings
                }
            }
        },
        apis = {
            order = 4,
            type = "group",
            name = "Plugins",
            inline = false,
            hidden = function() return core.apiConfigOptions == {} end,
        },
        aboutGroup = {
            order = 5,
            type = "group",
            name = "About",
            args = {} -- Will contain about info and documentation
        },
    }
}

-- Shared UI components
local function CustomSpacingLayout(content, children)
    local height = 0
    for i, child in ipairs(children) do
        local spacing = 60
        child.frame:ClearAllPoints()

        if i == 1 then
            child.frame:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -10)
            child.frame:SetPoint("RIGHT", content, "RIGHT", 0, 0)
        else
            child.frame:SetPoint("TOPLEFT", children[i - 1].frame, "BOTTOMLEFT", 0, -spacing)
            child.frame:SetPoint("RIGHT", content, "RIGHT", 0, 0)

            child.frame:SetBackdrop({
                bgFile = "Interface\\Buttons\\WHITE8x8",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                tile = true,
                tileSize = 16,
                edgeSize = 16,
                insets = { left = 4, right = 4, top = 4, bottom = 4 }
            })
        end

        height = height + child.frame:GetHeight() + spacing
    end
    content:SetHeight(height)
end

-- Initialize configuration
function NemesisChat:InitializeConfig()
    if self.configInitialized then return end

    -- Register custom layout
    AceGUI:RegisterLayout("NCSpacing", CustomSpacingLayout)

    -- Register options table
    AC:RegisterOptionsTable("NemesisChat_options", core.options)
    self.optionsFrame = ACD:AddToBlizOptions("NemesisChat_options", "NemesisChat")

    self.configInitialized = true
end

-- Popup dialog helpers
function NemesisChat:ShowPopup(text, showReloadButton, title)
    local frame = AceGUI:Create("Frame")
    frame:SetTitle(title or "Reload Required")
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    frame:SetLayout("List")
    frame:SetWidth(300)
    frame:SetHeight(300)

    local desc = AceGUI:Create("Label")
    desc:SetText(text)
    desc:SetFullWidth(true)
    frame:AddChild(desc)

    local padding = AceGUI:Create("Label")
    padding:SetText(" ")
    padding:SetFullWidth(true)
    frame:AddChild(padding)

    if showReloadButton then
        local button = AceGUI:Create("Button")
        button:SetText("Reload Now")
        button:SetFullWidth(true)
        button:SetCallback("OnClick", function() ReloadUI() end)
        frame:AddChild(button)
    end
end

-- Convenience wrappers
function NemesisChat:ShowReloadPopup(text)
    self:ShowPopup(text, true)
end

function NemesisChat:ShowTogglePopup(feature)
    self:ShowReloadPopup(string.format(
        "Toggling %s requires a reload. If you choose not to reload, functionality will be unexpected and may cause errors. It is recommended to reload now for smooth gameplay.",
        feature
    ))
end

function NemesisChat:ShowApiErrorPopup(api)
    self:ShowPopup(
        string.format("Cannot enable %s API: %s could not be found! Please ensure it is enabled and functional.", api,
            api),
        false,
        "Error!"
    )
end
