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
		Settings.OpenToCategory("NemesisChat")
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
	elseif cmd == "debug" then
		-- Open a new window that shows entries and their #count, for both leavers and low performers (core.db.profile.leavers and core.db.profile.lowPerformers)
		local function CreateDebugWindow()
			local frame = CreateFrame("Frame", "NemesisChatDebugWindow", UIParent, "BasicFrameTemplateWithInset")
			frame:SetSize(400, 300)
			frame:SetPoint("CENTER")
			frame:SetMovable(true)
			frame:EnableMouse(true)
			frame:RegisterForDrag("LeftButton")
			frame:SetScript("OnDragStart", frame.StartMoving)
			frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

			local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
			scrollFrame:SetPoint("TOPLEFT", 12, -30)
			scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

			local content = CreateFrame("Frame", nil, scrollFrame)
			content:SetSize(330, 240)
			scrollFrame:SetScrollChild(content)

			local text = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			text:SetPoint("TOPLEFT")
			text:SetJustifyH("LEFT")

			local debugInfo = "Leavers:\n"
			for guid, timestampTable in pairs(core.db.profile.leavers) do
				debugInfo = debugInfo .. guid .. ": " .. #timestampTable .. "\n"
			end
			debugInfo = debugInfo .. "\nLow Performers:\n"
			for guid, timestampTable in pairs(core.db.profile.lowPerformers) do
				debugInfo = debugInfo .. guid .. ": " .. #timestampTable .. "\n"
			end

			debugInfo = debugInfo .. "\nPet Owners:\n"
			local ownerCount = 0
			for guid, timestampTable in pairs(NCRuntime:GetPetOwners()) do
				ownerCount = ownerCount + 1
			end
			debugInfo = debugInfo .. ownerCount .. "\n"

			debugInfo = debugInfo .. "\nSegments:\n" .. #NCSegment.Segments .. "\n"
			debugInfo = debugInfo .. "\nLast Syncs:\n" .. #core.db.global.lastSync .. "\n"
			debugInfo = debugInfo .. "\nGroup Roster Size:\n" .. NCRuntime:GetGroupRosterCount() .. "\n"
			debugInfo = debugInfo .. "\nRoster Snapshot Size:\n" .. #NemesisChat:GetKeys(NCDungeon.RosterSnapshot) .. "\n"
			debugInfo = debugInfo .. "\nNemeses Count:\n" .. #core.db.profile.nemeses .. "\n"

			text:SetText(debugInfo)
			frame:Show()
		end

		CreateDebugWindow()
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end