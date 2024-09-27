-----------------------------------------------------
-- CUSTOM EVENTS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Event handling for Nemesis Chat events
-----------------------------------------------------

function NemesisChat:HandleEvent()
    -- Exit if we're not in a group, the event is not supported, config isn't setup, etc.
	if NCCombatLogEvent:ShouldExitEventHandler() then
        return
    end

    -- Try to pull a configured message first
    NCController:ConfigMessage()

    -- If AI messages are enabled, use them if a configured message couldn't be found
    -- if core.db.profile.ai and not NCController:ValidMessage() then
    --     NCController:AIMessage()
    -- end

    -- If we still don't have a message, bail
    if not NCController:ValidMessage() then
        return
    end

    NCController:Handle()
end

--- Handles the event when a player joins a group.
-- @param playerName The name of the player who joined.
-- @param isNemesis A boolean indicating if the player is a nemesis.
function NemesisChat:PLAYER_JOINS_GROUP(playerName, isNemesis)
    if not self:ShouldProcessBrann(playerName) then return end

    local category = IsInRaid() and "RAID" or "GROUP"
    self:HandlePlayerEvent("JOIN", category, playerName, isNemesis)
end

--- Handles the event when a player leaves a group.
-- @param playerName The name of the player who left.
-- @param isNemesis A boolean indicating if the player is a nemesis.
function NemesisChat:PLAYER_LEAVES_GROUP(playerName, isNemesis)
    if not self:ShouldProcessBrann(playerName) then return end

    local category = IsInRaid() and "RAID" or "GROUP"
    self:HandlePlayerEvent("LEAVE", category, playerName, isNemesis)
end

--- Handles the event when a guild player logs in.
-- @param playerName The name of the player who logged in.
-- @param isNemesis A boolean indicating if the player is a nemesis.
function NemesisChat:GUILD_PLAYER_LOGIN(playerName, isNemesis)
    self:HandlePlayerEvent("LOGIN", "GUILD", playerName, isNemesis)
end

--- Helper function to process player events.
-- @param event The event type ("JOIN", "LEAVE", "LOGIN", etc.).
-- @param category The category of the event ("GROUP", "RAID", "GUILD").
-- @param playerName The name of the player involved in the event.
-- @param isNemesis A boolean indicating if the player is a nemesis.
function NemesisChat:HandlePlayerEvent(event, category, playerName, isNemesis)
    NCEvent:Initialize()
    NCEvent:SetCategory(category)
    NCEvent:SetEvent(event)

    if playerName == GetMyName() then
        -- The player involved is yourself
        NCEvent:SetTarget("SELF")
        NCEvent:RandomNemesis()
        NCEvent:RandomBystander()
    elseif isNemesis then
        -- The player involved is a nemesis
        NCEvent:SetTarget("NEMESIS")
        NCEvent:SetNemesis(playerName)
        NCEvent:RandomBystander()
    else
        -- The player involved is a bystander
        NCEvent:SetTarget("BYSTANDER")
        NCEvent:SetBystander(playerName)
        NCEvent:RandomNemesis()
    end

    self:HandleEvent()
end

--- Determines whether to process events related to Brann Bronzebeard.
-- @param playerName The name of the player involved.
-- @return True if the event should be processed; false otherwise.
function NemesisChat:ShouldProcessBrann(playerName)
    if playerName == "Brann Bronzebeard" and not NCConfig:IsAllowingBrannMessages() then
        NCEvent:Initialize()
        return false
    end
    return true
end


--- Handles the event when a guild player logs out.
-- @param playerName The name of the player who logged out.
-- @param isNemesis A boolean indicating if the player is a nemesis.
function NemesisChat:GUILD_PLAYER_LOGOUT(playerName, isNemesis)
    NCEvent:SetCategory("GUILD")
    NCEvent:SetEvent("LOGOUT")

    if playerName == GetMyName() then
        -- The player logging out is yourself
        NCEvent:SetTarget("SELF")
        NCEvent:RandomNemesis()
        NCEvent:RandomBystander()
    elseif isNemesis then
        -- The player logging out is a nemesis
        NCEvent:SetTarget("NEMESIS")
        NCEvent:SetNemesis(playerName)
        NCEvent:RandomBystander()
    else
        -- The player logging out is a bystander
        NCEvent:SetTarget("BYSTANDER")
        NCEvent:SetBystander(playerName)
        NCEvent:RandomNemesis()
    end

    NemesisChat:HandleEvent()
end

function NemesisChat:START_DUNGEON()
    -- Stub for non-mythic support
end

function NemesisChat:END_DUNGEON()
    -- Stub for non-mythic support
end

function NemesisChat:CheckGuild()
    if not IsInGuild() then return end

    local totalGuildMembers = GetNumGuildMembers()
    if totalGuildMembers <= 1 then return end  -- No guild members to process

    self.guildRosterIndex = self.guildRosterIndex or 1
    local cursor = self.guildRosterIndex
    local chunkSize = 10
    local maxIndex = math.min(totalGuildMembers, cursor + chunkSize - 1)

    for i = cursor, maxIndex do
        local memberInfo = self:GetGuildMemberInfo(i)
        self:UpdateGuildMember(memberInfo)
    end

    self:UpdateGuildCache()

    -- Update the guildRosterIndex for the next iteration
    if maxIndex >= totalGuildMembers then
        self.guildRosterIndex = 1
    else
        self.guildRosterIndex = maxIndex + 1
    end
end

function NemesisChat:GetGuildMemberInfo(index)
    local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, isMobile, _, _, guid = GetGuildRosterInfo(index)
    name = Ambiguate(name, "guild")
    local memberOnline = isOnline and not isMobile
    local isNemesis = NCConfig:GetNemesis(name) ~= nil

    return {
        name = name,
        online = memberOnline,
        isNemesis = isNemesis,
        guid = guid,
    }
end

function NemesisChat:UpdateGuildMember(memberInfo)
    local name = memberInfo.name
    local existingMember = core.runtime.guild[name]

    if existingMember then
        if existingMember.online ~= memberInfo.online then
            existingMember.online = memberInfo.online

            if memberInfo.online then
                self:GUILD_PLAYER_LOGIN(name, memberInfo.isNemesis)
            else
                self:GUILD_PLAYER_LOGOUT(name, memberInfo.isNemesis)
            end
        end
    else
        core.runtime.guild[name] = {
            online = memberInfo.online,
            isNemesis = memberInfo.isNemesis,
            guid = memberInfo.guid,
        }
    end
end

function NemesisChat:UpdateGuildCache()
    core.db.profile.cache.guild = DeepCopy(core.runtime.guild)
    core.db.profile.cache.guildTime = GetTime()
end
