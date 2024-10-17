-----------------------------------------------------
-- EVENT TABLES
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-- We subscribe to these events when we are in a group, and unsubscribe when we are not
core.dynamicEvents = {
    -- Enter / exit combat
    "PLAYER_REGEN_ENABLED",  -- Exit Combat
    "PLAYER_REGEN_DISABLED", -- Enter Combat

    -- Group
    "PLAYER_ROLES_ASSIGNED",    -- Role change
    "ENCOUNTER_START",          -- Boss start
    "ENCOUNTER_END",            -- Boss end
    "CHALLENGE_MODE_START",     -- M+ start
    "CHALLENGE_MODE_COMPLETED", -- M+ complete
    "CHALLENGE_MODE_RESET",     -- M+ reset
    "SCENARIO_CRITERIA_UPDATE", -- Follower dungeon
    "SCENARIO_COMPLETED",       -- Follower dungeon complete
    "INSPECT_READY",            -- Inspect ready

    -- Self
    -- "PLAYER_TARGET_CHANGED",
    "COMBAT_LOG_EVENT_UNFILTERED",
}

-- We always subscribe to these events
core.staticEvents = {
    "GROUP_ROSTER_UPDATE",
    "PLAYER_ENTERING_WORLD",
    "PLAYER_LEAVING_WORLD",
    "CHAT_MSG_ADDON",
    "ACTIVE_DELVE_DATA_UPDATE",
    "ZONE_CHANGED_NEW_AREA",
    "SCENARIO_CRITERIA_UPDATE",
    "SCENARIO_COMPLETED",
    "LFG_LIST_APPLICANT_UPDATED",
}
