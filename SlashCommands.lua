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
		for k, v in pairs(core.db.profile.messages["COMBATLOG"]["COMBAT_END"]["NA"]) do
			NemesisChat:Print(v.message, v.channel, v.target)
		end
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end