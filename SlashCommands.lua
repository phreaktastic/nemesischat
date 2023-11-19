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
	elseif msg:trim() == "info" then
		NCInfo.StatsFrame:Show()
	elseif msg:trim() == "update" then
		NCInfo:Update()
	elseif msg:trim() == "testpulltoast" then
		NCRuntime:SetLastUnsafePull("TEST PERSON", "TEST MOB")
		NemesisChat:SpawnToast("Pull", "TEST PERSON", "TEST MOB")
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end