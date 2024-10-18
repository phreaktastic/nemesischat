-----------------------------------------------------
-- CORE FUNCTIONALITY
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

NemesisChat.registeredEvents = NemesisChat.registeredEvents or {}

-- Save the original Ace3 RegisterEvent method
local OriginalRegisterEvent = NemesisChat.RegisterEvent

function NemesisChat:OnInitialize()
    core.db = LibStub("AceDB-3.0"):New("NemesisChatDB", core.defaults, true)
    NemesisChatAPI:SetAPIConfigOptions()

    self:RegisterChatCommand("nc", "SlashCommand")
    self:RegisterChatCommand("nemesischat", "SlashCommand")

    NCMigration:Run()
end

function NemesisChat:OnEnable()
    if not NCRuntime:IsInitialized() then
        NemesisChat:InitializeCore()
    else
        self:InitIfEnabled()
    end

    NemesisChat:RegisterStaticEvents()
    NCInfo:OnEnableStateChanged(true)
end

function NemesisChat:OnDisable()
    self:UnregisterStaticEvents()
    NCInfo:OnEnableStateChanged(false)
end

function NemesisChat:RegisterEvent(event, method, ...)
    -- Track the event
    if not self.registeredEvents[event] then
        self.registeredEvents[event] = true
    end

    -- Call the original RegisterEvent method from Ace3
    OriginalRegisterEvent(self, event, method, ...)
end

function NemesisChat:IsEventRegistered(event)
    return self.registeredEvents[event] ~= nil
end

function NemesisChat:RegisterStaticEvents()
    for _, event in ipairs(core.staticEvents) do
        if not self:IsEventRegistered(event) then
            self:RegisterEvent(event)
        end
    end
end

function NemesisChat:UnregisterStaticEvents()
    for _, event in ipairs(core.staticEvents) do
        if self:IsEventRegistered(event) then
            self:UnregisterEvent(event)
        end
    end
end

function NemesisChat:InitializeCore()
    if NCRuntime:IsInitialized() then return end

    NemesisChatAPI:SetAPIConfigOptions()

    self:InstantiateCore()
    self:SetEnabledState(IsNCEnabled())
    self:InitializeConfig()
    self:InitializeHelpers()
    self:SetMyName()
    self:RegisterStaticEvents()

    NCRuntime:UpdateInitializationTime()
    NCRuntime:SetInitialized(true)

    self:InitIfEnabled()
end
