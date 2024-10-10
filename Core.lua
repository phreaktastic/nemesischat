-----------------------------------------------------
-- CORE FUNCTIONALITY
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

function NemesisChat:OnInitialize()
    core.db = LibStub("AceDB-3.0"):New("NemesisChatDB", core.defaults, true)
    NemesisChatAPI:SetAPIConfigOptions()
    NemesisChat:Initialize()

    NemesisChat:RegisterChatCommand("nc", "SlashCommand")
    NemesisChat:RegisterChatCommand("nemesischat", "SlashCommand")

    NCMigration:Run()
end

function NemesisChat:OnEnable()
    self:InitIfEnabled()

    self:RegisterEvent("GROUP_ROSTER_UPDATE")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_LEAVING_WORLD")
    self:RegisterEvent("CHAT_MSG_ADDON")
    self:RegisterEvent("ACTIVE_DELVE_DATA_UPDATE")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
    self:RegisterEvent("SCENARIO_COMPLETED")

    self:SetMyName()
    self:PopulateFriends()
    self:InstantiateCore()
    self:SilentGroupSync()
    self:CheckGroup()

    NCInfo:OnEnableStateChanged(true)

    if (NCRuntime:TimeSinceInitialization() < 1) then
        return
    end

    self:PLAYER_ENTERING_WORLD()
end

function NemesisChat:OnDisable()
    self:UnregisterAllEvents()
    NCInfo:OnEnableStateChanged(false)
end

local origErrorHandler = geterrorhandler()

seterrorhandler(function(err)
    if not IsNCEnabled() then return origErrorHandler(err) end

    -- Initialize the SessionErrors table if it doesn't exist
    NemesisChat.SessionErrors = NemesisChat.SessionErrors or {}

    local stackTrace = debugstack(2)

    -- Update or add the error entry
    if NemesisChat.SessionErrors[err] then
        NemesisChat.SessionErrors[err].count = NemesisChat.SessionErrors[err].count + 1
    else
        NemesisChat.SessionErrors[err] = {count = 1, stackTrace = stackTrace}
    end

    -- Ensure only the last 3 errors are stored
    local errorKeys = {}
    for key in pairs(NemesisChat.SessionErrors) do
        table.insert(errorKeys, key)
    end
    table.sort(errorKeys, function(a, b)
        return NemesisChat.SessionErrors[a].count > NemesisChat.SessionErrors[b].count
    end)
    while #errorKeys > 3 do
        NemesisChat.SessionErrors[errorKeys[#errorKeys]] = nil
        table.remove(errorKeys)
    end

    NemesisChat:Print("An error has occurred within Nemesis Chat. Please use /nc debug to see the errors and relevant information.")
end)
