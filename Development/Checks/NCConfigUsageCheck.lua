local BaseCheck = require("Core.BaseCheck")
local Severity = require("Core.Severity")

local NCConfigUsageCheck = setmetatable({}, { __index = BaseCheck })
NCConfigUsageCheck.__index = NCConfigUsageCheck

-- Cache the config methods (could be moved to constructor if needed)
local function getNCConfigMethods()
    local config_path = "Models/Config.lua"
    local config_file = io.open(config_path, "r")
    local config_content = config_file:read("*all")
    config_file:close()

    local methods = {}
    for method_name in config_content:gmatch("([%w_]+)%s*=%s*function%s*%b()") do
        methods[method_name] = true
    end
    return methods
end

function NCConfigUsageCheck.new()
    local params = {
        name = "NCConfig Usage Check",
        exclusion_pattern = "",
        exclusions = {
            "Models/Config.lua",
        },
        severity = Severity.ERROR,
        cleanOptions = {
            removeComments = true,
            removeDoubleQuotes = false,
            removeSingleQuotes = false
        }
    }

    local self = setmetatable(BaseCheck.new(params), NCConfigUsageCheck)
    self.ncconfig_methods_cache = getNCConfigMethods()
    self.utils = require("Core.Utils")
    return self
end

function NCConfigUsageCheck:check(full_path, content)
    local line_numbers = {}
    local context_methods = {}
    for line_number, line in ipairs(self.utils.splitString(content, "\n")) do
        local method_name = line:match("NCConfig:([%w_]+)")
        if method_name and not self.ncconfig_methods_cache[method_name] then
            table.insert(line_numbers, line_number)
            table.insert(context_methods, method_name .. " (line " .. line_number .. ")")
        end
    end
    return #line_numbers > 0, line_numbers, context_methods
end

function NCConfigUsageCheck:getErrorMessage(full_path, lineNumbers, context)
    local method_names = context and table.concat(context, "\n  - ") or ""
    return "Invalid reference to NCConfig found in " .. full_path .. ": \n  - " .. method_names
end

return NCConfigUsageCheck
