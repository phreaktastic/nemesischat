local addonName, core = ...
local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")

local AddonCommunication = {}
core.AddonCommunication = AddonCommunication

local NCRuntime = NCRuntime
local NCDungeon = NCDungeon
local NCCombat = NCCombat

local GetNumGuildMembers = GetNumGuildMembers
local setmetatable = setmetatable
local UnitName = UnitName
local GetNormalizedRealmName = GetNormalizedRealmName
local GetTime = GetTime
local Ambiguate = Ambiguate
local wipe = wipe
local pairs = pairs
local type = type
local string_find = string.find
local ArrayMerge = ArrayMerge


local syncTable = setmetatable({}, {__mode = "kv"})

function AddonCommunication:TransmitSyncData()
    if NCRuntime:GetLastSyncType() == "" or NCRuntime:GetLastSyncType() == nil or NCRuntime:GetLastSyncType() == "LEAVERS" then
        NCRuntime:SetLastSyncType("LOWPERFORMERS")
        AddonCommunication:TransmitLowPerformers()
    else
        NCRuntime:SetLastSyncType("LEAVERS")
        AddonCommunication:TransmitLeavers()
    end
end

function AddonCommunication:TransmitLeavers()
    if core.db.profile.leavers == nil or core.db.profile.leaversSerialized == nil or NCDungeon:IsActive() then
        return
    end

    local _, online = GetNumGuildMembers()

    if online > 1 and NCRuntime:GetLastLeaverSyncType() ~= "GUILD" then
        AddonCommunication:Transmit("NC_LEAVERS", core.db.profile.leaversSerialized, "GUILD")
        NCRuntime:SetLastLeaverSyncType("GUILD")
    else
        AddonCommunication:Transmit("NC_LEAVERS", core.db.profile.leaversSerialized, "YELL")
        NCRuntime:SetLastLeaverSyncType("YELL")
    end
end

function AddonCommunication:TransmitLowPerformers()
    if core.db.profile.lowPerformers == nil or core.db.profile.lowPerformersSerialized == nil or NCDungeon:IsActive() then
        return
    end

    local _, online = GetNumGuildMembers()

    if online > 1 and NCRuntime:GetLastLowPerformerSyncType() ~= "GUILD" then
        AddonCommunication:Transmit("NC_LOWPERFORMERS", core.db.profile.lowPerformersSerialized, "GUILD")
        NCRuntime:SetLastLowPerformerSyncType("GUILD")
    else
        AddonCommunication:Transmit("NC_LOWPERFORMERS", core.db.profile.lowPerformersSerialized, "YELL")
        NCRuntime:SetLastLowPerformerSyncType("YELL")
    end
end

function AddonCommunication:Transmit(prefix, payload, distribution, target)
    if target and distribution == "WHISPER" then
        self:SendCommMessage(prefix, payload, distribution, target)
    else
        self:SendCommMessage(prefix, payload, distribution)
    end
end

function AddonCommunication:ProcessLeavers(leavers)
    core:Print("Processing leavers.")

    AddonCommunication:ProcessReceivedData("leavers", leavers)

    leavers = nil
end

function AddonCommunication:ProcessLowPerformers(lowPerformers)
    core:Print("Processing low performers.")

    AddonCommunication:ProcessReceivedData("lowPerformers", lowPerformers)

    lowPerformers = nil
end

function AddonCommunication:ProcessReceivedData(configKey, data)
    if data == nil or type(data) ~= "table" then
        return
    end

    if core.db.profile[configKey] == nil then
        core.db.profile[configKey] = setmetatable({}, {__mode = "kv"})
    end

    local count = 0
    local combinedRow = setmetatable({}, {__mode = "kv"})

    for key,val in pairs(data) do
        count = count + 1
        if core.db.profile[configKey][key] == nil then
            core.db.profile[configKey][key] = val
        else
            combinedRow = ArrayMerge(core.db.profile[configKey][key], val)
            core.db.profile[configKey][key] = combinedRow
        end
    end
end

function AddonCommunication:OnCommReceived(prefix, payload, distribution, sender)
    if not prefix or not string_find(prefix, "NC_") then return end

    local myFullName = UnitName("player") .. "-" .. GetNormalizedRealmName()

    if not core.db.global.lastSync then
        core.db.global.lastSync = setmetatable({}, {__mode = "kv"})
    end

    -- We attempt to sync fairly often, but we don't want to actually sync that much. We also don't want to sync if we're in combat.
    if sender == myFullName or NCCombat:IsActive() or (core.db.global.lastSync[sender] and (GetTime() - core.db.global.lastSync[sender] <= 1800)) then
        return
    end

    core.db.global.lastSync[sender] = GetTime()

    core:Print("Synchronizing data received from " .. Ambiguate(sender, "guild"))

    syncTable.decoded = LibDeflate:DecodeForWoWAddonChannel(payload)
    if not syncTable.decoded then return end
    syncTable.decompressed = LibDeflate:DecompressDeflate(syncTable.decoded)
    if not syncTable.decompressed then return end
    syncTable.success, syncTable.data = LibSerialize:Deserialize(syncTable.decompressed)
    if not syncTable.success then return end

    payload = nil
    syncTable.decoded = nil
    syncTable.decompressed = nil

    if prefix == "NC_LEAVERS" then
        AddonCommunication:ProcessLeavers(syncTable.data)
    elseif prefix == "NC_LOWPERFORMERS" then
        AddonCommunication:ProcessLowPerformers(syncTable.data)
    end

    wipe(syncTable)
end
