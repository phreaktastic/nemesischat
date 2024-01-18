-----------------------------------------------------
-- STATE
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- State logic and data for everything we interact with
-----------------------------------------------------

core.stateDefaults = {
    player = {
        health = 0,
        maxHealth = 0,
        power = 0,
        maxPower = 0,
        powerType = 0,
        combat = false,
        dead = false,
        lastHeal = 0,
        lastDamage = 0,
        lastSpellReceived = {},
        lastSpellCast = {},
    },
    group = {},
    dungeon = {},
    boss = {},
    guild = {},
}