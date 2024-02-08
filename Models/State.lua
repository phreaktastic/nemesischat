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
        rawClass = "",
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
        lastSpellReceived = {
            -- spellId,
            -- spellName,
            -- damage,
        },
        lastSpellCast = {
            -- spellId,
            -- spellName,
            -- damage,
        },
    },
    group = {
        players = {
            -- Uses the player object (core.stateDefaults.player)
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

NCState = DeepCopy(core.stateDefaults)

function NCState:Reset()
    NCState = DeepCopy(core.stateDefaults)
end

function NCState:ClearGroup()
    NCState.group = DeepCopy(core.stateDefaults.group)

    NCState:AddPlayerToGroup(GetMyName())
end

function NCState:AddPlayerToGroup(playerName)
    local isInGuild = UnitIsInMyGuild(playerName) ~= nil and playerName ~= GetMyName()
    local isNemesis = (NCConfig:GetNemesis(playerName) ~= nil or (NCRuntime:GetFriend(playerName) ~= nil and NCConfig:IsFlaggingFriendsAsNemeses()) or (isInGuild and NCConfig:IsFlaggingGuildmatesAsNemeses())) and playerName ~= GetMyName()
    local itemLevel = NemesisChat:GetItemLevel(playerName)
    local groupLead = UnitIsGroupLeader(playerName) ~= nil
    local class, rawClass = UnitClass(playerName)
    local data =  {
        guid = UnitGUID(playerName),
        isGuildmate = isInGuild,
        isFriend = NCRuntime:IsFriend(playerName),
        isNemesis = isNemesis,
        role = UnitGroupRolesAssigned(playerName),
        itemLevel = itemLevel,
        race = UnitRace(playerName),
        class = class,
        rawClass = rawClass,
        groupLead = groupLead,
        health = UnitHealth(playerName),
        maxHealth = UnitHealthMax(playerName),
        power = UnitPower(playerName),
        maxPower = UnitPowerMax(playerName),
        powerType = UnitPowerType(playerName),
        combat = false,
        dead = false,
        lastHeal = 0,
        lastDamage = 0,
        lastDamageAvoidable = false,
        lastSpellReceived = {},
        lastSpellCast = {},
    }

    NCState.group.players[playerName] = data
    NCState.group.size = NCState.group.size + 1

    if data.role == "TANK" then
        NCState.group.tank = playerName
    elseif data.role == "HEALER" then
        NCState.group.healer = playerName
    end

    if groupLead then
        NCState.group.lead = playerName
    end

    NCInfo:UpdatePlayerDropdown()

    self:CacheGroup()

    return data
end

function NCState:RemovePlayerFromGroup(playerName)
    NCState.group.players[playerName] = nil
    NCState.group.size = NCState.group.size - 1

    if NCState.group.tank == playerName then
        NCState.group.tank = ""
    elseif NCState.group.healer == playerName then
        NCState.group.healer = ""
    end

    if NCState.group.lead == playerName then
        NCState.group.lead = ""
    end

    NCInfo:UpdatePlayerDropdown()

    self:CacheGroup()
end

function NCState:CacheGroup()
    core.db.profile.cache.groupRoster = NCState.group.players
end