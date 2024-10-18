local rootDir = arg[2] .. "\\"
print ("Root Directory: " .. rootDir)

if not rootDir then
    return
end

local scriptDir = rootDir .. "Tests\\"

-- Add the Tests directory to package.path
package.path = scriptDir .. "?.lua;" .. scriptDir .. "Core\\?.lua;" .. "Tests\\?.lua;"

require("Core.Mocks.MockWoWAPI")

local function runTest(testName)
    require(testName)

    print("Running test: " .. testName)
    local test = dofile(testFile)
    if type(test) == "function" then
        test()
    else
        print("Test file does not return a function")
    end
end

local testName = arg[1]
if not testName then
    print("Please provide a test name as an argument")
    return
end



local parsersLoc = "Parsers"
local parsers = require(parsersLoc)
local luaFiles = parsers.ParseTOCFile(rootDir)

-- Load each Lua file in order
for _, filePath in ipairs(luaFiles) do
    print("Loading file: " .. filePath)
    local status, err = pcall(dofile, filePath)
    if not status then
        print("Error loading file '" .. filePath .. "': " .. err)
    end
end

runTest(testName)
