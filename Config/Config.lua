-----------------------------------------------------
-- CONFIGURATION UI
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local messagePreview = ""

core.defaults = {
	profile = {
		enabled = true,
        dbg = false,
        nonCombatMode = false,
        ai = true,
        flagFriendsAsNemeses = false,
        flagGuildmatesAsNemeses = false,
        reportConfig = {
            channel = "GROUP",
            excludeNemeses = false,
            reportLowPerformersOnWipe = false,
            reportLowPerformersOnDungeonFail = false,
            ["DAMAGE"] = {
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["COMBAT"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
            },
            ["AVOIDABLE"] = {
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["COMBAT"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
            },
            ["INTERRUPTS"] = {
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["COMBAT"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
            },
            ["DEATHS"] = {
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["COMBAT"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
            },
            ["OFFHEALS"] = {
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["COMBAT"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
            },
            ["PULLS"] = {
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["COMBAT"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
                ["REALTIME"] = false,
            },
            ["NEGLECTEDHEALS"] = {
                ["REALTIME"] = false,
            },
            ["AFFIXES"] = {
                ["CASTSTART"] = false,
                ["CASTINTERRUPTED"] = false,
                ["CASTSUCCESS"] = false,
                ["MARKERS"] = false,
                ["TOP"] = false,
                ["BOTTOM"] = false,
                ["BOSS"] = false,
                ["DUNGEON"] = false,
                ["AURASTACKS"] = false,
            }
        },
        aiConfig = {
            selected = "taunts",
            overrides = {}
        },
        useGlobalChance = false,
        globalChance = 0.5,
        minimumTime = 1,
        nemeses = {},
        messages = {},
        API = {},
        leavers = {},
        lowPerformers = {},
        statsFrame = {},
	},
}

core.options = { 
	name = "Nemesis Chat",
	handler = NemesisChat,
	type = "group",
    -- childGroups = "tab",
	args = {
        generalGroup = {}, -- General.lua
        nemesesGroup = {}, -- Nemeses.lua
        messagesGroup = {}, -- Messages.lua
        reportsGroup = {}, -- Reports.lua
        referenceGroup = {}, -- Reference.lua
        aboutGroup = {}, -- About.lua
	},
}

-- Initialization - called from core
function NemesisChat:InitializeConfig()
    AC:RegisterOptionsTable("NemesisChat_options", core.options)
	core.optionsFrame = ACD:AddToBlizOptions("NemesisChat_options", "NemesisChat")
end

-- Common functions for all tabs / UI
function PopUp(title, text)
    local AceGUI = LibStub("AceGUI-3.0")
    local frame = AceGUI:Create("Frame")
    frame:SetTitle(title)
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    frame:SetLayout("Fill")
    frame:SetWidth(300)
    frame:SetHeight(128)

    local desc = AceGUI:Create("Label")
    desc:SetText(text)
    desc:SetFullWidth(true)
    frame:AddChild(desc)
end

function ShowPopup(text, showReloadButton, title)
    local AceGUI = LibStub("AceGUI-3.0")
    local frame = AceGUI:Create("Frame")

    if title then
        frame:SetTitle(title)
    else
        frame:SetTitle("Reload Required")
    end

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

function ShowReloadPopup(text)
    ShowPopup(text, true)
end

function ShowTogglePopup(feature)
    ShowReloadPopup("Toggling " .. feature .. " requires a reload. If you choose not to reload, functionality will absolutely be unexpected and may even cause LUA errors to be thrown. It is highly recommended to reload now, ensuring smooth gameplay without thrown errors.")
end

function ShowApiErrorPopup(api)
    ShowPopup("Cannot enable " .. api .. " API: " .. api .. " could not be found! Please ensure it is enabled and functional.", false, "Error!")
end
