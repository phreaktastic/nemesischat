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

-- 2024-01-29: Wipes leavers and low performers. Many people were added while this was in development, so it's
-- necessary to wipe the data to avoid errors. This migration is only compatible with versions less than 2.0.0.
-- 2024-02-06: Reset key to wipe all data again.
NCMigration:New("20240206")
    :AddPathToErase("leavers")
    :AddPathToErase("lowPerformers")
    :SetLessThanVersion("2.0.0")