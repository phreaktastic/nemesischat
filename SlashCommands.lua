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
		NCInfo.StatsFrame:Show()
	elseif cmd == "hideinfo" then
		NCInfo.StatsFrame:Hide()
	elseif cmd == "stats" then
		local playerName = args
		if playerName and NCRuntime:GetGroupRosterPlayer(playerName) then
			self:Print("NemesisChat: " .. playerName .. "'s stats:")
			for metric, _ in pairs(NCRankings.METRICS) do
				local stats = NCDungeon:GetStats(playerName, metric)
				
				self:Print(metric .. ": " .. stats)
			end
		else
			self:Print("Please specify a valid player name.")
		end
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end