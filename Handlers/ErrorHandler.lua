-----------------------------------------------------
-- Nemesis Chat Custom Event Handler
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local origErrorHandler = geterrorhandler()
NemesisChat.errorThrottleTime = 5  -- Time in seconds to throttle repeated errors
NemesisChat.maxErrorEntries = 5    -- Number of top errors to keep
NemesisChat.errorKeys = {}         -- Reusable table for error keys

local function calculateErrorScore(errorData, currentTime)
    return errorData.count * (1 / (currentTime - errorData.lastOccurrence + 1))
end

local function siftDown(heap, startPos, pos)
    local newItem = heap[pos]
    while pos > startPos do
        local parentPos = math.floor(pos / 2)
        local parent = heap[parentPos]
        if calculateErrorScore(newItem.data, GetTime()) >= calculateErrorScore(parent.data, GetTime()) then
            break
        end
        heap[pos] = parent
        pos = parentPos
    end
    heap[pos] = newItem
end

function NemesisChat:HandleError(err)
    self.SessionErrors = self.SessionErrors or {}
    local currentTime = GetTime()

    -- Initialize error entry if it doesn't exist
    if not self.SessionErrors[err] then
        self.SessionErrors[err] = {
            count = 0,
            stackTrace = debugstack(3),
            lastOccurrence = 0
        }
    end

    local errorEntry = self.SessionErrors[err]

    -- Check if this error has occurred recently
    if (currentTime - errorEntry.lastOccurrence) < (self.errorThrottleTime or 5) then
        errorEntry.count = errorEntry.count + 1
        return  -- Exit early without updating lastOccurrence or printing message
    end

    -- Update error information
    errorEntry.count = errorEntry.count + 1
    errorEntry.lastOccurrence = currentTime

    -- Update error heap
    self.errorHeap = self.errorHeap or {}
    local heap = self.errorHeap
    local found = false
    for i, item in ipairs(heap) do
        if item.key == err then
            siftDown(heap, 1, i)
            found = true
            break
        end
    end

    if not found then
        table.insert(heap, {key = err, data = errorEntry})
        siftDown(heap, 1, #heap)
    end

    -- Keep only the top errors
    while #heap > (self.maxErrorEntries or 5) do
        local removed = table.remove(heap)
        self.SessionErrors[removed.key] = nil
    end

    -- Only print message for new errors or if it's been a while since the last occurrence
    if errorEntry.count == 1 or (currentTime - errorEntry.lastOccurrence) > (self.errorThrottleTime or 5) then
        self:Print("An error has occurred within Nemesis Chat. Please use /nc debug to see the errors and relevant information.")
    end
end

function NemesisChat:TestErrorHandler()
    local errorTypes = {
        "Test Error 1",
        "Test Error 2",
        "Test Error 3",
        "Critical Test Error",
        "Minor Test Error"
    }

    local function throwRandomError()
        local errorType = errorTypes[math.random(1, #errorTypes)]
        error("NemesisChat Test Error: " .. errorType)
    end

    -- Throw a series of errors to test the handler
    for i = 1, 20 do
        local success, err = pcall(throwRandomError)
        if not success then
            self:HandleError(err)
        end
        -- Add a small delay between errors to test timing-related features
        C_Timer.After(0.5 * i, function()
            local success, err = pcall(throwRandomError)
            if not success then
                self:HandleError(err)
            end
        end)
    end

    -- Throw a rapid succession of the same error to test throttling
    for i = 1, 10 do
        local success, err = pcall(function() error("NemesisChat Test Error: Rapid Succession") end)
        if not success then
            self:HandleError(err)
        end
    end
end

seterrorhandler(function(err)
    if not IsNCEnabled() then return origErrorHandler(err) end

    NemesisChat:HandleError(err)
end)
