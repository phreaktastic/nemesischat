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
    if not IsInInstance() then
        return
    end

    self.time, self.event, self.hideCaster, self.sourceGuid, self.sourceName, self.sourceFlags, self.sourceRaidFlags, self.destGuid, self.destName, self.destFlags, self.destRaidFlags, self.spellId, self.spellName, self.spellSchool, self.extraSpellId, self.extraSpellName, self.extraSpellSchool = CombatLogGetCurrentEventInfo()
    local time, event, hidecaster, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, destGuid, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool = NCCombatLogEvent:GetCombatLogVariables()
    local isPull, event, pullPlayerName, mobName = self:IsPull()

    NemesisChat:SetMyName()
    NCCombatLogEvent:CheckAffixes()

    NCEvent:Initialize()
    NCEvent:SetCategory("COMBATLOG")

    if isPull and pullPlayerName then
        NCSegment:GlobalAddPull(UnitName(pullPlayerName))

        -- WIP -- fire event!
    end

    if event == "SPELL_INTERRUPT" then
        NCEvent:Interrupt(sourceName, destName, spellId, spellName, extraSpellId)
    elseif event == "SPELL_CAST_SUCCESS" then
        NCEvent:Spell(sourceName, destName, spellId, spellName)

        -- This needs to be handled in a more modular way
        if spellName == "Blessing of Freedom" and tContains(NCDungeon:GetKeystoneAffixes(), 134) then
            if sourceName ~= destName then
                NCSegment:GlobalAddAffix(sourceName, 10)
            else
                -- Currently not awarding any affix points for casting on self, esp when it's easy to spec into
            end
        end
    -- Spell start
    elseif event == "SPELL_CAST_START" then
        NCEvent:SpellStart(sourceName, destName, spellId, spellName)
    elseif event == "SPELL_HEAL" then
        NCEvent:Heal(sourceName, destName, spellId, spellName, extraSpellId)
    elseif event == "PARTY_KILL" then
        NCEvent:Kill(sourceName, destName)
    elseif event == "UNIT_DIED" then
        if not UnitInParty(destName) then
            return
        end

        NCEvent:Death(destName)

        local state = NCState:GetPlayerState(destName)

        if state and state.lastDamageAvoidable then
            NCEvent:AvoidableDeath(destName)

            if not NCEvent:EventHasMessages() then
                NCEvent:Death(destName)
            end
        end

        NCSegment:GlobalAddDeath(destName)
    elseif NCEvent.IsDamageEvent and NCEvent:IsDamageEvent(event, destName, extraSpellId) then
        local damage = tonumber(extraSpellId) or 0
        local state = NCState:GetPlayerState(destName)
        local isAvoidable = (GTFO and GTFO.SpellID[tostring(spellId)] ~= nil)

        if isAvoidable then
            NCSegment:GlobalAddAvoidableDamage(damage, destName)
        end

        if state then
            state.lastDamageAvoidable = isAvoidable
        end

        NCEvent:Damage(sourceName, destName, isAvoidable, damage)
    elseif string.find(event, "AURA_APPLIED") or string.find(event, "AURA_DOSE") then
        NCEvent:Aura(sourceName, destName, spellId, spellName)
    else
        -- Something unsupported.
        return
    end

    NemesisChat:HandleEvent()
end

function NCCombatLogEvent:GetCombatLogVariables()
    return self.time, self.event, self.hideCaster, self.sourceGuid, self.sourceName, self.sourceFlags, self.sourceRaidFlags, self.destGuid, self.destName, self.destFlags, self.destRaidFlags, self.spellId, self.spellName, self.spellSchool, self.extraSpellId, self.extraSpellName, self.extraSpellSchool
end

function NCCombatLogEvent:IsPull()
    if not IsInGroup() or (NCBoss:IsActive() and NCDungeon:IsActive()) or IsInRaid() then
        return false
    end

    local time,event,hidecaster,sguid,sname,sflags,sraidflags,dguid,dname,dflags,draidflags,arg1,arg2,arg3,itype = CombatLogGetCurrentEventInfo()

    if not UnitInParty(sname) and not UnitInParty(dname) then
        return false
    end

    if (dname and sname and dname ~= sname and not string.find(event,"_RESURRECT") and not string.find(event,"_CREATE") and (string.find(event,"SWING") or string.find(event,"RANGE") or string.find(event,"SPELL"))) and not tContains(core.affixMobs, sname) and not tContains(core.affixMobs, dname) then
        local function IsInvalidPlayer(player, pulledUnit)
            if not pulledUnit then pulledUnit = dname end

            if not player or player.role == "TANK" then
                NCRuntime:AddPulledUnit(pulledUnit)
                return true
            end
            return false
        end
        
        if(not string.find(event,"_SUMMON")) then
            if(bit.band(sflags,COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit.band(dflags,COMBATLOG_OBJECT_TYPE_NPC) ~= 0) then
                -- A player is attacking a mob
                local player = NCRuntime:GetGroupRosterPlayer(sname)

                if IsInvalidPlayer(player) then
                    return false
                end

                local validDamage = type(itype) == "number" and itype > 0
                local classification = UnitClassification(dguid)
                local isEliteEnemy = classification ~= "trivial" and classification ~= "minus" and classification ~= "normal" and not UnitIsPlayer(dguid)
            
                if not UnitIsUnconscious(dguid) and validDamage and NemesisChat:UnitIsNotPulled(dguid) and isEliteEnemy then
                    -- Fire off a pull event -- player attacked a mob!

                    return true, NC_PULL_EVENT_ATTACK, sname, dname
                end
            elseif(bit.band(dflags,COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit.band(sflags,COMBATLOG_OBJECT_TYPE_NPC) ~= 0) then
                -- A mob is attacking a player
                local player = NCRuntime:GetGroupRosterPlayer(dname)

                if IsInvalidPlayer(player, sname) then
                    return false
                end

                local classification = UnitClassification(sguid)
                local isEliteEnemy = classification ~= "trivial" and classification ~= "minus" and classification ~= "normal" and not UnitIsPlayer(dguid)

                if NemesisChat:UnitIsNotPulled(sguid) and isEliteEnemy then
                    -- Fire off a butt-pull event -- mob attacked a player!

                    return true, NC_PULL_EVENT_AGGRO, dname, sname
                end
            elseif(bit.band(sflags,COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 and bit.band(dflags,COMBATLOG_OBJECT_TYPE_NPC) ~= 0) then
                -- Player's pet attacks a mob
                local pullname;
                local pname = NemesisChat:GetPetOwner(sguid);

                if (pname == "Unknown") then 
                    pullname = sname.." (pet)"
                else 
                    pullname = pname
                end

                local validDamage = type(itype) == "number" and itype > 0
                local classification = UnitClassification(dguid)
                local isEliteEnemy = classification ~= "trivial" and classification ~= "minus" and classification ~= "normal" and not UnitIsPlayer(dguid)
                    
                if not UnitIsUnconscious(dguid) and validDamage and NemesisChat:UnitIsNotPulled(dguid) and isEliteEnemy then
                    -- Fire off a pet pull event -- player's pet attacked a mob!

                    return true, NC_PULL_EVENT_PET, pullname, dname
                end
            elseif(bit.band(dflags,COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 and bit.band(sflags,COMBATLOG_OBJECT_TYPE_NPC) ~= 0) then
                --Mob attacks a player's pet
                local pullname;
                local pname = NemesisChat:GetPetOwner(dguid);

                if(pname == "Unknown") then pullname = dname.." (pet)";
                else pullname = pname .. " (pet)";
                end

                if NemesisChat:UnitIsNotPulled(sguid) then
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
