-----------------------------------------------------
-- SLASH COMMANDS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local debugFrame

local function CreateDebugWindow()
    if debugFrame then
        debugFrame:Show()
        return
    end

    debugFrame = CreateFrame("Frame", "NemesisChatDebugWindow", UIParent, "BasicFrameTemplateWithInset")
    debugFrame:SetSize(400, 400)
    debugFrame:SetPoint("CENTER")
    debugFrame:SetMovable(true)
    debugFrame:EnableMouse(true)
    debugFrame:RegisterForDrag("LeftButton")
    debugFrame:SetScript("OnDragStart", debugFrame.StartMoving)
    debugFrame:SetScript("OnDragStop", debugFrame.StopMovingOrSizing)

    -- Session Errors Section
    local errorLabel = debugFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    errorLabel:SetPoint("TOPLEFT", 12, -30)
    errorLabel:SetText("Session Errors")

    local errorScrollFrame = CreateFrame("ScrollFrame", nil, debugFrame, "UIPanelScrollFrameTemplate")
    errorScrollFrame:SetPoint("TOPLEFT", 12, -50)
    errorScrollFrame:SetPoint("BOTTOMRIGHT", debugFrame, "BOTTOMRIGHT", -30, 140)

    local errorContent = CreateFrame("Frame", nil, errorScrollFrame)
    errorContent:SetSize(330, 240)
    errorScrollFrame:SetScrollChild(errorContent)

	debugFrame.errorContent = errorContent

    local errorText = errorContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    errorText:SetPoint("TOPLEFT")
    errorText:SetJustifyH("LEFT")

    -- Debug Info Section
    local debugLabel = debugFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    debugLabel:SetPoint("TOPLEFT", 12, -270)
    debugLabel:SetText("Debugging Info")

    local debugScrollFrame = CreateFrame("ScrollFrame", nil, debugFrame, "UIPanelScrollFrameTemplate")
    debugScrollFrame:SetPoint("TOPLEFT", 12, -290)
    debugScrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

    local debugContent = CreateFrame("Frame", nil, debugScrollFrame)
    debugContent:SetSize(330, 100)
    debugScrollFrame:SetScrollChild(debugContent)

    local debugText = debugContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    debugText:SetPoint("TOPLEFT")
    debugText:SetJustifyH("LEFT")

    debugFrame.errorText = errorText
    debugFrame.debugText = debugText
end

local function CreateErrorRow(parent, error, data)
    local row = CreateFrame("Button", nil, parent)
    row:SetSize(330, 20)
    row:SetNormalFontObject("GameFontNormal")
    
    local truncatedError = error:sub(1, 50) .. (error:len() > 50 and "..." or "")
    row:SetText(string.format("%s (%d times)", truncatedError, data.count))
    
    local stackTrace = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    stackTrace:SetPoint("TOPLEFT", row, "BOTTOMLEFT", 10, -5)
    stackTrace:SetPoint("TOPRIGHT", row, "BOTTOMRIGHT", -10, -5)
    stackTrace:SetJustifyH("LEFT")
    stackTrace:SetText(data.stackTrace)
    stackTrace:Hide()
    
    row:SetScript("OnClick", function()
        stackTrace:SetShown(not stackTrace:IsShown())
    end)
    
    return row, stackTrace
end

local function UpdateDebugWindow()
    if not debugFrame or not debugFrame.errorContent then return end

    -- Clear previous content
    debugFrame.errorContent:SetHeight(1)
    for _, child in pairs({debugFrame.errorContent:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end

    -- Update Session Errors
    local yOffset = 0
    if NemesisChat.SessionErrors then
        for err, data in pairs(NemesisChat.SessionErrors) do
            local row, stackTrace = CreateErrorRow(debugFrame.errorContent, err, data)
            row:SetPoint("TOPLEFT", debugFrame.errorContent, "TOPLEFT", 0, -yOffset)
            row:SetPoint("TOPRIGHT", debugFrame.errorContent, "TOPRIGHT", 0, -yOffset)
            yOffset = yOffset + row:GetHeight() + (stackTrace:IsShown() and stackTrace:GetHeight() or 0) + 5
        end
    else
        local noErrors = debugFrame.errorContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noErrors:SetPoint("TOPLEFT")
        noErrors:SetText("No session errors \\o/")
        yOffset = noErrors:GetHeight()
    end

    debugFrame.errorContent:SetHeight(yOffset)

    -- Update Debug Info
    local debugInfo = "Leavers:\n"
    for guid, timestampTable in pairs(core.db.profile.leavers) do
        debugInfo = debugInfo .. guid .. ": " .. #timestampTable .. "\n"
    end
    debugInfo = debugInfo .. "\nLow Performers:\n"
    for guid, timestampTable in pairs(core.db.profile.lowPerformers) do
        debugInfo = debugInfo .. guid .. ": " .. #timestampTable .. "\n"
    end

    -- Add other debug info as before...

    debugFrame.debugText:SetText(debugInfo)
end

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
		CreateDebugWindow()
    	UpdateDebugWindow()
	elseif cmd == "fixnemeses" then
		for name, nemesis in pairs(NCConfig:GetNemeses()) do
			NemesisChat:Print("Fixing nemesis " .. name)
			core.db.profile.nemeses[name] = name
		end
	elseif cmd == "testerror" then
		local function generateError()
			pcall(function()
				error("This is a test error thrown by NemesisChat")
			end)
		end
		generateError()
	else
        if core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
	end
end