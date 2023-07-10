-----------------------------------------------------
-- HELPER FUNCTIONS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Core global helper functions
-----------------------------------------------------
function NemesisChat:InitializeHelpers()

    function NemesisChat:GetMyName()
        NemesisChat:SetMyName()
        return core.runtime.myName
    end

    function NemesisChat:ShouldExitEventHandler()
        -- Respect disabling of the plugin.
        if not core.db.profile.enabled then
            return true
        end

        -- Improper event data
        if not NCEvent:IsValidEvent() then
            if core.db.profile.dbg and NCSpell:GetSource() == core.runtime.myName then 
                -- self:Print("Invalid event.")
                -- NemesisChat:Print("Cat:", NCEvent:GetCategory(), "Event:", NCEvent:GetEvent(), "Target:", NCEvent:GetTarget())
            end
            return true
        end

        -- Player is not in a group, exit
        if not IsInGroup() then
            if core.db.profile.dbg then 
                -- self:Print("Player not in group.")
            end
            return true
        end

        -- Configs are not setup, exit
        if not NemesisChat:HasNemeses() or (not NemesisChat:HasMessages() and not core.db.profile.ai) then
            if core.db.profile.dbg then 
                self:Print("Invalid config.")
            end
            return true
        end

        -- Unit is/has cast(ing) a spell, but are not in the party
        if NCSpell:IsValidSpell() and not UnitInParty(NCSpell:GetSource()) then
            if core.db.profile.dbg then 
                self:Print("Source is not in party.")
            end
            return true
        end

        -- We don't have a nemesis, exit
        if not NCEvent:HasNemesis() then
            if core.db.profile.dbg then 
                self:Print("No nemesis.")
            end
            return true
        end

        return false
    end

    -- Combat Log event hydration
    function NemesisChat:PopulateCombatEventDetails()
        local timeStamp, subEvent, _, _, sourceName, _, _, destGuid, destName, _, _, misc1, misc2, misc3, misc4 = CombatLogGetCurrentEventInfo()

        NemesisChat:SetMyName()
        NCEvent:Initialize()
        NCEvent:SetCategory("COMBATLOG")

        -- This could be more modular, the only problem is feasts...
        if subEvent == "SPELL_INTERRUPT" then
            NCEvent:Interrupt(sourceName, destName, misc1, misc2, misc4)
            NCCombat:AddInterrupt(sourceName)
            NCDungeon:AddInterrupt(sourceName)
        elseif subEvent == "SPELL_CAST_SUCCESS" then
            NCEvent:Spell(sourceName, destName, misc1, misc2)
        elseif subEvent == "SPELL_HEAL" then
            NCEvent:Heal(sourceName, destName, misc1, misc2)
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
                NCDungeon:AddAvoidableDamage(damage, destName)
                NCCombat:AddAvoidableDamage(damage, destName)
            end
        else
            -- Something unsupported.
        end

        NemesisChat:HandleEvent()
    end

    function NemesisChat:IncrementDeaths(playerName)
        if not UnitInParty(playerName) then
            return
        end

        if core.runtime.deathCounter[playerName] ~= nil then
            core.runtime.deathCounter[playerName] = core.runtime.deathCounter[playerName] + 1
        else 
            core.runtime.deathCounter[playerName] = 1
        end
    end

    function NemesisChat:IncrementKills(playerName)
        if not UnitInParty(playerName) then
            return
        end

        if core.runtime.killCounter[playerName] ~= nil then
            core.runtime.killCounter[playerName] = core.runtime.killCounter[playerName] + 1
        else 
            core.runtime.killCounter[playerName] = 1
        end
    end

    function NemesisChat:GetMessages()
        return core.db.profile.messages
    end

    function NemesisChat:GetNemeses()
        return core.db.profile.nemeses
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

        for key,val in pairs(core.runtime.groupRoster) do
            if val and val.isNemesis then
                nemeses[key] = key
            end
        end

        return nemeses
    end

    function NemesisChat:GetPartyBystanders()
        local bystanders = {}

        for key,val in pairs(core.runtime.groupRoster) do
            if val and not val.isNemesis then
                bystanders[key] = key
            end
        end

        return nemeses
    end

    function NemesisChat:GetNemeses()
        return core.db.profile.nemeses
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
        local oldRoster = NemesisChat:GetDoubleMap(core.runtime.groupRoster)
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
        if core.runtime.myName == nil or core.runtime.myName == "" or core.runtime.myName == UNKNOWNOBJECT then
            core.runtime.myName = UnitName("player")
        end
    end

    -- Check compatibility with enabled APIs
    function NemesisChat:CheckAPICompatibility()
        if core.db.profile.detailsAPI == true and Details == nil then
            self:Print("Details API is enabled, but Details cannot be found! Please enable Details.")
        end

        if core.db.profile.gtfoAPI == true and GTFO == nil then
            self:Print("GTFO API is enabled, but GTFO cannot be found! Please enable GTFO.")
        end
    end

    -- Check the roster and (un/re)subscribe events appropriately
    function NemesisChat:CheckGroup()
        if not core.db.profile.enabled then
            NemesisChat:OnDisable()
        else
            NemesisChat:OnEnable()
        end

        core.runtime.groupRoster = {}
        local members = NemesisChat:GetPlayersInGroup()
        local count = 0
        local nemeses = 0
    
        for key,val in pairs(members) do
            if val ~= nil then
                local isNemesis = (core.db.profile.nemeses[val] ~= nil)
                count = count + 1
    
                if isNemesis then
                    nemeses = nemeses + 1
                end
    
                core.runtime.groupRoster[val] = {
                    isNemesis = isNemesis,
                    role = UnitGroupRolesAssigned(val),
                }
            end
        end
    
        if count > 0 and nemeses > 0 then
            NemesisChat:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            NemesisChat:RegisterEvent("CHALLENGE_MODE_START")
            NemesisChat:RegisterEvent("CHALLENGE_MODE_COMPLETED")
            NemesisChat:RegisterEvent("ENCOUNTER_START")
            NemesisChat:RegisterEvent("ENCOUNTER_END")
            NemesisChat:RegisterEvent("PLAYER_REGEN_DISABLED")
            NemesisChat:RegisterEvent("PLAYER_REGEN_ENABLED")
        else
            if not core.db.profile.pugMode then
                NemesisChat:UnregisterEvent("PLAYER_REGEN_ENABLED")
                NemesisChat:UnregisterEvent("ENCOUNTER_END")
                NemesisChat:UnregisterEvent("CHALLENGE_MODE_COMPLETED")
            end

            NemesisChat:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            NemesisChat:UnregisterEvent("CHALLENGE_MODE_START")
            NemesisChat:UnregisterEvent("ENCOUNTER_START")
            NemesisChat:UnregisterEvent("PLAYER_REGEN_DISABLED")
            
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
    else
        NCDungeon = DeepCopy(core.runtimeDefaults.ncDungeon)
    end
    
    if core.runtime.NCBoss ~= nil then
        NCBoss = core.runtime.NCBoss
    else
        NCBoss = DeepCopy(core.runtimeDefaults.ncBoss)
    end

    NemesisChat:InstantiateDungeon()
    NemesisChat:InstantiateBoss()
    NemesisChat:InstantiateCombat()
end
