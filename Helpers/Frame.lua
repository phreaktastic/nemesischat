local _, core = ...;

function NemesisChat:RegisterConfig(frame, configKey)
    if not core.db.profile[configKey] then
        core.db.profile[configKey] = {}
    end
    frame.configKey = configKey
end

function NemesisChat:SavePosition(frame)
    if frame.configKey then
        local config = core.db.profile[frame.configKey]
        config.point, config.relativeTo, config.relativePoint, config.xOfs, config.yOfs = frame:GetPoint()
        config.width = frame:GetWidth()
        config.height = frame:GetHeight()
    end
end

function NemesisChat:RestorePosition(frame)
    if frame.configKey then
        local config = core.db.profile[frame.configKey]
        if config.point then
            frame:ClearAllPoints()
            frame:SetPoint(config.point, config.relativeTo, config.relativePoint, config.xOfs, config.yOfs)
            frame:SetSize(config.width or 200, config.height or 300)
        end
    end
end
