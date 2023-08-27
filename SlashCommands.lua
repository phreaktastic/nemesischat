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
	elseif msg:trim() == "stats" then
		--NemesisChat:ShowStatsFrame()
	elseif msg:trim() == "test" then
		
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end