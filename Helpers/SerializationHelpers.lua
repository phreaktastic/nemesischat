-----------------------------------------------------
-- SERIALIZATION HELPERS
-- Handles data encoding/decoding and compression
-----------------------------------------------------
local addonName, core = ...
local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")

-----------------------------------------------------
-- Leaver Data Serialization
-----------------------------------------------------
function NemesisChat:AddLeaver(guid)
    -- Initialize leavers table if needed
    local leavers = NCConfig:GetLeavers() or {}
    if not leavers[guid] then
        leavers[guid] = {}
    end

    NCConfig:AddLeaver(guid)
    NemesisChat:EncodeLeavers()
end

function NemesisChat:EncodeLeavers()
    -- Clear encoded data if no leavers exist
    if not NCConfig:GetLeavers() or NCConfig:GetLeaversCount() == 0 then
        NCConfig:SetLeaversEncoded(nil)
        return
    end

    -- Serialize and compress data
    local serialized = LibSerialize:Serialize(NCConfig:GetLeavers())
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed)

    -- Store encoded data and clean up intermediates
    NCConfig:SetLeaversEncoded(encoded)
    NCConfig:SetLeaversSerialized(nil)
    NCConfig:SetLeaversCompressed(nil)
end

-----------------------------------------------------
-- Low Performer Data Serialization
-----------------------------------------------------
function NemesisChat:AddLowPerformer(guid)
    -- Initialize low performers table if needed
    local lowPerformers = NCConfig:GetLowPerformers() or {}
    if not lowPerformers[guid] then
        lowPerformers[guid] = {}
    end

    -- Add timestamp rounded to nearest 10 seconds
    table.insert(lowPerformers[guid], math.ceil(GetTime() / 10) * 10)
    NCConfig:SetLowPerformers(lowPerformers)
    NemesisChat:EncodeLowPerformers()
end

function NemesisChat:EncodeLowPerformers()
    -- Clear encoded data if no low performers exist
    if not NCConfig:GetLowPerformers() or NCConfig:GetLowPerformersCount() == 0 then
        NCConfig:SetLowPerformersEncoded(nil)
        return
    end

    -- Serialize and compress data
    local serialized = LibSerialize:Serialize(NCConfig:GetLowPerformers())
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed)

    -- Store encoded data and clean up intermediates
    NCConfig:SetLowPerformersEncoded(encoded)
    NCConfig:SetLowPerformersSerialized(nil)
    NCConfig:SetLowPerformersCompressed(nil)
end

-----------------------------------------------------
-- Combined Data Management
-----------------------------------------------------
function NemesisChat:EncodeAddonMessageData()
    -- Ensure both data types are encoded
    if not NemesisChat:GetLeaversEncoded() then
        NemesisChat:EncodeLeavers()
    end

    if not NemesisChat:GetLowPerformersEncoded() then
        NemesisChat:EncodeLowPerformers()
    end
end

-----------------------------------------------------
-- Data Count Utilities
-----------------------------------------------------
function NemesisChat:LeaveCount(guid)
    return NCConfig:GetLeaverCount(guid)
end

function NemesisChat:LowPerformerCount(guid)
    return NCConfig:GetLowPerformerCount(guid)
end
