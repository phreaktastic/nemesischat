-----------------------------------------------------
-- DATA HELPERS
-- Handles data structure manipulation and calculations
-----------------------------------------------------
local addonName, core = ...

-----------------------------------------------------
-- Table Management
-----------------------------------------------------
function NemesisChat:GetLength(myTable)
    -- Early exit for invalid tables
    if type(myTable) ~= "table" or next(myTable) == nil then
        return 0
    end

    local count = 0
    for _ in pairs(myTable) do
        count = count + 1
    end

    return count
end

function NemesisChat:GetKeys(myTable)
    local keys = {}
    for k in pairs(myTable) do
        table.insert(keys, k)
    end
    return keys
end

function NemesisChat:GetDoubleMap(myTable)
    local keys = {}
    for k in pairs(myTable) do
        keys[k] = k
    end
    return keys
end

function NemesisChat:GetRandomKey(myTable)
    -- Get all keys and validate
    local keys = NemesisChat:GetKeys(myTable)
    if #keys == 0 then
        return ""
    end

    -- Return random key
    return keys[math.random(#keys)]
end

-----------------------------------------------------
-- Number Formatting
-----------------------------------------------------
function NemesisChat:FormatNumber(num)
    local numberToFormat = tonumber(num)

    -- Handle invalid or zero numbers
    if numberToFormat == nil or numberToFormat == 0 then
        return 0
    end

    -- Format based on magnitude
    if numberToFormat < 1000 then
        return numberToFormat .. ""
    end

    local thousands = math.floor(numberToFormat / 10) / 100

    if thousands < 1000 then
        return thousands .. "k"
    end

    return math.floor(thousands / 10) / 100 .. "m"
end

-----------------------------------------------------
-- Time Formatting
-----------------------------------------------------
function NemesisChat:GetDuration(timeStamp)
    -- Handle invalid timestamps
    if timeStamp == nil or timeStamp == 0 then
        return "no time"
    end

    local duration = GetTime() - timeStamp
    local minutes = math.floor(duration / 60)
    local seconds = math.floor(duration % 60)

    return minutes .. "min " .. seconds .. "sec"
end

-----------------------------------------------------
-- Random Utilities
-----------------------------------------------------
function NemesisChat:Roll(chance)
    local roll = math.random()
    return roll <= tonumber(chance)
end
