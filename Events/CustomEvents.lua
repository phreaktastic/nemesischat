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

-- Event handling
function NemesisChat:HandleEvent()
    if NemesisChat:ShouldExitEventHandler() then
        return
    end

    NCController:ConfigMessage()

    if not NCController:ValidMessage() then
        return
    end

    NCController:Handle()
end

-- A player joins the group we are currently in
function NemesisChat:PLAYER_JOINS_GROUP(playerName, isNemesis)
    if playerName == "Brann Bronzebeard" and not NCConfig:IsAllowingBrannMessages() then
        NCEvent:Initialize()
        return
    end

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

-- A player leaves the group we are currently in
function NemesisChat:PLAYER_LEAVES_GROUP(playerName, isNemesis)
    if playerName == "Brann Bronzebeard" and not NCConfig:IsAllowingBrannMessages() then
        NCEvent:Initialize()
        return
    end

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

-- A player in the guild logs in
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

-- A player in the guild logs out
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

function NemesisChat:START_DUNGEON()
    NCEvent:Initialize()
    NCDungeon:Reset()
    NCDungeon:Start()
end

function NemesisChat:END_DUNGEON()
    NCEvent:Initialize()
    NCDungeon:End()
end

function NemesisChat:GROUP_DISBANDED()
    -- Stub
end

-----------------------------------------------------
-- Guild Sync
-----------------------------------------------------
--- While this is not actually an event, it is used
--- to sync the guild roster and fire custom events.
-----------------------------------------------------

local lastFullUpdate = 0
local updateInterval = 60 -- Full update every 60 seconds

function NemesisChat:CheckGuild()
    if not IsInGuild() then
        core.runtime.guild = {}
        return
    end

    local function IsNemesis(name)
        return core.db.profile.nemeses[name]
    end

    local currentTime = GetTime()
    local totalMembers, onlineMembers = GetNumGuildMembers()
    local needFullUpdate = currentTime - lastFullUpdate > updateInterval

    if needFullUpdate then
        local guildRoster = {}
        for i = 1, totalMembers do
            local name, rank, _, _, _, _, _, _, online = GetGuildRosterInfo(i)
            if name then
                guildRoster[name] = {rank = rank, online = online, isNemesis = IsNemesis(name)}
                if core.runtime.guild[name] then
                    if core.runtime.guild[name].online ~= online then
                        _ = online and NemesisChat:GUILD_PLAYER_LOGIN(name, IsNemesis(name)) or NemesisChat:GUILD_PLAYER_LOGOUT(name, IsNemesis(name))
                    end
                else
                    -- NemesisChat:TriggerCustomEvent("GUILD_MEMBER_ADDED", name)
                end
            end
        end

        for name, info in pairs(core.runtime.guild) do
            if not guildRoster[name] then
                -- NemesisChat:TriggerCustomEvent("GUILD_MEMBER_REMOVED", name)
                core.runtime.guild[name] = nil
            end
        end

        core.runtime.guild = guildRoster
        lastFullUpdate = currentTime
    else
        -- Quick update for online status changes
        for i = 1, onlineMembers do
            local name, rank, _, _, _, _, _, _, online = GetGuildRosterInfo(i)
            if name and core.runtime.guild[name] then
                if core.runtime.guild[name].online ~= online then
                    core.runtime.guild[name].online = online
                    NemesisChat:TriggerCustomEvent(online and "GUILD_MEMBER_LOGGED_IN" or "GUILD_MEMBER_LOGGED_OUT", name)
                end
            end
        end
    end

    core.db.profile.cache.guild = core.runtime.guild
end