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
	local cmd, args = self:GetArgs(msg, 2)

	if not msg or msg:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(core.optionsFrame)
	elseif cmd == "showinfo" then
		NCConfig:SetShowInfoFrame(true)
		NCInfo.StatsFrame:Show()
	elseif cmd == "hideinfo" then
		NCConfig:SetShowInfoFrame(false)
		NCInfo.StatsFrame:Hide()
	else
        if core.db.profile.default.dbg then
            self:Print("Invalid command issued.")
        end
	end
end