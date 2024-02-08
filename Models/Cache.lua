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

NCCache = {}

function NCCache:Push(key, data)
    local isSegment = data.IsSegment and data.IsSegment or false

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

function NCCache:RestoreSegment(key, data)
    if not core.db.profile.cache then core.db.profile.cache = {} end

    if core.db.profile.cache[key] and core.db.profile.cache[key].Restore then
        core.db.profile.cache[key].Restore(data)
    else
        core.db.profile.cache[key] = NCSegment:New(data:GetIdentifier())
    end
end