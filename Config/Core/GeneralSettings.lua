-----------------------------------------------------
-- Core Settings Configuration
-----------------------------------------------------
local _, core = ...;

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
    }
}
