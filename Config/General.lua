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
    order = 0,
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
        enabled = {
            order = 1,
            type = "toggle",
            name = "Enable",
            desc = "Toggle Nemesis Chat",
            get = function() return IsNCEnabled() end,
            set = function() NCConfig:SetEnabled(value) end,
        },
        nonCombatMode = {
            order = 2,
            type = "toggle",
            name = "Non-Combat Mode",
            desc = "Toggle Non-Combat Mode. This restricts Nemesis Chat from messaging while in combat.",
            get = function() return NCConfig:IsNonCombatMode() end,
            set = function() return NCConfig:SetNonCombatMode(value) end,
        },
        flagFriendsAsNemeses = {
            order = 3,
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
        ai = {
            order = 4,
            type = "toggle",
            name = "AI Phrases",
            desc = "Toggle AI Generated Phrases. This allows you to run NC without configuring any phrases. NOTE: This will only taunt Nemeses currently. More functionality is on the way!",
            get = function() NCConfig:IsAIEnabled() end,
            set = function() NCConfig:SetAI(value) end,
        },
        globalChanceToggle = {
            order = 5,
            type = "toggle",
            name = "Use Global Chance",
            desc = "Toggle Global Chance. This allows you to ensure that messages will only be sent a percentage of the time. NOTE: This does not apply for reports.",
            get = function() return NCConfig:IsUsingGlobalChance() end,
            set = function() return NCConfig:SetUsingGlobalChance(value) end,
        },
        globalChanceSlider = {
            order = 6,
            type = "range",
            min = 0.0,
            max = 1.0,
            step = 0.05,
            name = "Global Chance",
            desc = "A chance can be 0.0 (0%) to 1.0 (100%).",
            get = function() return NCConfig:GetGlobalChance() end,
            set = function() return NCConfig:SetGlobalChance(value) end,
            disabled = function() return NCConfig:IsUsingGlobalChance() ~= true end,
        },
        minimumTimeSlider = {
            order = 7,
            type = "range",
            min = 1,
            max = 300,
            step = 1,
            name = "Minimum Time",
            desc = "The minimum time (in seconds) between messages. NOTE: This does not apply for reports.",
            get = function() return NCConfig:GetMinimumTime() end,
            set = function() return NCConfig:SetMinimumTime(value) end,
        },
        apis = {
            order = 8,
            type = "group",
            name = "APIs",
            inline = false,
            hidden = function() return core.apiConfigOptions == {} end,
        },
    }
}

