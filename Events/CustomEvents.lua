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
    if core.db.profile.ai and not NCController:ValidMessage() then
        NCController:AIMessage()
    end

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
