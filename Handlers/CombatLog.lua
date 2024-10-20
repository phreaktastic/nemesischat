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

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
local COMBATLOG_OBJECT_TYPE_NPC = COMBATLOG_OBJECT_TYPE_NPC
local COMBATLOG_OBJECT_TYPE_PET = COMBATLOG_OBJECT_TYPE_PET
local COMBATLOG_OBJECT_TYPE_GUARDIAN = COMBATLOG_OBJECT_TYPE_GUARDIAN
local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER
local GetTime = GetTime
local UnitName = UnitName
local tContains = tContains
local string_find = string.find
local IsInGroup = IsInGroup
local UnitInParty = UnitInParty
local bit_band = bit.band
local IsInRaid = IsInRaid
local UnitIsUnconscious = UnitIsUnconscious
local CreateFrame = CreateFrame
local WorldFrame = WorldFrame
local setmetatable = setmetatable
local format = string.format
local UnitGUID = UnitGUID

local NC_PULL_EVENT_ATTACK = NC_PULL_EVENT_ATTACK
local NC_PULL_EVENT_AGGRO = NC_PULL_EVENT_AGGRO
local NC_PULL_EVENT_PET = NC_PULL_EVENT_PET

local CROWD_CTRL = { LibPlayerSpells.constants.CROWD_CTRL }
local KNOCKBACK = { LibPlayerSpells.constants.KNOCKBACK }
local SNAIR = { LibPlayerSpells.constants.SNAIR }
local DISPEL = { LibPlayerSpells.constants.DISPEL }
local SURVIVAL = { LibPlayerSpells.constants.SURVIVAL }
local COOLDOWN = { LibPlayerSpells.constants.COOLDOWN }
local SURVIVAL_COOLDOWN = { LibPlayerSpells.constants.SURVIVAL, LibPlayerSpells.constants.COOLDOWN }

local GTFO = _G["GTFO"]

local scanTipName = format("%s_ScanTooltip", addonName)
local scanTipText = format("%sTextLeft2", scanTipName)
local scanTip = CreateFrame("GameTooltip", scanTipName, WorldFrame, "GameTooltipTemplate")
local scanTipTitles = setmetatable({}, { __mode = "kv" })

local eventInfo = setmetatable({}, { __mode = "kv" })

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
}

local ignoredCCSpells = {
    111400, -- Burning Rush
    7870,   -- Lesser Invisibility from Succubus
}

local function checkFlags(flags, flagList)
    for _, flag in ipairs(flagList) do
        if bit_band(flags, flag) == 0 then
            return false
        end
    end
    return true
end

-- Combat Log event hydration
function CombatEventHandler:Fire()
    wipe(eventInfo)

    eventInfo.time, eventInfo.subEvent, eventInfo.hidecaster, eventInfo.sourceGUID, eventInfo.sourceName, eventInfo.sourceFlags, eventInfo.sourceRaidFlags, eventInfo.destGUID, eventInfo.destName, eventInfo.destFlags, eventInfo.destRaidFlags, eventInfo.misc1, eventInfo.misc2, eventInfo.misc3, eventInfo.misc4 =
        CombatLogGetCurrentEventInfo()

    if (not eventInfo.sourceName and not eventInfo.destName) or not NCRuntime:GetGroupRosterPlayer(eventInfo.sourceName) and not NCRuntime:GetGroupRosterPlayer(eventInfo.destName) and bit_band(eventInfo.sourceFlags, COMBATLOG_OBJECT_TYPE_PET) == 0 and bit_band(eventInfo.sourceFlags, COMBATLOG_OBJECT_TYPE_GUARDIAN) == 0 then
        wipe(eventInfo)
        return
    end

    local subEvent, eventType, sourceName, destName, misc1, misc2, misc4 = eventInfo.subEvent, eventInfo.eventType,
        eventInfo.sourceName, eventInfo.destName, eventInfo.misc1, eventInfo.misc2, eventInfo.misc4
    local damage = CombatEventHandler:GetDamageAmount(subEvent, misc1, misc4)

    if bit_band(eventInfo.sourceFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0 or bit_band(eventInfo.sourceFlags, COMBATLOG_OBJECT_TYPE_GUARDIAN) ~= 0 then
        local petOwner = CombatEventHandler:GetPetOwner(eventInfo.sourceGUID)

        if petOwner then
            eventInfo.sourceName = NCRuntime:GetPlayerNameFromGuid(petOwner)
            sourceName = eventInfo.sourceName

            if not NCRuntime:GetGroupRosterPlayer(sourceName) and not NCRuntime:GetGroupRosterPlayer(eventInfo.destName) then
                wipe(eventInfo)
                return
            end
        end
    end

    CombatEventHandler:ActionScoring()

    NCEvent:Reset()
    NCEvent:SetCategory("COMBATLOG")

    if not IsInRaid() then
        local isPull, pullType, pullPlayerName, mobName = CombatEventHandler:IsPull()
        if isPull and pullPlayerName then
            if NCRuntime:GetLastUnsafePullToastDelta() > 1.5 then
                -- Nesting this in to prevent spam
                if NCConfig:IsReportingPulls_Realtime() then
                    local channel = NemesisChat:GetActualChannel(NCConfig:GetReportingPulls_Channel() or
                        "YELL")
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
    end

    if NCEvent:IsDamageEvent(subEvent, destName, damage) then
        local isAvoidable = (GTFO and GTFO.SpellID[tostring(misc1)] ~= nil)

        if isAvoidable then
            NCSegment:GlobalAddAvoidableDamage(damage, destName)
        end

        NCRuntime:SetPlayerStateValue(destName, "lastDamageAvoidable", isAvoidable)

        NCEvent:Damage(sourceName, destName, misc1, misc2, damage, isAvoidable)

        -- Damage events are handled in addition to everything else.
        NemesisChat:HandleEvent()
        NCEvent:Reset()
        NCEvent:SetCategory("COMBATLOG")
    end

    if eventPatterns[subEvent] then
        if subEvent == "SPELL_INTERRUPT" then
            NCEvent:Interrupt(sourceName, destName, misc1, misc2, misc4)
        elseif subEvent == "SPELL_CAST_SUCCESS" then
            NCEvent:Spell(sourceName, destName, misc1, misc2)
            -- Handle Blessing of Freedom logic here
        elseif subEvent == "SPELL_CAST_START" then
            NCEvent:SpellStart(sourceName, destName, misc1, misc2)
        elseif subEvent == "SPELL_HEAL" or subEvent == "SPELL_PERIODIC_HEAL" then
            NCEvent:Heal(sourceName, destName, misc1, misc2, misc4)
        elseif subEvent == "PARTY_KILL" then
            NCEvent:Kill(sourceName, destName)
        elseif subEvent == "UNIT_DIED" then
            if UnitInParty(destName) then
                NCEvent:Death(destName)
                -- Handle avoidable death logic here
                NCSegment:GlobalAddDeath(destName)
            end
        end
    elseif string_find(subEvent, "AURA_APPLIED") or string_find(subEvent, "AURA_DOSE") then
        NCEvent:Aura(sourceName, destName, misc1, misc2)
    else
        -- Handle unsupported events or return early
        wipe(eventInfo)
        return
    end

    wipe(eventInfo)
    NemesisChat:HandleEvent()
end

function CombatEventHandler:GetDamageAmount(event, arg1, arg4)
    if event == "SWING_DAMAGE" then
        return arg1 or 0
    elseif event == "RANGE_DAMAGE" or event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" then
        return arg4 or 0
    end

    return 0
end

-- Originally taken from https://github.com/logicplace/who-pulled/blob/master/WhoPulled/WhoPulled.lua, with heavy modifications
--- @return boolean, string|nil, string|nil, string|nil
function CombatEventHandler:IsPull()
    if not IsInGroup() or (NCBoss:IsActive() and NCDungeon:IsActive()) or IsInRaid() then
        return false
    end

    local _, event, _, sguid, sname, sflags, _, dguid, dname, dflags, _, arg1, _, _, arg4 = eventInfo.time,
        eventInfo.subEvent, eventInfo.sourceGUID, eventInfo.sourceName, eventInfo.sourceFlags, eventInfo.destGUID,
        eventInfo.destName, eventInfo.destFlags, eventInfo.destRaidFlags, eventInfo.misc1, eventInfo.misc2,
        eventInfo.misc3, eventInfo.misc4

    if not UnitInParty(sname) and not UnitInParty(dname) then
        return false
    end

    if (dname and sname and dname ~= sname and not string_find(event, "_RESURRECT") and not string_find(event, "_CREATE") and (string_find(event, "SWING") or string_find(event, "RANGE") or string_find(event, "SPELL"))) then
        local function IsInvalidPlayer(player, pulledUnit)
            if not pulledUnit then pulledUnit = dname end

            if not player or player.role == "TANK" then
                NCRuntime:AddPulledUnit(pulledUnit)
                return true
            end
            return false
        end

        local damageAmount = 0

        -- More verbose and perhaps lacking in ingenuity, but it's easier to read
        if event == "SWING_DAMAGE" then
            damageAmount = arg1
        elseif event == "RANGE_DAMAGE" or event == "SPELL_DAMAGE" then
            damageAmount = arg4
        elseif event == "SPELL_PERIODIC_DAMAGE" then
            damageAmount = arg4
        end

        if (not string_find(event, "_SUMMON")) then
            if (bit_band(sflags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit_band(dflags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0) then
                -- A player is attacking a mob
                local player = NCRuntime:GetGroupRosterPlayer(sname)

                if IsInvalidPlayer(player) then
                    return false
                end

                local validDamage = damageAmount > 0
                local isEliteEnemy = CombatEventHandler:IsEliteMob(dname)

                if not UnitIsUnconscious(dguid) and validDamage and CombatEventHandler:UnitIsNotPulled(dguid) and isEliteEnemy then
                    -- Fire off a pull event -- player attacked a mob!

                    return true, NC_PULL_EVENT_ATTACK, sname, dname
                end
            elseif (bit_band(dflags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit_band(sflags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0) then
                -- A mob is attacking a player
                local player = NCRuntime:GetGroupRosterPlayer(dname)

                if IsInvalidPlayer(player, sname) then
                    return false
                end

                local isEliteEnemy = CombatEventHandler:IsEliteMob(sname)

                if CombatEventHandler:UnitIsNotPulled(sguid) and isEliteEnemy then
                    -- Fire off a butt-pull event -- mob attacked a player!

                    return true, NC_PULL_EVENT_AGGRO, dname, sname
                end
            elseif (bit_band(sflags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 and bit_band(dflags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0) then
                -- Player's pet attacks a mob
                local pname = CombatEventHandler:GetPetOwner(sguid)
                local pullname = pname ~= "Unknown" and pname or (sname .. " (pet)")

                local player = NCRuntime:GetGroupRosterPlayer(pname)
                if IsInvalidPlayer(player) then
                    return false
                end

                local validDamage = damageAmount > 0
                local isEliteEnemy = CombatEventHandler:IsEliteMob(dname)

                if not UnitIsUnconscious(dguid) and validDamage and CombatEventHandler:UnitIsNotPulled(dguid) and isEliteEnemy then
                    return true, NC_PULL_EVENT_PET, pullname, dname
                end
            elseif (bit_band(dflags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 and bit_band(sflags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0) then
                --Mob attacks a player's pet
                local pullname;
                local pname = CombatEventHandler:GetPetOwner(dguid);

                if (pname == "Unknown") then
                    pullname = dname .. " (pet)";
                else
                    pullname = pname .. " (pet)";
                end

                if CombatEventHandler:UnitIsNotPulled(sguid) then
                    -- Fire off a pet butt-pull event -- mob attacked a player's pet!

                    return true, NC_PULL_EVENT_AGGRO, pullname, sname
                end
            end
        else
            -- Summon
            local player = NCRuntime:GetGroupRosterPlayer(sname)

            if player ~= nil then
                NCRuntime:AddPetOwner(dguid, sname)
            end

            return false
        end
    end

    return false
end

function CombatEventHandler:IsEliteMob(name)
    -- Iterate through all nameplates since we need a token to scan the tooltip
    for i = 1, 40 do
        local unit = "nameplate" .. i -- Use nameplate tokens (e.g., nameplate1, nameplate2...)
        if UnitName(unit) == name then
            -- Name matches, scan the tooltip for Elite status
            local frame = CreateFrame("GameTooltip", "TooltipScan", nil, "GameTooltipTemplate")
            frame:SetOwner(WorldFrame, "ANCHOR_NONE")
            frame:SetUnit(unit) -- Use the nameplate unit token

            for i = 1, frame:NumLines() do
                local text = _G["TooltipScanTextLeft" .. i]:GetText()
                if text and string_find(text, "Elite") then
                    return true
                end
            end

            return false
        end
    end

    return false
end

function CombatEventHandler:ActionScoring()
    local subEvent, sourceGUID, sourceName, sourceFlags, spellId = eventInfo.subEvent, eventInfo.sourceGUID,
        eventInfo.sourceName, eventInfo.sourceFlags, eventInfo.misc1

    if not IsInGroup() or not sourceName then return end

    if not UnitInParty(sourceName) then
        return
    end

    local flags = LibPlayerSpells:GetSpellInfo(spellId)
    if not flags then
        return
    end

    if not tContains(ignoredCCSpells, spellId) and (checkFlags(flags, CROWD_CTRL) or checkFlags(flags, SNAIR) or checkFlags(flags, KNOCKBACK)) then
        NCSegment:GlobalAddCrowdControl(sourceName)
    end

    if checkFlags(flags, DISPEL) then
        NCSegment:GlobalAddDispell(sourceName)
    end

    if checkFlags(flags, SURVIVAL_COOLDOWN) then
        NCSegment:GlobalAddDefensive(sourceName)
        local playerState = NCRuntime:GetPlayerState(sourceName)
        if playerState then
            playerState.lastDefensive = GetTime()
        end
    end

    -- NCSegment:GlobalAddActionPoints(1, sname, description)
end

-- Get the owner of a pet from cache, and if it doesn't exist in cache, set it and return the owner
function CombatEventHandler:GetPetOwner(petGuid)
    local owner = NCRuntime:GetPetOwner(petGuid)

    if not owner then
        owner = CombatEventHandler:ScanTooltipForPetOwner(petGuid)
        NCRuntime:AddPetOwner(petGuid, owner)
    end

    return owner
end

-- Pull the owner of a pet from the tooltip
function CombatEventHandler:ScanTooltipForPetOwner(guid)
    for i = 1, 48 do
        scanTipTitles[#scanTipTitles + 1] = _G[format("UNITNAME_SUMMON_TITLE%i", i)]
    end

    local text = _G[scanTipText]
    if (guid and text) then
        scanTip:SetOwner(WorldFrame, "ANCHOR_NONE")
        scanTip:SetHyperlink(format('unit:%s', guid))
        local text2 = text:GetText()
        if (text2) then
            for i = 1, #scanTipTitles do
                local check = scanTipTitles[i]:gsub("%%s", "(.+)"):gsub("[%[%]]", "%%%1")
                local a, b, c = string_find(text2, check)
                if (c) then
                    local g = UnitGUID(c)
                    if (g) then
                        return g
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
