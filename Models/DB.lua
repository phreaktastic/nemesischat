-----------------------------------------------------
-- DB
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Logic for everything that interacts with permanent
-- storage.
-----------------------------------------------------

core.db = LibStub("AceDB-3.0"):New("NemesisChatDB", core.defaults, true)

NCDB = {
    prefix = "",
    basePath = "profile",
}

function NCDB:New(prefix, basePath)
    local db = {}

    setmetatable(db, self)
    self.__index = self

    db.prefix = prefix

    if basePath then
        db.basePath = basePath
    end

    if prefix then
        self:TouchPath(db.prefix)
    end

    return db
end

-- Simple string keys, meaning no dots to parse
function NCDB:Get()
    if not self.prefix then
        return core.db[self.basePath]
    end

    return core.db[self.basePath][self.prefix]
end

function NCDB:Set(value)
    if not value then
        return
    end

    if not self.prefix then
        core.db[self.basePath] = value
        return
    end

    core.db[self.basePath][self.prefix] = value
end

function NCDB:GetKey(key)
    if not key then
        return
    end

    if not self.prefix then
        return core.db[self.basePath][key]
    end

    return core.db[self.basePath][self.prefix][key]
end

function NCDB:SetKey(key, value)
    if not key then
        return
    end

    if not self.prefix then
        core.db[self.basePath][key] = value
        return
    end

    core.db[self.basePath][self.prefix][key] = value
end

function NCDB:DeleteKey(key)
    if not key then
        return
    end

    if not self.prefix then
        core.db[self.basePath][key] = nil
        return
    end

    core.db[self.basePath][self.prefix][key] = nil
end

function NCDB:Clear(key)
    NCDB:DeleteKey(key)
end

function NCDB:TouchKey(key)
    if not key then
        return
    end

    if not self.prefix then
        if core.db[self.basePath][key] == nil then
            core.db[self.basePath][key] = {}
        end
        return
    end

    if core.db[self.basePath][self.prefix][key] == nil then
        core.db[self.basePath][self.prefix][key] = {}
    end
end

function NCDB:InsertIntoArray(key, value)
    if not key then
        return
    end

    if not self.prefix then
        if core.db[self.basePath][key] == nil then
            core.db[self.basePath][key] = {}
        end

        table.insert(core.db[self.basePath][key], value)
        return
    end

    if core.db[self.basePath][self.prefix][key] == nil then
        core.db[self.basePath][self.prefix][key] = {}
    end

    table.insert(core.db[self.basePath][self.prefix][key], value)
end

-- Complex keys, meaning dots to parse and null check
function NCDB:GetPath(key)
    if not key then
        return
    end

    if key ~= self.prefix and self.prefix then
        key = self.prefix .. "." .. key
    end

    local keys = {strsplit(".", key)}
    local value = core.db[self.basePath]

    for i = 1, #keys do
        if value[keys[i]] == nil then
            return nil
        end

        value = value[keys[i]]
    end

    return value
end

function NCDB:SetPath(key, value)
    if not key then
        return
    end

    if key ~= self.prefix and self.prefix then
        key = self.prefix .. "." .. key
    end

    local keys = {strsplit(".", key)}
    local parent = core.db[self.basePath]

    for i = 1, #keys - 1 do
        if parent[keys[i]] == nil then
            parent[keys[i]] = {}
        end

        parent = parent[keys[i]]
    end

    parent[keys[#keys]] = value
end

function NCDB:DeletePath(key)
    if not key then
        return
    end

    if key ~= self.prefix and self.prefix then
        key = self.prefix .. "." .. key
    end

    local keys = {strsplit(".", key)}
    local parent = core.db[self.basePath]

    for i = 1, #keys - 1 do
        if parent[keys[i]] == nil then
            return
        end

        parent = parent[keys[i]]
    end

    parent[keys[#keys]] = nil
end

function NCDB:TouchPath(key)
    if not key then
        return
    end

    if key ~= self.prefix and self.prefix then
        key = self.prefix .. "." .. key
    end

    local keys = {strsplit(".", key)}
    local parent = core.db[self.basePath]

    for i = 1, #keys do
        if parent[keys[i]] == nil then
            parent[keys[i]] = {}
        end

        parent = parent[keys[i]]
    end
end

function NCDB:PathInsert(key, value)
    if not key then
        return
    end

    if key ~= self.prefix and self.prefix then
        key = self.prefix .. "." .. key
    end

    local keys = {strsplit(".", key)}
    local parent = core.db[self.basePath]

    for i = 1, #keys - 1 do
        if parent[keys[i]] == nil then
            parent[keys[i]] = {}
        end

        parent = parent[keys[i]]
    end

    if parent[keys[#keys]] == nil then
        parent[keys[#keys]] = {}
    end

    table.insert(parent[keys[#keys]], value)
end

-- Check if the base path + prefix is nil or an empty table
function NCDB:IsEmpty()
    if not self.prefix then
        return core.db[self.basePath] == nil or core.db[self.basePath] == ""
    end

    return core.db[self.basePath][self.prefix] == nil or core.db[self.basePath][self.prefix] == ""
end

-- Check if a key is nil or an empty table
function NCDB:IsKeyEmpty(key)
    if not self.prefix then
        return core.db[self.basePath][key] == nil or core.db[self.basePath][key] == ""
    end

    return core.db[self.basePath][self.prefix][key] == nil or core.db[self.basePath][self.prefix][key] == ""
end

-- Check if a complex key is nil or an empty table
function NCDB:IsPathEmpty(key)
    if key ~= self.prefix and self.prefix then
        key = self.prefix .. "." .. key
    end

    local keys = {strsplit(".", key)}
    local value = core.db[self.basePath]

    for i = 1, #keys do
        if value[keys[i]] == nil then
            return true
        end

        value = value[keys[i]]
    end

    return next(value) == nil
end

-- Increment a key by a value
function NCDB:Increment(key, value)
    if not value then
        value = 1
    end

    if core.db[self.basePath][self.prefix][key] == nil then
        core.db[self.basePath][self.prefix][key] = 0
    end

    core.db[self.basePath][self.prefix][key] = core.db[self.basePath][self.prefix][key] + value
end

-- Decrement a key by a value
function NCDB:Decrement(key, value)
    if not value then
        value = 1
    end

    if not self.prefix then
        if core.db[self.basePath][key] == nil then
            core.db[self.basePath][key] = 0
        end

        core.db[self.basePath][key] = core.db[self.basePath][key] - value
        return
    end

    if core.db[self.basePath][self.prefix][key] == nil then
        core.db[self.basePath][self.prefix][key] = 0
    end

    core.db[self.basePath][self.prefix][key] = core.db[self.basePath][self.prefix][key] - value
end

-- Toggle a boolean key
function NCDB:Toggle(key)
    if not key then
        return
    end

    if not self.prefix then
        core.db[self.basePath][key] = not core.db[self.basePath][key]
        return
    end

    core.db[self.basePath][self.prefix][key] = not core.db[self.basePath][self.prefix][key]
end

-- Toggle a boolean path 
function NCDB:TogglePath(key)
    if not key then
        return
    end

    local value = self:GetPath(key)

    if value == nil then
        return
    end

    self:SetPath(key, not value)
end
