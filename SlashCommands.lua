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
	elseif msg:trim() == "ilvl" then
		NemesisChat:Print(NemesisChat:GetItemLevel("player"))
	elseif msg:trim() == "debugaffix" then
		NemesisChat:Print("AFFIXES")
		if not NCCombat:IsActive() then
			NCCombat:Start("Debug")
		end
		NCSegment:GlobalAddAffix(GetMyName())
		NemesisChat:Print_r(NCCombat:GetAffixes())
	elseif msg:trim() == "debugclass" then
		local playerClass, englishClass = UnitClass("player")
		ChatFrame1:AddMessage('Your player is a : ' .. playerClass .. '; ' .. englishClass .. '.')
	elseif msg:trim() == "debugcalc" then
		local test1, test2 = NCCombat.Rankings.Configuration.Increments.Metrics["DPS"].AdditiveCallback(NCCombat.Rankings, "Glaivetastic", "None", 837462, 12843)

		NemesisChat:Print("TEST1: " .. test1, "TEST2: " .. test2)
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end