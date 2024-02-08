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
    friends = {},
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
    local isNemesis = (NCConfig:GetNemesis(playerName) ~= nil or (NCState:IsFriend(playerName) and NCConfig:IsFlaggingFriendsAsNemeses()) or (isInGuild and NCConfig:IsFlaggingGuildmatesAsNemeses())) and playerName ~= GetMyName()
    local itemLevel = NemesisChat:GetItemLevel(playerName)
    local groupLead = UnitIsGroupLeader(playerName) ~= nil
    local class, rawClass = UnitClass(playerName)
    local data =  {
        guid = UnitGUID(playerName),
        isGuildmate = isInGuild,
        isFriend = NCState:IsFriend(playerName),
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

function NCState:GetGuildNemeses()
    local nemeses = {}

    for playerName, player in pairs(NCState.guild) do
        if player.isNemesis then
            table.insert(nemeses, playerName)
        end
    end

    return nemeses
end

function NCState:GetRandomGroupNemesis()
    local nemeses = NCState:GetGroupNemeses()

    if #nemeses > 0 then
        return nemeses[math.random(#nemeses)]
    end

    return ""
end

function NCState:GetRandomGuildNemesis()
    local nemeses = NCState:GetGuildNemeses()

    if #nemeses > 0 then
        return nemeses[math.random(#nemeses)]
    end

    return ""
end

function NCState:GetNonExcludedNemesis()
    local nemeses

        if NCController:GetEventType() == NC_EVENT_TYPE_GROUP then
            nemeses = NCState:GetGroupNemeses()
        else
            nemeses = NCState:GetGuildNemeses()
        end

        for player, _ in pairs(nemeses) do
            if not tContains(NCController.excludedNemeses, player) then
                return player
            end
        end

        return nil
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

function NCState:GetGuildBystanders()
    local bystanders = {}

    for playerName, player in pairs(NCState.guild) do
        if not player.isNemesis then
            table.insert(bystanders, playerName)
        end
    end

    return bystanders

end

function NCState:GetRandomGroupBystander()
    local bystanders = NCState:GetGroupBystanders()

    if #bystanders > 0 then
        return bystanders[math.random(#bystanders)]
    end

    return ""
end

function NCState:GetRandomGuildBystander()
    local bystanders = NCState:GetGuildBystanders()

    if #bystanders > 0 then
        return bystanders[math.random(#bystanders)]
    end

    return ""
end

function NCState:GetNonExcludedBystander()
    local bystanders

    if NCController:GetEventType() == NC_EVENT_TYPE_GROUP then
        bystanders = NCState:GetGroupBystanders()
    else
        bystanders = NCState:GetGuildBystanders()
    end

    for player, _ in pairs(bystanders) do
        if not tContains(NCController.excludedBystanders, player) then
            return player
        end
    end

    return nil
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

function NCState:UpsertGuildPlayer(playerName, isOnline, isNemesis, guid)
    local changed = false

    if not NCState.guild[playerName] then
        NCState.guild[playerName] = {
            isOnline = isOnline,
            isNemesis = isNemesis,
            guid = guid,
        }
    else
        changed = NCState.guild[playerName].isOnline ~= isOnline

        NCState.guild[playerName].isOnline = isOnline
        NCState.guild[playerName].isNemesis = isNemesis
        NCState.guild[playerName].guid = guid
    end

    return changed
end

function NCState:PopulateFriends()
    local _, onlineBnetFriends = BNGetNumFriends()

    NCRuntime:ClearFriends()

    for i = 1, onlineBnetFriends do
        local info = C_BattleNet.GetFriendAccountInfo(i)
        if info and info.gameAccountInfo then
            local character, client = info.gameAccountInfo.characterName, info.gameAccountInfo.clientProgram or ""

            -- Only add WoW characters
            if character and client == BNET_CLIENT_WOW then
                -- Account for realm names, since our roster does as well
                character = Ambiguate(character, "guild")

                NCState:AddFriend(character)
            end
        end
    end

    NCCache:Push(NC_CACHE_KEY_FRIENDS, NCState.friends)
end

function NCState:RestoreFriends()
    local friends = NCCache:Pull(NC_CACHE_KEY_FRIENDS)

    if friends then
        NCState.friends = friends
    end
end

function NCState:AddFriend(playerName)
    if not NCState.friends then NCState.friends = {} end

    tinsert(NCState.friends, playerName)
end

function NCState:IsFriend(playerName)
    if not NCState.friends then NCState.friends = {} end

    return tContains(NCState.friends, playerName)
end

function NCState:CheckGuild()
    if not IsInGuild() then
        return
    end

    local totalGuildMembers, onlineGuildMembers = GetNumGuildMembers()

    -- The guild roster is empty
    if not totalGuildMembers or totalGuildMembers <= 1 then
        return
    end

    if not NemesisChat.guildRosterIndex then
        NemesisChat.guildRosterIndex = 1
    end

    core.db.global.guildRow = {}

    local cursor = NemesisChat.guildRosterIndex
    local chunk = 10
    local maxIndex = math.min(totalGuildMembers, NemesisChat.guildRosterIndex + chunk)

    for i = cursor, maxIndex do
        core.db.global.guildRow.name, _, _, _, _, _, _, _, core.db.global.guildRow.isOnline, _, _, _, _, core.db.global.guildRow.isMobile, _, _, core.db.global.guildRow.guid = GetGuildRosterInfo(i)
        core.db.global.guildRow.memberOnline = core.db.global.guildRow.isOnline and not core.db.global.guildRow.isMobile
        core.db.global.guildRow.name = Ambiguate(core.db.global.guildRow.name, "guild")
        core.db.global.guildRow.isNemesis = NCConfig:GetNemesis(core.db.global.guildRow.name) ~= nil

        NCState:UpdateGuildPlayer(core.db.global.guildRow.name, core.db.global.guildRow.memberOnline, core.db.global.guildRow.isNemesis, core.db.global.guildRow.guid)
    end

    -- Update the guild roster in the DB cache, in case a reload occurs
    NCCache:Push(NC_CACHE_KEY_GUILD, core.runtime.guild)

    -- Reset the guild roster index if it's at the end of the list
    if maxIndex >= GetNumGuildMembers() then
        NemesisChat.guildRosterIndex = 1
    else
        NemesisChat.guildRosterIndex = maxIndex + chunk
    end
end

function NCState:RestoreGuild()
    local guild = NCCache:Pull(NC_CACHE_KEY_GUILD)

    if guild then
        NCState.guild = guild
    end
end

function NCState:UpdateGuildPlayer(playerName, isOnline, isNemesis, guid)
    local changed = NCState:UpsertGuildPlayer(playerName, isOnline, isNemesis, guid)

    if changed then
        if isOnline then
            NemesisChat:GUILD_PLAYER_LOGIN(playerName, isNemesis)
        else
            NemesisChat:GUILD_PLAYER_LOGOUT(playerName, isNemesis)
        end
    end
end

function NCState:RestoreAll()
    NCState:RestoreGroup()
    NCState:RestoreFriends()
    NCState:RestoreGuild()
end