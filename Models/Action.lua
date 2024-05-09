-----------------------------------------------------
-- ACTION
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Action model for triggers
-----------------------------------------------------

NC_ACTION_MESSAGE = "MESSAGE"
NC_ACTION_SOUND = "SOUND"
NC_ACTION_EMOTE = "EMOTE"
NC_ACTION_SCRIPT = "SCRIPT"
NC_ACTION_MARKER = "MARKER"
NC_ACTION_SESSION_VARIABLE = "SESSION_VARIABLE"
NC_ACTION_DB_VARIABLE = "DB_VARIABLE"

NemesisChat:RegisterGlobalLookup("NC_ACTION_", "Actions")

local actionDefaults = {
    -- Action type defined above
    Type = "",
    -- Message model
    Message = {},
    Sound = "",
    Emote = "",
    Script = "",
    Marker = "",
    -- Variable models
    Variables = {},
    Chance = 1.0,
    Weight = 1.0,
}

NCAction = DeepCopy(actionDefaults)

function NCAction:New()
    local o = DeepCopy(actionDefaults)

    setmetatable(o, self)
    self.__index = self

    return o
end

-- Must be a valid action type, defined above and upon initialization NemesisChat.Actions is populated
function NCAction:SetType(type)
    if not NemesisChat.Actions[type] then
        error("Invalid action type: " .. type)
        return
    end

    self.Type = type

    return self
end

function NCAction:GetType()
    return self.Type
end

function NCAction:SetMessage(message)
    self.Message = message

    return self
end

function NCAction:GetMessage()
    return self.Message
end

function NCAction:SetSound(sound)
    self.Sound = sound

    return self
end

function NCAction:GetSound()
    return self.Sound
end

function NCAction:SetEmote(emote)
    self.Emote = emote

    return self
end

function NCAction:GetEmote()
    return self.Emote
end

function NCAction:SetScript(script)
    self.Script = script

    return self
end

function NCAction:GetScript()
    return self.Script
end

function NCAction:SetMarker(marker)
    self.Marker = marker

    return self
end

function NCAction:GetMarker()
    return self.Marker
end

function NCAction:AddVariable(variable)
    if not variable or type(variable) ~= "table" or not variable.Name then
        error("Invalid variable: " .. variable)
        return
    end

    tinsert(self.Variables, variable)

    return self
end

function NCAction:RemoveVariable(variable)
    for i, v in ipairs(self.Variables) do
        if v == variable then
            tremove(self.Variables, i)
            break
        end
    end

    return self
end

function NCAction:RemoveVariableByIndex(index)
    tremove(self.Variables, index)

    return self
end

function NCAction:RemoveVariableByName(name)
    for i, v in ipairs(self.Variables) do
        if v.Name == name then
            tremove(self.Variables, i)
            break
        end
    end

    return self
end

function NCAction:ResetVariables()
    for i = 1, #self.Variables do
        tremove(self.Variables, i)
    end

    self.Variables = {}

    return self
end

function NCAction:GetVariables()
    return self.Variables
end

function NCAction:SetChance(chance)
    self.Chance = chance

    return self
end

function NCAction:GetChance()
    return self.Chance
end

function NCAction:SetWeight(weight)
    self.Weight = weight

    return self
end

function NCAction:GetWeight()
    return self.Weight
end
