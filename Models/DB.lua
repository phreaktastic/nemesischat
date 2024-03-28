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

    self:TouchPath(db.prefix)

    return db
end

-- Simple string keys, meaning no dots to parse
function NCDB:Get()
    return core.db[self.basePath][self.prefix]
end

function NCDB:Set(value)
    core.db[self.basePath][self.prefix] = value
end

function NCDB:GetKey(key)
    return core.db[self.basePath][self.prefix][key]
end

function NCDB:SetKey(key, value)
    core.db[self.basePath][self.prefix][key] = value
end

function NCDB:DeleteKey(key)
    core.db[self.basePath][self.prefix][key] = nil
end

function NCDB:Clear(key)
    NCDB:DeleteKey(key)
end

function NCDB:TouchKey(key)
    if core.db[self.basePath][self.prefix][key] == nil then
        core.db[self.basePath][self.prefix][key] = {}
    end
end

function NCDB:InsertIntoArray(key, value)
    if core.db[self.basePath][self.prefix][key] == nil then
        core.db[self.basePath][self.prefix][key] = {}
    end

    table.insert(core.db[self.basePath][self.prefix][key], value)
end

-- Complex keys, meaning dots to parse and null check
function NCDB:GetPath(key)
    if key ~= self.prefix then
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
    if key ~= self.prefix then
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
    if key ~= self.prefix then
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
    if key ~= self.prefix then
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
    if key ~= self.prefix then
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
    return core.db[self.basePath][self.prefix] == nil or core.db[self.basePath][self.prefix] == ""
end

-- Check if a key is nil or an empty table
function NCDB:IsKeyEmpty(key)
    return core.db[self.basePath][self.prefix][key] == nil or core.db[self.basePath][self.prefix][key] == ""
end

-- Check if a complex key is nil or an empty table
function NCDB:IsPathEmpty(key)
    if key ~= self.prefix then
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
