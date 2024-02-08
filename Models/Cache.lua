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

NCCache = {}

function NCCache:Push(key, data)
    local isSegment = data.IsSegment or false

    if not core.db.profile.cache then core.db.profile.cache = {} end

    if isSegment then
        if core.db.profile.cache[key] and core.db.profile.cache[key].Restore then
            core.db.profile.cache[key].Restore(data)
        else
            core.db.profile.cache[key] = NCSegment:New(data:GetIdentifier())
            core.db.profile.cache[key]:Restore(data)
        end
    else
        core.db.profile.cache[key] = data
    end
end

function NCCache:Pull(key)
    if not core.db.profile.cache then core.db.profile.cache = {} end

    return core.db.profile.cache[key]
end

function NCCache:RestoreSegment(key)
    local model = self:GetSegmentFromKey(key)

    if not model then
        NemesisChat:Print("No segment found for key:", key)
        return
    end

    if not core.db.profile.cache then core.db.profile.cache = {} end

    if core.db.profile.cache[key] and core.db.profile.cache[key].Restore then
        model:Restore(core.db.profile.cache[key])
        return
    end

    NemesisChat:Print("Attempted restore on key that is not a segment. Key:", key)
end

function NCCache:Clear(key)
    if not core.db.profile.cache then core.db.profile.cache = {} end

    core.db.profile.cache[key] = nil
end

function NCCache:GetSegmentFromKey(key)
    if key == NC_CACHE_KEY_BOSS then
        return NCBoss
    elseif key == NC_CACHE_KEY_DUNGEON then
        return NCDungeon
    end

    return nil
end