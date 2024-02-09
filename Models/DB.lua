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

    self:TouchComplexKey(db.prefix)

    return db
end

-- Simple string keys, meaning no dots to parse
function NCDB:GetKey(key)
    return core.db[self.basePath][self.prefix][key]
end

function NCDB:SetKey(key, value)
    core.db[self.basePath][self.prefix][key] = value
end

function NCDB:DeleteKey(key)
    core.db[self.basePath][self.prefix][key] = nil
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
function NCDB:GetComplexKey(key)
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

function NCDB:SetComplexKey(key, value)
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

function NCDB:DeleteComplexKey(key)
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

function NCDB:TouchComplexKey(key)
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

function NCDB:ComplexInsertIntoArray(key, value)
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