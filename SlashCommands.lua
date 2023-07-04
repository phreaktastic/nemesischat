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
	elseif msg:trim() == "ad" then
		for player, data in pairs(core.runtime.groupRoster) do
			self:Print(player, NCCombat:GetAvoidableDamage(player))
		end

		self:Print(core.runtime.myName, NCCombat:GetAvoidableDamage(core.runtime.myName))
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end