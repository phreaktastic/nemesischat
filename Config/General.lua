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
            get = "IsEnabled",
            set = "EnableDisable",
        },
        nonCombatMode = {
            order = 2,
            type = "toggle",
            name = "Non-Combat Mode",
            desc = "Toggle Non-Combat Mode. This restricts Nemesis Chat from messaging while in combat.",
            get = "IsNonCombatMode",
            set = "ToggleNonCombatMode",
        },
        flagFriendsAsNemeses = {
            order = 3,
            type = "toggle",
            name = "Flag Friends as Nemeses",
            desc = "If a person within your group is on your friends list, they will be flagged as a Nemesis.",
            get = function() return core.db.profile.flagFriendsAsNemeses end,
            set = function(_, value) core.db.profile.flagFriendsAsNemeses = value end,
        },
        ai = {
            order = 4,
            type = "toggle",
            name = "AI Phrases",
            desc = "Toggle AI Generated Phrases. This allows you to run NC without configuring any phrases. NOTE: This will only taunt Nemeses currently. More functionality is on the way!",
            get = "IsAI",
            set = "ToggleAI",
        },
        globalChanceToggle = {
            order = 5,
            type = "toggle",
            name = "Use Global Chance",
            desc = "Toggle Global Chance. This allows you to ensure that messages will only be sent a percentage of the time. NOTE: This does not apply for reports.",
            get = "IsUseGlobalChance",
            set = "ToggleUseGlobalChance",
        },
        globalChanceSlider = {
            order = 6,
            type = "range",
            min = 0.0,
            max = 1.0,
            step = 0.05,
            name = "Global Chance",
            desc = "A chance can be 0.0 (0%) to 1.0 (100%).",
            get = "GetGlobalChance",
            set = "SetGlobalChance",
            disabled = function() return core.db.profile.useGlobalChance ~= true end
        },
        minimumTimeSlider = {
            order = 7,
            type = "range",
            min = 1,
            max = 300,
            step = 1,
            name = "Minimum Time",
            desc = "The minimum time (in seconds) between messages. NOTE: This does not apply for reports.",
            get = "GetMinimumTime",
            set = "SetMinimumTime",
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

function NemesisChat:IsEnabled(info)
	return IsNCEnabled()
end

function NemesisChat:EnableDisable(info, value)
	core.db.profile.enabled = value

    NemesisChat:CheckGroup()
end

function NemesisChat:IsDebug(info)
	return core.db.profile.dbg
end

function NemesisChat:ToggleDebug(info, value)
	core.db.profile.dbg = value

    if value then
        self:Print("Debug mode enabled.")
    else
        self:Print("Debug mode disabled.")
    end
end

function NemesisChat:IsNonCombatMode()
    return core.db.profile.nonCombatMode
end

function NemesisChat:ToggleNonCombatMode(info, value)
    core.db.profile.nonCombatMode = value
end

function NemesisChat:IsAI(info)
	return core.db.profile.ai
end

function NemesisChat:ToggleAI(info, value)
	core.db.profile.ai = value

    ShowTogglePopup("AI")
end

function NemesisChat:IsUseGlobalChance(info)
	return core.db.profile.useGlobalChance
end

function NemesisChat:ToggleUseGlobalChance(info, value)
	core.db.profile.useGlobalChance = value
end

function NemesisChat:GetGlobalChance(info)
	return core.db.profile.globalChance
end

function NemesisChat:SetGlobalChance(info, value)
	core.db.profile.globalChance = value
end

function NemesisChat:GetMinimumTime(info)
	return core.db.profile.minimumTime
end

function NemesisChat:SetMinimumTime(info, value)
	core.db.profile.minimumTime = value
end