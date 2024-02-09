-----------------------------------------------------
-- CACHE
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Cache logic for storing and retrieving objects 
-- and data from permanent storage, such as groups,
-- players, dungeons, and bosses. Allows the user
-- to do a /reload and not lose any data.
-----------------------------------------------------

NC_CACHE_KEY_GROUP = "group"
NC_CACHE_KEY_GUILD = "guild"
NC_CACHE_KEY_FRIENDS = "friends"
NC_CACHE_KEY_DUNGEON = "dungeon"
NC_CACHE_KEY_BOSS = "boss"

NCCache = {
    db = NCDB:New("cache"),
}

local LibSerialize = LibStub("LibSerialize")

function NCCache:Push(key, data)
    local isSegment = type(data) == "table" and data.IsSegment or false

    if type(data) == "table" then
        data.CACHE_TIMESTAMP = GetTime()
        data.CACHE_VERSION = core.version
        data = LibSerialize:Serialize(data)
    end

    if isSegment then
        if self.db:GetPath(key .. ".Restore") then
            self.db:GetKey(key):Restore(data)
        else
            self.db:SetKey(key, NCSegment:New(data:GetIdentifier()))
            self.db:GetKey(key):Restore(data)
        end
    else
        self.db:SetKey(key, data)
    end
end

function NCCache:Pull(key)
    local data = self.db:GetKey(key)

    if not data then
        return nil
    end

    if type(data) == "string" then
        local deserialized = LibSerialize:Deserialize(data)

        if data.CACHE_VERSION ~= core.version then
            return nil
        end

        return deserialized
    else
        return data
    end
end

function NCCache:RestoreSegment(key)
    local model = self:GetSegmentFromKey(key)

    if not model then
        NemesisChat:Print("No segment found for key:", key)
        return
    end

    if self.db:GetPath(key .. ".Restore") and model.Restore then
        model:Restore(self.db:GetKey(key))
        return
    end

    NemesisChat:Print("Attempted restore on key that is not a segment. Key:", key)
end

function NCCache:Clear(key)
    self.db:DeleteKey(key)
end

function NCCache:GetSegmentFromKey(key)
    if key == NC_CACHE_KEY_BOSS then
        return NCBoss
    elseif key == NC_CACHE_KEY_DUNGEON then
        return NCDungeon
    end

    return nil
end

function NCCache:Exists(key)
    return self.db:IsKeyEmpty(key)
end

function NCCache:GetTimestamp(key)
    local data = self.db:GetKey(key)

    if not data then
        return nil
    end

    if type(data) == "string" then
        local deserialized = LibSerialize:Deserialize(data)

        return deserialized.CACHE_TIMESTAMP
    else
        return data.CACHE_TIMESTAMP
    end
end

function NCCache:GetPushDelta(key)
    local timestamp = self:GetTimestamp(key)

    if not timestamp then
        return 999999999
    end

    return GetTime() - timestamp
end