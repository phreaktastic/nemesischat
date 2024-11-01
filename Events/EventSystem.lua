local addonName, core = ...;

-- Create a hidden frame to handle OnUpdate
local EventFrame = CreateFrame("Frame")
EventFrame:Hide() -- Initially hidden to prevent OnUpdate when no events

EventSystem = {
    events = {},
    queue = {},
    frameQueue = {},
    currentFrame = 0,
    config = {
        globalDelay = 0.1,    -- Default delay between firing queued events
        maxEventsPerFrame = 1 -- Configurable: number of events to process per frame
    }
}

core.EventSystem = EventSystem

-- Register an event with optional parameters: fireOnce, sticky, timed, staggered (with custom staggerDelay)
function EventSystem:RegisterEvent(eventName, callback, priority, options)
    if not self.events[eventName] then
        options = options or {}
        self.events[eventName] = {
            subscribers = {},
            fireOnce = options.fireOnce or false,
            sticky = options.sticky or false,
            timed = options.timed or false,
            staggered = options.staggered or false,
            staggerDelay = options.staggerDelay or (1 / 60), -- Default delay between staggered callbacks (1 frame)
            stickyValue = nil,
            nextFireTime = 0
        }
    end

    table.insert(self.events[eventName].subscribers, { callback = callback, priority = priority or 1 })

    -- Sort subscribers based on priority (higher first)
    table.sort(self.events[eventName].subscribers, function(a, b) return a.priority > b.priority end)
end

-- Publish an event, firing all subscribers' callbacks
function EventSystem:Publish(eventName, ...)
    local event = self.events[eventName]
    if not event then return end

    -- Check for sticky or timed conditions
    if event.fireOnce and event.sticky then
        if event.stickyValue then return end              -- Already fired and sticky
    elseif event.fireOnce and event.timed then
        if GetTime() < event.nextFireTime then return end -- Wait for the timer reset
    end

    -- Queue event if there's a global delay
    table.insert(self.queue, { event = eventName, args = { ... } })
    self:ProcessQueue() -- Process the event queue immediately
end

-- Process the event queue, respecting staggered execution and global delay
function EventSystem:ProcessQueue()
    if #self.queue == 0 then return end

    -- Make sure the EventFrame is active
    EventFrame:Show()

    local queuedEvent = table.remove(self.queue, 1)
    local event = self.events[queuedEvent.event]

    -- If staggered, add to frame-specific batch processing
    if event.staggered then
        for i, subscriber in ipairs(event.subscribers) do
            local delay = (i - 1) * event.staggerDelay -- Calculate stagger delay for each subscriber
            C_Timer.After(delay, function()
                -- Ensure we handle the event even with a delayed stagger
                if self.frameQueue[self.currentFrame] then
                    table.insert(self.frameQueue[self.currentFrame],
                        { callback = subscriber.callback, args = queuedEvent.args })
                else
                    self.frameQueue[self.currentFrame] = { { callback = subscriber.callback, args = queuedEvent.args } }
                end
            end)
        end
    else
        -- Non-staggered event processing
        for _, subscriber in ipairs(event.subscribers) do
            subscriber.callback(unpack(queuedEvent.args))
        end
    end
end

function EventSystem:ProcessFrameQueue()
    -- If there are no events in the frame queue, stop the OnUpdate script
    if next(self.frameQueue) == nil then
        self.currentFrame = 0 -- Reset the frame counter
        EventFrame:Hide()     -- Disable OnUpdate processing when idle
        return
    end

    self.currentFrame = self.currentFrame + 1 -- Increment frame count
    local frameEvents = self.frameQueue[self.currentFrame]

    if frameEvents then
        local count = 0
        -- Process up to config.maxEventsPerFrame for the current frame
        while count < self.config.maxEventsPerFrame and #frameEvents > 0 do
            local event = table.remove(frameEvents, 1)
            event.callback(unpack(event.args)) -- Fire the event callback with arguments
            count = count + 1
        end

        -- If there are still unprocessed events, leave them for the next frame
        if #frameEvents == 0 then
            self.frameQueue[self.currentFrame] = nil -- Clear once all events are processed
        end
    end
end

-- Function to reset a "fire once" event
function EventSystem:ResetEvent(eventName)
    local event = self.events[eventName]
    if not event then return end

    event.stickyValue = nil
    event.nextFireTime = 0
end

-- Hooking into the OnUpdate event of the hidden frame to process every frame
EventFrame:SetScript("OnUpdate", function(self, elapsed)
    EventSystem:ProcessFrameQueue()
end)

-- Start processing the queue
EventSystem:ProcessQueue()
