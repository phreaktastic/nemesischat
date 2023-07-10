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
        detailsAPI = {
            order = 2,
            type = "toggle",
            name = "Details API",
            desc = "Toggle Details API. This enables additional replacements (such as [DPS], [NEMESISDPS], etc.) and events.",
            get = "IsDetailsAPI",
            set = "ToggleDetailsAPI",
        },
        gtfoAPI = {
            order = 3,
            type = "toggle",
            name = "GTFO API",
            desc = "Toggle GTFO API. This enables additional replacements (such as [AVOIDABLEDAMAGE], [NEMESISAVOIDABLEDAMAGE], etc.) and events.",
            get = "IsGtfoAPI",
            set = "ToggleGtfoAPI",
        },
        nonCombatMode = {
            order = 4,
            type = "toggle",
            name = "Non-Combat Mode",
            desc = "Toggle Non-Combat Mode. This restricts Nemesis Chat from messaging while in combat.",
            get = "IsNonCombatMode",
            set = "ToggleNonCombatMode",
        },
        pugMode = {
            order = 5,
            type = "toggle",
            name = "PUG Mode",
            desc = "Toggle PUG Mode. This enables Nemesis Chat functionality while no Nemeses are present. Core functionality (event-driven messages) will NOT function, but other functionality (such as reports) will.",
            get = "IsPugMode",
            set = "TogglePugMode",
        },
        ai = {
            order = 6,
            type = "toggle",
            name = "AI Phrases",
            desc = "Toggle AI Generated Phrases. This allows you to run NC without configuring any phrases. NOTE: This will only taunt Nemeses currently. More functionality is on the way!",
            get = "IsAI",
            set = "ToggleAI",
        },
        globalChanceToggle = {
            order = 7,
            type = "toggle",
            name = "Use Global Chance",
            desc = "Toggle Global Chance. This allows you to ensure that messages will only be sent a percentage of the time. NOTE: This does not apply for reports.",
            get = "IsUseGlobalChance",
            set = "ToggleUseGlobalChance",
        },
        globalChanceSlider = {
            order = 8,
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
            order = 9,
            type = "range",
            min = 1,
            max = 300,
            step = 1,
            name = "Minimum Time",
            desc = "The minimum time (in seconds) between messages. NOTE: This does not apply for reports.",
            get = "GetMinimumTime",
            set = "SetMinimumTime",
        },
    }
}

function NemesisChat:IsEnabled(info)
	return core.db.profile.enabled
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

function NemesisChat:IsDetailsAPI()
	return core.db.profile.detailsAPI
end

function NemesisChat:ToggleDetailsAPI(info, value)
    if value == true and Details == nil then
        self:Print("Cannot enable Details API: Details could not be found! Please ensure it is enabled and functional.")
        ShowApiErrorPopup("Details!")
        return
    end
	core.db.profile.detailsAPI = value

    if value == false then
        return
    end

    ShowTogglePopup("Details! API")
end

function NemesisChat:IsGtfoAPI()
    return core.db.profile.gtfoAPI
end

function NemesisChat:ToggleGtfoAPI(info, value)
    if value == true and Details == nil then
        self:Print("Cannot enable GTFO API: GTFO could not be found! Please ensure it is enabled and functional.")
        ShowApiErrorPopup("GTFO")
        return
    end
	core.db.profile.gtfoAPI = value

    if value == false then
        return
    end

    ShowTogglePopup("GTFO API")
end

function NemesisChat:IsNonCombatMode()
    return core.db.profile.nonCombatMode
end

function NemesisChat:ToggleNonCombatMode(info, value)
    core.db.profile.nonCombatMode = value
end

function NemesisChat:IsPugMode()
    return core.db.profile.pugMode
end

function NemesisChat:TogglePugMode(info, value)
    core.db.profile.pugMode = value

    NemesisChat:CheckGroup()
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