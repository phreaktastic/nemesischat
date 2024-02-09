-----------------------------------------------------
-- SYNCHRONIZATION
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Logic for synchronizing data between clients
-----------------------------------------------------

local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")

C_ChatInfo.RegisterAddonMessagePrefix("NC_LEAVERS")
C_ChatInfo.RegisterAddonMessagePrefix("NC_LOWPERFORMERS")

NCSync = {
    lastSyncType = "",
    lastLeaverSynctype = "",
    lastLowPerformerSyncType = "",
    sync = {},
    syncDataTimer = NemesisChat:ScheduleRepeatingTimer("TransmitSyncData", 60),
    leaverDb = NCDB:New("leavers"),
    leaverDbSerialized = NCDB:New("leaversSerialized"),
    lowPerformerDb = NCDB:New("lowPerformers"),
    lowPerformerDbSerialized = NCDB:New("lowPerformersSerialized"),
    lastSyncDb = NCDB:New("lastSync", "global"),
}

function NCSync:GetLastSyncType()
    return self.lastSyncType
end

function NCSync:SetLastSyncType(type)
    self.lastSyncType = type
end

function NCSync:GetLastLeaverSyncType()
    return self.lastLeaverSynctype
end

function NCSync:SetLastLeaverSyncType(type)
    self.lastLeaverSynctype = type
end

function NCSync:GetLastLowPerformerSyncType()
    return self.lastLowPerformerSyncType
end

function NCSync:SetLastLowPerformerSyncType(type)
    self.lastLowPerformerSyncType = type
end

function NCSync:TransmitSyncData()
    if NCSync:GetLastSyncType() == "" or NCSync:GetLastSyncType() == nil or NCSync:GetLastSyncType() == "LEAVERS" then
        NCSync:SetLastSyncType("LOWPERFORMERS")
        NCSync:TransmitLowPerformers()
    else
        NCSync:SetLastSyncType("LEAVERS")
        NCSync:TransmitLeavers()
    end
end

function NCSync:TransmitLeavers()
    if self.leaverDb:IsEmpty() or self.leaverDbSerialized:IsEmpty() or NCDungeon:IsActive() then
        return
    end

    local _, online = GetNumGuildMembers()
    local channel

    if online > 1 and NCSync:GetLastLeaverSyncType() ~= "GUILD" then
        channel = "GUILD"
    else
        channel = "YELL"
    end

    NCSync:Transmit("NC_LEAVERS", self.leaverDbSerialized:Get(), channel)
    NCSync:SetLastLeaverSyncType(channel)
end

function NCSync:TransmitLowPerformers()
    if self.lowPerformerDb:IsEmpty() or self.lowPerformerDbSerialized:IsEmpty() or NCDungeon:IsActive() then
        return
    end

    local _, online = GetNumGuildMembers()
    local channel

    if online > 1 and NCSync:GetLastLowPerformerSyncType() ~= "GUILD" then
        channel = "GUILD"
    else
        channel = "YELL"
    end

    NCSync:Transmit("NC_LOWPERFORMERS", self.lowPerformerDbSerialized:Get(), channel)
    NCSync:SetLastLowPerformerSyncType(channel)
end

function NCSync:Transmit(prefix, payload, distribution, target)
    if target and distribution == "WHISPER" then
        NemesisChat:SendCommMessage(prefix, payload, distribution, target)
    else
        NemesisChat:SendCommMessage(prefix, payload, distribution)
    end
end

function NCSync:OnCommReceived(prefix, payload, distribution, sender)
    if not prefix or not string.find(prefix, "NC_") then return end

    local myFullName = UnitName("player") .. "-" .. GetNormalizedRealmName()

    -- We attempt to sync fairly often, but we don't want to actually sync that much. We also don't want to sync if we're in combat.
    if sender == myFullName or NCCombat:IsActive() or (self.lastSyncDb:Get() and GetTime() - self.lastSyncDb:Get() <= 1800) then
        return
    end

    self.lastSyncDb:Set(GetTime())

    NemesisChat:Print("Synchronizing data received from " .. Ambiguate(sender, "guild"))

    self.sync = {}

    self.sync.decoded = LibDeflate:DecodeForWoWAddonChannel(payload)
    if not self.sync.decoded then return end
    self.sync.decompressed = LibDeflate:DecompressDeflate(self.sync.decoded)
    if not self.sync.decompressed then return end
    self.sync.success, self.sync.data = LibSerialize:Deserialize(self.sync.decompressed)
    if not self.sync.success then return end

    payload = nil
    self.sync.decoded = nil
    self.sync.decompressed = nil

    if prefix == "NC_LEAVERS" then
        NCSync:ProcessLeavers(self.sync.data)
    elseif prefix == "NC_LOWPERFORMERS" then
        NCSync:ProcessLowPerformers(self.sync.data)
    end

    self.sync.data = nil
end

function NCSync:ProcessLeavers(leavers)
    NemesisChat:Print("Processing leavers.")

    NCSync:ProcessReceivedData("leavers", leavers)

    leavers = nil
end

function NCSync:ProcessLowPerformers(lowPerformers)
    NemesisChat:Print("Processing low performers.")

    NCSync:ProcessReceivedData("lowPerformers", lowPerformers)

    lowPerformers = nil
end

function NCSync:ProcessReceivedData(configKey, data)
    if data == nil or type(data) ~= "table" then
        return
    end

    if core.db.profile[configKey] == nil then
        core.db.profile[configKey] = {}
    end

    local count = 0

    for key,val in pairs(data) do
        count = count + 1
        if core.db.profile[configKey][key] == nil then
            core.db.profile[configKey][key] = val
        else
            self.sync.combinedRow = ArrayMerge(core.db.profile[configKey][key], val)
            core.db.profile[configKey][key] = self.sync.combinedRow
        end
    end

    self.sync.combinedRow = {}
end

function NCSync:PrintNumberOfLeavers()
    NemesisChat:Print("Leavers:", #NemesisChat:GetKeys(core.db.profile.leavers))
end

function NCSync:PrintNumberOfLowPerformers()
    NemesisChat:Print("Low Performers:", #NemesisChat:GetKeys(core.db.profile.lowPerformers))
end

function NCSync:PrintSyncKeys()
    NemesisChat:Print("LEAVER KEYS")

    NemesisChat:Print_r(NemesisChat:GetKeys(core.db.profile.leavers))

    for key,val in pairs(core.db.profile.leavers) do
        NemesisChat:Print(key, ":", #val)
    end

    NemesisChat:Print("LOW PERFORMER KEYS")

    NemesisChat:Print_r(NemesisChat:GetKeys(core.db.profile.lowPerformers))

    for key,val in pairs(core.db.profile.lowPerformers) do
        NemesisChat:Print(key, ":", #val)
    end
end