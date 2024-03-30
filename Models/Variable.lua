-----------------------------------------------------
-- VARIABLE
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Variable model for actions
-----------------------------------------------------

local variableDefaults = {
    Name = "",
    Stored = false,
    PerDungeon = false,
    PerBoss = false,
    ShouldIncrement = false,
    _variables = {},
    _bossCache = {},
    _dungeonCache = {},
    _db = NCDB:New("userVariables"),
}

NCVariable = DeepCopy(variableDefaults)

function NCVariable:New(name, stored, perDungeon, perBoss, shouldIncrement)
    if not name then
        error("Variable name is required")
        return
    end

    local o = DeepCopy(variableDefaults, true)

    for key, _ in pairs(NCVariable) do
        if string.match(key, "^_") then
            o[key] = nil
        end
    end

    o.Name = name

    if stored then
        o.Stored = stored
    end

    if perDungeon then
        o.PerDungeon = perDungeon
    end

    if perBoss then
        o.PerBoss = perBoss
    end

    if shouldIncrement then
        o.ShouldIncrement = shouldIncrement
    end

    setmetatable(o, self)
    self.__index = self

    NCVariable._variables[o.Name] = o

    return o
end

function NCVariable:BossCallback()
    if not core.InDungeon then
        return
    end

    if not NCVariable._bossCache then
        self:BossCache()
    end

    for variable, _ in pairs(NCVariable._bossCache) do
        if not variable.Stored then
            if NemesisChat.UserVariables[variable] then
                NemesisChat.UserVariables[variable] = nil
            end
        else
            NCDB:DeleteKey(variable)
        end
    end
end

function NCVariable:BossCache()
    for _, variable in pairs(NCVariable._variables) do
        if variable.PerBoss then
            NCVariable._bossCache[variable.Name] = true
        end
    end
end

function NCVariable:DungeonCallback()
    if not core.InDungeon then
        return
    end

    if not NCVariable._dungeonCache then
        self:DungeonCache()
    end

    for variable, _ in pairs(NCVariable._dungeonCache) do
        if not variable.Stored then
            if NemesisChat.UserVariables[variable] then
                NemesisChat.UserVariables[variable] = nil
            end
        else
            NCDB:DeleteKey(variable)
        end
    end
end

function NCVariable:DungeonCache()
    for _, variable in pairs(NCVariable._variables) do
        if variable.PerDungeon then
            NCVariable._dungeonCache[variable.Name] = true
        end
    end
end

function NCVariable:Increment()
    if self.ShouldIncrement then
        if not self.Stored then
            if not NemesisChat.UserVariables[self.Name] then
                NemesisChat.UserVariables[self.Name] = 0
            end

            NemesisChat.UserVariables[self.Name] = NemesisChat.UserVariables[self.Name] + 1
            return
        end

        NCDB._db:Increment(self.Name)
    end
end

function NCVariable:Set(value)
    if not self.Stored then
        NemesisChat.UserVariables[self.Name] = value
        return
    end

    NCDB:Set(self.Name, value)
end

function NCVariable:Get()
    if not self.Stored then
        return NemesisChat.UserVariables[self.Name]
    end

    return NCDB:Get(self.Name)
end

function NCVariable:Clear()
    if not self.Stored then
        NemesisChat.UserVariables[self.Name] = nil
        return
    end

    NCDB:Clear(self.Name)
end

function NCVariable:SetStored(stored)
    self.Stored = stored

    if not core.db.profile.userVariables then
        core.db.profile.userVariables = {}
    end

    return self
end

function NCVariable:SetPerDungeon(perDungeon)
    self.PerDungeon = perDungeon

    return self
end

function NCVariable:SetPerBoss(perBoss)
    self.PerBoss = perBoss

    return self
end

function NCVariable:SetShouldIncrement(shouldIncrement)
    self.ShouldIncrement = shouldIncrement

    return self
end

function NCVariable:Destroy()
    if self.Stored then
        NCDB:DeleteKey(self.Name)
    else
        if NemesisChat.UserVariables then
            NemesisChat.UserVariables[self.Name] = nil
        end
    end

    if NCVariable._variables[self.Name] then
        NCVariable._variables[self.Name] = nil
    end

    self = nil
end
