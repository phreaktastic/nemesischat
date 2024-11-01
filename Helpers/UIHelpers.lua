-----------------------------------------------------
-- UI HELPERS
-- Handles UI interactions, chat output, and messaging
-----------------------------------------------------
local addonName, core = ...

-----------------------------------------------------
-- Chat Output
-----------------------------------------------------
function NemesisChat:Print(...)
    local c = ChatTypeInfo.SYSTEM
    local message = self:BuildPrintMessage(...)

    -- Add message to all relevant chat frames
    for i = 1, NUM_CHAT_WINDOWS do
        _G['ChatFrame' .. i]:AddMessage(message, 1, 1, 1, c.id)
    end
end

function NemesisChat:BuildPrintMessage(...)
    local message = ""

    -- Combine all message parts
    for _, msg in pairs({ ... }) do
        local strMsg = tostring(msg)
        if message == "" then
            message = strMsg
        else
            message = message .. " " .. strMsg
        end
    end

    -- Add prefix and emphasis
    return NCColors.Emphasize("NemesisChat: ") .. message
end

function NemesisChat:Print_r(...)
    local arg = {...}

    for _,item in pairs(arg) do
        if type(item) == "table" then
            for key,val in pairs(item) do
                if type(key) == "table" then
                    self:Print("#### Table ####")
                    self:Print_r(key)
                    self:Print("#### End Table ####")
                else
                    if type(val) == "boolean" then
                        self:Print("    - " .. key .. "(" .. type(val) .. "):", tostring(val))
                    elseif type(val) == "function" then
                        self:Print("    - " .. key .. "(function)")
                    elseif type(val) ~= "table" then
                        self:Print("    - " .. key .. "(" .. type(val) .. "):", val)
                    else
                        self:Print("#### Table ####")
                        self:Print(key .. ":")
                        self:Print_r(val)
                        self:Print("#### End Table ####")
                    end
                end
            end
        elseif type (item) == "function" then
            self:Print("Function")
        elseif type(item) == "boolean" then
            self:Print(tostring(item))
        else
            self:Print(item)
        end
    end
end

-----------------------------------------------------
-- Channel Management
-----------------------------------------------------
function NemesisChat:GetActualChannel(inputChannel)
    if inputChannel ~= "GROUP" then
        return inputChannel
    end

    -- Determine appropriate channel based on group type
    if IsInRaid() then
        return "RAID"
    elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        return "INSTANCE_CHAT"
    else
        return "PARTY"
    end
end

-----------------------------------------------------
-- Debug Output
-----------------------------------------------------
function NemesisChat:PrintNumberOfLeavers()
    NemesisChat:Print("Leavers:", NCConfig:GetLeaversCount())
end

function NemesisChat:PrintNumberOfLowPerformers()
    NemesisChat:Print("Low Performers:", NCConfig:GetLowPerformersCount())
end

function NemesisChat:PrintSyncKeys()
    -- Print leaver information
    NemesisChat:Print("LEAVER KEYS")
    local leavers = NCConfig:GetLeavers()
    NemesisChat:Print_r(NemesisChat:GetKeys(leavers))

    for key, val in pairs(leavers) do
        NemesisChat:Print(key, ":", #val)
    end

    -- Print low performer information
    NemesisChat:Print("LOW PERFORMER KEYS")
    local lowPerformers = NCConfig:GetLowPerformers()
    NemesisChat:Print_r(NemesisChat:GetKeys(lowPerformers))

    for key, val in pairs(lowPerformers) do
        NemesisChat:Print(key, ":", #val)
    end
end
