-----------------------------------------------------
-- COMBAT LOG HANDLER
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local addonName, core = ...;
local CombatEventHandler = {}
core.CombatEventHandler = CombatEventHandler

local LibPlayerSpells = LibStub("LibPlayerSpells-1.0")

local eliteMobCache = GetWeakTable()

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
local COMBATLOG_OBJECT_TYPE_NPC = COMBATLOG_OBJECT_TYPE_NPC
local COMBATLOG_OBJECT_TYPE_PET = COMBATLOG_OBJECT_TYPE_PET
local COMBATLOG_OBJECT_TYPE_GUARDIAN = COMBATLOG_OBJECT_TYPE_GUARDIAN
local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER
local GetTime = GetTime
local UnitName = UnitName
local string_find = string.find
local IsInGroup = IsInGroup
local bit_band = bit.band
local IsInRaid = IsInRaid
local UnitIsUnconscious = UnitIsUnconscious
local UnitGUID = UnitGUID
local GetSpellInfo = _G.C_Spell.GetSpellInfo

local NC_PULL_EVENT_ATTACK = NC_PULL_EVENT_ATTACK
local NC_PULL_EVENT_AGGRO = NC_PULL_EVENT_AGGRO
local NC_PULL_EVENT_PET = NC_PULL_EVENT_PET

local CROWD_CTRL = LibPlayerSpells.constants.CROWD_CTRL
local KNOCKBACK = LibPlayerSpells.constants.KNOCKBACK
local SNARE = LibPlayerSpells.constants.SNARE
local DISPEL = LibPlayerSpells.constants.DISPEL
local SURVIVAL = LibPlayerSpells.constants.SURVIVAL
local COOLDOWN = LibPlayerSpells.constants.COOLDOWN

local GTFO = _G["GTFO"]

local eventInfo = {}

local eventPatterns = {
    ["SPELL_INTERRUPT"] = true,
    ["SPELL_CAST_SUCCESS"] = true,
    ["SPELL_CAST_START"] = true,
    ["SPELL_HEAL"] = true,
    ["SPELL_PERIODIC_HEAL"] = true,
    ["SPELL_PERIODIC_DAMAGE"] = true,
    ["SPELL_DAMAGE"] = true,
    ["SWING_DAMAGE"] = true,
    ["RANGE_DAMAGE"] = true,
    ["PARTY_KILL"] = true,
    ["UNIT_DIED"] = true,
    ["SPELL_SUMMON"] = true,
    ["SPELL_AURA_APPLIED"] = true,
    ["SPELL_AURA_APPLIED_DOSE"] = true,
}

local ignoredCCSpells = {
    [111400] = true, -- Burning Rush
    [7870] = true,   -- Lesser Invisibility from Succubus
}

local damageTable = {
    SWING_DAMAGE = 1,
    RANGE_DAMAGE = 4,
    SPELL_DAMAGE = 4,
    SPELL_PERIODIC_DAMAGE = 4
}

local damageLookup = {
    ["SWING_DAMAGE"] = true,
    ["RANGE_DAMAGE"] = true,
    ["SPELL_DAMAGE"] = true,
    ["SPELL_PERIODIC_DAMAGE"] = true
}

local groupRoster = NCRuntime:GetGroupRoster()

local function GetDamageAmount(event, arg1, arg2, arg3, arg4)
    local index = damageTable[event]
    if index == 1 then
        return arg1 or 0
    elseif index == 4 then
        return arg4 or 0
    else
        return 0
    end
end

local function IsEliteMob(name, guid)
    if not name or not guid then return false end

    -- Check cache first
    if eliteMobCache[name] ~= nil then
        return eliteMobCache[name]
    end

    local tooltip = GameTooltip
    if not tooltip then
        eliteMobCache[name] = false
        return false
    end

    tooltip:SetHyperlink("unit:" .. guid)

    for i = 2, tooltip:NumLines() do
        local line = _G["GameTooltipTextLeft" .. i]
        if line and line:GetText() and (string_find(line:GetText(), "Elite") or string_find(line:GetText(), "Boss")) then
            eliteMobCache[name] = true
            return true
        end
    end

    eliteMobCache[name] = false
    return false
end

local function handlePetEvent(eventInfo)
    if bit_band(eventInfo.sourceFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0 or bit_band(eventInfo.sourceFlags, COMBATLOG_OBJECT_TYPE_GUARDIAN) ~= 0 then
        if eventInfo.subEvent == "UNIT_DIED" then
            return false
        end
        local petOwner = CombatEventHandler:GetPetOwner(eventInfo.sourceGUID)

        if petOwner then
            eventInfo.sourceName = NCRuntime:GetPlayerNameFromGuid(petOwner)

            if not groupRoster[eventInfo.sourceName] and not groupRoster[eventInfo.destName] then
                return false
            end
        else
            return false
        end
    end
    return true
end

local function handlePullEvent(pullPlayerName, mobName)
    if NCRuntime:GetLastUnsafePullToastDelta() > 1.5 then
        if NCConfig:IsReportingPulls_Realtime() then
            local channel = NemesisChat:GetActualChannel(NCConfig:GetReportingPulls_Channel() or "YELL")
            SendChatMessage("Nemesis Chat: " .. UnitName(pullPlayerName) .. " pulled " .. mobName, channel)
        end

        if NCConfig:IsReportingPulls_Toast() then
            NemesisChat:SpawnToast("Pull", pullPlayerName, mobName)
            NCRuntime:UpdateLastUnsafePullToast()
        end
    end

    NCRuntime:SetLastUnsafePull(UnitName(pullPlayerName), mobName)
    NCSegment:GlobalAddPull(UnitName(pullPlayerName))
end

local function handleDamageEvent(subEvent, sourceName, destName, misc1, misc2, damage)
    local isAvoidable = (GTFO and GTFO.SpellID[tostring(misc1)] ~= nil)

    if isAvoidable then
        NCSegment:GlobalAddAvoidableDamage(damage, destName)
    end

    NCRuntime:SetPlayerStateValue(destName, "lastDamageAvoidable", isAvoidable)

    NCEvent:Damage(sourceName, destName, misc1, misc2, damage, isAvoidable)

    if NCEvent:EventHasMessages() then
        NemesisChat:HandleEvent()
        NCEvent:Reset()
        NCEvent:SetCategory("COMBATLOG")
    end
end

local function handleSpecificEvents(subEvent, sourceName, destName, misc1, misc2, misc4)
    if subEvent == "SPELL_INTERRUPT" then
        NCEvent:Interrupt(sourceName, destName, misc1, misc2, misc4)
    elseif subEvent == "SPELL_CAST_SUCCESS" then
        NCEvent:Spell(sourceName, destName, misc1, misc2)
    elseif subEvent == "SPELL_CAST_START" then
        NCEvent:SpellStart(sourceName, destName, misc1, misc2)
    elseif subEvent == "SPELL_HEAL" or subEvent == "SPELL_PERIODIC_HEAL" then
        NCEvent:Heal(sourceName, destName, misc1, misc2, misc4)
    elseif subEvent == "PARTY_KILL" then
        NCEvent:Kill(sourceName, destName)
    elseif subEvent == "UNIT_DIED" and groupRoster[destName] then
        NCEvent:Death(destName)
        NCSegment:GlobalAddDeath(destName)
    elseif subEvent == "SPELL_SUMMON" then
        if groupRoster[sourceName] then
            NCRuntime:AddPetOwner(eventInfo.destGUID, sourceName)
        end
    elseif subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_APPLIED_DOSE" then
        NCEvent:Aura(sourceName, destName, misc1, misc2)
    end
end

-----------------------------------------------------
-----------------------------------------------------
--- Combat Event Handler - Main Entry Point       ---
-----------------------------------------------------
-----------------------------------------------------

function CombatEventHandler:Fire()
    if not groupRoster or not next(groupRoster) then
        groupRoster = NCRuntime:GetGroupRoster()
        return
    end

    eventInfo.time, eventInfo.subEvent, eventInfo.hidecaster, eventInfo.sourceGUID, eventInfo.sourceName, eventInfo.sourceFlags, eventInfo.sourceRaidFlags, eventInfo.destGUID, eventInfo.destName, eventInfo.destFlags, eventInfo.destRaidFlags, eventInfo.misc1, eventInfo.misc2, eventInfo.misc3, eventInfo.misc4 =
        CombatLogGetCurrentEventInfo()

    if (not eventInfo.sourceName and not eventInfo.destName) or
       (not groupRoster[eventInfo.sourceName] and not groupRoster[eventInfo.destName]) then
        wipe(eventInfo)
        return
    end

    if not handlePetEvent(eventInfo) then
        wipe(eventInfo)
        return
    end

    CombatEventHandler:ActionScoring()

    NCEvent:Reset()
    NCEvent:SetCategory("COMBATLOG")

    if not IsInRaid() then
        local isPull, pullType, pullPlayerName, mobName = CombatEventHandler:IsPull()
        if isPull and pullPlayerName then
            handlePullEvent(pullPlayerName, mobName)
        end
    end

    local subEvent, sourceName, destName, misc1, misc2, misc4 = eventInfo.subEvent, eventInfo.sourceName,
        eventInfo.destName, eventInfo.misc1, eventInfo.misc2, eventInfo.misc4
    local damage = damageLookup[subEvent] and GetDamageAmount(subEvent, misc1, misc4) or nil

    if damage and damage > 0 and groupRoster[destName] then
        handleDamageEvent(subEvent, sourceName, destName, misc1, misc2, damage)
    end

    if eventPatterns[subEvent] then
        handleSpecificEvents(subEvent, sourceName, destName, misc1, misc2, misc4)
    end

    if NCEvent:EventHasMessages() then
        NemesisChat:HandleEvent()
    end

    wipe(eventInfo)
end

-- Originally taken from https://github.com/logicplace/who-pulled/blob/master/WhoPulled/WhoPulled.lua, with heavy modifications (it's entirely different now, but I appreciate the original authors <3)
--- @return boolean, number|nil, string|nil, string|nil
function CombatEventHandler:IsPull()
    if not IsInGroup() or (NCBoss:IsActive() and NCDungeon:IsActive()) or IsInRaid() then
        return false
    end

    local event, sguid, sname, sflags, dguid, dname, dflags, misc1, misc4 =
        eventInfo.subEvent, eventInfo.sourceGUID, eventInfo.sourceName, eventInfo.sourceFlags,
        eventInfo.destGUID, eventInfo.destName, eventInfo.destFlags, eventInfo.misc1, eventInfo.misc4

    if not groupRoster[sname] and not groupRoster[dname] then
        return false
    end

    if dname == sname or string_find(event, "_RESURRECT", 1, true) or string_find(event, "_CREATE", 1, true) then
        return false
    end

    local isSwingOrRangeOrSpell = event == "SWING_DAMAGE" or event == "RANGE_DAMAGE" or event == "SPELL_DAMAGE" or
        event == "SPELL_CAST_SUCCESS"

    if not isSwingOrRangeOrSpell then
        return false
    end

    local damageAmount = GetDamageAmount(event, misc1, misc4)

    local function IsInvalidPlayer(player, pulledUnit)
        if not player then return true end
        if player.role == "TANK" then
            NCRuntime:AddPulledUnit(pulledUnit or dname)
            return true
        end
        return false
    end

    local isPlayerSource = bit_band(sflags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
    local isNPCDest = bit_band(dflags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0
    local isPlayerDest = bit_band(dflags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
    local isNPCSource = bit_band(sflags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0
    local isPlayerControlledSource = bit_band(sflags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0
    local isPlayerControlledDest = bit_band(dflags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0

    if isPlayerSource and isNPCDest then
        -- Player attacking mob
        local player = groupRoster[sname]
        if IsInvalidPlayer(player) then return false end

        if not UnitIsUnconscious(dguid) and damageAmount > 0 and CombatEventHandler:UnitIsNotPulled(dguid) and IsEliteMob(dname, dguid) then
            return true, NC_PULL_EVENT_ATTACK, sname, dname
        end
    elseif isPlayerDest and isNPCSource then
        -- Mob attacking player
        local player = groupRoster[dname]
        if IsInvalidPlayer(player, sname) then return false end

        if CombatEventHandler:UnitIsNotPulled(sguid) and IsEliteMob(sname, sguid) then
            return true, NC_PULL_EVENT_AGGRO, dname, sname
        end
    elseif isPlayerControlledSource and isNPCDest then
        -- Player's pet attacking mob
        local pname = CombatEventHandler:GetPetOwner(sguid)
        local pullname = pname ~= "Unknown" and pname or (sname .. " (pet)")

        local player = groupRoster[pname]
        if IsInvalidPlayer(player) then return false end

        if not UnitIsUnconscious(dguid) and damageAmount > 0 and CombatEventHandler:UnitIsNotPulled(dguid) and IsEliteMob(dname, dguid) then
            return true, NC_PULL_EVENT_PET, pullname, dname
        end
    elseif isPlayerControlledDest and isNPCSource then
        -- Mob attacking player's pet
        local pname = CombatEventHandler:GetPetOwner(dguid)
        local pullname = pname ~= "Unknown" and pname or (dname .. " (pet)")

        if CombatEventHandler:UnitIsNotPulled(sguid) and IsEliteMob(sname, sguid) then
            return true, NC_PULL_EVENT_AGGRO, pullname, sname
        end
    elseif string_find(event, "_SUMMON") then
        local player = groupRoster[sname]
        if player then
            NCRuntime:AddPetOwner(dguid, sname)
        end
    end

    return false
end

function CombatEventHandler:ActionScoring()
    local spellId, sourceName = eventInfo.misc1, eventInfo.sourceName

    if not IsInGroup() or not sourceName or not groupRoster[sourceName] then
        return
    end

    local flags = LibPlayerSpells:GetSpellInfo(spellId)

    if not flags then return end

    if not ignoredCCSpells[spellId] and (bit_band(flags, CROWD_CTRL) ~= 0 or bit_band(flags, KNOCKBACK) ~= 0) then
        NCSegment:GlobalAddCrowdControl(sourceName)
    end

    if bit_band(flags, DISPEL) ~= 0 then
        NCSegment:GlobalAddDispell(sourceName)
    end

    if bit_band(flags, SURVIVAL) ~= 0 and bit_band(flags, COOLDOWN) ~= 0 and eventInfo.subEvent == "SPELL_CAST_SUCCESS" then
        -- We can't get the cooldown until the cast resolves -- we need to wait 0.1 second
        C_Timer.After(0.1, function()
            local cdInfo = C_Spell.GetSpellCooldown(spellId)
            -- @TODO: Magic number -- this needs to either be a config value or a constant
            if cdInfo.isEnabled and cdInfo.duration and cdInfo.duration >= 55 then
                NCSegment:GlobalAddDefensive(sourceName)
                NCRuntime:SetPlayerStateValue(sourceName, "lastDefensive", GetTime())
            end
        end)
    end
end

-- Get the owner of a pet from cache, and if it doesn't exist in cache, set it and return the owner
function CombatEventHandler:GetPetOwner(petGuid)
    local owner = NCRuntime:GetPetOwner(petGuid)
    if not owner then
        owner = CombatEventHandler:ScanTooltipForPetOwner(petGuid)
        if owner then
            NCRuntime:AddPetOwner(petGuid, owner)
        end
    end
    return owner
end

-- Pull the owner of a pet from the tooltip
function CombatEventHandler:ScanTooltipForPetOwner(guid)
    if not guid then return "Unknown" end

    local tooltip = GameTooltip
    if not tooltip then return "Unknown" end

    tooltip:SetHyperlink("unit:" .. guid)

    local petOwnerPatterns = {
        "^(.+)'s ", -- English
        "^(.+) de ", -- French
        "^(.+)s ", -- German
        "^(.+)의 ", -- Korean
        "^(.+)的", -- Chinese
        "^(.+) 的", -- Traditional Chinese
        "^(.+) ", -- Russian
    }

    for i = 1, tooltip:NumLines() do
        local line = _G["GameTooltipTextLeft" .. i]
        if line and line:GetText() then
            for _, pattern in ipairs(petOwnerPatterns) do
                local ownerName = line:GetText():match(pattern)
                if ownerName then
                    local ownerGuid = UnitGUID(ownerName)
                    if ownerGuid then
                        return ownerGuid
                    end
                end
            end
        end
    end

    return "Unknown"
end

function CombatEventHandler:UnitIsNotPulled(guid)
    NCRuntime:CheckPulledUnits()

    if NCRuntime:GetPulledUnit(guid) == nil then
        NCRuntime:AddPulledUnit(guid)
        return true
    end

    return false
end
