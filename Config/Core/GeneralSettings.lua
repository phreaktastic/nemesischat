-----------------------------------------------------
-- Core Settings Configuration
-----------------------------------------------------
local _, core = ...;

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local partyIconSize = 128
local targetIconSize = 128
local nameplateIconSize = 128

local function UpdatePartyIconPreviewSize()
    core.options.args.coreGroup.args.general.args.nemesisIcons.args.partyFrame.args.iconPreview.imageWidth = partyIconSize
    core.options.args.coreGroup.args.general.args.nemesisIcons.args.partyFrame.args.iconPreview.imageHeight = partyIconSize
end

local function UpdateTargetIconPreviewSize()
    core.options.args.coreGroup.args.general.args.nemesisIcons.args.targetFrame.args.iconPreview.imageWidth = targetIconSize
    core.options.args.coreGroup.args.general.args.nemesisIcons.args.targetFrame.args.iconPreview.imageHeight = targetIconSize
end

local function UpdateNameplateIconPreviewSize()
    core.options.args.coreGroup.args.general.args.nemesisIcons.args.nameplateFrame.args.iconPreview.imageWidth = nameplateIconSize
    core.options.args.coreGroup.args.general.args.nemesisIcons.args.nameplateFrame.args.iconPreview.imageHeight = nameplateIconSize
end

core.EventSystem:RegisterEvent("DATABASE_INITIALIZED", function()
    C_Timer.After(0.1, function()
        partyIconSize = NCConfig:GetPath("nemesisIcons.frames.party.size")
        targetIconSize = NCConfig:GetPath("nemesisIcons.frames.target.size")
        nameplateIconSize = NCConfig:GetPath("nemesisIcons.frames.nameplate.size")

        UpdatePartyIconPreviewSize()
        UpdateTargetIconPreviewSize()
        UpdateNameplateIconPreviewSize()
    end)
end)

core.options.args.coreGroup.args.general = {
    order = 1,
    type = "group",
    name = "General Settings",
    args = {
        addonControl = {
            order = 1,
            type = "group",
            name = "Addon Control",
            inline = true,
            args = {
                enabled = {
                    order = 1,
                    type = "toggle",
                    name = "Enable Addon",
                    desc = "Enable or disable all Nemesis Chat functionality",
                    width = "full",
                    get = function() return NCConfig:IsEnabled() end,
                    set = function() NCConfig:ToggleEnabled() end,
                },
                contextMenuEnabled = {
                    order = 2,
                    type = "toggle",
                    name = "Enable Context Menu",
                    desc = "Toggle the context menu option for right-clicking players to mark or unmark them as a nemesis.",
                    width = "full",
                    get = function() return NCConfig:IsContextMenuEnabled() end,
                    set = function() NCConfig:ToggleContextMenuEnabled() end,
                },
            }
        },
        nemesisAutomatic = {
            order = 2,
            type = "group",
            name = "Automatic Nemesis Recognition",
            inline = true,
            args = {
                description = {
                    order = 1,
                    type = "description",
                    fontSize = "medium",
                    name = "Automatically recognize players as Nemeses based on their relationship to you:",
                },
                flagFriends = {
                    order = 2,
                    type = "toggle",
                    name = "Friends List Members",
                    desc = "Automatically recognize players from your friends list as Nemeses",
                    width = "full",
                    get = function() return NCConfig:IsFlaggingFriendsAsNemeses() end,
                    set = function(_, value) NCConfig:SetFlaggingFriendsAsNemeses(value) end,
                },
                flagGuildies = {
                    order = 3,
                    type = "toggle",
                    name = "Guild Members",
                    desc = "Automatically recognize guild members as Nemeses",
                    width = "full",
                    get = function() return NCConfig:IsFlaggingGuildmatesAsNemeses() end,
                    set = function(_, value) NCConfig:SetFlaggingGuildmatesAsNemeses(value) end,
                },
            }
        },
        nemesisIcons = {
            order = 3,
            type = "group",
            name = "Nemesis Icons",
            inline = true,
            args = {
                enableFeature = {
                    order = 1,
                    type = "toggle",
                    name = "Enable Nemesis Icons",
                    desc = "Toggle the entire nemesis icon feature on or off.",
                    width = "full",
                    get = function() return NCConfig:GetPath("nemesisIcons.enabled") end,
                    set = function(_, value) NCConfig:SetPath("nemesisIcons.enabled", value) UpdateNemesisIcons() end,
                },
                partyFrame = {
                    order = 2,
                    type = "group",
                    name = "Party Frame",
                    inline = true,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = "Enable Party Frame Icon",
                            desc = "Toggle the nemesis icon on the party frame.",
                            width = "full",
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.party.enabled") end,
                            set = function(_, value) NCConfig:SetPath("nemesisIcons.frames.party.enabled", value) UpdateNemesisIcons() end,
                        },
                        icon = {
                            order = 2,
                            type = "select",
                            name = "Select Icon",
                            desc = "Select the icon to use for the nemesis icon on the party frame.",
                            width = "full",
                            values = {
                                [1] = "Icon 1",
                                [2] = "Icon 2",
                                [3] = "Icon 3",
                                [4] = "Icon 4",
                                [5] = "Icon 5",
                                [6] = "Icon 6",
                                [7] = "Icon 7",
                                [8] = "Icon 8",
                            },
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.party.iconIndex") end,
                            set = function(_, value)
                                NCConfig:SetPath("nemesisIcons.frames.party.iconIndex", value)
                                AceConfigRegistry:NotifyChange("NemesisChat_options")
                                UpdateNemesisIcons()
                            end,
                        },
                        iconPreview = {
                            order = 3,
                            type = "description",
                            name = "",
                            width = "full",
                            image = function()
                                local iconIndex = NCConfig:GetPath("nemesisIcons.frames.party.iconIndex")
                                return "Interface\\Addons\\NemesisChat\\Media\\Icons\\Nemesis" .. iconIndex .. ".blp"
                            end,
                            imageWidth = partyIconSize,
                            imageHeight = partyIconSize,
                        },
                        size = {
                            order = 4,
                            type = "range",
                            name = "Icon Size",
                            min = 16,
                            max = 128,
                            step = 1,
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.party.size") end,
                            set = function(_, value)
                                if partyIconSizeTimer then
                                    partyIconSizeTimer:Cancel()
                                end
                                partyIconSizeTimer = C_Timer.NewTimer(0.25, function()
                                    NCConfig:SetPath("nemesisIcons.frames.party.size", value)
                                    partyIconSize = value
                                    UpdatePartyIconPreviewSize()
                                    AceConfigRegistry:NotifyChange("NemesisChat_options")
                                    UpdateNemesisIcons()
                                end)
                            end,
                        },
                        point = {
                            order = 5,
                            type = "select",
                            name = "Anchor Point",
                            values = {
                                ["CENTER"] = "Center",
                                ["TOP"] = "Top",
                                ["BOTTOM"] = "Bottom",
                                ["LEFT"] = "Left",
                                ["RIGHT"] = "Right",
                                ["TOPLEFT"] = "Top Left",
                                ["TOPRIGHT"] = "Top Right",
                                ["BOTTOMLEFT"] = "Bottom Left",
                                ["BOTTOMRIGHT"] = "Bottom Right",
                            },
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.party.point") end,
                            set = function(_, value) NCConfig:SetPath("nemesisIcons.frames.party.point", value) UpdateNemesisIcons() end,
                        },
                        xOffset = {
                            order = 6,
                            type = "range",
                            name = "X Offset",
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.party.xOffset") end,
                            set = function(_, value) NCConfig:SetPath("nemesisIcons.frames.party.xOffset", value) UpdateNemesisIcons() end,
                        },
                        yOffset = {
                            order = 7,
                            type = "range",
                            name = "Y Offset",
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.party.yOffset") end,
                            set = function(_, value) NCConfig:SetPath("nemesisIcons.frames.party.yOffset", value) UpdateNemesisIcons() end,
                        },
                    },
                },
                targetFrame = {
                    order = 3,
                    type = "group",
                    name = "Target Frame",
                    inline = true,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = "Enable Target Frame Icon",
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.target.enabled") end,
                            set = function(_, value) NCConfig:SetPath("nemesisIcons.frames.target.enabled", value) UpdateNemesisIcons() end,
                        },
                        icon = {
                            order = 2,
                            type = "select",
                            name = "Select Icon",
                            values = {
                                [1] = "Icon 1",
                                [2] = "Icon 2",
                                [3] = "Icon 3",
                                [4] = "Icon 4",
                                [5] = "Icon 5",
                                [6] = "Icon 6",
                                [7] = "Icon 7",
                                [8] = "Icon 8",
                            },
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.target.iconIndex") end,
                            set = function(_, value)
                                NCConfig:SetPath("nemesisIcons.frames.target.iconIndex", value)
                                AceConfigRegistry:NotifyChange("NemesisChat_options")
                                UpdateNemesisIcons()
                            end,
                        },
                        iconPreview = {
                            order = 3,
                            type = "description",
                            name = "",
                            image = function()
                                local iconIndex = NCConfig:GetPath("nemesisIcons.frames.target.iconIndex")
                                return "Interface\\Addons\\NemesisChat\\Media\\Icons\\Nemesis" .. iconIndex .. ".blp"
                            end,
                            imageWidth = targetIconSize,
                            imageHeight = targetIconSize,
                        },
                        size = {
                            order = 4,
                            type = "range",
                            name = "Icon Size",
                            min = 8,
                            max = 64,
                            step = 1,
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.target.size") end,
                            set = function(_, value)
                                if targetIconSizeTimer then
                                    targetIconSizeTimer:Cancel()
                                end
                                targetIconSizeTimer = C_Timer.NewTimer(0.25, function()
                                    NCConfig:SetPath("nemesisIcons.frames.target.size", value)
                                    targetIconSize = value
                                    UpdateTargetIconPreviewSize()
                                    AceConfigRegistry:NotifyChange("NemesisChat_options")
                                    UpdateNemesisIcons()
                                end)
                            end,
                        },
                        point = {
                            order = 5,
                            type = "select",
                            name = "Anchor Point",
                            values = {
                                ["CENTER"] = "Center",
                                ["TOP"] = "Top",
                                ["BOTTOM"] = "Bottom",
                                ["LEFT"] = "Left",
                                ["RIGHT"] = "Right",
                                ["TOPLEFT"] = "Top Left",
                                ["TOPRIGHT"] = "Top Right",
                                ["BOTTOMLEFT"] = "Bottom Left",
                                ["BOTTOMRIGHT"] = "Bottom Right",
                            },
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.target.point") end,
                            set = function(_, value) NCConfig:SetPath("nemesisIcons.frames.target.point", value) UpdateNemesisIcons() end,
                        },
                        xOffset = {
                            order = 6,
                            type = "range",
                            name = "X Offset",
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.target.xOffset") end,
                            set = function(_, value) NCConfig:SetPath("nemesisIcons.frames.target.xOffset", value) UpdateNemesisIcons() end,
                        },
                        yOffset = {
                            order = 7,
                            type = "range",
                            name = "Y Offset",
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.target.yOffset") end,
                            set = function(_, value) NCConfig:SetPath("nemesisIcons.frames.target.yOffset", value) UpdateNemesisIcons() end,
                        },
                    },
                },
                nameplateFrame = {
                    order = 4,
                    type = "group",
                    name = "Nameplate Frame",
                    inline = true,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = "Enable Nameplate Frame Icon",
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.nameplate.enabled") end,
                            set = function(_, value) NCConfig:SetPath("nemesisIcons.frames.nameplate.enabled", value) UpdateNemesisIcons() end,
                        },
                        icon = {
                            order = 2,
                            type = "select",
                            name = "Select Icon",
                            values = {
                                [1] = "Icon 1",
                                [2] = "Icon 2",
                                [3] = "Icon 3",
                                [4] = "Icon 4",
                                [5] = "Icon 5",
                                [6] = "Icon 6",
                                [7] = "Icon 7",
                                [8] = "Icon 8",
                            },
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.nameplate.iconIndex") end,
                            set = function(_, value)
                                NCConfig:SetPath("nemesisIcons.frames.nameplate.iconIndex", value)
                                AceConfigRegistry:NotifyChange("NemesisChat_options")
                                UpdateNemesisIcons()
                            end,
                        },
                        iconPreview = {
                            order = 3,
                            type = "description",
                            name = "",
                            image = function()
                                local iconIndex = NCConfig:GetPath("nemesisIcons.frames.nameplate.iconIndex")
                                return "Interface\\Addons\\NemesisChat\\Media\\Icons\\Nemesis" .. iconIndex .. ".blp"
                            end,
                            imageWidth = nameplateIconSize,
                            imageHeight = nameplateIconSize,
                        },
                        size = {
                            order = 4,
                            type = "range",
                            name = "Icon Size",
                            min = 8,
                            max = 64,
                            step = 1,
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.nameplate.size") end,
                            set = function(_, value)
                                if nameplateIconSizeTimer then
                                    nameplateIconSizeTimer:Cancel()
                                end
                                nameplateIconSizeTimer = C_Timer.NewTimer(0.25, function()
                                    NCConfig:SetPath("nemesisIcons.frames.nameplate.size", value)
                                    nameplateIconSize = value
                                    UpdateNameplateIconPreviewSize()
                                    AceConfigRegistry:NotifyChange("NemesisChat_options")
                                    UpdateNemesisIcons()
                                end)
                            end,
                        },
                        point = {
                            order = 5,
                            type = "select",
                            name = "Anchor Point",
                            values = {
                                ["CENTER"] = "Center",
                                ["TOP"] = "Top",
                                ["BOTTOM"] = "Bottom",
                                ["LEFT"] = "Left",
                                ["RIGHT"] = "Right",
                                ["TOPLEFT"] = "Top Left",
                                ["TOPRIGHT"] = "Top Right",
                                ["BOTTOMLEFT"] = "Bottom Left",
                                ["BOTTOMRIGHT"] = "Bottom Right",
                            },
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.nameplate.point") end,
                            set = function(_, value) NCConfig:SetPath("nemesisIcons.frames.nameplate.point", value) UpdateNemesisIcons() end,
                        },
                        xOffset = {
                            order = 6,
                            type = "range",
                            name = "X Offset",
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.nameplate.xOffset") end,
                            set = function(_, value) NCConfig:SetPath("nemesisIcons.frames.nameplate.xOffset", value) UpdateNemesisIcons() end,
                        },
                        yOffset = {
                            order = 7,
                            type = "range",
                            name = "Y Offset",
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function() return NCConfig:GetPath("nemesisIcons.frames.nameplate.yOffset") end,
                            set = function(_, value) NCConfig:SetPath("nemesisIcons.frames.nameplate.yOffset", value) UpdateNemesisIcons() end,
                        },
                    },
                },
            },
        },
    }
}
