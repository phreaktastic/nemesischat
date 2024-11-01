-----------------------------------------------------
-- Core Configuration Management
-- Handles central config initialization and management
-----------------------------------------------------
local _, core = ...;
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

-- Spacing constants
local VERTICAL_GAP = 20 -- Base gap between elements
local SECTION_GAP = 50  -- Larger gap between sections
local GROUP_GAP = 30    -- Gap between grouped elements

-- Spacing enhancements
local function EnhanceOptionsSpacing(options)
    if type(options) ~= "table" then return options end

    local function processGroup(group)
        if type(group) ~= "table" then return end

        -- First pass: collect and sort elements by order
        local elements = {}
        for name, opt in pairs(group) do
            if type(opt) == "table" then
                elements[#elements + 1] = { name = name, opt = opt, order = opt.order or 100 }
            end
        end
        table.sort(elements, function(a, b) return (a.order or 100) < (b.order or 100) end)

        -- Second pass: adjust spacing
        local lastOrder = 0
        for i, element in ipairs(elements) do
            local opt = element.opt

            -- Base enhancements
            if not opt.width then
                -- opt.width = "full"
            end

            if opt.type == "description" then
                if not opt.fontSize then
                    opt.fontSize = "medium"
                end
                if not opt.descStyle then
                    opt.descStyle = "inline"
                end
            end

            -- Adjust order for spacing
            local baseOrder = i * 10

            -- Add extra spacing after headers and certain elements
            if opt.type == "header" then
                baseOrder = baseOrder + GROUP_GAP
            elseif opt.type == "description" and opt.fontSize == "large" then
                baseOrder = baseOrder + SECTION_GAP
            else
                baseOrder = baseOrder + VERTICAL_GAP
            end

            opt.order = baseOrder
            lastOrder = baseOrder

            -- Process nested groups
            if opt.type == "group" then
                if not opt.childGroups then
                    opt.childGroups = "tab"
                end

                if opt.args then
                    processGroup(opt.args)
                end
            end
        end
    end

    if options.args then
        processGroup(options.args)
    end

    return options
end

-- Hook AceConfig registration
local originalRegister = AC.RegisterOptionsTable
AC.RegisterOptionsTable = function(self, appName, options, ...)
    if type(options) == "function" then
        local oldFunc = options
        options = function(...)
            return EnhanceOptionsSpacing(oldFunc(...))
        end
    else
        options = EnhanceOptionsSpacing(options)
    end

    return originalRegister(self, appName, options, ...)
end

-- Main options table structure
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

-- Initialize configuration
function NemesisChat:InitializeConfig()
    if self.configInitialized then return end

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
        string.format("Cannot enable %s Plugin: %s could not be found! Please ensure it is enabled and functional.", api,
            api),
        false,
        "Error!"
    )
end
