-----------------------------------------------------
-- HELPER FUNCTIONS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local addonName, core = ...;

local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")

local E = ElvUI and unpack(ElvUI) or nil
local GTFO = _G["GTFO"]

local scanTipName = format("%s_ScanTooltip", addonName)
local scanTipText = format("%sTextLeft2", scanTipName)
local scanTip = CreateFrame("GameTooltip", scanTipName, WorldFrame, "GameTooltipTemplate")
local scanTipTitles = {}

local eventInfo = setmetatable({}, {__mode = "kv"})

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local GetTime = GetTime
local UnitIsDead = UnitIsDead
local UnitName = UnitName
local tContains = tContains
local string_find = string.find
local IsInGroup = IsInGroup
local UnitInParty = UnitInParty
local bit_band = bit.band

local eventPatterns = {
    ["SPELL_INTERRUPT"] = true,
    ["SPELL_CAST_SUCCESS"] = true,
    ["SPELL_CAST_START"] = true,
    ["SPELL_HEAL"] = true,
    ["PARTY_KILL"] = true,
    ["UNIT_DIED"] = true,
}

-- Weak cache, for memory optimization
local weakCache = setmetatable({}, {__mode = "kv"})
local function getCachedValue(key, defaultValue)
    if not weakCache[key] then
        weakCache[key] = defaultValue
    end
    return weakCache[key]
end

-----------------------------------------------------
-- Core global helper functions
-----------------------------------------------------
function NemesisChat:InitializeHelpers()

    function NemesisChat:TransmitSyncData()
        if NCRuntime:GetLastSyncType() == "" or NCRuntime:GetLastSyncType() == nil or NCRuntime:GetLastSyncType() == "LEAVERS" then
            NCRuntime:SetLastSyncType("LOWPERFORMERS")
            NemesisChat:TransmitLowPerformers()
        else
            NCRuntime:SetLastSyncType("LEAVERS")
            NemesisChat:TransmitLeavers()
        end
    end

    function NemesisChat:TransmitLeavers()
        if core.db.profile.leavers == nil or core.db.profile.leaversSerialized == nil or NCDungeon:IsActive() then
            return
        end

        local _, online = GetNumGuildMembers()

        if online > 1 and NCRuntime:GetLastLeaverSyncType() ~= "GUILD" then
            NemesisChat:Transmit("NC_LEAVERS", core.db.profile.leaversSerialized, "GUILD")
            NCRuntime:SetLastLeaverSyncType("GUILD")
        else
            NemesisChat:Transmit("NC_LEAVERS", core.db.profile.leaversSerialized, "YELL")
            NCRuntime:SetLastLeaverSyncType("YELL")
        end
    end

    function NemesisChat:TransmitLowPerformers()
        if core.db.profile.lowPerformers == nil or core.db.profile.lowPerformersSerialized == nil or NCDungeon:IsActive() then
            return
        end

        local _, online = GetNumGuildMembers()

        if online > 1 and NCRuntime:GetLastLowPerformerSyncType() ~= "GUILD" then
            NemesisChat:Transmit("NC_LOWPERFORMERS", core.db.profile.lowPerformersSerialized, "GUILD")
            NCRuntime:SetLastLowPerformerSyncType("GUILD")
        else
            NemesisChat:Transmit("NC_LOWPERFORMERS", core.db.profile.lowPerformersSerialized, "YELL")
            NCRuntime:SetLastLowPerformerSyncType("YELL")
        end
    end

    function NemesisChat:Transmit(prefix, payload, distribution, target)
        if target and distribution == "WHISPER" then
            self:SendCommMessage(prefix, payload, distribution, target)
        else
            self:SendCommMessage(prefix, payload, distribution)
        end
    end

    local syncTable = setmetatable({}, {__mode = "kv"})

    function NemesisChat:OnCommReceived(prefix, payload, distribution, sender)
        if not prefix or not string.find(prefix, "NC_") then return end

        local myFullName = UnitName("player") .. "-" .. GetNormalizedRealmName()

        if not core.db.global.lastSync then
            core.db.global.lastSync = setmetatable({}, {__mode = "kv"})
        end

        -- We attempt to sync fairly often, but we don't want to actually sync that much. We also don't want to sync if we're in combat.
        if sender == myFullName or NCCombat:IsActive() or (core.db.global.lastSync[sender] and (GetTime() - core.db.global.lastSync[sender] <= 1800)) then
            return
        end

        core.db.global.lastSync[sender] = GetTime()

        NemesisChat:Print("Synchronizing data received from " .. Ambiguate(sender, "guild"))

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
            NemesisChat:ProcessLeavers(syncTable.data)
        elseif prefix == "NC_LOWPERFORMERS" then
            NemesisChat:ProcessLowPerformers(syncTable.data)
        end

        wipe(syncTable)
    end

    function NemesisChat:ProcessLeavers(leavers)
        NemesisChat:Print("Processing leavers.")

        NemesisChat:ProcessReceivedData("leavers", leavers)

        leavers = nil
    end

    function NemesisChat:ProcessLowPerformers(lowPerformers)
        NemesisChat:Print("Processing low performers.")

        NemesisChat:ProcessReceivedData("lowPerformers", lowPerformers)

        lowPerformers = nil
    end

    function NemesisChat:ProcessReceivedData(configKey, data)
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

    function NemesisChat:PrintNumberOfLeavers()
        NemesisChat:Print("Leavers:", #NemesisChat:GetKeys(core.db.profile.leavers))
    end

    function NemesisChat:PrintNumberOfLowPerformers()
        NemesisChat:Print("Low Performers:", #NemesisChat:GetKeys(core.db.profile.lowPerformers))
    end

    function NemesisChat:PrintSyncKeys()
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

    function NemesisChat:AddLeaver(guid)
        if core.db.profile.leavers == nil then
            core.db.profile.leavers = {}
        end

        if core.db.profile.leavers[guid] == nil then
            core.db.profile.leavers[guid] = {}
        end

        tinsert(core.db.profile.leavers[guid], math.ceil(GetTime() / 10) * 10)

        NemesisChat:EncodeLeavers()
    end

    function NemesisChat:EncodeLeavers()
        if not core.db.profile.leavers or core.db.profile.leavers == {} then
            core.db.profile.leaversEncoded = nil
            return
        end

        core.db.profile.leaversSerialized = LibSerialize:Serialize(core.db.profile.leavers)
        core.db.profile.leaversCompressed = LibDeflate:CompressDeflate(core.db.profile.leaversSerialized)
        core.db.profile.leaversEncoded = LibDeflate:EncodeForWoWAddonChannel(core.db.profile.leaversCompressed)

        core.db.profile.leaversSerialized = nil
        core.db.profile.leaversCompressed = nil
    end

    function NemesisChat:AddLowPerformer(guid)
        if core.db.profile.lowPerformers == nil then
            core.db.profile.lowPerformers = {}
        end

        if core.db.profile.lowPerformers[guid] == nil then
            core.db.profile.lowPerformers[guid] = {}
        end

        tinsert(core.db.profile.lowPerformers[guid], math.ceil(GetTime() / 10) * 10)

        NemesisChat:EncodeLowPerformers()
    end

    function NemesisChat:EncodeLowPerformers()
        if not core.db.profile.lowPerformers or core.db.profile.lowPerformers == {} then
            core.db.profile.lowPerformersEncoded = nil
            return
        end

        core.db.profile.lowPerformersSerialized = LibSerialize:Serialize(core.db.profile.lowPerformers)
        core.db.profile.lowPerformersCompressed = LibDeflate:CompressDeflate(core.db.profile.lowPerformersSerialized)
        core.db.profile.lowPerformersEncoded = LibDeflate:EncodeForWoWAddonChannel(core.db.profile.lowPerformersCompressed)

        core.db.profile.lowPerformersSerialized = nil
        core.db.profile.lowPerformersCompressed = nil
    end

    function NemesisChat:EncodeAddonMessageData()
        NemesisChat:Print("Encoding synchronization data.")

        if not core.db.profile.leaversEncoded then
            NemesisChat:EncodeLeavers()
        end

        if not core.db.profile.lowPerformersEncoded then
            NemesisChat:EncodeLowPerformers()
        end
    end

    function NemesisChat:LeaveCount(guid)
        if core.db.profile.leavers == nil then
            return 0
        end

        if core.db.profile.leavers[guid] == nil then
            return 0
        end

        return #core.db.profile.leavers[guid]
    end

    function NemesisChat:LowPerformerCount(guid)
        if core.db.profile.lowPerformers == nil then
            return 0
        end

        if core.db.profile.lowPerformers[guid] == nil then
            return 0
        end

        return #core.db.profile.lowPerformers[guid]
    end

    function NemesisChat:InitializeTimers()
        if not self.SyncLeaversTimer then self.SyncLeaversTimer = self:ScheduleRepeatingTimer("TransmitSyncData", 60) end
    end

    function NemesisChat:GetMyName()
        NemesisChat:SetMyName()
        return core.runtime.myName
    end

    function NemesisChat:ShouldExitEventHandler()
        -- Respect disabling of the plugin.
        if not IsNCEnabled() then
            return true
        end

        -- Improper event data
        if not NCEvent:IsValidEvent() then
            if NCConfig:IsDebugging() and NCSpell:GetSource() == GetMyName() then 
                -- self:Print("Invalid event.")
                -- NemesisChat:Print("Cat:", NCEvent:GetCategory(), "Event:", NCEvent:GetEvent(), "Target:", NCEvent:GetTarget())
            end
            return true
        end

        -- Player is not in a group, exit
        if not IsInGroup() then
            if NCConfig:IsDebugging() then 
                -- self:Print("Player not in group.")
            end
            return true
        end

        return false
    end

    -- Combat Log event hydration
    function NemesisChat:PopulateCombatEventDetails()
        wipe(eventInfo)

        eventInfo.time, eventInfo.subEvent, eventInfo.hidecaster, eventInfo.sourceGUID, eventInfo.sourceName, eventInfo.sourceFlags, eventInfo.sourceRaidFlags, eventInfo.destGUID, eventInfo.destName, eventInfo.destFlags, eventInfo.destRaidFlags, eventInfo.misc1, eventInfo.misc2, eventInfo.misc3, eventInfo.misc4 = CombatLogGetCurrentEventInfo()

        if not NCRuntime:GetGroupRosterPlayer(eventInfo.sourceName) and not NCRuntime:GetGroupRosterPlayer(eventInfo.destName) and not bit_band(eventInfo.sourceFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0 then
            wipe(eventInfo)
            return
        end

        local subEvent, eventType, sourceName, destName, misc1, misc2, misc4 = eventInfo.subEvent, eventInfo.eventType, eventInfo.sourceName, eventInfo.destName, eventInfo.misc1, eventInfo.misc2, eventInfo.misc4
        local pullInfo = pullInfo or {}
        local isPull, pullType, pullPlayerName, mobName = NemesisChat:IsPull(pullInfo)
        local damage = NemesisChat:GetDamageAmount(subEvent, misc1, misc4)

        if bit_band(eventInfo.sourceFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0 then
            local petOwner = NemesisChat:GetPetOwner(eventInfo.sourceGUID)

            if petOwner then
                eventInfo.sourceName = petOwner
                sourceName = eventInfo.sourceName

                if not NCRuntime:GetGroupRosterPlayer(petOwner) and not NCRuntime:GetGroupRosterPlayer(eventInfo.destName) then
                    wipe(eventInfo)
                    return
                end
            end
        end

        NemesisChat:SetMyName()
        NemesisChat:ActionScoring()

        NCEvent:Initialize()
        NCEvent:SetCategory("COMBATLOG")

        if isPull and pullPlayerName then
            if NCRuntime:GetLastUnsafePullToastDelta() > 1.5 then
                -- Nesting this in to prevent spam
                if NCConfig:IsReportingPulls_Realtime() then
                    SendChatMessage("Nemesis Chat: " .. UnitName(pullPlayerName) .. " pulled " .. mobName, "YELL")
                end

                NemesisChat:SpawnToast("Pull", pullPlayerName, mobName)
                NCRuntime:UpdateLastUnsafePullToast()
            end

            NCRuntime:SetLastUnsafePull(UnitName(pullPlayerName), mobName)
            NCSegment:GlobalAddPull(UnitName(pullPlayerName))
        end

        wipe(pullInfo)

        if NCEvent:IsDamageEvent(subEvent, destName, damage) then
            local isAvoidable = (GTFO and GTFO.SpellID[tostring(misc1)] ~= nil)

            if isAvoidable then
                NCSegment:GlobalAddAvoidableDamage(damage, destName)
            end

            NCRuntime:SetPlayerStateValue(destName, "lastDamageAvoidable", isAvoidable)

            NCEvent:Damage(sourceName, destName, misc1, misc2, damage, isAvoidable)

            -- Damage events are handled in addition to everything else.
            NemesisChat:HandleEvent()
            NCEvent:Initialize()
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
            elseif subEvent == "SPELL_HEAL" then
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

    function NemesisChat:GetDamageAmount(event, arg1, arg4)
        if event == "SWING_DAMAGE" then
            return arg1 or 0
        elseif event == "RANGE_DAMAGE" or event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" then
            return arg4 or 0
        else
            return 0
        end
    end

    function NemesisChat:GetNemeses()
        return NCConfig:GetNemeses()
    end

    function NemesisChat:GetRandomNemesis()
        return NemesisChat:GetRandomKey(NemesisChat:GetNemeses())
    end

    function NemesisChat:GetNonExcludedNemesis()
        local nemeses

        if NCController:GetEventType() == NC_EVENT_TYPE_GROUP then
            nemeses = NemesisChat:GetPartyNemeses()
        else
            nemeses = NemesisChat:GetGuildNemeses()
        end

        for player, _ in pairs(nemeses) do
            if not tContains(NCController.excludedNemeses, player) then
                return player
            end
        end

        return nil
    end

    function NemesisChat:GetNonExcludedBystander()
        local bystanders

        if NCController:GetEventType() == NC_EVENT_TYPE_GROUP then
            bystanders = NemesisChat:GetPartyBystanders()
        else
            bystanders = NemesisChat:GetGuildBystanders()
        end

        for player, _ in pairs(bystanders) do
            if not tContains(NCController.excludedBystanders, player) then
                return player
            end
        end

        return nil
    end

    function NemesisChat:GetRandomPartyNemesis()
        local partyNemeses = NemesisChat:GetPartyNemeses()

        if not partyNemeses then 
            return nil
        end

        return partyNemeses[NemesisChat:GetRandomKey(partyNemeses)]
    end

    function NemesisChat:GetRandomGuildNemesis()
        local guildNemeses = NemesisChat:GetGuildNemeses()

        if not guildNemeses then
            return nil
        end

        return guildNemeses[NemesisChat:GetRandomKey(guildNemeses)]
    end

    function NemesisChat:GetRandomPartyBystander()
        local partyBystanders = NemesisChat:GetPartyBystanders()

        if not partyBystanders then
            return nil
        end

        local bystander = partyBystanders[NemesisChat:GetRandomKey(partyBystanders)]

        return bystander
    end

    function NemesisChat:GetRandomGuildBystander()
        local guildBystanders = NemesisChat:GetGuildBystanders()

        if not guildBystanders then
            return nil
        end

        return guildBystanders[NemesisChat:GetRandomKey(guildBystanders)]
    end

    function NemesisChat:GetPartyNemesesCount()
        return NemesisChat:GetLength(NemesisChat:GetPartyNemeses())
    end

    function NemesisChat:GetPartyNemeses()
        local nemeses = {}

        for key,val in pairs(NCRuntime:GetGroupRoster()) do
            if val and val.isNemesis then
                nemeses[key] = key
            end
        end

        return nemeses
    end

    function NemesisChat:GetGuildNemeses()
        local nemeses = {}

        for key,val in pairs(NCRuntime:GetGuildRoster()) do
            if val and val.isNemesis then
                nemeses[key] = key
            end
        end

        return nemeses
    end

    function NemesisChat:GetPartyBystanders()
        local bystanders = {}

        for key,val in pairs(NCRuntime:GetGroupRoster()) do
            if val and not val.isNemesis and key ~= GetMyName() then
                bystanders[key] = key
            end
        end

        return bystanders
    end

    function NemesisChat:GetGuildBystanders()
        local bystanders = {}

        for key,val in pairs(NCRuntime:GetGuildRoster()) do
            if key ~= GetMyName() and not val.isNemesis then
                bystanders[key] = key
            end
        end

        return bystanders
    end

    function NemesisChat:GetPartyBystandersCount()
        return NemesisChat:GetLength(NemesisChat:GetPartyBystanders())
    end

    function NemesisChat:GetNemesesLength()
        return NemesisChat:GetLength(NemesisChat:GetNemeses())
    end

    function NemesisChat:GetMessagesLength()
        return NemesisChat:GetLength(NemesisChat:GetMessages())
    end

    function NemesisChat:HasNemeses()
        return NemesisChat:GetNemesesLength() > 0
    end

    function NemesisChat:HasPartyNemeses()
        return NemesisChat:GetLength(NemesisChat:GetPartyNemeses()) > 0
    end

    function NemesisChat:HasPartyBystanders()
        return (NemesisChat:GetLength(NemesisChat:GetPartyBystanders()) > 0)
    end

    function NemesisChat:HasMessages()
        return NemesisChat:GetMessagesLength() > 0
    end

    -- We have to do a bit of trickery to get the total number of elements
    function NemesisChat:GetLength(myTable)
        local next = next
        local count = 0

        if type(myTable) ~= "table" or next(myTable) == nil then
            return 0
        end

        for k in pairs(myTable) do count = count + 1 end
        return count
    end

    -- Get all the keys of a hashmap
    function NemesisChat:GetKeys(myTable)
        local keys = {}
        for k in pairs(myTable) do table.insert(keys, k) end
        return keys
    end

    -- Get a hashmap of values from a table (key = key, value = key)
    function NemesisChat:GetDoubleMap(myTable)
        local keys = {}
        for k in pairs(myTable) do keys[k] = k end
        return keys
    end

    -- Get a random key from a hashmap
    function NemesisChat:GetRandomKey(myTable)
        local keys = NemesisChat:GetKeys(myTable)
        if #keys == 0 then
            return ""
        end
        return keys[math.random(#keys)]
    end

    -- Get a duration in human readable format (xmin ysec)
    function NemesisChat:GetDuration(timeStamp)
        if timeStamp == nil or timeStamp == 0 then
            return "no time"
        end

        return math.floor((GetTime() - timeStamp) / 60) .. "min " .. math.floor((GetTime() - timeStamp) % 60) .. "sec"
    end

    -- Get all the players in the group, as a hashmap (key = name, val = name)
    function NemesisChat:GetPlayersInGroup()
        local plist = setmetatable({}, {__mode = "kv"})

        if IsInRaid() then
            for i=1,40 do
                if (UnitName('raid'..i)) then
                    local n,s = UnitName('raid'..i)
                    local playerName = n

                    if s then 
                        playerName = playerName .. "-" .. s
                    end

                    if playerName ~= "Unknown" then
                        plist[playerName] = playerName
                    end
                end
            end
        elseif IsInGroup() then
            for i=1,5 do
                if (UnitName('party'..i)) then
                    local n,s = UnitName('party'..i)
                    local playerName = n

                    if s then 
                        playerName = playerName .. "-" .. s
                    end

                    if playerName ~= "Unknown" then
                        plist[playerName] = playerName
                    end
                end
            end
        end

        return plist
    end

    -- Get the difference between the current roster and the in-memory roster as a pair (joined,left)
    function NemesisChat:GetRosterDelta()
        local newRoster = NemesisChat:GetPlayersInGroup()
        local oldRoster = NemesisChat:GetDoubleMap(NCRuntime:GetGroupRoster())
        local joined = {}
        local left = {}

        -- Get joins
        for key,val in pairs(newRoster) do 
            if oldRoster[val] == nil and val ~= GetMyName() then
                tinsert(joined, val)
            end
        end

        -- Get leaves
        for key,val in pairs(oldRoster) do
            if newRoster[val] == nil and val ~= GetMyName() then
                tinsert(left, val)
            end
        end

        return joined,left
    end

    -- Check if all players within the group are dead
    function NemesisChat:IsWipe()
        if not UnitIsDead("player") then 
            return false
        end

        local players = NemesisChat:GetPlayersInGroup()
        
        for key,val in pairs(players) do
            if not UnitIsDead(val) then 
                return false
            end
        end

        return true
    end

    -- Get a random AI phrase for the event
    function NemesisChat:GetRandomAiPhrase()
        if core.ai.taunts[NCEvent:GetCategory()] == nil or core.ai.taunts[NCEvent:GetCategory()][NCEvent:GetEvent()] == nil or core.ai.taunts[NCEvent:GetCategory()][NCEvent:GetEvent()][NCEvent:GetTarget()] == nil then
            return
        end

        local pool = core.ai.taunts[NCEvent:GetCategory()][NCEvent:GetEvent()][NCEvent:GetTarget()]
        local key = math.random(#pool or 5)

        if pool == nil then 
            return ""
        end

        return pool[key]
    end

    -- If the player's name isn't set (or is set to a pre-load value), set it
    function NemesisChat:SetMyName()
        if core.runtime.myName == nil or core.runtime.myName == "" or core.runtime.myName == UNKNOWNOBJECT then
            core.runtime.myName = UnitName("player")
        end
    end

    -- Get a player's average item level. Currently only works if ElvUI or Details is installed, may be expanded later.
    function NemesisChat:GetItemLevel(unit)
        if UnitIsUnit(unit, "player") then
            return GetAverageItemLevel()
        end

        local rosterPlayer = NCRuntime:GetGroupRosterPlayer(unit)
        local rosterIlvl = rosterPlayer and rosterPlayer.itemLevel or nil

        if rosterIlvl ~= nil and rosterIlvl > 0 then
            return rosterPlayer.itemLevel
        end

        if E and E.GetUnitItemLevel then
            local itemLevel = E:GetUnitItemLevel(unit)

            if itemLevel ~= "tooSoon" then
                return itemLevel
            end
        end

        if Details and Details.ilevel then
            local rosterPlayer = NCRuntime:GetGroupRosterPlayer(unit)

            if rosterPlayer ~= nil then
                local detailsIlvlTable = Details.ilevel:GetIlvl(rosterPlayer.guid)

                if not detailsIlvlTable or not detailsIlvlTable.ilvl then
                    return nil
                end

                return detailsIlvlTable.ilvl
            end
        end

        return nil
    end

    -- Check the roster and (un/re)subscribe events appropriately
    function NemesisChat:CheckGroup()
        local isEnabled = IsNCEnabled()
        local hasGroupMembers = NCRuntime:GetGroupRosterCountOthers() > 0
        local shouldSubscribe = isEnabled and hasGroupMembers

        if NCRuntime.lastCheckSubscribe == shouldSubscribe then
            return
        end

        NCRuntime.lastCheckSubscribe = shouldSubscribe

        local action, reason
        if isEnabled then
            action = shouldSubscribe and "re-subscribing to" or "un-subscribing from"
            reason = "Group state changed"
        else
            action = "un-subscribing from"
            reason = "NemesisChat was disabled"
        end

        NemesisChat:Print(("%s, %s group based events."):format(reason, action))

        local method = shouldSubscribe and "RegisterEvent" or "UnregisterEvent"
        for _, event in pairs(core.eventSubscriptions) do
            NemesisChat[method](NemesisChat, event)
        end
    end

    -- Roll with a chance and return TRUE for successful rolls
    function NemesisChat:Roll(chance)
        local roll = math.random()

        if roll <= tonumber(chance) then
            return true
        end

        return false
    end

    -- Format a number (827, 8.27k, 82.74k, 827.44k, 8.27m, etc)
    function NemesisChat:FormatNumber(num)
        local numberToFormat = tonumber(num)

        if numberToFormat == nil or numberToFormat == 0 then
            return 0
        end

        if numberToFormat < 1000 then
            return numberToFormat .. ""
        end

        local thousands = math.floor(numberToFormat / 10) / 100

        if thousands < 1000 then
            return thousands .. "k"
        end

        return math.floor(thousands / 10) / 100 .. "m"
    end

    -- Populate friends map with currently online friends
    function NemesisChat:PopulateFriends()
        if GetTime() - NCRuntime:GetLastFriendCheck() < 60 then
            return
        end

        local _, onlineBnetFriends = BNGetNumFriends()

        NCRuntime:ClearFriends()

        for i = 1, onlineBnetFriends do
            local info = C_BattleNet.GetFriendAccountInfo(i)
            if info and info.gameAccountInfo then
                local character, client = info.gameAccountInfo.characterName, info.gameAccountInfo.clientProgram or ""

                -- Only add WoW characters
                if character and client == BNET_CLIENT_WOW then
                    -- Account for realm names, since our roster does as well
                    if info.gameAccountInfo.realmName and info.gameAccountInfo.realmName ~= GetNormalizedRealmName() then
                        character = character .. "-" .. info.gameAccountInfo.realmName
                    end

                    NCRuntime:AddFriend(character)
                end
            end
        end

        NCRuntime:UpdateLastFriendCheck()
    end

    -- Get the owner of a pet from cache, and if it doesn't exist in cache, set it and return the owner
    function NemesisChat:GetPetOwner(petGuid)
        for i = 1, 48 do
            scanTipTitles[#scanTipTitles + 1] = _G[format("UNITNAME_SUMMON_TITLE%i",i)]
        end

        NCRuntime:CheckPetOwners()

        local owner = NCRuntime:GetPetOwner(petGuid)

        if owner ~= nil then
            return owner
        end

        local owner = NemesisChat:ScanTooltipForPetOwner(petGuid)

        NCRuntime:AddPetOwner(petGuid, owner)
        
        return owner
    end

    -- Pull the owner of a pet from the tooltip
    function NemesisChat:ScanTooltipForPetOwner(guid)
        for i = 1, 48 do
            scanTipTitles[#scanTipTitles + 1] = _G[format("UNITNAME_SUMMON_TITLE%i",i)]
        end

        local text = _G[scanTipText]
        if(guid and text) then
            scanTip:SetOwner( WorldFrame, "ANCHOR_NONE" )
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

    function NemesisChat:UnitIsNotPulled(guid)
        NCRuntime:CheckPulledUnits()

        if NCRuntime:GetPulledUnit(guid) == nil then
            NCRuntime:AddPulledUnit(guid)
            return true
        end

        return false
    end

    function NemesisChat:GetActualChannel(inputChannel)
        if inputChannel ~= "GROUP" then
            return inputChannel
        end

        -- Default to party chat
        local channel = "PARTY"

        -- In an instance
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then channel = "INSTANCE_CHAT" end
        
        -- In a raid
        if IsInRaid() then channel = "RAID" end

        return channel
    end

    function NemesisChat:GetNewPlayerStateObject()
        return {
            health = 0,
            healthPercent = 0,
            power = 0,
            powerPercent = 0,
            powerType = "",
            lastHeal = GetTime(),
            lastDeltaReport = GetTime(),
            lastDefensive = GetTime(),
            lastDamageAvoidable = false,
        }
    end

    function NemesisChat:SetLastHealPlayerState(source, player)
        NCRuntime:CheckPlayerState(player)

        -- Self heals don't count
        if source ~= player then
            NCRuntime:GetPlayerState(player).lastHeal = GetTime()
        end
    end

    function NemesisChat:GetHealer()
        return NCRuntime:GetGroupHealer()
    end

    function NemesisChat:Print_r(...)
        local arg = {...}

        for _,item in pairs(arg) do
            if type(item) == "table" then
                for key,val in pairs(item) do
                    if type(key) == "table" then
                        self:Print("#### Table ####")
                        self:Print_r(key)
                        self:Print("#### End Table ####")
                    else
                        if type(val) == "boolean" then
                            self:Print("    - " .. key .. "(" .. type(val) .. "):", tostring(val))
                        elseif type(val) == "function" then
                            self:Print("    - " .. key .. "(function)")
                        elseif type(val) ~= "table" then
                            self:Print("    - " .. key .. "(" .. type(val) .. "):", val)
                        else
                            self:Print("#### Table ####")
                            self:Print(key .. ":")
                            self:Print_r(val)
                            self:Print("#### End Table ####")
                        end
                    end
                end
            elseif type (item) == "function" then
                self:Print("Function")
            elseif type(item) == "boolean" then
                self:Print(tostring(item))
            else
                self:Print(item)
            end
        end
    end

    function NemesisChat:IsHealerAlive()
        local healer = NemesisChat:GetHealer()

        if healer == nil then
            return false
        end

        return not UnitIsDead(healer)
    end

    function NemesisChat:UpdatePlayerState(player)
        NCRuntime:CheckPlayerState(player)
        local state = NCRuntime:GetPlayerState(player)

        state.health = UnitHealth(player)
        state.healthPercent = math.floor((UnitHealth(player) / UnitHealthMax(player)) * 10000) / 100 -- Round to 2 digit %
        state.power = UnitPower(player)
        state.powerPercent = math.floor((UnitPower(player) / UnitPowerMax(player)) * 10000) / 100 -- Round to 2 digit %
        state.powerType = UnitPowerType(player)

        if state.healthPercent >= 60 or state.health == 0 then
            state.lastHeal = GetTime()
        end
    end

    function NemesisChat:CheckLastHealDelta(playerName)
        local player = NCRuntime:GetPlayerState(playerName)

        if GetTime() - player.lastDeltaReport < 2 then
            return
        end

        if NemesisChat:IsHealerAlive() and NemesisChat:GetHealer() ~= playerName then
            local lastHealDelta = math.floor((GetTime() - player.lastHeal) * 100) / 100

            if not UnitIsDead(playerName) and player.healthPercent <= 55 and lastHealDelta >= 2 and NCConfig:IsReportingNeglectedHeals_Realtime() then
                -- If playerName is a nemesis, different message 
                if NCConfig:GetNemesis(playerName) ~= nil then
                    SendChatMessage("Nemesis Chat: " .. playerName .. " is at " .. player.healthPercent .. "% health, and has not received healing for " .. lastHealDelta .. " seconds! Please do not heal them -- it's okay if they die.", "YELL")
                else
                    SendChatMessage("Nemesis Chat: " .. playerName .. " is at " .. player.healthPercent .. "% health, and has not received healing for " .. lastHealDelta .. " seconds!", "YELL")
                end

                player.lastDeltaReport = GetTime()
            end
        end
    end

    function NemesisChat:UpdateGroupState()
        if IsInRaid() or not IsInGroup() or NCCombat:IsInactive() or NCRuntime:GetPlayerStatesLastCheckDelta() < 0.25 then
            return
        end

        NCRuntime:UpdatePlayerStatesLastCheck()

        for i=1,4 do
            if (UnitName('party'..i)) then
                local n,s = UnitName('party'..i)
                local playerName = n

                if s then 
                    playerName = playerName .. "-" .. s
                end

                if playerName ~= "Unknown" then
                    NemesisChat:UpdatePlayerState(playerName)
                    NemesisChat:CheckLastHealDelta(playerName)
                end
            end
        end

        NemesisChat:UpdatePlayerState(GetMyName())
        NemesisChat:CheckLastHealDelta(GetMyName())
    end

    -- Originally taken from https://github.com/logicplace/who-pulled/blob/master/WhoPulled/WhoPulled.lua, with heavy modifications
    function NemesisChat:IsPull()
        if not IsInGroup() or (NCBoss:IsActive() and NCDungeon:IsActive()) or IsInRaid() then
            return false
        end

        local _, event, _, sguid, sname, sflags, _, dguid, dname, dflags, _, arg1, _, _, arg4 = eventInfo.time, eventInfo.subEvent, eventInfo.sourceGUID, eventInfo.sourceName, eventInfo.sourceFlags, eventInfo.destGUID, eventInfo.destName, eventInfo.destFlags, eventInfo.destRaidFlags, eventInfo.misc1, eventInfo.misc2, eventInfo.misc3, eventInfo.misc4

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

            local damageAmount = 0

            -- More verbose and perhaps lacking in ingenuity, but it's easier to read
            if event == "SWING_DAMAGE" then
                damageAmount = arg1
            elseif event == "RANGE_DAMAGE" or event == "SPELL_DAMAGE" then
                damageAmount = arg4
            elseif event == "SPELL_PERIODIC_DAMAGE" then
                damageAmount = arg4
            end

            if(not string.find(event,"_SUMMON")) then
                if(bit.band(sflags,COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit.band(dflags,COMBATLOG_OBJECT_TYPE_NPC) ~= 0) then
                    -- A player is attacking a mob
                    local player = NCRuntime:GetGroupRosterPlayer(sname)

                    if IsInvalidPlayer(player) then
                        return false
                    end

                    local validDamage = damageAmount > 0
                    local isEliteEnemy = NemesisChat:IsEliteMob(dname)

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

                    local isEliteEnemy = NemesisChat:IsEliteMob(sname)

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

                    local validDamage = damageAmount > 0
                    local isEliteEnemy = NemesisChat:IsEliteMob(dname)
                        
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

    function NemesisChat:IsEliteMob(name)
        -- Iterate through all nameplates since we need a token to scan the tooltip
        for i = 1, 40 do
            local unit = "nameplate" .. i  -- Use nameplate tokens (e.g., nameplate1, nameplate2...)
            if UnitName(unit) == name then
                -- Name matches, scan the tooltip for Elite status
                local frame = CreateFrame("GameTooltip", "TooltipScan", nil, "GameTooltipTemplate")
                frame:SetOwner(WorldFrame, "ANCHOR_NONE")
                frame:SetUnit(unit)  -- Use the nameplate unit token

                for i = 1, frame:NumLines() do
                    local text = _G["TooltipScanTextLeft" .. i]:GetText()
                    if text and string.find(text, "Elite") then
                        return true
                    end
                end

                return false
            end
        end

        return false
    end

    local function checkFlags(flags, ...)
        for i = 1, select('#', ...) do
            if bit_band(flags, select(i, ...)) == 0 then
                return false
            end
        end
        return true
    end

    function NemesisChat:ActionScoring()
        local playerState = playerState or {}
        local CROWD_CTRL = LibPlayerSpells.constants.CROWD_CTRL
        local DISPEL = LibPlayerSpells.constants.DISPEL
        local SURVIVAL = LibPlayerSpells.constants.SURVIVAL
        local COOLDOWN = LibPlayerSpells.constants.COOLDOWN
        local eventInfo = eventInfo or setmetatable({}, {__mode = "kv"})
        local event, sname, spellId = eventInfo.subEvent, eventInfo.sourceName, eventInfo.misc1

        if not IsInGroup() or not UnitInParty(sname) then
            return
        end

        local flags = LibPlayerSpells:GetSpellInfo(spellId)
        if not flags then
            return
        end

        if checkFlags(flags, CROWD_CTRL) then
            NCSegment:GlobalAddCrowdControl(sname)
        elseif checkFlags(flags, DISPEL) then
            NCSegment:GlobalAddDispell(sname)
        elseif checkFlags(flags, SURVIVAL, COOLDOWN) then
            NCRuntime:GetPlayerState(sname, playerState)
            if playerState then
                playerState.lastDefensive = GetTime()
            end
            NCSegment:GlobalAddDefensive(sname)
        end

        -- NCSegment:GlobalAddActionPoints(1, sname, description)
    end

    function NemesisChat:IsAffixAuraHandled()
        if not IsInInstance() or not IsInGroup() then
            return false, nil
        end

        local _, event, _, _, sname, _, _, _, dname, _, _, _, _, _, dispelledId = CombatLogGetCurrentEventInfo()

        if (NCRuntime:GetGroupRosterPlayer(sname) == nil and sname ~= GetMyName()) or (NCRuntime:GetGroupRosterPlayer(dname) == nil and dname ~= GetMyName()) or event ~= "SPELL_DISPEL" then
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

    function NemesisChat:CheckIsAffix()
        if not IsInInstance() or not IsInGroup() then
            return false
        end

        local _,event,_,_,sname = CombatLogGetCurrentEventInfo()

        return core.affixMobsLookup[sname] == true
    end

    function NemesisChat:SilentGroupSync()
        NCRuntime:ClearGroupRoster()

        local members = NemesisChat:GetPlayersInGroup()

        for key,val in pairs(members) do
            if val ~= nil and val ~= GetMyName() then
                NCRuntime:AddGroupRosterPlayer(val)
            end
        end
    end

    function NemesisChat:AttemptSyncItemLevels()
        if not IsInGroup() then
            return
        end

        for key,val in pairs(NCRuntime:GetGroupRoster()) do
            if val ~= nil and val.itemLevel == nil then
                local itemLevel = NemesisChat:GetItemLevel(key)

                if itemLevel ~= nil then
                    val.itemLevel = itemLevel
                end
            end
        end
    end

    function NemesisChat:LowPriorityTimer()
        NemesisChat:AttemptSyncItemLevels()
    end

    function NemesisChat:Print(...)
        local notfound, c, message = true, ChatTypeInfo.SYSTEM, ""

        for _, msg in pairs({...}) do
            local strMsg = tostring(msg)
            if message == "" then
                message = strMsg
            else
                message = message .. " " .. strMsg
            end
        end

        message = NCColors.Emphasize("NemesisChat: ") .. message

        for i=1, NUM_CHAT_WINDOWS do
            -- if _G['ChatFrame'..i]:IsEventRegistered('CHAT_MSG_SYSTEM') then
            --     notfound = false
            --     _G['ChatFrame'..i]:AddMessage(message, c.r, c.g, c.b, c.id)
            -- end

            _G['ChatFrame'..i]:AddMessage(message, 1, 1, 1, c.id)
        end

        -- if notfound then
        --     DEFAULT_CHAT_FRAME:AddMessage(message, c.r, c.g, c.b, c.id)
        -- end
    end
end

function NemesisChat:UnitHasAura(unit, auraName, auraType)
    if string.lower(auraType) == "buff" then
        auraType = "HELPFUL"
    elseif string.lower(auraType) == "debuff" then
        auraType = "HARMFUL"
    end

    local _, _, count = AuraUtil.FindAuraByName(auraName, unit, auraType)

    return count ~= nil and tonumber(count) > 0, count
end

function NemesisChat:UnitHasBuff(unit, buffName)
    return NemesisChat:UnitHasAura(unit, buffName, "buff")
end

function NemesisChat:UnitHasDebuff(unit, debuffName)
    return NemesisChat:UnitHasAura(unit, debuffName, "debuff")
end

-- Instantiate NC objects since they are ephemeral and will not persist through a UI load
function NemesisChat:InstantiateCore()
    NCController = DeepCopy(core.runtimeDefaults.NCController)
    NemesisChat:InstantiateController()
    NCController:Initialize()

    NCSpell = DeepCopy(core.runtimeDefaults.ncSpell)
    NemesisChat:InstantiateSpell()

    NCEvent = DeepCopy(core.runtimeDefaults.ncEvent)
    NemesisChat:InstantiateEvent()

    if core.db.profile.cache.guild then
        core.runtime.guild = DeepCopy(core.db.profile.cache.guild)
    end

    if core.db.profile.cache.friends then
        core.runtime.friends = DeepCopy(core.db.profile.cache.friends)
    end

    if core.db.profile.cache.groupRoster and GetTime() - core.db.profile.cache.groupRosterTime <= core.runtime.dbCacheExpiration then
        core.runtime.groupRoster = DeepCopy(core.db.profile.cache.groupRoster)
    end

    NCDungeon:CheckCache()
end

function NemesisChat:Initialize()
    NemesisChat:SetEnabledState(IsNCEnabled())

    NemesisChat:InitializeConfig()
    NemesisChat:InitializeHelpers()
    NemesisChat:SetMyName()

    NemesisChat:InitIfEnabled()
end

function NemesisChat:InitIfEnabled()
    if not IsNCEnabled() then return end

    NCInfo:Initialize()
    NemesisChat:InitializeTimers()
    NemesisChat:PopulateFriends()
    NemesisChat:RegisterPrefixes()
    NemesisChat:RegisterToasts()
    NemesisChat:SilentGroupSync()
    NCRuntime:UpdateInitializationTime()
end

function NemesisChat:ClearAllData()
    -- Clear NCDungeon data
    if NCDungeon then
        NCDungeon:ClearCache()
        NCDungeon:Reset()
        NCDungeon:SetIdentifier(nil)
        NCDungeon.RosterSnapshot = {}
    end

    -- Clear other segment data
    if NCBoss then NCBoss:Reset() end
    if NCCombat then NCCombat:Reset() end

    -- Clear runtime data
    NCRuntime:ClearGroupRoster()
    NCRuntime:ClearPlayerStates()
    NCRuntime:ClearPulledUnits()
    NCRuntime:ClearPetOwners()

    -- Reset event data
    NCEvent:Initialize()

    -- Reset controller data
    NCController:Initialize()

    -- Reset spell data
    NCSpell:Initialize()

    -- Clear any stored rankings
    if NCDungeon.Rankings then NCDungeon.Rankings:Reset(NCDungeon) end

    -- Clear any stored caches
    wipe(core.db.profile.cache)

    -- Reinitialize core components
    NemesisChat:InstantiateCore()

    -- Resync group data
    NemesisChat:SilentGroupSync()
    NemesisChat:CheckGroup()

    -- Update the info frame
    NCInfo:Update()

    -- Print confirmation message
    NemesisChat:Print("All data has been cleared and reset.")
end
