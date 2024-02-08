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
	elseif cmd == "dbinfo" then
		NemesisChat:Print("Leavers:", #core.db.profile.leavers, "Low performers:", #core.db.profile.lowPerformers)
	elseif cmd == "wipe" then
		local name = UnitName(args)
		local guid = UnitGUID(name)

		if not guid then
			self:Print("Invalid unit.")
			return
		end

		core.db.profile.lowPerformers[guid] = nil
		core.db.profile.leavers[guid] = nil

		self:Print("Wiped data for " .. name .. " (" .. guid .. ")")
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end