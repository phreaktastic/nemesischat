-----------------------------------------------------
-- NEMESIS HELPERS
-- Handles nemesis-related functionality and tracking
-----------------------------------------------------
local addonName, core = ...

-----------------------------------------------------
-- Nemesis Retrieval
-----------------------------------------------------
function NemesisChat:GetNemeses()
    return NCConfig:GetNemeses()
end

function NemesisChat:GetRandomNemesis()
    return NemesisChat:GetRandomKey(NemesisChat:GetNemeses())
end

-----------------------------------------------------
-- Party Nemesis Management
-----------------------------------------------------
function NemesisChat:GetRandomPartyNemesis()
    local partyNemeses = NemesisChat:GetPartyNemeses()
    if not partyNemeses then return nil end
    return partyNemeses[NemesisChat:GetRandomKey(partyNemeses)]
end

function NemesisChat:GetPartyNemeses()
    local nemeses = {}
    for key, val in pairs(NCRuntime:GetGroupRoster()) do
        if val and val.isNemesis then
            nemeses[key] = key
        end
    end
    return nemeses
end

function NemesisChat:GetPartyNemesesCount()
    return NemesisChat:GetLength(NemesisChat:GetPartyNemeses())
end

-----------------------------------------------------
-- Guild Nemesis Management
-----------------------------------------------------
function NemesisChat:GetRandomGuildNemesis()
    local guildNemeses = NemesisChat:GetGuildNemeses()
    if not guildNemeses then return nil end
    return guildNemeses[NemesisChat:GetRandomKey(guildNemeses)]
end

function NemesisChat:GetGuildNemeses()
    local nemeses = {}
    for key, val in pairs(NCRuntime:GetGuildRoster()) do
        if val and val.isNemesis then
            nemeses[key] = key
        end
    end
    return nemeses
end

function NemesisChat:GetGuildNemesesCount()
    return NemesisChat:GetLength(NemesisChat:GetGuildNemeses())
end

function NemesisChat:HasGuildNemeses()
    return NemesisChat:GetGuildNemesesCount() > 0
end

-----------------------------------------------------
-- Bystander Management
-----------------------------------------------------
function NemesisChat:GetRandomPartyBystander()
    local partyBystanders = NemesisChat:GetPartyBystanders()
    if not partyBystanders then return nil end
    return partyBystanders[NemesisChat:GetRandomKey(partyBystanders)]
end

function NemesisChat:GetPartyBystanders()
    local bystanders = {}
    for key, val in pairs(NCRuntime:GetGroupRoster()) do
        if val and not val.isNemesis and key ~= GetMyName() then
            bystanders[key] = key
        end
    end
    return bystanders
end

function NemesisChat:GetRandomGuildBystander()
    local guildBystanders = NemesisChat:GetGuildBystanders()
    if not guildBystanders then return nil end
    return guildBystanders[NemesisChat:GetRandomKey(guildBystanders)]
end

function NemesisChat:GetGuildBystanders()
    local bystanders = {}
    for key, val in pairs(NCRuntime:GetGuildRoster()) do
        if key ~= GetMyName() and not val.isNemesis then
            bystanders[key] = key
        end
    end
    return bystanders
end

function NemesisChat:GetGuildBystandersCount()
    return NemesisChat:GetLength(NemesisChat:GetGuildBystanders())
end

function NemesisChat:HasGuildBystanders()
    return NemesisChat:GetGuildBystandersCount() > 0
end

function NemesisChat:GetPartyBystandersCount()
    return NemesisChat:GetLength(NemesisChat:GetPartyBystanders())
end

-----------------------------------------------------
-- State Checks
-----------------------------------------------------
function NemesisChat:HasNemeses()
    return NemesisChat:GetNemesesLength() > 0
end

function NemesisChat:HasPartyNemeses(forceFullLookup)
    if not forceFullLookup then
        return NCRuntime.hasNemesis == true
    end
    return NemesisChat:GetPartyNemesesCount() > 0
end

function NemesisChat:HasPartyBystanders(forceFullLookup)
    if not forceFullLookup then
        return NCRuntime.hasBystander == true
    end
    return NemesisChat:GetPartyBystandersCount() > 0
end

function NemesisChat:GetNemesesLength()
    return NemesisChat:GetLength(NemesisChat:GetNemeses())
end
