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

function NCCache:Push(key, data)
    local isSegment = data.IsSegment or false

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
    return self.db:GetKey(key)
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