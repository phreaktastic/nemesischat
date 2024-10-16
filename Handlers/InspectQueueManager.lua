local InspectQueueManager = {}
InspectQueueManager.queue = {}
InspectQueueManager.currentInspection = nil
InspectQueueManager.timeout = 1 -- seconds to wait before considering a request stale
InspectQueueManager.lastInspectTime = 0

NemesisChat.InspectQueueManager = InspectQueueManager

local NotifyInspect = NotifyInspect
local table_insert = table.insert
local table_remove = table.remove
local wipe = wipe
local CanInspect = CanInspect
local ClearInspectPlayer = ClearInspectPlayer
local GetTime = GetTime
local C_Timer = C_Timer
local ipairs = ipairs

-- Function to add a player to the queue based on their GUID
function InspectQueueManager:QueuePlayerForInspect(guid)
    -- Check if the GUID represents a player
    local name = GetPlayerInfoByGUID(guid)
    if not name then
        -- The GUID is not a player GUID; it's an NPC or other type
        return
    end

    local player = NCRuntime:GetPlayerFromGuid(guid)
    if not player or not player.token then return end

    -- Add player to the queue if not already queued
    if not self:IsPlayerQueued(guid) then
        table_insert(self.queue, { guid = guid, token = player.token, name = player.name })

        -- Attempt to process the queue immediately if no current inspection is ongoing
        self:ProcessNext()
    end
end

-- Check if a player is already queued
function InspectQueueManager:IsPlayerQueued(guid)
    for _, queuedPlayer in ipairs(self.queue) do
        if queuedPlayer.guid == guid then
            return true
        end
    end
    return false
end

-- Process the next player in the queue
function InspectQueueManager:ProcessNext()
    if self.currentInspection or #self.queue == 0 or NCCombat:IsActive() then
        return
    end

    local player = table_remove(self.queue, 1)
    if player then
        if CanInspect(player.token) then
            -- Initiate inspect request
            self.currentInspection = player
            NotifyInspect(player.token)
            self.lastInspectTime = GetTime()

            -- Schedule a timeout check
            C_Timer.After(self.timeout, function() self:CheckForTimeout() end)
        else
            -- Player is not (currently) inspectable, skip to the next player
            local guid = player.guid

            C_Timer.After(1.5, function()
                self:QueuePlayerForInspect(guid)
            end)

            self.currentInspection = nil
            self:ProcessNext()
        end
    end
end

-- Handle the INSPECT_READY event
function InspectQueueManager:OnInspectReady(guid)
    if self.currentInspection and self.currentInspection.guid == guid then
        -- Successfully inspected the player, clear the current inspection
        self.currentInspection = nil
        ClearInspectPlayer()
        self:ProcessNext()
    end
end

-- Check for stale (timed-out) inspect requests
function InspectQueueManager:CheckForTimeout()
    if self.currentInspection and (GetTime() - self.lastInspectTime > self.timeout) then
        -- Stale request, skip this player
        local staleGuid = self.currentInspection.guid

        C_Timer.After(1.5, function()
            self:QueuePlayerForInspect(staleGuid)
        end)

        self.currentInspection = nil
        self:ProcessNext()
    end
end

-- Clear the queue and reset the current inspection
function InspectQueueManager:ClearQueue()
    wipe(self.queue)
    self.currentInspection = nil
end
