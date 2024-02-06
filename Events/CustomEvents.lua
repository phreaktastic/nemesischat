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
    if not IsInGuild() then
        return
    end

    local totalGuildMembers, onlineGuildMembers = GetNumGuildMembers()

    -- The guild roster is empty
    if totalGuildMembers <= 1 then
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

        -- Strip realm name from name
        core.db.global.guildRow.name = Ambiguate(core.db.global.guildRow.name, "guild")

        core.db.global.guildRow.isNemesis = NCConfig:GetNemesis(core.db.global.guildRow.name) ~= nil

        if core.runtime.guild[core.db.global.guildRow.name] then
            local changed = core.runtime.guild[core.db.global.guildRow.name].online ~= core.db.global.guildRow.memberOnline

            if changed then
                core.runtime.guild[core.db.global.guildRow.name].online = core.db.global.guildRow.memberOnline
            
                if core.db.global.guildRow.memberOnline then
                    NemesisChat:GUILD_PLAYER_LOGIN(core.db.global.guildRow.name, core.db.global.guildRow.isNemesis)
                else
                    NemesisChat:GUILD_PLAYER_LOGOUT(core.db.global.guildRow.name, core.db.global.guildRow.isNemesis)
                end
            end
        else
            core.runtime.guild[core.db.global.guildRow.name] = {
                online = core.db.global.guildRow.memberOnline,
                isNemesis = core.db.global.guildRow.isNemesis,
                guid = core.db.global.guildRow.guid
            }
        end
    end

    -- Update the guild roster in the DB cache, in case a reload occurs
    core.db.profile.cache.guild = DeepCopy(core.runtime.guild)
    core.db.profile.cache.guildTime = GetTime()

    -- Reset the guild roster index if it's at the end of the list
    if maxIndex >= GetNumGuildMembers() then
        NemesisChat.guildRosterIndex = 1
    else
        NemesisChat.guildRosterIndex = maxIndex + chunk
    end
end