-----------------------------------------------------
-- COMBAT EVENT LOG
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local addonName, core = ...;

-----------------------------------------------------
-- Logic for all events handled which come from the
-- combat log.
-----------------------------------------------------

local scanTipName = format("%s_ScanTooltip", addonName)
local scanTipText = format("%sTextLeft2", scanTipName)
local scanTip = CreateFrame("GameTooltip", scanTipName, WorldFrame, "GameTooltipTemplate")
local scanTipTitles = {}

NCCombatLogEvent = {
    -- Precomputed reset defaults for performance
    resetDefaults = {
        time = 0,
        event = "",
        hideCaster = "",
        sourceGuid = "",
        sourceName = "",
        sourceFlags = 0,
        sourceRaidFlags = 0,
        destGuid = "",
        destName = "",
        destFlags = 0,
        destRaidFlags = 0,
        spellId = 0,
        spellName = "",
        spellSchool = 0,
        extraSpellId = 0,
        extraSpellName = "",
        extraSpellSchool = 0,
    },

    time = 0,
    event = "",
    hideCaster = "",
    sourceGuid = "",
    sourceName = "",
    sourceFlags = 0,
    sourceRaidFlags = 0,
    destGuid = "",
    destName = "",
    destFlags = 0,
    destRaidFlags = 0,
    spellId = 0,
    spellName = "",
    spellSchool = 0,
    extraSpellId = 0,
    extraSpellName = "",
    extraSpellSchool = 0,
    lastAuraCheck = 0,
    lastUnsafePullToast = 0,
    lastUnsafePullName = "",
    lastUnsafePullMob = "",
    lastUnsafePullCount = 0,
    pulledUnits = {},
    petOwners = {},
}
NCCLE = NCCombatLogEvent
NCCLEU = NCCombatLogEvent

function NCCombatLogEvent:ShouldExitEventHandler()
    -- Respect disabling of the plugin.
    if not IsNCEnabled() then
        return true
    end

    -- Improper event data
    if not NCEvent:IsValidEvent() then
        if NCConfig:IsDebugging() and NCSpell:GetSource() == GetMyName() then
            self:Print("Invalid event.")
            NemesisChat:Print("Cat:", NCEvent:GetCategory(), "Event:", NCEvent:GetEvent(), "Target:", NCEvent:GetTarget())
        end
        return true
    end

    -- Player is not in a group, exit
    if not IsInGroup() then
        if NCConfig:IsDebugging() then
            self:Print("Player not in group.")
        end
        return true
    end

    return false
end

function NCCombatLogEvent:Fire()
    if not IsInInstance() then return end

    self:CaptureCombatLogEvent()
    self:InitializeEvent()

    if self:IsPullEvent() then
        self:HandlePullEvent()
    end

    self:ProcessCombatEvent()
    NemesisChat:HandleEvent()
    self:ResetVars()
end

function NCCombatLogEvent:ResetVars()
    for var, default in pairs(self.resetDefaults) do
        self[var] = default
    end
end

function NCCombatLogEvent:CaptureCombatLogEvent()
    self.time, self.event, self.hideCaster,
    self.sourceGuid, self.sourceName, self.sourceFlags, self.sourceRaidFlags,
    self.destGuid, self.destName, self.destFlags, self.destRaidFlags,
    self.spellId, self.spellName, self.spellSchool,
    self.extraSpellId, self.extraSpellName, self.extraSpellSchool = CombatLogGetCurrentEventInfo()
end

function NCCombatLogEvent:InitializeEvent()
    NemesisChat:SetMyName()
    self:CheckAffixes()
    NCEvent:Initialize()
    NCEvent:SetCategory("COMBATLOG")
end

function NCCombatLogEvent:IsPullEvent()
    self.isPull, self.pullEvent, self.pullPlayerName, self.mobName = self:IsPull()
    return self.isPull and self.pullPlayerName
end

function NCCombatLogEvent:HandlePullEvent()
    if NCRuntime:GetLastUnsafePullToastDelta() > 1.5 then
        if NCConfig:IsReportingPulls_Realtime() then
            SendChatMessage("Nemesis Chat: " .. UnitName(self.pullPlayerName) .. " pulled " .. self.mobName, "YELL")
        end
        NemesisChat:SpawnToast("Pull", UnitName(self.pullPlayerName), self.mobName)
        NCRuntime:UpdateLastUnsafePullToast()
    end

    local playerName = UnitName(self.pullPlayerName)
    NCRuntime:SetLastUnsafePull(playerName, self.mobName)
    NCSegment:GlobalAddPull(playerName)
end

function NCCombatLogEvent:ProcessCombatEvent()
    local event = self.event
    local handlers = {
        SPELL_INTERRUPT = function() NCEvent:Interrupt(self.sourceName, self.destName, self.spellId, self.spellName, self.extraSpellId) end,
        SPELL_CAST_SUCCESS = function() self:HandleSpellCastSuccess() end,
        SPELL_CAST_START = function() NCEvent:SpellStart(self.sourceName, self.destName, self.spellId, self.spellName) end,
        SPELL_HEAL = function() NCEvent:Heal(self.sourceName, self.destName, self.spellId, self.spellName, self.extraSpellId) end,
        PARTY_KILL = function() NCEvent:Kill(self.sourceName, self.destName) end,
        UNIT_DIED = function() self:HandleUnitDied() end,
    }

    if handlers[event] then
        handlers[event]()
    elseif NCEvent.IsDamageEvent and NCEvent:IsDamageEvent(event, self.destName, self.extraSpellId) then
        self:HandleDamageEvent()
    elseif event:find("AURA_APPLIED") or event:find("AURA_DOSE") then
        NCEvent:Aura(self.sourceName, self.destName, self.spellId, self.spellName)
    else
        -- Unsupported event
        return
    end
end

function NCCombatLogEvent:HandleSpellCastSuccess()
    NCEvent:Spell(self.sourceName, self.destName, self.spellId, self.spellName)

    -- Modular handling for specific spells
    if self.spellName == "Blessing of Freedom" and tContains(NCDungeon:GetKeystoneAffixes(), 134) then
        if self.sourceName ~= self.destName then
            NCSegment:GlobalAddAffix(self.sourceName, 10)
        end
    end
end

function NCCombatLogEvent:HandleUnitDied()
    if not UnitInParty(self.destName) then return end

    NCEvent:Death(self.destName)
    local state = NCState:GetPlayerState(self.destName)

    if state and state.lastDamageAvoidable then
        NCEvent:AvoidableDeath(self.destName)
        if not NCEvent:EventHasMessages() then
            NCEvent:Death(self.destName)
        end
    end

    NCSegment:GlobalAddDeath(self.destName)
end

function NCCombatLogEvent:HandleDamageEvent()
    local damage = self:GetDamageAmount(self:GetEventData())
    local state = NCState:GetPlayerState(self.destName)
    local isAvoidable = GTFO and GTFO.SpellID[tostring(self.spellId)] ~= nil

    if isAvoidable then
        NCSegment:GlobalAddAvoidableDamage(damage, self.destName)
    end

    if state then
        state.lastDamageAvoidable = isAvoidable
    end

    NCEvent:Damage(self.sourceName, self.destName, isAvoidable, damage)
end


function NCCombatLogEvent:GetCombatLogVariables()
    return self.time, self.event, self.hideCaster, self.sourceGuid, self.sourceName, self.sourceFlags, self.sourceRaidFlags, self.destGuid, self.destName, self.destFlags, self.destRaidFlags, self.spellId, self.spellName, self.spellSchool, self.extraSpellId, self.extraSpellName, self.extraSpellSchool
end

-- Originally taken from https://github.com/logicplace/who-pulled/blob/master/WhoPulled/WhoPulled.lua, with heavy modifications
function NCCombatLogEvent:IsPull()
    if not self:ShouldProcessEvent() then
        return false
    end

    local eventData = self:GetEventData()
    if not self:IsRelevantEvent(eventData) then
        return false
    end

    local damageAmount = self:GetDamageAmount(eventData)
    if self:IsSummonEvent(eventData.event) then
        self:HandleSummonEvent(eventData)
        return false
    end

    return self:HandlePullScenarios(eventData, damageAmount)
end

function NCCombatLogEvent:ShouldProcessEvent()
    return IsInInstance() and IsInGroup() and not IsInRaid() and not (NCBoss:IsActive() and NCDungeon:IsActive())
end

function NCCombatLogEvent:GetEventData()
    local data = {}
    data.time, data.event, data.hideCaster,
    data.sguid, data.sname, data.sflags, data.sraidflags,
    data.dguid, data.dname, data.dflags, data.draidflags,
    data.arg1, data.arg2, data.arg3, data.arg4 = self:GetCombatLogVariables()
    return data
end

function NCCombatLogEvent:IsRelevantEvent(eventData)
    local sname, dname = eventData.sname, eventData.dname
    local event = eventData.event

    if not (UnitInParty(sname) or UnitInParty(dname)) then
        return false
    end

    if not sname or not dname or sname == dname then
        return false
    end

    local isResurrect = event:find("_RESURRECT")
    local isCreate = event:find("_CREATE")
    local isAttackEvent = event:find("SWING") or event:find("RANGE") or event:find("SPELL")
    local isAffixMob = tContains(core.affixMobs, sname) or tContains(core.affixMobs, dname)

    return not (isResurrect or isCreate or isAffixMob) and isAttackEvent
end

function NCCombatLogEvent:GetDamageAmount(eventData)
    local event = eventData.event
    local arg1, arg4 = eventData.arg1, eventData.arg4

    if event == "SWING_DAMAGE" then
        return arg1 or 0
    elseif event == "RANGE_DAMAGE" or event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" then
        return arg4 or 0
    else
        return 0
    end
end

function NCCombatLogEvent:IsSummonEvent(event)
    return event:find("_SUMMON")
end

function NCCombatLogEvent:HandleSummonEvent(eventData)
    local sname = eventData.sname
    local dguid = eventData.dguid
    local player = NCState:GetPlayerState(sname)

    if player then
        self:AddPetOwner(dguid, sname)
    end
end

function NCCombatLogEvent:HandlePullScenarios(eventData, damageAmount)
    local sflags, dflags = eventData.sflags, eventData.dflags
    local sname, dname = eventData.sname, eventData.dname
    local sguid, dguid = eventData.sguid, eventData.dguid

    if self:IsPlayerAttackingMob(sflags, dflags) then
        return self:HandlePlayerAttack(eventData, damageAmount)
    elseif self:IsMobAttackingPlayer(sflags, dflags) then
        return self:HandleMobAttack(eventData)
    elseif self:IsPetAttackingMob(sflags, dflags) then
        return self:HandlePetAttack(eventData, damageAmount)
    elseif self:IsMobAttackingPet(sflags, dflags) then
        return self:HandleMobAttackPet(eventData)
    end

    return false
end

function NCCombatLogEvent:IsPlayerAttackingMob(sflags, dflags)
    return bit.band(sflags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit.band(dflags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0
end

function NCCombatLogEvent:IsMobAttackingPlayer(sflags, dflags)
    return bit.band(dflags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit.band(sflags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0
end

function NCCombatLogEvent:IsPetAttackingMob(sflags, dflags)
    return bit.band(sflags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 and bit.band(dflags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0
end

function NCCombatLogEvent:IsMobAttackingPet(sflags, dflags)
    return bit.band(dflags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 and bit.band(sflags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0
end

function NCCombatLogEvent:IsInvalidPlayer(player, pulledUnit)
    pulledUnit = pulledUnit or self.eventData.dname
    if not player or player.role == "TANK" then
        self:AddPulledUnit(pulledUnit)
        return true
    end
    return false
end

function NCCombatLogEvent:HandlePlayerAttack(eventData, damageAmount)
    local sname, dname = eventData.sname, eventData.dname
    local sguid, dguid = eventData.sguid, eventData.dguid

    local player = NCState:GetPlayerState(sname)
    if self:IsInvalidPlayer(player) then
        return false
    end

    if self:ShouldTriggerPullEvent(dguid, damageAmount, dname) then
        return true, NC_PULL_EVENT_ATTACK, sname, dname
    end

    return false
end

function NCCombatLogEvent:HandleMobAttack(eventData)
    local sname, dname = eventData.sname, eventData.dname
    local sguid = eventData.sguid

    local player = NCState:GetPlayerState(dname)
    if self:IsInvalidPlayer(player, sname) then
        return false
    end

    if self:ShouldTriggerPullEvent(sguid, 0, sname) then
        return true, NC_PULL_EVENT_AGGRO, dname, sname
    end

    return false
end

function NCCombatLogEvent:HandlePetAttack(eventData, damageAmount)
    local sname, dname = eventData.sname, eventData.dname
    local sguid, dguid = eventData.sguid, eventData.dguid

    local petOwnerName = self:GetPetOwner(sguid) or sname .. " (pet)"
    if self:ShouldTriggerPullEvent(dguid, damageAmount, dname) then
        return true, NC_PULL_EVENT_PET, petOwnerName, dname
    end

    return false
end

function NCCombatLogEvent:HandleMobAttackPet(eventData)
    local sname, dname = eventData.sname, eventData.dname
    local sguid = eventData.sguid
    local petOwnerName = self:GetPetOwner(eventData.dguid)
    local pullName = petOwnerName and petOwnerName .. " (pet)" or dname .. " (pet)"

    if self:UnitIsNotPulled(sguid) then
        return true, NC_PULL_EVENT_AGGRO, pullName, sname
    end

    return false
end

function NCCombatLogEvent:ShouldTriggerPullEvent(unitGuid, damageAmount, unitName)
    local isValidDamage = damageAmount > 0
    local isEliteEnemy = NemesisChat:IsEliteMob(unitName)
    local isUnitAlive = not UnitIsUnconscious(unitGuid)
    local isUnitNotPulled = self:UnitIsNotPulled(unitGuid)

    return isValidDamage and isEliteEnemy and isUnitAlive and isUnitNotPulled
end


function NCCombatLogEvent:GetPetOwner(petGuid)
    for i = 1, 48 do
        scanTipTitles[#scanTipTitles + 1] = _G[format("UNITNAME_SUMMON_TITLE%i",i)]
    end

    local owner = NCCombatLogEvent.petOwners[petGuid]

    if owner ~= nil then
        return owner
    end

    local owner = NCCombatLogEvent:ScanTooltipForPetOwner(petGuid)

    self:AddPetOwner(petGuid, owner)

    return owner
end

function NCCombatLogEvent:AddPetOwner(petGuid, owner)
    self.petOwners[petGuid] = owner
end

function NCCombatLogEvent:ScanTooltipForPetOwner(guid)
    for i = 1, 48 do
        scanTipTitles[#scanTipTitles + 1] = _G[format("UNITNAME_SUMMON_TITLE%i",i)]
    end

    local text = _G[scanTipText]
    if(guid and text) then
        scanTip:SetOwner(WorldFrame, "ANCHOR_NONE")
        scanTip:SetHyperlink(format('unit:%s',guid))
        local text2 = text:GetText()
        if(text2) then
            for i = 1, #scanTipTitles do
                local check = scanTipTitles[i]:gsub("%%s", "(.+)"):gsub("[%[%]]", "%%%1")
                local a,b,c = string.find(text2, check)
                if(c) then
                    local g = UnitGUID(c)
                    if(g) then
                        return g
                    end
                end
            end
        end
    end

    return "Unknown"
end

function NCCombatLogEvent:UnitIsNotPulled(guid)
    if NCCombatLogEvent:GetPulledUnit(guid) == nil then
        NCCombatLogEvent:AddPulledUnit(guid)
        return true
    end

    return false
end

function NCCombatLogEvent:GetPulledUnit(guid)
    for i = 1, #self.pulledUnits do
        if self.pulledUnits[i] == guid then
            return guid
        end
    end

    return nil
end

function NCCombatLogEvent:AddPulledUnit(guid)
    tinsert(self.pulledUnits, guid)
end

function NCCombatLogEvent:IsAffixMobHandled()
    if not IsInInstance() or not IsInGroup() then
        return false, nil, nil
    end

    local _,event,_,sguid,sname,_,_,dguid,dname,_,_,spellId = CombatLogGetCurrentEventInfo()

    if NCState:GetPlayerState(sname) == nil then
        return false, nil, nil
    end

    if UnitIsUnconscious(dguid) or UnitIsDead(dguid) or string.find(event, "INSTAKILL") then
        return true, sname, dguid
    end

    if core.affixMobsHandles[dname] ~= nil and type(core.affixMobsHandles[dname]) == "table" then
        for _, eventSubstr in pairs(core.affixMobsHandles[dname]) do
            if eventSubstr == "CROWD_CONTROL" then
                local flags = LibPlayerSpells:GetSpellInfo(spellId)

                if flags and bit.band(flags, LibPlayerSpells.constants.CROWD_CTRL) ~= 0 then
                    return true, sname, dguid
                end
            else
                if string.find(event, eventSubstr) then
                    return true, sname, dguid
                end
            end
        end
    end

    return false, nil, nil
end

function NCCombatLogEvent:IsAffixAuraHandled()
    if not IsInInstance() or not IsInGroup() then
        return false, nil
    end

    local _, event, _, _, sname, _, _, _, dname, _, _, _, _, _, dispelledId = NCCombatLogEvent:GetCombatLogVariables()

    if (NCState:GetPlayerState(sname) == nil) or (NCState:GetPlayerState(dname) == nil) or event ~= "SPELL_DISPEL" then
        return false, nil
    end

    local isHandled = false

    for _, auraData in pairs(core.affixMobsAuras) do
        if auraData.spellId == dispelledId then
            isHandled = true
            break
        end
    end

    return isHandled, sname
end

function NCCombatLogEvent:CheckIsAffix()
    if not IsInInstance() or not IsInGroup() then
        return false
    end

    local _,event,_,_,sname = NCCombatLogEvent:GetCombatLogVariables()

    return core.affixMobsLookup[sname] == true
end

function NCCombatLogEvent:CheckAffixes()
    NCCombatLogEvent:CheckAffixAuras()

    local isAffixMobHandled, affixMobHandlerName, affixMobHandledGuid = NCCombatLogEvent:IsAffixMobHandled()
    local isAuraHandled, auraHandlerName = NCCombatLogEvent:IsAffixAuraHandled()

    if isAffixMobHandled then
        local mobName = UnitName(affixMobHandledGuid)
        -- SetRaidTarget(affixMobHandledGuid, 0)

        -- More score for caster mobs as opposed to simply CCing shades, for example
        if core.affixMobsCastersLookup[mobName] then
            NCSegment:GlobalAddAffix(affixMobHandlerName, 10)
        else
            NCSegment:GlobalAddAffix(affixMobHandlerName)
        end
    end

    if isAuraHandled then
        NCSegment:GlobalAddAffix(auraHandlerName)
    end
end

function NCCombatLogEvent:CheckAffixAuras()
    if not IsInInstance() or not IsInGroup() then
        return
    end

    local time,event,hidecaster,sguid,sname,sflags,sraidflags,dguid,dname,dflags,draidflags,arg1,arg2,arg3,itype = NCCombatLogEvent:GetCombatLogVariables()

    if not core.affixMobsAuraSpells[arg1] then
        return
    end

    if not string.find(event, "AURA_APPLIED") and not string.find(event, "AURA_DOSE") then
        return
    end

    for _, auraData in pairs(core.affixMobsAuras) do
        if auraData.spellId == arg1 then
            local _, _, count = AuraUtil.FindAuraByName(auraData.spellName, dname, auraData.type)

            if count ~= nil and tonumber(count) >= auraData.highStacks and NCCombatLogEvent:GetLastAuraCheckDelta() >= 3 then
                -- fire event!
                NCCombatLogEvent:UpdateLastAuraCheck()
            end
        end
    end
end

function NCCombatLogEvent:UpdateLastAuraCheck()
    self.lastAuraCheck = GetTime()
end

function NCCombatLogEvent:GetLastAuraCheckDelta()
    return GetTime() - self.lastAuraCheck
end

function NCCombatLogEvent:SetLastUnsafePull(name, mob)
    self.lastUnsafePullMob = mob

    if not self.lastUnsafePullCount then
        self.lastUnsafePullCount = 0
    end

    if self.lastUnsafePullName == name then
        self.lastUnsafePullCount = self.lastUnsafePullCount + 1
        return
    end

    self.lastUnsafePullCount = 1
    self.lastUnsafePullName = name
end

function NCCombatLogEvent:GetLastUnsafePull()
    return self.lastUnsafePullName, self.lastUnsafePullMob, self.lastUnsafePullCount
end

function NCCombatLogEvent:GetLastUnsafePullToast()
    return self.lastUnsafePullToast
end

function NCCombatLogEvent:SetLastUnsafePullToast(value)
    self.lastUnsafePullToast = value
end

function NCCombatLogEvent:UpdateLastUnsafePullToast()
    self.lastUnsafePullToast = GetTime()
end

function NCCombatLogEvent:GetLastUnsafePullToastDelta()
    return GetTime() - self.lastUnsafePullToast
end

function NCCombatLogEvent:GetLastUnsafePullName()
    return self.lastUnsafePullName
end

function NCCombatLogEvent:SetLastUnsafePullName(value)
    self.lastUnsafePullName = value
end

function NCCombatLogEvent:GetLastUnsafePullMob()
    return self.lastUnsafePullMob
end

function NCCombatLogEvent:SetLastUnsafePullMob(value)
    self.lastUnsafePullMob = value
end

function NCCombatLogEvent:GetLastUnsafePullCount()
    return self.lastUnsafePullCount
end

function NCCombatLogEvent:SetLastUnsafePullCount(value)
    self.lastUnsafePullCount = value
end

function NCCombatLogEvent:UpdateLastUnsafePullCount()
    if not self.lastUnsafePullCount then
        self.lastUnsafePullCount = 0
    end

    self.lastUnsafePullCount = self.lastUnsafePullCount + 1
end
