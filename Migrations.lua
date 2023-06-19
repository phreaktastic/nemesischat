-----------------------------------------------------
-- MIGRATIONS
-----------------------------------------------------
-- Migrations to update certain stored data to be  --
-- compatible with current versions.               --
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Old DB wipe. Pre-release so no need to migrate.
-----------------------------------------------------
if core.db.profile.messages ~= nil then
    core.db.profile.messages = nil
end
