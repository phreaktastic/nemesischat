-----------------------------------------------------
-- CONFIGURATION UI
-----------------------------------------------------
-- General Tab
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

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
                    get = function() return IsNCEnabled() end,
                    set = function(_, value) NCConfig:SetEnabled(value) end,
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
                    desc = "Toggle Global Chance. This allows you to ensure that messages will only be sent a percentage of the time. NOTE: This does not apply for reports.",
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
            }
        },
        nonCombatMode = {
            order = 2,
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
                    name = "NOTE: Non-Combat Mode will still allow some messages to fire, such as messages triggered by mobs or bosses.",
                },
            }
        },
        apis = {
            order = 3,
            type = "group",
            name = "APIs",
            inline = false,
            hidden = function() return core.apiConfigOptions == {} end,
        },
    }
}

