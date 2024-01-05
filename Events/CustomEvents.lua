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
	if NemesisChat:ShouldExitEventHandler() then
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

function NemesisChat:PLAYER_JOINS_GROUP(playerName, isNemesis)
    if IsInRaid() then
        NCEvent:SetCategory("RAID")
    else
        NCEvent:SetCategory("GROUP")
    end

    NCEvent:SetEvent("JOIN")

    if isNemesis then
        NCEvent:SetTarget("NEMESIS")
        NCEvent:SetNemesis(playerName)
        NCEvent:RandomBystander()
    elseif playerName ~= GetMyName() then
        NCEvent:SetTarget("BYSTANDER")
        NCEvent:SetBystander(playerName)
        NCEvent:RandomNemesis()
    else
        NCEvent:SetTarget("SELF")
        NCEvent:RandomNemesis()
        NCEvent:RandomBystander()
    end

    NemesisChat:HandleEvent()
end

function NemesisChat:PLAYER_LEAVES_GROUP(playerName, isNemesis)
    if IsInRaid() then
        NCEvent:SetCategory("RAID")
    else
        NCEvent:SetCategory("GROUP")
    end

    NCEvent:SetEvent("LEAVE")

    if isNemesis then
        NCEvent:SetTarget("NEMESIS")
        NCEvent:SetNemesis(playerName)
        NCEvent:RandomBystander()
    elseif playerName ~= GetMyName() then
        NCEvent:SetTarget("BYSTANDER")
        NCEvent:SetBystander(playerName)
        NCEvent:RandomNemesis()
    else
        NCEvent:SetTarget("SELF")
        NCEvent:RandomNemesis()
        NCEvent:RandomBystander()
    end

    NemesisChat:HandleEvent()
end

function NemesisChat:GUILD_PLAYER_LOGIN(playerName, isNemesis)
    NCEvent:SetCategory("GUILD")
    NCEvent:SetEvent("LOGIN")

    if isNemesis then
        NCEvent:SetTarget("NEMESIS")
        NCEvent:SetNemesis(playerName)
        NCEvent:RandomBystander()
    elseif playerName ~= GetMyName() then
        NCEvent:SetTarget("BYSTANDER")
        NCEvent:SetBystander(playerName)
        NCEvent:RandomNemesis()
    else
        NCEvent:SetTarget("SELF")
        NCEvent:RandomNemesis()
        NCEvent:RandomBystander()
    end

    NemesisChat:HandleEvent()
end

function NemesisChat:GUILD_PLAYER_LOGOUT(playerName, isNemesis)
    NCEvent:SetCategory("GUILD")
    NCEvent:SetEvent("LOGOUT")

    if isNemesis then
        NCEvent:SetTarget("NEMESIS")
        NCEvent:SetNemesis(playerName)
        NCEvent:RandomBystander()
    elseif playerName ~= GetMyName() then
        NCEvent:SetTarget("BYSTANDER")
        NCEvent:SetBystander(playerName)
        NCEvent:RandomNemesis()
    else
        NCEvent:SetTarget("SELF")
        NCEvent:RandomNemesis()
        NCEvent:RandomBystander()
    end

    NemesisChat:HandleEvent()
end

function NemesisChat:CheckGuild()
    local onlineGuildMembers = {}

    -- Populate onlineGuildMembers with the current online guild members
    for i = 1, GetNumGuildMembers() do
        local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, isMobile, _, _, guid = GetGuildRosterInfo(i)

        if isOnline and not isMobile then
            onlineGuildMembers[name] = {
                guid = guid,
                isNemesis = NCConfig:GetNemesis(name) ~= nil,
            }
        end
    end

    -- Compare onlineGuildMembers to core.runtime.guild, to see who has come online or gone offline
    for name, data in pairs(core.runtime.guild) do
        if not onlineGuildMembers[name] then
            -- Player has gone offline
            core.runtime.guild[name] = nil

            NemesisChat:GUILD_PLAYER_LOGOUT(name, NCConfig:GetNemesis(name) ~= nil)
        end
    end

    for name, data in pairs(onlineGuildMembers) do
        if not core.runtime.guild[name] then
            -- Player has come online
            local isNemesis = NCConfig:GetNemesis(name) ~= nil

            core.runtime.guild[name] = {
                name = name,
                isNemesis = isNemesis,
            }

            NemesisChat:GUILD_PLAYER_LOGIN(name, isNemesis)
        end
    end

    -- Update the guild roster
    core.runtime.guild = DeepCopy(onlineGuildMembers)

    -- Update the guild roster in the DB cache, in case a reload occurs
    core.db.profile.cache.guild = DeepCopy(onlineGuildMembers)
    core.db.profile.cache.guildTime = GetTime()
end