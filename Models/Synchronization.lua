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
    syncDataTimer = NemesisChat:ScheduleRepeatingTimer("TransmitSyncData", 60),
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
    if core.db.profile.leavers == nil or core.db.profile.leaversSerialized == nil or NCDungeon:IsActive() then
        return
    end

    local _, online = GetNumGuildMembers()

    if online > 1 and NCSync:GetLastLeaverSyncType() ~= "GUILD" then
        NCSync:Transmit("NC_LEAVERS", core.db.profile.leaversSerialized, "GUILD")
        NCSync:SetLastLeaverSyncType("GUILD")
    else
        NCSync:Transmit("NC_LEAVERS", core.db.profile.leaversSerialized, "YELL")
        NCSync:SetLastLeaverSyncType("YELL")
    end
end

function NCSync:TransmitLowPerformers()
    if core.db.profile.lowPerformers == nil or core.db.profile.lowPerformersSerialized == nil or NCDungeon:IsActive() then
        return
    end

    local _, online = GetNumGuildMembers()

    if online > 1 and NCSync:GetLastLowPerformerSyncType() ~= "GUILD" then
        NCSync:Transmit("NC_LOWPERFORMERS", core.db.profile.lowPerformersSerialized, "GUILD")
        NCSync:SetLastLowPerformerSyncType("GUILD")
    else
        NCSync:Transmit("NC_LOWPERFORMERS", core.db.profile.lowPerformersSerialized, "YELL")
        NCSync:SetLastLowPerformerSyncType("YELL")
    end
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

    if not core.db.global.lastSync then
        core.db.global.lastSync = {}
    end

    -- We attempt to sync fairly often, but we don't want to actually sync that much. We also don't want to sync if we're in combat.
    if sender == myFullName or NCCombat:IsActive() or (core.db.global.lastSync[sender] and GetTime() - core.db.global.lastSync[sender] <= 1800) then
        return
    end

    core.db.global.lastSync[sender] = GetTime()

    NemesisChat:Print("Synchronizing data received from " .. Ambiguate(sender, "guild"))

    core.runtime.sync = {}

    core.runtime.sync.decoded = LibDeflate:DecodeForWoWAddonChannel(payload)
    if not core.runtime.sync.decoded then return end
    core.runtime.sync.decompressed = LibDeflate:DecompressDeflate(core.runtime.sync.decoded)
    if not core.runtime.sync.decompressed then return end
    core.runtime.sync.success, core.runtime.sync.data = LibSerialize:Deserialize(core.runtime.sync.decompressed)
    if not core.runtime.sync.success then return end

    payload = nil
    core.runtime.sync.decoded = nil
    core.runtime.sync.decompressed = nil

    if prefix == "NC_LEAVERS" then
        NCSync:ProcessLeavers(core.runtime.sync.data)
    elseif prefix == "NC_LOWPERFORMERS" then
        NCSync:ProcessLowPerformers(core.runtime.sync.data)
    end

    core.runtime.sync.data = nil
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
            core.runtime.sync.combinedRow = ArrayMerge(core.db.profile[configKey][key], val)
            core.db.profile[configKey][key] = core.runtime.sync.combinedRow
        end
    end

    core.runtime.sync.combinedRow = {}
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