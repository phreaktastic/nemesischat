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
        isTank = false,
        isHealer = false,
        isLead = false,
        role = "",
        itemLevel = 0,
        race = "",
        class = "",
        rawClass = "",
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
    guild = {},
    dungeon = {},
    boss = {},
}

NCState = DeepCopy(core.stateDefaults)

function NCState:Reset()
    -- We don't want to alter state functions, just the data
    for k, v in pairs(core.stateDefaults) do
        NCState[k] = DeepCopy(v)
    end
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
        isTank = UnitGroupRolesAssigned(playerName) == "TANK",
        isHealer = UnitGroupRolesAssigned(playerName) == "HEALER",
        role = UnitGroupRolesAssigned(playerName),
        itemLevel = itemLevel,
        race = UnitRace(playerName),
        class = class,
        rawClass = rawClass,
        isLead = groupLead,
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
    NCCache:Push(NC_CACHE_KEY_GROUP, NCState.group)
end

function NCState:RestoreGroup()
    local group = NCCache:Pull(NC_CACHE_KEY_GROUP)

    if group then
        NCState.group = group
    end
end

function NCState:UpdatePlayerHealth(playerName)
    local player = NCState.group.players[playerName]

    if player then
        player.health = UnitHealth(playerName)
        player.maxHealth = UnitHealthMax(playerName)
    end
end

function NCState:UpdatePlayerPower(playerName)
    local player = NCState.group.players[playerName]

    if player then
        player.power = UnitPower(playerName)
        player.maxPower = UnitPowerMax(playerName)
    end
end

function NCState:UpdatePlayerCombat(playerName)
    local player = NCState.group.players[playerName]

    if player then
        player.combat = UnitAffectingCombat(playerName)
    end
end

function NCState:UpdatePlayerDead(playerName)
    local player = NCState.group.players[playerName]

    if player then
        player.dead = UnitIsDeadOrGhost(playerName)
    end
end

function NCState:UpdatePlayerRole(playerName)
    local player = NCState.group.players[playerName]

    if player then
        player.role = UnitGroupRolesAssigned(playerName)
    end
end

function NCState:UpdateAllPlayerRoles()
    for playerName, player in pairs(NCState.group.players) do
        player.role = UnitGroupRolesAssigned(playerName)
        player.isLead = UnitIsGroupLeader(playerName) ~= nil
        player.isTank = player.role == "TANK"
        player.isHealer = player.role == "HEALER"
    end
end

function NCState:UpdatePlayerItemLevel(playerName)
    local player = NCState.group.players[playerName]

    if player then
        player.itemLevel = NemesisChat:GetItemLevel(playerName)
    end
end

function NCState:UpdatePlayerLastHeal(playerName)
    local player = NCState.group.players[playerName]

    if player then
        player.lastHeal = GetTime()
    end
end

function NCState:UpdatePlayerLastDamage(playerName, spellId)
    local player = NCState.group.players[playerName]
    local isAvoidable = (GTFO and GTFO.SpellID[tostring(spellId)] ~= nil)

    if player then
        player.lastDamage = GetTime()
        player.lastDamageAvoidable = isAvoidable
    end
end

function NCState:UpdatePlayerLastSpellReceived(playerName, spellId, spellName, damage)
    local player = NCState.group.players[playerName]

    if player then
        player.lastSpellReceived = {
            spellId = spellId,
            spellName = spellName,
            damage = damage,
        }
    end
end

function NCState:UpdatePlayerLastSpellCast(playerName, spellId, spellName, damage)
    local player = NCState.group.players[playerName]

    if player then
        player.lastSpellCast = {
            spellId = spellId,
            spellName = spellName,
            damage = damage,
        }
    end
end

function NCState:GetPlayerState(playerName)
    return NCState.group.players[playerName]
end

function NCState:GetGroupState()
    return NCState.group
end

function NCState:GetGroupSizeOthers()
    return NCState.group.size - 1
end

function NCState:GetGroupSize()
    return NCState.group.size
end

function NCState:GetGroupLead()
    return NCState.group.lead
end

function NCState:GetGroupTank()
    return NCState.group.tank
end

function NCState:GetGroupHealer()
    return NCState.group.healer
end

function NCState:GetGroupPlayers()
    return NCState.group.players
end

function NCState:GetGroupPlayerNames()
    local players = {}

    for playerName, _ in pairs(NCState.group.players) do
        table.insert(players, playerName)
    end

    return players
end

function NCState:GetGroupNemeses()
    local nemeses = {}

    for playerName, player in pairs(NCState.group.players) do
        if player.isNemesis then
            table.insert(nemeses, playerName)
        end
    end

    return nemeses
end

function NCState:GetGroupGuildmates()
    local guildmates = {}

    for playerName, player in pairs(NCState.group.players) do
        if player.isGuildmate then
            table.insert(guildmates, playerName)
        end
    end

    return guildmates
end

function NCState:GetGroupFriends()
    local friends = {}

    for playerName, player in pairs(NCState.group.players) do
        if player.isFriend then
            table.insert(friends, playerName)
        end
    end

    return friends
end

function NCState:GetGroupBystanders()
    local bystanders = {}

    for playerName, player in pairs(NCState.group.players) do
        if not player.isNemesis then
            table.insert(bystanders, playerName)
        end
    end

    return bystanders
end

function NCState:GetPlayerGUID(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.guid
    end

    return ""
end

function NCState:GetPlayerIsGuildmate(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.isGuildmate
    end

    return false
end

function NCState:GetPlayerIsFriend(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.isFriend
    end

    return false
end

function NCState:GetPlayerIsNemesis(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.isNemesis
    end

    return false
end

function NCState:GetPlayerIsTank(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.isTank
    end

    return false
end

function NCState:GetPlayerIsHealer(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.isHealer
    end

    return false
end

function NCState:GetPlayerIsLead(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.isLead
    end

    return false
end

function NCState:GetPlayerRole(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.role
    end

    return ""
end

function NCState:GetPlayerItemLevel(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.itemLevel
    end

    return 0
end

function NCState:GetPlayerRace(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.race
    end

    return ""
end

function NCState:GetPlayerClass(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.class
    end

    return ""
end

function NCState:GetPlayerRawClass(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.rawClass
    end

    return ""
end

function NCState:GetPlayerHealth(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.health
    end

    return 0
end

function NCState:GetPlayerMaxHealth(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.maxHealth
    end

    return 0
end

function NCState:GetPlayerHealthPercentage(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return (player.health / player.maxHealth) * 100
    end

    return 0
end

function NCState:GetPlayerPower(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.power
    end

    return 0
end

function NCState:GetPlayerMaxPower(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.maxPower
    end

    return 0
end

function NCState:GetPlayerPowerPercentage(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return (player.power / player.maxPower) * 100
    end

    return 0
end

function NCState:GetPlayerPowerType(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.powerType
    end

    return 0
end

function NCState:GetPlayerCombat(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.combat
    end

    return false
end

function NCState:GetPlayerDead(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.dead
    end

    return false
end

function NCState:GetPlayerLastHeal(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.lastHeal
    end

    return 0
end

function NCState:GetPlayerLastDamage(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.lastDamage
    end

    return 0
end

function NCState:GetPlayerLastDamageAvoidable(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.lastDamageAvoidable
    end

    return false
end

function NCState:GetPlayerLastSpellReceived(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.lastSpellReceived
    end

    return {}
end

function NCState:GetPlayerLastSpellCast(playerName)
    local player = NCState.group.players[playerName]

    if player then
        return player.lastSpellCast
    end

    return {}
end

function NCState:GetPlayerIsInGroup(playerName)
    return NCState.group.players[playerName] ~= nil
end

function NCState:GetPlayerIsInGroupAndNotMe(playerName)
    return NCState.group.players[playerName] ~= nil and not UnitIsUnit(playerName, "player")
end

