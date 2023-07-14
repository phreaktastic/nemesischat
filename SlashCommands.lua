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
	elseif msg:trim() == "msg" then
		for key, data in pairs(core.db.profile.messages["GROUP"]["JOIN"]["BYSTANDER"]) do
			self:Print(data.message)
		end
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end