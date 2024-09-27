-----------------------------------------------------
-- HELPER FUNCTIONS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")

-----------------------------------------------------
-- Core global helper functions
-----------------------------------------------------
function NemesisChat:InitializeHelpers()
    local leaverDb = NCDB:New("leavers")
    local lowPerformerDb = NCDB:New("lowPerformers")

    function NemesisChat:RegisterToasts()
        NemesisChat:RegisterToast("Pull", function(toast, player, mob)
            toast:SetTitle("|cffff4040Potentially Dangerous Pull|r")
            toast:SetText("|cffffffff" .. player .. " pulled " .. mob .. "!|r")
            toast:SetIconTexture([[Interface\ICONS\INV_10_Engineering2_BoxOfBombs_Dangerous_Color3]])
            toast:SetUrgencyLevel("emergency")
        end)
    end

    function NemesisChat:AddLeaver(guid)
        leaverDb:InsertIntoArray(guid, math.ceil(GetTime() / 10) * 10)

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
        lowPerformerDb:InsertIntoArray(guid, math.ceil(GetTime() / 10) * 10)

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

    function NemesisChat:GetMessages()
        return core.db.profile.messages
    end

    function NemesisChat:GetMyName()
        NemesisChat:SetMyName()
        return core.runtime.myName
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
        return NemesisChat:GetLength(NCState:GetGroupNemeses()) > 0
    end

    function NemesisChat:HasPartyBystanders()
        return (NemesisChat:GetLength(NCState:GetGroupBystanders()) > 0)
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
            local name, realm = UnitName("player")
            if name and name ~= UNKNOWNOBJECT then
                if realm and realm ~= "" then
                    core.runtime.myName = name .. "-" .. realm
                else
                    core.runtime.myName = name
                end
            end
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
        local healer = NCState:GetGroupHealer()

        if healer == nil then
            return false
        end

        return not UnitIsDead(healer)
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

    NCSpell = DeepCopy(core.runtimeDefaults.NCSpell)
    NemesisChat:InstantiateSpell()

    NCEvent = DeepCopy(core.runtimeDefaults.NCEvent)
    NemesisChat:InstantiateEvent()

    if NCCache:Exists(NC_CACHE_KEY_GUILD) then
        core.runtime.guild = DeepCopy(NCCache:Pull(NC_CACHE_KEY_GUILD))
    end

    if NCCache:Exists(NC_CACHE_KEY_FRIENDS) then
        core.runtime.friends = DeepCopy(NCCache:Pull(NC_CACHE_KEY_FRIENDS))
    end

    if NCCache:Exists(NC_CACHE_KEY_GROUP) and NCCache:GetPushDelta(NC_CACHE_KEY_GROUP) <= NCState:GetGroupCacheExpiration() then
        core.runtime.groupRoster = DeepCopy(NCCache:Get(NC_CACHE_KEY_GROUP))
    end

    NCDungeon:CheckCache()
end

function NemesisChat:Initialize()
    NemesisChat:InitializeConfig()
    NemesisChat:InitializeHelpers()
    NemesisChat:InitializeGlobals()
    NemesisChat:RegisterToasts()
    NemesisChat:SetMyName()
    NCInfo:Initialize()
end

function NemesisChat:InitializeGlobals()
    local count = 0
    for key, value in pairs(_G) do
        count = count + 1
        for prefix, name in pairs(NemesisChat._globalPrefixes) do
            if string.match(key, "^" .. prefix) then
                if not NemesisChat[name] then
                    NemesisChat[name] = {}
                end

                NemesisChat[name][key] = value
            end
        end
    end

    NemesisChat:Print("NemesisChat:InitializeGlobals() - Found " .. count .. " global variables.")
end

function NemesisChat:GetNameplateTokenByName(name)
    for i = 1, 40 do
        local unit = "nameplate" .. i -- Use nameplate tokens (e.g., nameplate1, nameplate2...)
        if UnitName(unit) == name then
            return unit
        end
    end
    return nil
end

function NemesisChat:CheckEliteStatus(unit)
    local frame = CreateFrame("GameTooltip", "TooltipScan", nil, "GameTooltipTemplate")
    frame:SetOwner(WorldFrame, "ANCHOR_NONE")
    frame:SetUnit(unit) -- Use the nameplate unit token

    for i = 1, frame:NumLines() do
        local text = _G["TooltipScanTextLeft" .. i]:GetText()
        if text and string.find(text, "Elite") then
            return true
        end
    end
    return false
end

function NemesisChat:IsEliteMob(name)
    local unit = NemesisChat:GetNameplateTokenByName(name)
    if unit then
        return NemesisChat:CheckEliteStatus(unit)
    end
    return false
end
