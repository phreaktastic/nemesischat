-----------------------------------------------------
-- SLASH COMMANDS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Slash commands for in-game ease of use
-----------------------------------------------------

function NemesisChat:SlashCommand(msg)
	if not msg or msg:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(core.optionsFrame)
    elseif msg == "nemeses" then
        self:Print("Total nemeses defined:", NemesisChat:GetNemesesLength())
    elseif msg == "nemeses list" then 
        self:Print("Nemeses list:")
        for key,val in pairs(NemesisChat:GetNemeses()) do
            self:Print(key, val)
        end
    elseif msg == "phrases" then
        self:Print("Total phrases defined:", NemesisChat:GetMessagesLength())
    elseif msg == "phrases interrupt" then
        self:Print("Total interrupt phrases defined:", NemesisChat:GetLength(NemesisChat:GetAllInterruptPhrases()))
    elseif msg == "party" then
        NemesisChat:CheckGroup()
    elseif msg == "partynemeses" then
        local nemeses = NemesisChat:GetPartyNemeses()

        if nemeses == nil then
            self:Print("NONE")
            return
        end

        for key,val in pairs(nemeses) do
            self:Print(key)
        end
    elseif msg == "status" then
        self:Print("NC Status", NCStatus)
        core.runtime.event.category = "BOSS"
        core.runtime.event.event = "GREATERDPS"
        core.runtime.event.target = "SELF"
        self:Print(NemesisChat:GetRandomAiPhrase())
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end