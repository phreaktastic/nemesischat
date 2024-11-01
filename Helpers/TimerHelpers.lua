-----------------------------------------------------
-- TIMER HELPERS
-- Handles timer initialization and scheduling
-----------------------------------------------------
local addonName, core = ...

-----------------------------------------------------
-- Timer Initialization
-----------------------------------------------------
function NemesisChat:InitializeTimers()
    self:InitializeSyncTimer()
    self:InitializeLowPriorityTimer()
    self:InitializeSystemTickers()
end

function NemesisChat:InitializeSyncTimer()
    if not self.SyncLeaversTimer then
        self.SyncLeaversTimer = self:ScheduleRepeatingTimer(
            core.AddonCommunication.TransmitSyncData, 60)
    end
end

function NemesisChat:InitializeLowPriorityTimer()
    if not self.LowPriorityTimer then
        self.LowPriorityTimer = self:ScheduleRepeatingTimer(
            self.ProcessLowPriorityTasks, 5)
    end
end

function NemesisChat:InitializeSystemTickers()
    -- Combat sync cleanup ticker
    C_Timer.NewTicker(60, function()
        if not NCCombat or not NCCombat.IsActive then return end
        if not NCCombat:IsActive() then
            NemesisChat:CleanupSyncData()
        end
    end)

    -- Guild check ticker
    C_Timer.NewTicker(0.1, function()
        if IsNCEnabled() then
            NemesisChat:CheckGuild()
        end
    end)
end

-----------------------------------------------------
-- Timer Tasks
-----------------------------------------------------
function NemesisChat:ProcessLowPriorityTasks()
    -- Update item levels for group members
    NemesisChat:AttemptSyncItemLevels()

    -- Update friend list periodically
    if GetTime() - NCRuntime:GetLastFriendCheck() >= 60 then
        NemesisChat:PopulateFriends()
    end
end

function NemesisChat:CleanupSyncData()
    local count = 0

    if not core.db.global.lastSync or not next(core.db.global.lastSync) then return end

    for key, val in pairs(core.db.global.lastSync) do
        if GetTime() - val > 1800 then
            count = count + 1
            core.db.global.lastSync[key] = nil
        end

        if count > 100 then break end
    end
end

-----------------------------------------------------
-- Timer Management
-----------------------------------------------------
function NemesisChat:CancelTimers()
    if NemesisChat.SyncLeaversTimer then
        NemesisChat:CancelTimer(NemesisChat.SyncLeaversTimer)
        NemesisChat.SyncLeaversTimer = nil
    end

    if NemesisChat.LowPriorityTimer then
        NemesisChat:CancelTimer(NemesisChat.LowPriorityTimer)
        NemesisChat.LowPriorityTimer = nil
    end
end

function NemesisChat:ResetTimers()
    NemesisChat:CancelTimers()
    NemesisChat:InitializeTimers()
end

-----------------------------------------------------
-- Time Utilities
-----------------------------------------------------
function NemesisChat:GetFormattedTime(timestamp)
    if not timestamp then return "00:00" end

    local minutes = math.floor(timestamp / 60)
    local seconds = timestamp % 60
    return string.format("%02d:%02d", minutes, seconds)
end

function NemesisChat:GetTimeUntilReset()
    local now = GetTime()
    local resetTime = NCRuntime:GetNextResetTime()
    return resetTime - now
end
