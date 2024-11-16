local BaseCheck = require("Core.BaseCheck")
local Severity = require("Core.Severity")

local CoreDbUsageCheck = setmetatable({}, { __index = BaseCheck })
CoreDbUsageCheck.__index = CoreDbUsageCheck

function CoreDbUsageCheck.new()
    local params = {
        name = "Core DB Usage Check",
        exclusion_pattern = "",
        exclusions = {
            "DB.lua", -- This is the only file that should use core.db
            "Core.lua:16", -- This is where we instantiate core.db
            "SlashCommands.lua",
            "Init.lua:643,647",
            "Migrations.lua",
            "Migration.lua"
        },
        severity = Severity.WARNING,
        cleanOptions = {
            removeComments = true,
            removeDoubleQuotes = true,
            removeSingleQuotes = true
        }
    }

    local self = setmetatable(BaseCheck.new(params), CoreDbUsageCheck)
    self.utils = require("Core.Utils")
    return self
end

function CoreDbUsageCheck:check(full_path, content)
    local line_numbers = {}
    for line_number, line in ipairs(self.utils.splitString(content, "\n")) do
        if line:find("core%.db") then
            table.insert(line_numbers, line_number)
        end
    end
    return #line_numbers > 0, line_numbers
end

function CoreDbUsageCheck:getErrorMessage(full_path, lineNumbers)
    if #lineNumbers == 1 then
        return "Core DB usage found in " .. full_path .. ":" .. table.concat(lineNumbers, ", ") .. "."
    else
        return "Core DB usage found in " .. full_path .. " at lines " .. table.concat(lineNumbers, ", ") .. "."
    end
end

return CoreDbUsageCheck
