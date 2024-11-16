-----------------------------------------------------
-- Group Finder Role Settings Configuration
-----------------------------------------------------
local _, core = ...;
local L = _G.NCL
local AceGUI = LibStub("AceGUI-3.0")

local soundTable, soundTableSortKeys = GetSoundTable()
local minItemLevelMin = 0
local minItemLevelMax = 650

-- Create the dropdown menu with preview buttons
local function CreateSoundDropdown(role, order)
    return {
        order = order,
        type = "select",
        dialogControl = "SoundDropdown",
        name = "Notification Sound",
        desc = "Sound to play when a " .. role .. " applies",
        values = soundTable,
        sorting = soundTableSortKeys,
        width = "full",
        get = function() return NCConfig:GetRoleSound(role) end,
        set = function(_, value)
            NCConfig:SetRoleSound(role, value)
        end,
        disabled = function() return not NCConfig:IsRoleEnabled(role) end
    }
end

core.options.args.dungeonGroup.args.lfgTools.args.roleSettings = {
    order = 2,
    type = "group",
    name = "Role-Specific Settings",
    args = {
        tank = {
            order = 1,
            type = "group",
            name = "Tank Settings",
            inline = true,
            args = {
                enabled = {
                    order = 1,
                    type = "toggle",
                    name = "Tank Notifications",
                    desc = "Enable notifications for tank applicants",
                    width = "full",
                    get = function() return NCConfig:IsRoleEnabled("tank") end,
                    set = function() NCConfig:ToggleRoleEnabled("tank") end,
                },
                chat = {
                    order = 2,
                    type = "toggle",
                    name = "Tank Chat Announcements",
                    desc = "Enable chat announcements for tank applicants",
                    width = "full",
                    get = function() return NCConfig:IsRoleChatEnabled("tank") end,
                    set = function() NCConfig:ToggleRoleChatEnabled("tank") end,
                },
                notification = CreateSoundDropdown("tank", 3),
                requirements = {
                    order = 4,
                    type = "group",
                    name = "Tank Requirements",
                    inline = true,
                    args = {
                        minItemLevel = {
                            order = 1,
                            type = "range",
                            name = "Tank Item Level",
                            desc = "Minimum item level for tanks",
                            min = minItemLevelMin,
                            max = minItemLevelMax,
                            step = 1,
                            width = "full",
                            get = function() return NCConfig:GetRoleMinItemLevel("tank") end,
                            set = function(_, value) NCConfig:SetRoleMinItemLevel("tank", value) end,
                        },
                        minScore = {
                            order = 2,
                            type = "range",
                            name = "Tank M+ Score",
                            desc = "Minimum Mythic+ rating for tanks",
                            min = 0,
                            max = 5000,
                            step = 10,
                            width = "full",
                            get = function() return NCConfig:GetRoleMinDungeonScore("tank") end,
                            set = function(_, value) NCConfig:SetRoleMinDungeonScore("tank", value) end,
                        }
                    }
                }
            }
        },
        healer = {
            order = 2,
            type = "group",
            name = "Healer Settings",
            inline = true,
            args = {
                enabled = {
                    order = 1,
                    type = "toggle",
                    name = "Healer Notifications",
                    desc = "Enable notifications for healer applicants",
                    width = "full",
                    get = function() return NCConfig:IsRoleEnabled("healer") end,
                    set = function() NCConfig:ToggleRoleEnabled("healer") end,
                },
                chat = {
                    order = 2,
                    type = "toggle",
                    name = "Healer Chat Announcements",
                    desc = "Enable chat announcements for healer applicants",
                    width = "full",
                    get = function() return NCConfig:IsRoleChatEnabled("healer") end,
                    set = function() NCConfig:ToggleRoleChatEnabled("healer") end,
                },
                notification = CreateSoundDropdown("healer", 3),
                requirements = {
                    order = 4,
                    type = "group",
                    name = "Healer Requirements",
                    inline = true,
                    args = {
                        minItemLevel = {
                            order = 1,
                            type = "range",
                            name = "Healer Item Level",
                            desc = "Minimum item level for healers",
                            min = minItemLevelMin,
                            max = minItemLevelMax,
                            step = 1,
                            width = "full",
                            get = function() return NCConfig:GetRoleMinItemLevel("healer") end,
                            set = function(_, value) NCConfig:SetRoleMinItemLevel("healer", value) end,
                        },
                        minScore = {
                            order = 2,
                            type = "range",
                            name = "Healer M+ Score",
                            desc = "Minimum Mythic+ rating for healers",
                            min = 0,
                            max = 5000,
                            step = 10,
                            width = "full",
                            get = function() return NCConfig:GetRoleMinDungeonScore("healer") end,
                            set = function(_, value) NCConfig:SetRoleMinDungeonScore("healer", value) end,
                        }
                    }
                }
            }
        },
        dps = {
            order = 3,
            type = "group",
            name = "DPS Settings",
            inline = true,
            args = {
                enabled = {
                    order = 1,
                    type = "toggle",
                    name = "DPS Notifications",
                    desc = "Enable notifications for DPS applicants",
                    width = "full",
                    get = function() return NCConfig:IsRoleEnabled("dps") end,
                    set = function() NCConfig:ToggleRoleEnabled("dps") end,
                },
                chat = {
                    order = 2,
                    type = "toggle",
                    name = "DPS Chat Announcements",
                    desc = "Enable chat announcements for DPS applicants",
                    width = "full",
                    get = function() return NCConfig:IsRoleChatEnabled("dps") end,
                    set = function() NCConfig:ToggleRoleChatEnabled("dps") end,
                },
                notification = CreateSoundDropdown("dps", 3),
                requirements = {
                    order = 4,
                    type = "group",
                    name = "DPS Requirements",
                    inline = true,
                    args = {
                        minItemLevel = {
                            order = 1,
                            type = "range",
                            name = "DPS Item Level",
                            desc = "Minimum item level for DPS",
                            min = minItemLevelMin,
                            max = minItemLevelMax,
                            step = 1,
                            width = "full",
                            get = function() return NCConfig:GetRoleMinItemLevel("dps") end,
                            set = function(_, value) NCConfig:SetRoleMinItemLevel("dps", value) end,
                        },
                        minScore = {
                            order = 2,
                            type = "range",
                            name = "DPS M+ Score",
                            desc = "Minimum Mythic+ rating for DPS",
                            min = 0,
                            max = 5000,
                            step = 10,
                            width = "full",
                            get = function() return NCConfig:GetRoleMinDungeonScore("dps") end,
                            set = function(_, value) NCConfig:SetRoleMinDungeonScore("dps", value) end,
                        }
                    }
                }
            }
        }
    }
}
