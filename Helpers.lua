-----------------------------------------------------
-- HELPER FUNCTIONS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local addonName, core = ...;

local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")

-----------------------------------------------------
-- Blizzard functions
-----------------------------------------------------
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local GetTime = GetTime
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsInMyGuild = UnitIsInMyGuild
local UnitInParty = UnitInParty
local UnitIsDead = UnitIsDead
local UnitName = UnitName
local tContains = tContains
local tinsert = tinsert
local GetNormalizedRealmName = GetNormalizedRealmName
local BNGetNumFriends = BNGetNumFriends
local C_BattleNet = C_BattleNet
local BNET_CLIENT_WOW = BNET_CLIENT_WOW
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local UNKNOWNOBJECT = UNKNOWNOBJECT
local WorldFrame = WorldFrame
local CreateFrame = CreateFrame
local SendChatMessage = SendChatMessage
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitPowerType = UnitPowerType
local UnitIsUnconscious = UnitIsUnconscious
local SetRaidTarget = SetRaidTarget
local IsInInstance = IsInInstance
local UnitClassification = UnitClassification
local UnitGUID = UnitGUID
local C_ChatInfo = C_ChatInfo

-- APIs
local GTFO = GTFO

-- Core
local math = math
local format = format
local tonumber = tonumber
local tostring = tostring
local pairs = pairs
local table = table
local string = string

-----------------------------------------------------
-- Local variables
-----------------------------------------------------
local scanTipName = format("%s_ScanTooltip", addonName)
local scanTipText = format("%sTextLeft2", scanTipName)
local scanTip = CreateFrame("GameTooltip", scanTipName, WorldFrame, "GameTooltipTemplate")
local scanTipTitles = {}

for i = 1, 48 do
    scanTipTitles[#scanTipTitles + 1] = _G[format("UNITNAME_SUMMON_TITLE%i",i)]
end

-----------------------------------------------------
-- Core global helper functions
-----------------------------------------------------
function NemesisChat:InitializeHelpers()

    function NemesisChat:TransmitLeavers()
        if core.db.profile.leavers == nil or NCDungeon:IsActive() then
            return
        end

        NemesisChat:Transmit("NC_LEAVERS", core.db.profile.leavers, "YELL")
    end

    function NemesisChat:Transmit(prefix, data, channel, target)
        local serialized = LibSerialize:Serialize(data)
        local compressed = LibDeflate:CompressDeflate(serialized)
        local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed)

        if target and channel == "WHISPER" then
            self:SendCommMessage(prefix, encoded, channel, target)
        else
            self:SendCommMessage(prefix, encoded, channel)
        end
    end

    function NemesisChat:OnCommReceived(prefix, payload, distribution, sender)
        local decoded = LibDeflate:DecodeForWoWAddonChannel(payload)
        if not decoded then return end
        local decompressed = LibDeflate:DecompressDeflate(decoded)
        if not decompressed then return end
        local success, data = LibSerialize:Deserialize(decompressed)
        if not success then return end

        if sender == GetMyName() then
            return
        end

        if prefix == "NC_LEAVERS" then
            NemesisChat:ProcessLeavers(data)
        end
    end

    function NemesisChat:ProcessLeavers(leavers)
        if leavers == nil then
            return
        end

        if core.db.profile.leavers == nil then
            core.db.profile.leavers = {}
        end

        local count = 0

        for key,val in pairs(leavers) do
            count = count + 1
            if core.db.profile.leavers[key] == nil then
                core.db.profile.leavers[key] = val
            else
                core.db.profile.leavers[key] = ArrayMerge(core.db.profile.leavers[key], val)
            end
        end

        self:Print("Successfully synced " .. count .. " leavers.")
    end

    function NemesisChat:RegisterPrefixes()
        C_ChatInfo.RegisterAddonMessagePrefix("NC_LEAVERS")
    end

    function NemesisChat:AddLeaver(guid)
        if core.db.profile.leavers == nil then
            core.db.profile.leavers = {}
        end

        if core.db.profile.leavers[guid] == nil then
            core.db.profile.leavers[guid] = {}
        end

        tInsert(core.db.profile.leavers[guid], math.floor(GetTime() / 10) * 10)
    end

    function NemesisChat:InitializeTimers()
        self.SyncLeaversTimer = self:ScheduleRepeatingTimer("TransmitLeavers", 60)
    end

    function NemesisChat:GetMyName()
        NemesisChat:SetMyName()
        return GetMyName()
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

        -- Unit is/has cast(ing) a spell, but are not in the party
        if NCSpell:IsValidSpell() and not UnitInParty(NCSpell:GetSource()) then
            if NCConfig:IsDebugging() then 
                self:Print("Source is not in party.")
            end
            return true
        end

        return false
    end

    -- Combat Log event hydration
    function NemesisChat:PopulateCombatEventDetails()
        local timeStamp, subEvent, _, _, sourceName, _, _, destGuid, destName, _, _, misc1, misc2, misc3, misc4, _, _, _, _, _, _, healAmount = CombatLogGetCurrentEventInfo()
        local isPull, pullType, pullName, mobName = NemesisChat:IsPull()

        NemesisChat:SetMyName()
        NemesisChat:UpdateGroupState()
        NemesisChat:CheckAffixes()

        NCEvent:Initialize()
        NCEvent:SetCategory("COMBATLOG")

        -- Beta feature, to be cleaned up and polished
        if isPull then
            if NCConfig:IsReportingPulls_Realtime() then
                SendChatMessage("Nemesis Chat: " .. pullName .. " pulled " .. mobName, "YELL")
            end
            
            NCSegment:GlobalAddPull(pullName)
        end

        -- This could be more modular, the only problem is feasts...
        if subEvent == "SPELL_INTERRUPT" then
            NCEvent:Interrupt(sourceName, destName, misc1, misc2, misc4)
        elseif subEvent == "SPELL_CAST_SUCCESS" then
            NCEvent:Spell(sourceName, destName, misc1, misc2)
        elseif subEvent == "SPELL_HEAL" then
            NCEvent:Heal(sourceName, destName, misc1, misc2, healAmount)
        elseif subEvent == "PARTY_KILL" then
            NCEvent:Kill(sourceName, destName)
        elseif subEvent == "UNIT_DIED" then
            if not UnitInParty(destName) then
                return
            end

            NCEvent:Death(destName)
        elseif NCEvent:IsDamageEvent(subEvent, destName, misc4) then
            local damage = tonumber(misc4) or 0

            if GTFO and GTFO.SpellID[tostring(misc1)] ~= nil then
                NCSegment:GlobalAddAvoidableDamage(damage, destName)
            end
        else
            -- Something unsupported.
        end

        NemesisChat:HandleEvent()
    end

    function NemesisChat:GetMessages()
        return NCConfig:GetMessages()
    end

    function NemesisChat:GetNemeses()
        return NCConfig:GetNemeses()
    end

    function NemesisChat:GetRandomNemesis()
        return NemesisChat:GetRandomKey(NemesisChat:GetNemeses())
    end

    function NemesisChat:GetNonExcludedNemesis()
        local nemeses = NemesisChat:GetPartyNemeses()

        for player, _ in pairs(nemeses) do
            if not tContains(NCMessage.excludedNemeses, player) then
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

    function NemesisChat:GetRandomPartyBystander()
        local partyBystanders = NemesisChat:GetPartyBystanders()

        if not partyBystanders then 
            return nil
        end

        return partyBystanders[NemesisChat:GetRandomKey(partyBystanders)]
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

    function NemesisChat:GetPartyBystanders()
        local bystanders = {}

        for key,val in pairs(NCRuntime:GetGroupRoster()) do
            if val and not val.isNemesis then
                bystanders[key] = key
            end
        end

        return bystanders
    end

    function NemesisChat:GetNemeses()
        return NCConfig:GetNemeses()
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

        return math.floor((GetTime() - timeStamp) / 60) .. "min " .. ((GetTime() - timeStamp) % 60) .. "sec"
    end

    -- Get all the players in the group, as a hashmap (key = name, val = name)
    function NemesisChat:GetPlayersInGroup()
        local plist = {}

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
            for i=1,4 do
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
            if oldRoster[val] == nil then
                tinsert(joined, val)
            end
        end

        -- Get leaves
        for key,val in pairs(oldRoster) do
            if newRoster[val] == nil then
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
        if GetMyName() == nil or GetMyName() == "" or GetMyName() == UNKNOWNOBJECT then
            core.runtime.myName = UnitName("player")
        end
    end

    -- Check the roster and (un/re)subscribe events appropriately
    function NemesisChat:CheckGroup()
        if not IsNCEnabled() then
            NemesisChat:OnDisable()
        else
            NemesisChat:OnEnable()
        end

        NCRuntime:ClearGroupRoster()
        local members = NemesisChat:GetPlayersInGroup()
        local count = 0
        local nemeses = 0
    
        for key,val in pairs(members) do
            if val ~= nil then
                local isInGuild = UnitIsInMyGuild(val) ~= nil
                local isNemesis = (NCConfig:GetNemesis(val) ~= nil or (NCRuntime:GetFriend(val) ~= nil and NCConfig:IsFlaggingFriendsAsNemeses()) or (isInGuild and NCConfig:IsFlaggingGuildmatesAsNemeses()))
                count = count + 1
    
                if isNemesis then
                    nemeses = nemeses + 1
                end
    
                local rosterPlayer = {
                    guid = UnitGUID(val),
                    isGuildmate = isInGuild,
                    isFriend = NCRuntime:IsFriend(val),
                    isNemesis = isNemesis,
                    role = UnitGroupRolesAssigned(val),
                }

                NCRuntime:AddGroupRosterPlayer(val, rosterPlayer)
            end
        end

        if count > 0 then
            NemesisChat:RegisterEvent("PLAYER_REGEN_ENABLED")
            NemesisChat:RegisterEvent("ENCOUNTER_END")
            NemesisChat:RegisterEvent("CHALLENGE_MODE_COMPLETED")
            NemesisChat:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            NemesisChat:RegisterEvent("CHALLENGE_MODE_START")
            NemesisChat:RegisterEvent("ENCOUNTER_START")
            NemesisChat:RegisterEvent("PLAYER_REGEN_DISABLED")
            NemesisChat:RegisterEvent("PLAYER_ROLES_ASSIGNED")
        else
            NemesisChat:UnregisterEvent("PLAYER_REGEN_ENABLED")
            NemesisChat:UnregisterEvent("ENCOUNTER_END")
            NemesisChat:UnregisterEvent("CHALLENGE_MODE_COMPLETED")
            NemesisChat:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            NemesisChat:UnregisterEvent("CHALLENGE_MODE_START")
            NemesisChat:UnregisterEvent("ENCOUNTER_START")
            NemesisChat:UnregisterEvent("PLAYER_REGEN_DISABLED")
            NemesisChat:UnregisterEvent("PLAYER_ROLES_ASSIGNED")
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

    function NemesisChat:GetChannel(inputChannel)
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
        for key,val in pairs(NCRuntime:GetGroupRoster()) do
            if val.role == "HEALER" then
                return key
            end
        end

        return nil
    end

    function NemesisChat:Print_r(item)
        if type(item) == "table" then
            for key,val in pairs(item) do
                if type(key) == "table" then
                    self:Print_r(key)
                else
                    if type(val) ~= "table" then
                        self:Print(key .. ":", val)
                    else
                        self:Print(key .. ":")
                        self:Print_r(val)
                    end
                end
            end
        else
            self:Print(item)
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

            if not UnitIsDead(playerName) and player.healthPercent <= 60 and lastHealDelta >= 2 and NCConfig:IsReportingNeglectedHeals_Realtime() then
                SendChatMessage("Nemesis Chat: " .. playerName .. " is at " .. player.healthPercent .. "% health, and has not received healing for " .. lastHealDelta .. " seconds!", "YELL")
                player.lastDeltaReport = GetTime()
            end
        end
    end

    function NemesisChat:UpdateGroupState()
        if IsInRaid() or not IsInGroup() then
            return
        end

        if NCRuntime:GetPlayerStatesLastCheck() == nil or GetTime() - NCRuntime:GetPlayerStatesLastCheck() > 0.25 then
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
    end

    -- Largely taken from https://github.com/logicplace/who-pulled/blob/master/WhoPulled/WhoPulled.lua, with some modifications
    function NemesisChat:IsPull()
        if not IsInInstance() or not IsInGroup() then
            return false, nil, nil, nil
        end

        local time,event,hidecaster,sguid,sname,sflags,sraidflags,dguid,dname,dflags,draidflags,arg1,arg2,arg3,itype = CombatLogGetCurrentEventInfo()

        if not UnitInParty(sname) and not UnitInParty(dname) then
            return false, nil, nil, nil
        end

		if (dname and sname and dname ~= sname and not string.find(event,"_RESURRECT") and not string.find(event,"_CREATE") and (string.find(event,"SWING") or string.find(event,"RANGE") or string.find(event,"SPELL"))) and not tContains(core.affixMobs, sname) and not tContains(core.affixMobs, dname) then
			if(not string.find(event,"_SUMMON")) then
				if(bit.band(sflags,COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit.band(dflags,COMBATLOG_OBJECT_TYPE_NPC) ~= 0) and not tContains(core.affixMobs, dname) then
                    -- A player is attacking a mob
                    local player = NCRuntime:GetGroupRosterPlayer(sname)

                    if (sname ~= GetMyName() and (player == nil or player.role == "TANK")) or (sname == GetMyName() and UnitGroupRolesAssigned("player") == "TANK") then
                        NCRuntime:AddPulledUnit(dguid)
                        return false, nil, nil, nil
                    end

                    local validDamage = type(itype) == "number" and itype > 0
                    local classification = UnitClassification(dguid)
                    local isNotTrivial = classification ~= "trivial" and classification ~= "minus"

					if not UnitIsUnconscious(dguid) and validDamage and NemesisChat:UnitIsNotPulled(dguid) and isNotTrivial then
                        -- Fire off a pull event -- player attacked a mob!

                        return true, "PLAYER_ATTACK", sname, dname
					end
				elseif(bit.band(dflags,COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit.band(sflags,COMBATLOG_OBJECT_TYPE_NPC) ~= 0) and not tContains(core.affixMobs, sname) then
                    -- A mob is attacking a player
                    local player = core.runtime.groupRoster[dname]

                    if (dname ~= GetMyName() and (player == nil or player.role == "TANK")) or (dname == GetMyName() and UnitGroupRolesAssigned("player") == "TANK") then
                        NCRuntime:AddPulledUnit(dguid)
                        return false, nil, nil, nil
                    end

                    local classification = UnitClassification(sguid)
                    local isNotTrivial = classification ~= "trivial" and classification ~= "minus"

                    if NemesisChat:UnitIsNotPulled(sguid) and isNotTrivial then
                        -- Fire off a butt-pull event -- mob attacked a player!

                        return true, "PLAYER_PULL", dname, sname
                    end
				elseif(bit.band(sflags,COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 and bit.band(dflags,COMBATLOG_OBJECT_TYPE_NPC) ~= 0) and not tContains(core.affixMobs, dname) then
                    -- Player's pet attacks a mob
					local pullname;
					local pname = NemesisChat:GetPetOwner(sguid);

					if(pname == "Unknown") then pullname = sname.." (pet)";
					else pullname = pname;
					end

                    local validDamage = type(itype) == "number" and itype > 0
                    local classification = UnitClassification(dguid)
                    local isNotTrivial = classification ~= "trivial" and classification ~= "minus"
					    
                    if not UnitIsUnconscious(dguid) and validDamage and NemesisChat:UnitIsNotPulled(dguid) and isNotTrivial then
                        -- Fire off a pet pull event -- player's pet attacked a mob!

                        return true, "PET_ATTACK", pullname, dname
                    end
				elseif(bit.band(dflags,COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 and bit.band(sflags,COMBATLOG_OBJECT_TYPE_NPC) ~= 0) and not tContains(core.affixMobs, sname) then
                    --Mob attacks a player's pet
					local pullname;
					local pname = NemesisChat:GetPetOwner(dguid);

					if(pname == "Unknown") then pullname = dname.." (pet)";
					else pullname = pname;
					end

                    if NemesisChat:UnitIsNotPulled(sguid) then
                        -- Fire off a pet butt-pull event -- mob attacked a player's pet!

                        return true, "PET_PULL", pullname, sname
                    end
				end
			else
		 	    -- Summon
                local player = NCRuntime:GetGroupRosterPlayer(sname)

                if player ~= nil then
                    NCRuntime:AddPetOwner(dguid, sname)
                end

                return false, nil, nil, nil
			end
		end
    end

    function NemesisChat:IsAffixBeginCast()
        if not NemesisChat:CheckIsAffix() then
            return false
        end

        local _,event,_,sguid,sname = CombatLogGetCurrentEventInfo()

        return event == "SPELL_CAST_START", sguid, sname
    end

    function NemesisChat:IsAffixSuccessfulCast()
        if not NemesisChat:CheckIsAffix() then
            return false
        end

        local _,event,_,sguid,sname = CombatLogGetCurrentEventInfo()

        return event == "SPELL_CAST_SUCCESS", sguid, sname
    end

    function NemesisChat:IsAffixCastInterrupted()
        if not NemesisChat:CheckIsAffix() then
            return false
        end

        local _,event,_,sguid,sname = CombatLogGetCurrentEventInfo()

        return event == "SPELL_CAST_FAILED", sguid, sname
    end

    function NemesisChat:IsAffixMobHandled()
        if not IsInInstance() or not IsInGroup() then
            return false
        end

        local _,event,_,sguid,sname,_,_,dguid,dname = CombatLogGetCurrentEventInfo()

        if NCRuntime:GetGroupRosterPlayer(sname) == nil and sname ~= GetMyName() then
            return false
        end

        local isHandled = false

        if UnitIsUnconscious(dguid) or UnitIsDead(dguid) or string.find(event, "INSTAKILL") then
            return true, sname, dguid
        end

        if core.affixMobsHandles[dname] ~= nil then
            for _, eventSubstr in core.affixMobsHandles[dname] do
                if string.find(event, eventSubstr) then
                    isHandled = true
                    break
                end
            end
        end


        return isHandled, sname, dguid
    end

    function NemesisChat:CheckIsAffix()
        if not IsInInstance() or not IsInGroup() then
            return false
        end

        local _,event,_,_,sname = CombatLogGetCurrentEventInfo()

        return tContains(core.affixMobs, sname)
    end

    function NemesisChat:CheckAffixes()
        local isBeginCast, beginCastGuid, beginCastName = NemesisChat:IsAffixBeginCast()
        local isSuccessfulCast, successfulCastGuid, successfulCastName = NemesisChat:IsAffixSuccessfulCast()
        local isCastInterrupted, castInterruptedGuid, castInterruptedName = NemesisChat:IsAffixCastInterrupted()
        local isAffixMobHandled, affixMobHandlerName, affixMobHandledGuid = NemesisChat:IsAffixMobHandled()

        if isBeginCast then
            if core.db.profile.reportConfig["AFFIXES"]["CASTSTART"] then
                SendChatMessage("Nemesis Chat: " .. beginCastName .. " is casting!", "YELL")
            end

            -- if core.db.profile.reportConfig["AFFIXES"]["MARKERS"] and tContains(core.affixMobsMarker, beginCastName) then
            --     SetRaidTarget(beginCastGuid, core.markers[NCRuntime:GetRollingMarketIndex()])
            -- end
        end

        if isSuccessfulCast then
            if core.db.profile.reportConfig["AFFIXES"]["CASTSUCCESS"] then
                SendChatMessage("Nemesis Chat: " .. successfulCastName .. " successfully cast!", "YELL")
            end
        end

        if isCastInterrupted then
            if core.db.profile.reportConfig["AFFIXES"]["CASTINTERRUPTED"] and not UnitIsUnconscious(castInterruptedGuid) and not UnitIsDead(castInterruptedGuid) then
                SendChatMessage("Nemesis Chat: " .. castInterruptedName .. " cast interrupted, but not incapacitated/dead!", "YELL")
            end

            -- if core.db.profile.reportConfig["AFFIXES"]["MARKERS"] and UnitIsUnconscious(beginCastGuid) then
            --     SetRaidTarget(beginCastGuid, 0)
            -- end
        end

        if isAffixMobHandled then
            -- SetRaidTarget(affixMobHandledGuid, 0)

            NCSegment:GlobalAddAffix(affixMobHandlerName)
        end
    end
end

-- Instantiate NC objects since they are ephemeral and will not persist through a UI load
function NemesisChat:InstantiateCore()
    NCMessage = DeepCopy(core.runtimeDefaults.ncMessage)
    NemesisChat:InstantiateMsg()

    NCSpell = DeepCopy(core.runtimeDefaults.ncSpell)
    NemesisChat:InstantiateSpell()

    NCEvent = DeepCopy(core.runtimeDefaults.ncEvent)
    NemesisChat:InstantiateEvent()

    if core.runtime.NCDungeon ~= nil then
        NCDungeon = core.runtime.NCDungeon
    end
    
    if core.runtime.NCBoss ~= nil then
        NCBoss = core.runtime.NCBoss
    end
end
