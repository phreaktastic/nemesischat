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
        guid = "",
        isGuildmate = false,
        isFriend = false,
        isNemesis = false,
        role = "",
        itemLevel = 0,
        race = "",
        class = "",
        groupLead = false,
        health = 0,
        maxHealth = 0,
        power = 0,
        maxPower = 0,
        powerType = 0,
        combat = false,
        dead = false,
        lastHeal = 0,
        lastDamage = 0,
        lastDamageAvoidable = false,
        lastSpellReceived = {},
        lastSpellCast = {},
    },
    group = {
        players = {

        },
        size = 0,
        lead = "",
        tank = "",
        healer = "",

    },
    dungeon = {},
    boss = {},
    guild = {},
}