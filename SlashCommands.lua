-----------------------------------------------------
-- SLASH COMMANDS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...

-- Declare these as local if they're defined elsewhere in the addon
local NCConfig = NCConfig
local NCInfo = NCInfo
local Settings = Settings

local debugFrame

-----------------------------------------------------
-- Debug Window Functions
-----------------------------------------------------

local function GetAddonMemoryUsage()
    UpdateAddOnMemoryUsage()
    return GetAddOnMemoryUsage("NemesisChat") -- Replace with your addon's actual name
end

local function CreateDebugWindow()
    if debugFrame then
        debugFrame:Show()
        return debugFrame
    end

    debugFrame = CreateFrame("Frame", "NemesisChatDebugWindow", UIParent, "BasicFrameTemplateWithInset")
    debugFrame:SetSize(400, 400)
    debugFrame:SetPoint("CENTER")
    debugFrame:SetMovable(true)
    debugFrame:EnableMouse(true)
    debugFrame:RegisterForDrag("LeftButton")
    debugFrame:SetScript("OnDragStart", debugFrame.StartMoving)
    debugFrame:SetScript("OnDragStop", debugFrame.StopMovingOrSizing)
    debugFrame.TitleText:SetText("NemesisChat Debugger")
    debugFrame.TitleText:SetPoint("TOP", debugFrame, "TOP", 0, -5)

    -- Session Errors Section
    local errorLabel = debugFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    errorLabel:SetPoint("TOPLEFT", 12, -30)
    errorLabel:SetText("Session Errors")

    local errorScrollFrame = CreateFrame("ScrollFrame", nil, debugFrame, "UIPanelScrollFrameTemplate")
    errorScrollFrame:SetPoint("TOPLEFT", debugFrame, "TOPLEFT", 12, -50)
    errorScrollFrame:SetPoint("BOTTOMRIGHT", debugFrame, "BOTTOMRIGHT", -30, 140)

    local errorContent = CreateFrame("Frame", nil, errorScrollFrame)
    errorContent:SetWidth(errorScrollFrame:GetWidth())
    errorContent:SetHeight(1) -- Will be resized dynamically
    errorScrollFrame:SetScrollChild(errorContent)

    debugFrame.errorContent = errorContent
    debugFrame.errorScrollFrame = errorScrollFrame

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

    return debugFrame
end

local debugFramePool = setmetatable({}, { __mode = "v" })

local function GetOrCreateRow(errorContent)
    local frame = next(debugFramePool)
    if not frame then
        frame = CreateFrame("Button", nil, errorContent)
        frame:SetHeight(25)
        frame:SetNormalFontObject("GameFontNormal")

        local errorText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        errorText:SetPoint("LEFT", 5, 0)
        errorText:SetPoint("RIGHT", -25, 0)
        errorText:SetJustifyH("LEFT")
        frame.errorText = errorText

        local expandButton = CreateFrame("Button", nil, frame)
        expandButton:SetSize(16, 16)
        expandButton:SetPoint("RIGHT", -5, 0)
        expandButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
        frame.expandButton = expandButton

        local stackTraceFrame = CreateFrame("Frame", nil, frame)
        stackTraceFrame:SetHeight(100)
        stackTraceFrame:Hide()

        local stackTraceScroll = CreateFrame("ScrollFrame", nil, stackTraceFrame, "UIPanelScrollFrameTemplate")
        stackTraceScroll:SetPoint("TOPLEFT", 5, -5)
        stackTraceScroll:SetPoint("BOTTOMRIGHT", -25, 30)

        local stackTraceEdit = CreateFrame("EditBox", nil, stackTraceScroll)
        stackTraceEdit:SetMultiLine(true)
        stackTraceEdit:SetFontObject(GameFontHighlight)
        stackTraceEdit:SetAutoFocus(false)
        stackTraceEdit:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
        stackTraceScroll:SetScrollChild(stackTraceEdit)

        local selectAllButton = CreateFrame("Button", nil, stackTraceFrame, "UIPanelButtonTemplate")
        selectAllButton:SetSize(80, 22)
        selectAllButton:SetPoint("BOTTOMRIGHT", -5, 5)
        selectAllButton:SetText("Select All")
        selectAllButton:SetScript("OnClick", function()
            stackTraceEdit:SetFocus()
            stackTraceEdit:HighlightText()
        end)

        frame.stackTraceFrame = stackTraceFrame
        frame.stackTraceEdit = stackTraceEdit
    else
        frame:Show()
        debugFramePool[frame] = nil
    end

    frame:SetWidth(errorContent:GetWidth())
    frame.stackTraceFrame:SetWidth(frame:GetWidth())
    frame.stackTraceEdit:SetWidth(frame:GetWidth() - 30)

    frame.expandButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
    frame.stackTraceFrame:Hide()

    return frame
end

local function UpdateLayout(errorContent)
    local currentYOffset = 0
    for _, child in ipairs({ errorContent:GetChildren() }) do
        if child:IsShown() then
            child:SetPoint("TOPLEFT", errorContent, "TOPLEFT", 0, -currentYOffset)
            child:SetPoint("TOPRIGHT", errorContent, "TOPRIGHT", 0, -currentYOffset)
            child:SetWidth(errorContent:GetWidth())
            currentYOffset = currentYOffset + child:GetHeight() + 2

            local stackTrace = child.stackTraceFrame
            if stackTrace and stackTrace:IsShown() then
                stackTrace:SetPoint("TOPLEFT", child, "BOTTOMLEFT", 0, 0)
                stackTrace:SetPoint("TOPRIGHT", child, "BOTTOMRIGHT", 0, 0)
                stackTrace:SetWidth(child:GetWidth())
                child.stackTraceEdit:SetWidth(child:GetWidth() - 30)
                currentYOffset = currentYOffset + stackTrace:GetHeight() + 2
            end
        end
    end
    errorContent:SetHeight(math.max(1, currentYOffset))
end

local function UpdateDebugWindow()
    if not debugFrame or not debugFrame.errorContent then return end

    local errorContent = debugFrame.errorContent
    local scrollFrame = debugFrame.errorScrollFrame
    errorContent:SetWidth(scrollFrame:GetWidth())

    -- Hide all existing frames
    for _, frame in pairs({ errorContent:GetChildren() }) do
        frame:Hide()
        debugFramePool[frame] = true
    end

    local hasErrors = false
    local yOffset = 0

    if NemesisChat.SessionErrors then
        local sortedErrors = {}
        for err, data in pairs(NemesisChat.SessionErrors) do
            table.insert(sortedErrors, { error = err, data = data })
        end
        table.sort(sortedErrors, function(a, b) return a.data.count > b.data.count end)

        for err, errorData in pairs(sortedErrors) do
            local err = errorData.error
            local data = errorData.data
            hasErrors = true
            local row = GetOrCreateRow(errorContent)
            local truncatedError = err:sub(1, 50) .. (err:len() > 50 and "..." or "")
            row.errorText:SetText(string.format("%s (%d times)", truncatedError, data.count))

            row:SetPoint("TOPLEFT", errorContent, "TOPLEFT", 0, -yOffset)
            row:SetPoint("TOPRIGHT", errorContent, "TOPRIGHT", 0, -yOffset)
            row:SetWidth(errorContent:GetWidth())

            yOffset = yOffset + row:GetHeight() + 2

            row.expandButton:SetScript("OnClick", function()
                row.stackTraceFrame:SetShown(not row.stackTraceFrame:IsShown())

                if row.stackTraceFrame:IsShown() then
                    row.expandButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
                    local fullErrorInfo = err .. "\n\n" .. data.stackTrace
                    row.stackTraceEdit:SetText(fullErrorInfo)
                    row.stackTraceFrame:SetPoint("TOPLEFT", row, "BOTTOMLEFT", 0, 0)
                    row.stackTraceFrame:SetPoint("TOPRIGHT", row, "BOTTOMRIGHT", 0, 0)
                    row.stackTraceFrame:SetWidth(row:GetWidth())
                    row.stackTraceEdit:SetWidth(row:GetWidth() - 30)
                else
                    row.expandButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
                end

                UpdateLayout(errorContent)
            end)

            row:Show()
            debugFramePool[row] = nil
        end
    end

    if not hasErrors then
        local noErrors = GetOrCreateRow(errorContent)
        noErrors.errorText:SetText("No session errors \\o/")
        noErrors.expandButton:Hide()
        noErrors:Show()
        noErrors:SetPoint("TOPLEFT", errorContent, "TOPLEFT", 0, 0)
        noErrors:SetPoint("TOPRIGHT", errorContent, "TOPRIGHT", 0, 0)
        noErrors:SetWidth(errorContent:GetWidth())
        debugFramePool[noErrors] = nil
    end

    local memoryUsage = GetAddonMemoryUsage()
    local formattedMemory = string.format("%.2f MB", (memoryUsage / 1024))
    debugFrame.debugText:SetText("Memory Usage: " .. formattedMemory)

    UpdateLayout(errorContent)
end

local function checkFlags(flags, flagList)
    for _, flag in ipairs(flagList) do
        if bit.band(flags, flag) == 0 then
            return false
        end
    end
    return true
end

-----------------------------------------------------
-- Slash commands for in-game ease of use
-----------------------------------------------------

function NemesisChat:SlashCommand(msg)
    local cmd, args = self:GetArgs(msg, 2)

    if not msg or msg:trim() == "" then
        if Settings then
            Settings.OpenToCategory("NemesisChat")
        else
            self:Print("Settings panel not found. Please check your addon configuration.")
        end
    elseif cmd == "showinfo" then
        NCConfig:SetShowInfoFrame(true)
        NCInfo.StatsFrame:Show()
    elseif cmd == "hideinfo" then
        NCConfig:SetShowInfoFrame(false)
        NCInfo.StatsFrame:Hide()
    elseif cmd == "debug" then
        local frame = CreateDebugWindow()
        UpdateDebugWindow()
        frame:Show()

        frame:SetScript("OnUpdate", function(self, elapsed)
            self.timer = (self.timer or 0) + elapsed
            if self.timer >= 1 then -- Update every second
                self.timer = 0
                UpdateDebugWindow()
            end
        end)
    elseif cmd == "fixnemeses" then
        local nemeses = NCConfig:GetNemeses()
        if nemeses then
            for name, nemesis in pairs(nemeses) do
                self:Print(string.format("Fixing nemesis %s", name))
                if core.db and core.db.profile and core.db.profile.nemeses then
                    core.db.profile.nemeses[name] = name
                else
                    self:Print("Database or nemeses table not initialized.")
                    break
                end
            end
        else
            self:Print("No nemeses found or NCConfig:GetNemeses() returned nil.")
        end
    elseif cmd == "testerror" then
        self:TestErrorHandler()
        if debugFrame then
            UpdateDebugWindow()
            debugFrame:Show()
        end
    elseif cmd == "defensive" then
        local spellId = tonumber(args)
        NemesisChat:Print("Checking spell ID:", spellId)
        local flags, providers, modifiers, ccCategory, source, dispelCategory = LibPlayerSpells:GetSpellInfo(spellId)
        NemesisChat:Print("Flags:", flags, "Providers:", providers, "Modifiers:", modifiers, "CC Category:", ccCategory,
            "Source:", source, "Dispel Category:", dispelCategory)
        if flags then
            NemesisChat:Print("Flags:", flags)
            NemesisChat:Print("Cooldown:", checkFlags(flags, { LibPlayerSpells.constants.COOLDOWN }))
            NemesisChat:Print("Defensive:", checkFlags(flags, { LibPlayerSpells.constants.SURVIVAL }))
            NemesisChat:Print("Both:",
                checkFlags(flags, { LibPlayerSpells.constants.COOLDOWN, LibPlayerSpells.constants.SURVIVAL }))
        else
            NemesisChat:Print("Spell ID not found.")
        end
    else
        if core.db and core.db.profile and core.db.profile.dbg then
            self:Print("Invalid command issued.")
        end
    end
end
