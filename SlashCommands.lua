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
	elseif msg:trim():match("stats") then
		local _, _, cmd, arg = string.find(msg, "%s?(%w+)%s?(.*)")
		if arg ~= nil then
			arg = tonumber(arg)
			if arg ~= nil then
				if NCDungeon.Rankings.All[arg] ~= nil then
					local order = GetKeysSortedByValue(NCDungeon.Rankings.All[arg], function(a, b) return a > b end)

					NemesisChat:Print("Ranking for " .. arg)

					for i = 1, #order do
						NemesisChat:Print(order[i] .. ": " .. NCDungeon.Rankings.All[arg][order[i]])
					end
				else
					NemesisChat:Print("Invalid argument.")
				end
			else
				NemesisChat:Print("Invalid argument.")
			end
		else
			NemesisChat:Print("Invalid argument.")
		end
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end