local BaseCheck = {}
BaseCheck.__index = BaseCheck

function BaseCheck.new(params)
    local self = setmetatable({}, BaseCheck)
    self.name = params.name or "Unnamed Check"
    self.exclusion_pattern = params.exclusion_pattern or ""
    self.exclusions = params.exclusions or {}
    self.severity = params.severity
    self.cleanOptions = params.cleanOptions or {
        removeComments = true,
        removeDoubleQuotes = true,
        removeSingleQuotes = true
    }
    return self
end

function BaseCheck:check(full_path, content)
    error("check() method must be implemented by derived classes")
end

function BaseCheck:getErrorMessage(full_path, lineNumbers, context)
    error("getErrorMessage() method must be implemented by derived classes")
end

return BaseCheck
