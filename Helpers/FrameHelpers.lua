-----------------------------------------------------
-- FRAME HELPERS
-- Handles frame configuration, positioning, and state management
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Frame Configuration Management
-----------------------------------------------------
function NemesisChat:RegisterConfig(frame, configKey)
    -- Ensure configuration exists for this frame
    if not NCConfig:Get(configKey) then
        NCConfig:Set(configKey, {})
    end

    -- Associate the config key with the frame
    frame.configKey = configKey
end

-----------------------------------------------------
-- Frame Position Management
-----------------------------------------------------
function NemesisChat:SavePosition(frame)
    if not frame.configKey then return end

    local config = NCConfig:Get(frame.configKey)

    -- Store frame position attributes
    config.point, config.relativeTo, config.relativePoint, config.xOfs, config.yOfs = frame:GetPoint()

    -- Store frame dimensions
    config.width = frame:GetWidth()
    config.height = frame:GetHeight()
end

function NemesisChat:RestorePosition(frame)
    if not frame.configKey then return end

    local config = NCConfig:Get(frame.configKey)

    -- Only restore if we have a valid point saved
    if config.point then
        frame:ClearAllPoints()
        frame:SetPoint(config.point, config.relativeTo, config.relativePoint, config.xOfs, config.yOfs)
        frame:SetSize(config.width or 200, config.height or 300) -- Default size if none saved
    end
end

-----------------------------------------------------
-- Frame Utility Functions
-----------------------------------------------------
function NemesisChat:GetFrameDefaultSize()
    return {
        width = 200,
        height = 300
    }
end

function NemesisChat:ResetFramePosition(frame)
    if not frame.configKey then return end

    local defaults = self:GetFrameDefaultSize()
    local config = NCConfig:Get(frame.configKey)

    -- Reset to center of screen
    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetSize(defaults.width, defaults.height)

    -- Save the new default position
    self:SavePosition(frame)
end
