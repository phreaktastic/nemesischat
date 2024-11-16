-----------------------------------------------------
-- EVENT HELPERS
-- Handles event processing and validation
-----------------------------------------------------
local addonName, core = ...

-----------------------------------------------------
-- Event Validation
-----------------------------------------------------
function NemesisChat:ShouldExitEventHandler()
    -- Check if addon is enabled
    if not IsNCEnabled() then
        return true
    end

    -- Check if event is valid
    if not NCEvent:IsValidEvent() then
        return true
    end

    -- Check if player is in group
    if not IsInGroup() then
        return true
    end

    return false
end

-----------------------------------------------------
-- Event Processing
-----------------------------------------------------
function NemesisChat:ProcessGroupEvent(eventType, ...)
    if self:ShouldExitEventHandler() then
        return
    end

    local handler = self.eventHandlers[eventType]
    if handler then
        handler(self, ...)
    end
end

-----------------------------------------------------
-- Event Registration
-----------------------------------------------------
function NemesisChat:RegisterEvents()
    -- Register core events
    for _, event in pairs(core.coreEvents) do
        self:RegisterEvent(event)
    end

    -- Register dynamic events if in group
    if IsInGroup() then
        self:RegisterDynamicEvents()
    end
end

function NemesisChat:RegisterDynamicEvents()
    for _, event in pairs(core.dynamicEvents) do
        self:RegisterEvent(event)
    end
end

function NemesisChat:UnregisterDynamicEvents()
    for _, event in pairs(core.dynamicEvents) do
        self:UnregisterEvent(event)
    end
end

-----------------------------------------------------
-- Event Handlers
-----------------------------------------------------
NemesisChat.eventHandlers = {
    GROUP_ROSTER_UPDATE = function(self)
        self:HandleRosterUpdate()
    end,

    CHAT_MSG_ADDON = function(self, prefix, message, channel, sender)
        if self:IsValidAddonMessage(prefix) then
            self:ProcessAddonMessage(prefix, message, sender)
        end
    end,

    PLAYER_ENTERING_WORLD = function(self)
        self:HandlePlayerEnteringWorld()
    end
}

function NemesisChat:IsValidAddonMessage(prefix)
    return prefix == "NC_LEAVERS" or prefix == "NC_LOWPERFORMERS"
end

function NemesisChat:HandlePlayerEnteringWorld()
    self:InitIfEnabled()
    self:RegisterEvents()
end
