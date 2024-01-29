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
    NemesisChat:RegisterEvent("GROUP_ROSTER_UPDATE")
    NemesisChat:RegisterEvent("PLAYER_ENTERING_WORLD")
    NemesisChat:RegisterEvent("CHAT_MSG_ADDON")

    NemesisChat:SetMyName()
    NemesisChat:PopulateFriends()
end

function NemesisChat:OnDisable()
    NemesisChat:UnregisterAllEvents()
end

