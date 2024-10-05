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
    NemesisChat:RegisterEvent("PLAYER_LEAVING_WORLD")
    NemesisChat:RegisterEvent("CHAT_MSG_ADDON")
    NemesisChat:RegisterEvent("ACTIVE_DELVE_DATA_UPDATE")
    NemesisChat:RegisterEvent("ZONE_CHANGED_NEW_AREA")

    NemesisChat:SetMyName()
    NemesisChat:PopulateFriends()
end

function NemesisChat:OnDisable()
    NemesisChat:UnregisterAllEvents()
end

local origErrorHandler = geterrorhandler()

seterrorhandler(function(err)
    if string.find(err, "attempt to index .* %(a nil value%)") then
        NemesisChat:Print("Nil Index Error: " .. err)
        -- Considering more debugging here
    end
    return origErrorHandler(err)
end)

