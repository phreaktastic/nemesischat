local addonName, core = ...;

-- Create a hidden frame to handle OnUpdate
local EventFrame = CreateFrame("Frame")
EventFrame:Hide() -- Initially hidden to prevent OnUpdate when no events

--- @class EventOptions
--- @field fireOnce? boolean If true, event only fires once until reset
--- @field sticky? boolean If true and fireOnce is true, stores last value
--- @field timed? boolean If true and fireOnce is true, uses time-based cooldown
--- @field staggered? boolean If true, callbacks are distributed across frames
--- @field staggerDelay? number Delay between staggered callbacks (default: 1/60)
--- @field frameDelay? number Explicit frame delay for staggered events

--- @class EventSubscriber
--- @field callback function The callback function to execute
--- @field priority number Priority level (higher numbers execute first)

--- @class EventDefinition
--- @field subscribers EventSubscriber[] Array of subscribers
--- @field fireOnce boolean
--- @field sticky boolean
--- @field timed boolean
--- @field staggered boolean
--- @field staggerDelay number
--- @field frameDelay? number
--- @field stickyValue any
--- @field nextFireTime number

--- @class EventSystem
--- @field events table<string, EventDefinition>
--- @field queue table[]
--- @field frameQueue table<number, table[]>
--- @field currentFrame number
--- @field config table
EventSystem = {
    events = {},
    queue = {},
    frameQueue = {},
    currentFrame = 0,
    config = {
        globalDelay = 0.025,    -- Default delay between firing queued events
        maxEventsPerFrame = 3 -- Configurable: number of events to process per frame
    }
}

--- @type EventSystem
core.EventSystem = EventSystem

--- Register an event handler with the system
--- @param eventName string The unique identifier for the event
--- @param callback function The function to call when event fires
--- @param priority? number Priority level (higher numbers execute first, default: 1)
--- @param options? EventOptions Configuration options for the event
function EventSystem:RegisterEvent(eventName, callback, priority, options)
    if not self.events[eventName] then
        options = options or {}
        self.events[eventName] = {
            subscribers = {},
            fireOnce = options.fireOnce or false,
            sticky = options.sticky or false,
            timed = options.timed or false,
            staggered = options.staggered or false,
            staggerDelay = options.staggerDelay or (1 / 60), -- Default delay between staggered callbacks
            frameDelay = options.frameDelay, -- Explicit frame delay
            stickyValue = nil,
            nextFireTime = 0,
        }
    end

    table.insert(self.events[eventName].subscribers, { callback = callback, priority = priority or 1 })

    -- Sort subscribers based on priority (higher first)
    table.sort(self.events[eventName].subscribers, function(a, b) return a.priority > b.priority end)
end

--- Publish an event to all subscribers
--- @param eventName string The event to trigger
--- @param ... any Arguments to pass to the event handlers
function EventSystem:Publish(eventName, ...)
    local event = self.events[eventName]
    if not event then return end

    -- Check for sticky or timed conditions
    if event.fireOnce and event.sticky then
        if event.stickyValue then return end              -- Already fired and sticky
    elseif event.fireOnce and event.timed then
        if GetTime() < event.nextFireTime then return end -- Wait for the timer reset
    end

    -- Queue event
    table.insert(self.queue, { event = eventName, args = { ... } })
    self:ProcessQueue() -- Process the event queue immediately
end

-- Process the event queue, respecting staggered execution and global delay
function EventSystem:ProcessQueue()
    if #self.queue == 0 then return end

    local queuedEvent = table.remove(self.queue, 1)
    local event = self.events[queuedEvent.event]

    if event.staggered then
        local nextFrame = self.currentFrame + 1
        local eventsPerFrame = self.config.maxEventsPerFrame
        local frameDelayInFrames

        if event.frameDelay then
            frameDelayInFrames = event.frameDelay -- Use explicit frame delay if provided
        else
            local currentFPS = GetFramerate()
            frameDelayInFrames = math.ceil(event.staggerDelay * currentFPS) -- Fall back to time-based delay
        end

        for i, subscriber in ipairs(event.subscribers) do
            -- Calculate which frame this event should go in based on maxEventsPerFrame
            local frameOffset = math.ceil(i / eventsPerFrame) * frameDelayInFrames
            local targetFrame = nextFrame + frameOffset

            self.frameQueue[targetFrame] = self.frameQueue[targetFrame] or {}
            table.insert(self.frameQueue[targetFrame],
                { callback = subscriber.callback, args = queuedEvent.args })
        end
        EventFrame:Show()
    else
        -- Non-staggered event processing
        for _, subscriber in ipairs(event.subscribers) do
            subscriber.callback(unpack(queuedEvent.args))
        end
    end
end

function EventSystem:ProcessFrameQueue()
    -- Check for frame skips and process any missed frames
    local lastProcessedFrame = self.currentFrame
    self.currentFrame = self.currentFrame + 1
    local eventsProcessed = 0

    -- Process any frames we might have missed
    for frame = lastProcessedFrame + 1, self.currentFrame do
        local missedEvents = self.frameQueue[frame]
        if missedEvents then
            while eventsProcessed < self.config.maxEventsPerFrame and #missedEvents > 0 do
                local event = table.remove(missedEvents, 1)
                event.callback(unpack(event.args))
                eventsProcessed = eventsProcessed + 1
            end

            -- If we still have events, keep the frame in queue
            if #missedEvents == 0 then
                self.frameQueue[frame] = nil
            end

            -- If we've hit our limit, return early
            if eventsProcessed >= self.config.maxEventsPerFrame then
                return
            end
        end
    end

    -- Only hide if there are no events in any future frames
    local hasEvents = false
    for frame, events in pairs(self.frameQueue) do
        if frame >= self.currentFrame and #events > 0 then
            hasEvents = true
            break
        end
    end

    if not hasEvents then
        self.currentFrame = 0
        EventFrame:Hide()
        return
    end

    -- Process current frame events with remaining capacity
    local frameEvents = self.frameQueue[self.currentFrame]
    if frameEvents then
        while eventsProcessed < self.config.maxEventsPerFrame and #frameEvents > 0 do
            local event = table.remove(frameEvents, 1)
            event.callback(unpack(event.args))
            eventsProcessed = eventsProcessed + 1
        end

        if #frameEvents == 0 then
            self.frameQueue[self.currentFrame] = nil
        end
    end
end

--- Reset a "fire once" event to allow it to fire again
--- @param eventName string The event to reset
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
