-----------------------------------------------------
-- CORE HELPERS
-- Core initialization and management
-----------------------------------------------------
local addonName, core = ...
local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")
local E = ElvUI and unpack(ElvUI) or nil

-- Import frequently used globals
local GetTime = GetTime
local UnitIsDead = UnitIsDead
local UnitName = UnitName
local tContains = tContains
local IsInGroup = IsInGroup

-----------------------------------------------------
-- Core Registration
-----------------------------------------------------
function NemesisChat:RegisterPrefixes()
    C_ChatInfo.RegisterAddonMessagePrefix("NC_LEAVERS")
    C_ChatInfo.RegisterAddonMessagePrefix("NC_LOWPERFORMERS")
end

function NemesisChat:RegisterToasts()
    NemesisChat:RegisterToast("Pull", function(toast, player, mob)
        toast:SetTitle("|cffff4040Potentially Dangerous Pull|r")
        toast:SetText("|cffffffff" .. player .. " pulled " .. mob .. "!|r")
        toast:SetIconTexture([[Interface\ICONS\INV_10_Engineering2_BoxOfBombs_Dangerous_Color3]])
        toast:SetUrgencyLevel("emergency")
    end)
end

-----------------------------------------------------
-- Core Object Management
-----------------------------------------------------
function NemesisChat:InstantiateCore()
    NCConfig:Initialize()
    NCController:Initialize()
    NCSpell = DeepCopy(core.runtimeDefaults.ncSpell)
    NemesisChat:InstantiateSpell()
    NCEvent:Initialize()

    -- Load cached data if available
    self:RestoreCachedData()
    NCDungeon:CheckCache()
end

function NemesisChat:RestoreCachedData()
    -- Restore guild cache
    if NCConfig:GetPath("cache.guild") then
        core.runtime.guild = DeepCopy(NCConfig:GetPath("cache.guild") or GetWeakTable())
    end

    -- Restore friends cache
    if NCConfig:GetPath("cache.friends") then
        core.runtime.friends = DeepCopy(NCConfig:GetPath("cache.friends") or GetWeakTable())
    end

    -- Restore group roster if cache is still valid
    if self:IsGroupRosterCacheValid() then
        core.runtime.groupRoster = DeepCopy(NCConfig:GetPath("cache.groupRoster") or GetWeakTable())
    end
end

function NemesisChat:IsGroupRosterCacheValid()
    return NCConfig:GetPath("cache.groupRoster") and
           GetTime() - NCConfig:GetPath("cache.groupRosterTime") <= core.runtime.dbCacheExpiration
end

-----------------------------------------------------
-- Addon Initialization
-----------------------------------------------------
function NemesisChat:InitIfEnabled()
    if not IsNCEnabled() then return end

    self:InitializeTimers()
    self:PopulateFriends()
    self:RegisterPrefixes()
    self:RegisterToasts()
    self:SilentGroupSync()
    NCRuntime:UpdateInitializationTime()
    core.LFGHandler:Initialize()

    C_Timer.After(1, function()
        NCInfo:Initialize()
    end)
end

-----------------------------------------------------
-- Data Management
-----------------------------------------------------
function NemesisChat:ClearAllData()
    -- Clear all segment data
    self:ClearSegmentData()

    -- Clear runtime data
    self:ClearRuntimeData()

    -- Reset components
    self:ResetComponents()

    -- Clear caches and reinitialize
    wipe(NCConfig:GetPath("cache"))
    self:InstantiateCore()
    core.LFGHandler:Initialize()

    -- Resync and update
    self:SilentGroupSync()
    self:CheckGroup()
    NCInfo.CurrentPlayer = UnitName("player")
    NCInfo:Update()

    NemesisChat:Print("All data has been cleared and reset.")
end

function NemesisChat:ClearSegmentData()
    if NCDungeon then
        NCDungeon:ClearCache()
        NCDungeon:Reset()
    end
    if NCBoss then NCBoss:Reset() end
    if NCCombat then NCCombat:Reset() end
end

function NemesisChat:ClearRuntimeData()
    NCRuntime:ClearGroupRoster()
    NCRuntime:ClearPlayerStates()
    NCRuntime:ClearPulledUnits()
    NCRuntime:ClearPetOwners()
    NCRuntime:ClearLastCompletedDungeon()
end

function NemesisChat:ResetComponents()
    NCEvent:Reset()
    NCController:Reset()
    NCSpell:Initialize()
    if NCDungeon.Rankings then
        NCDungeon.Rankings:Reset(NCDungeon)
    end
end
