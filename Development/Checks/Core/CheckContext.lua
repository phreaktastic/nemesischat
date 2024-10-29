local Utils = require("Development.Checks.Core.Utils")

local CheckContext = {}

function CheckContext.new(params)
    return {
        utils = Utils,
        severity = params.severity,
        -- Add any other shared functionality needed by checks
    }
end

return CheckContext
