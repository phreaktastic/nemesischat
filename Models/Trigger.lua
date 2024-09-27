-----------------------------------------------------
-- TRIGGER
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Trigger model for performing actions
-----------------------------------------------------

local triggerDefaults = {
    Name = "",
    Actions = {},
    Variables = {},
}

NCTrigger = DeepCopy(triggerDefaults)

function NCTrigger:New()
    local o = {}

    setmetatable(o, self)
    self.__index = self

    return o
end

-- Actions must be an action object
function NCTrigger:AddAction(action)
    if not action or type(action.GetType) ~= "function" or not NemesisChat.Actions[action.GetType()] then
        NemesisChat:Print("Invalid action: " .. action)
        return
    end

    tinsert(self.Actions, action)

    return self
end