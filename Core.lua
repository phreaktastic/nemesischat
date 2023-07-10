-----------------------------------------------------
-- CORE FUNCTIONALITY
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

core.runtime = DeepCopy(core.runtimeDefaults)

function NemesisChat:OnInitialize()
    core.db = LibStub("AceDB-3.0"):New("NemesisChatDB", core.defaults, true)
    NemesisChat:InitializeConfig()
    NemesisChat:InitializeHelpers()

    NemesisChat:RegisterChatCommand("nc", "SlashCommand")
    NemesisChat:RegisterChatCommand("nemesischat", "SlashCommand")
end

function NemesisChat:OnEnable()
    NemesisChat:RegisterEvent("GROUP_ROSTER_UPDATE")
    NemesisChat:RegisterEvent("PLAYER_ENTERING_WORLD")

    NemesisChat:SetMyName()
    NemesisChat:CheckAPICompatibility()
end

function NemesisChat:OnDisable()
    NemesisChat:UnregisterEvent("GROUP_ROSTER_UPDATE")
    NemesisChat:UnregisterEvent("PLAYER_ENTERING_WORLD")
    NemesisChat:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    NemesisChat:UnregisterEvent("CHALLENGE_MODE_START")
    NemesisChat:UnregisterEvent("CHALLENGE_MODE_COMPLETED")
    NemesisChat:UnregisterEvent("ENCOUNTER_START")
    NemesisChat:UnregisterEvent("ENCOUNTER_END")
    NemesisChat:UnregisterEvent("PLAYER_REGEN_DISABLED")
    NemesisChat:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

