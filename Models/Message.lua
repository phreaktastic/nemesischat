-----------------------------------------------------
-- MESSAGE
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Wrapper for queued messages
-----------------------------------------------------

local messageDefaults = {
    category = "",
    event = "",
    target = "SELF",
    nemesis = "",
    bystander = "",
    message = "",
    messageReplaced = "",
    channel = "SAY",
    chance = 1.0,
    messages = {},
}

NCMessage = DeepCopy(messageDefaults)

function NCMessage:new()
    local o = DeepCopy(messageDefaults)

    o.messages = false

    setmetatable(o, self)
    self.__index = self

    o.messages = nil

    tinsert(self.messages, o)

    return o
end

function NCMessage:SetCategory(category)
    self.category = category

    return self
end

function NCMessage:SetEvent(event)
    self.event = event

    return self
end

function NCMessage:SetTarget(target)
    self.target = target

    return self
end

function NCMessage:SetNemesis(nemesis)
    self.nemesis = nemesis

    return self
end

function NCMessage:SetBystander(bystander)
    self.bystander = bystander

    return self
end

function NCMessage:SetMessage(message)
    self.message = message
    self.messageReplaced = NCController:GetReplacedString(self.message)

    return self
end

function NCMessage:SetChannel(channel)
    self.channel = channel

    return self
end

function NCMessage:SetChance(chance)
    self.chance = chance

    return self
end

function NCMessage:Reset()
    if self ~= NCMessage then
        return
    end

    for i = 1, #self.messages do
        tremove(self.messages, i)
    end

    self.messages = {}

    return self
end

