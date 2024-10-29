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

local GetTime = GetTime
local UnitIsDead = UnitIsDead
local UnitName = UnitName
local tContains = tContains
local IsInGroup = IsInGroup

-----------------------------------------------------
-- Core global helper functions
-----------------------------------------------------
function NemesisChat:InitializeHelpers()
    function NemesisChat:PrintNumberOfLeavers()
        NemesisChat:Print("Leavers:", NCConfig:GetLeaversCount())
    end

    function NemesisChat:PrintNumberOfLowPerformers()
        NemesisChat:Print("Low Performers:", NCConfig:GetLowPerformersCount())
    end

    function NemesisChat:PrintSyncKeys()
        NemesisChat:Print("LEAVER KEYS")
        local leavers = NCConfig:GetLeavers()
        NemesisChat:Print_r(NemesisChat:GetKeys(leavers))

        for key, val in pairs(leavers) do
            NemesisChat:Print(key, ":", #val)
        end

        NemesisChat:Print("LOW PERFORMER KEYS")
        local lowPerformers = NCConfig:GetLowPerformers()
        NemesisChat:Print_r(NemesisChat:GetKeys(lowPerformers))

        for key, val in pairs(lowPerformers) do
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
        local leavers = NCConfig:GetLeavers() or {}
        if not leavers[guid] then
            leavers[guid] = {}
        end

        NCConfig:AddLeaver(guid)

        NemesisChat:EncodeLeavers()
    end

    function NemesisChat:EncodeLeavers()
        if not NCConfig:GetLeavers() or NCConfig:GetLeaversCount() == 0 then
            NCConfig:SetLeaversEncoded(nil)
            return
        end

        NCConfig:SetLeaversSerialized(LibSerialize:Serialize(NCConfig:GetLeavers()))
        NCConfig:SetLeaversCompressed(LibDeflate:CompressDeflate(NCConfig:GetLeaversSerialized()))
        NCConfig:SetLeaversEncoded(LibDeflate:EncodeForWoWAddonChannel(NCConfig:GetLeaversCompressed()))

        NCConfig:SetLeaversSerialized(nil)
        NCConfig:SetLeaversCompressed(nil)
    end

    function NemesisChat:AddLowPerformer(guid)
        local lowPerformers = NCConfig:GetLowPerformers() or {}
        if not lowPerformers[guid] then
            lowPerformers[guid] = {}
        end

        table.insert(lowPerformers[guid], math.ceil(GetTime() / 10) * 10)
        NCConfig:SetLowPerformers(lowPerformers)
        NemesisChat:EncodeLowPerformers()
    end

    function NemesisChat:EncodeLowPerformers()
        if not NCConfig:GetLowPerformers() or NCConfig:GetLowPerformersCount() == 0 then
            NCConfig:SetLowPerformersEncoded(nil)
            return
        end

        NCConfig:SetLowPerformersSerialized(LibSerialize:Serialize(NCConfig:GetLowPerformers()))
        NCConfig:SetLowPerformersCompressed(LibDeflate:CompressDeflate(NCConfig:GetLowPerformersSerialized()))
        NCConfig:SetLowPerformersEncoded(LibDeflate:EncodeForWoWAddonChannel(NCConfig:GetLowPerformersCompressed()))

        NCConfig:SetLowPerformersSerialized(nil)
        NCConfig:SetLowPerformersCompressed(nil)
    end

    function NemesisChat:EncodeAddonMessageData()
        if not NemesisChat:GetLeaversEncoded() then
            NemesisChat:EncodeLeavers()
        end

        if not NemesisChat:GetLowPerformersEncoded() then
            NemesisChat:EncodeLowPerformers()
        end
    end

    function NemesisChat:LeaveCount(guid)
        return NCConfig:GetLeaverCount(guid)
    end

    function NemesisChat:LowPerformerCount(guid)
        return NCConfig:GetLowPerformerCount(guid)
    end

    function NemesisChat:InitializeTimers()
        if not self.SyncLeaversTimer then
            self.SyncLeaversTimer = self:ScheduleRepeatingTimer(
                core.AddonCommunication.TransmitSyncData, 60)
        end
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
            return true
        end

        -- Player is not in a group, exit
        if not IsInGroup() then
            return true
        end

        return false
    end

    function NemesisChat:GetNemeses()
        return NCConfig:GetNemeses()
    end

    function NemesisChat:GetRandomNemesis()
        return NemesisChat:GetRandomKey(NemesisChat:GetNemeses())
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

        for key, val in pairs(NCRuntime:GetGroupRoster()) do
            if val and val.isNemesis then
                nemeses[key] = key
            end
        end

        return nemeses
    end

    function NemesisChat:GetGuildNemeses()
        local nemeses = {}

        for key, val in pairs(NCRuntime:GetGuildRoster()) do
            if val and val.isNemesis then
                nemeses[key] = key
            end
        end

        return nemeses
    end

    function NemesisChat:GetPartyBystanders()
        local bystanders = {}

        for key, val in pairs(NCRuntime:GetGroupRoster()) do
            if val and not val.isNemesis and key ~= GetMyName() then
                bystanders[key] = key
            end
        end

        return bystanders
    end

    function NemesisChat:GetGuildBystanders()
        local bystanders = {}

        for key, val in pairs(NCRuntime:GetGuildRoster()) do
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

    function NemesisChat:HasPartyNemeses(forceFullLookup)
        if not forceFullLookup then
            return NCRuntime.hasNemesis
        end
        return NemesisChat:GetLength(NemesisChat:GetPartyNemeses()) > 0
    end

    function NemesisChat:HasPartyBystanders(forceFullLookup)
        if not forceFullLookup then
            return NCRuntime.hasBystander
        end
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
        local plist = setmetatable({}, { __mode = "kv" })

        if IsInRaid() then
            for i = 1, 40 do
                if (UnitName('raid' .. i)) then
                    local n, s = UnitName('raid' .. i)
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
            for i = 1, 5 do
                if (UnitName('party' .. i)) then
                    local n, s = UnitName('party' .. i)
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
        local oldRoster = NemesisChat:GetRosterPlayersMap()
        local joined = {}
        local left = {}

        -- Get joins
        for _, val in pairs(newRoster) do
            if oldRoster[val] == nil and val ~= GetMyName() then
                tinsert(joined, val)
            end
        end

        -- Get leaves
        for _, val in pairs(oldRoster) do
            if newRoster[val] == nil and val ~= GetMyName() then
                tinsert(left, val)
            end
        end

        return joined, left
    end

    function NemesisChat:GetRosterPlayersMap()
        local players = setmetatable({}, { __mode = "kv" })

        for key in pairs(NCRuntime:GetGroupRoster()) do
            players[key] = key
        end

        return players
    end

    -- Check if all players within the group are dead
    function NemesisChat:IsWipe()
        if not UnitIsDead("player") then
            return false
        end

        local players = NemesisChat:GetPlayersInGroup()

        for key, val in pairs(players) do
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
        local arg = { ... }

        for _, item in pairs(arg) do
            if type(item) == "table" then
                for key, val in pairs(item) do
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
            elseif type(item) == "function" then
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
        state.healthPercent = math.floor((UnitHealth(player) / UnitHealthMax(player)) * 10000) /
            100 -- Round to 2 digit %
        state.power = UnitPower(player)
        state.powerPercent = math.floor((UnitPower(player) / UnitPowerMax(player)) * 10000) /
            100 -- Round to 2 digit %
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

            if not UnitIsDead(playerName) and player.healthPercent <= 55 and lastHealDelta >= 2 and ReplaceMeIsReportingNeglectedHeals() then
                -- If playerName is a nemesis, different message
                if NCConfig:GetNemesis(playerName) ~= nil then
                    SendChatMessage(
                        "Nemesis Chat: " ..
                        playerName ..
                        " is at " ..
                        player.healthPercent ..
                        "% health, and has not received healing for " ..
                        lastHealDelta .. " seconds! Please do not heal them -- it's okay if they die.", "YELL")
                else
                    SendChatMessage(
                        "Nemesis Chat: " ..
                        playerName ..
                        " is at " ..
                        player.healthPercent ..
                        "% health, and has not received healing for " .. lastHealDelta .. " seconds!",
                        "YELL")
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

        for i = 1, 4 do
            if (UnitName('party' .. i)) then
                local n, s = UnitName('party' .. i)
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

    function NemesisChat:SilentGroupSync()
        NCRuntime:ClearGroupRoster()

        local members = NemesisChat:GetPlayersInGroup()

        for key, val in pairs(members) do
            if val ~= nil and val ~= GetMyName() then
                NCRuntime:AddGroupRosterPlayer(val)
            end
        end
    end

    function NemesisChat:AttemptSyncItemLevels()
        if not IsInGroup() then
            return
        end

        for key, val in pairs(NCRuntime:GetGroupRoster()) do
            if val ~= nil then
                if val.itemLevel == nil then
                    local itemLevel = NemesisChat:GetItemLevel(key)

                    if itemLevel ~= nil then
                        val.itemLevel = itemLevel
                    end
                end

                if not val.token then
                    val.token = NCRuntime:GetUnitTokenFromName(key)
                end
            end
        end
    end

    function NemesisChat:LowPriorityTimer()
        NemesisChat:AttemptSyncItemLevels()
    end

    function NemesisChat:Print(...)
        local notfound, c, message = true, ChatTypeInfo.SYSTEM, ""

        for _, msg in pairs({ ... }) do
            local strMsg = tostring(msg)
            if message == "" then
                message = strMsg
            else
                message = message .. " " .. strMsg
            end
        end

        message = NCColors.Emphasize("NemesisChat: ") .. message

        for i = 1, NUM_CHAT_WINDOWS do
            -- if _G['ChatFrame'..i]:IsEventRegistered('CHAT_MSG_SYSTEM') then
            --     notfound = false
            --     _G['ChatFrame'..i]:AddMessage(message, c.r, c.g, c.b, c.id)
            -- end

            _G['ChatFrame' .. i]:AddMessage(message, 1, 1, 1, c.id)
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

-- Instantiate NC objects since most are ephemeral and will not persist through a UI load
function NemesisChat:InstantiateCore()
    NCConfig:Initialize()
    NCController:Initialize()

    NCSpell = DeepCopy(core.runtimeDefaults.ncSpell)
    NemesisChat:InstantiateSpell()

    NCEvent:Initialize()

    if NCConfig:GetPath("cache.guild") then
        core.runtime.guild = DeepCopy(NCConfig:GetPath("cache.guild") or GetWeakTable())
    end

    if NCConfig:GetPath("cache.friends") then
        core.runtime.friends = DeepCopy(NCConfig:GetPath("cache.friends") or GetWeakTable())
    end

    if NCConfig:GetPath("cache.groupRoster") and GetTime() - NCConfig:GetPath("cache.groupRosterTime") <= core.runtime.dbCacheExpiration then
        core.runtime.groupRoster = DeepCopy(NCConfig:GetPath("cache.groupRoster") or GetWeakTable())
    end

    NCDungeon:CheckCache()
end

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

function NemesisChat:ClearAllData()
    -- Clear NCDungeon data
    if NCDungeon then
        NCDungeon:ClearCache()
        NCDungeon:Reset()
    end

    -- Clear other segment data
    if NCBoss then NCBoss:Reset() end
    if NCCombat then NCCombat:Reset() end

    -- Clear runtime data
    NCRuntime:ClearGroupRoster()
    NCRuntime:ClearPlayerStates()
    NCRuntime:ClearPulledUnits()
    NCRuntime:ClearPetOwners()
    NCRuntime:ClearLastCompletedDungeon()

    -- Reset event data
    NCEvent:Reset()

    -- Reset controller data
    NCController:Reset()

    -- Reset spell data
    NCSpell:Initialize()

    -- Clear any stored rankings
    if NCDungeon.Rankings then NCDungeon.Rankings:Reset(NCDungeon) end

    -- Clear any stored caches
    wipe(NCConfig:GetPath("cache"))

    -- Reinitialize core components
    NemesisChat:InstantiateCore()
    core.LFGHandler:Initialize()

    -- Resync group data
    NemesisChat:SilentGroupSync()
    NemesisChat:CheckGroup()

    -- Update the info frame
    NCInfo.CurrentPlayer = UnitName("player")
    NCInfo:Update()

    -- Print confirmation message
    NemesisChat:Print("All data has been cleared and reset.")
end
