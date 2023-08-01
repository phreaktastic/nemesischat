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
	elseif msg:trim() == "test" then
		for character, _ in pairs(core.runtime.friends) do
			self:Print(character .. " is a friend.")
		end
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end