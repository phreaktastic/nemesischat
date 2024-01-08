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
    if totalGuildMembers == 0 or totalGuildMembers == 1 then
        return
    end

    if not NemesisChat.guildRosterIndex then
        NemesisChat.guildRosterIndex = 1
    end

    local cursor = NemesisChat.guildRosterIndex
    local chunk = 10
    local maxIndex = math.min(totalGuildMembers, NemesisChat.guildRosterIndex + chunk)

    for i = cursor, maxIndex do
        local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, isMobile, _, _, guid = GetGuildRosterInfo(i)
        local memberOnline = isOnline and not isMobile

        -- Strip realm name from name
        name = Ambiguate(name, "guild")

        local isNemesis = NCConfig:GetNemesis(name) ~= nil

        if core.runtime.guild[name] then
            local changed = core.runtime.guild[name].online ~= memberOnline

            if changed then
                core.runtime.guild[name].online = memberOnline
            
                if memberOnline then
                    NemesisChat:GUILD_PLAYER_LOGIN(name, isNemesis)
                else
                    NemesisChat:GUILD_PLAYER_LOGOUT(name, isNemesis)
                end
            end
        else
            core.runtime.guild[name] = {
                online = memberOnline,
                isNemesis = isNemesis,
                guid = guid
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