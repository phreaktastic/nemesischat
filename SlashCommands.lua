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
	elseif msg:trim() == "showinfo" then
		NCInfo.StatsFrame:Show()
	elseif msg:trim() == "hideinfo" then
		NCInfo.StatsFrame:Hide()
	elseif msg:trim() == "debugscores" then
		NemesisChat:Print("TOP")
		NemesisChat:Print_r(NCDungeon.Rankings.TopTracker)
		NemesisChat:Print("BOTTOM")
		NemesisChat:Print_r(NCDungeon.Rankings.BottomTracker)
	elseif msg:trim() == "debugroster" then
		NemesisChat:Print("ROSTER")
		NemesisChat:Print_r(NCRuntime:GetGroupRoster())
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end