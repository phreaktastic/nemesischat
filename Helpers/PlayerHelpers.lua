-----------------------------------------------------
-- PLAYER HELPERS
-- Handles player state tracking, health monitoring, and player data management
-----------------------------------------------------
local addonName, core = ...

-----------------------------------------------------
-- Player State Management
-----------------------------------------------------
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

function NemesisChat:UpdatePlayerState(player)
    NCRuntime:CheckPlayerState(player)
    local state = NCRuntime:GetPlayerState(player)

    -- Update health metrics
    state.health = UnitHealth(player)
    state.healthPercent = math.floor((UnitHealth(player) / UnitHealthMax(player)) * 10000) / 100

    -- Update power metrics
    state.power = UnitPower(player)
    state.powerPercent = math.floor((UnitPower(player) / UnitPowerMax(player)) * 10000) / 100
    state.powerType = UnitPowerType(player)

    -- Reset heal timer if health is good or player is dead
    if state.healthPercent >= 60 or state.health == 0 then
        state.lastHeal = GetTime()
    end
end

function NemesisChat:SetLastHealPlayerState(source, player)
    NCRuntime:CheckPlayerState(player)

    -- Only update heal time if healed by someone else
    if source ~= player then
        NCRuntime:GetPlayerState(player).lastHeal = GetTime()
    end
end

-----------------------------------------------------
-- Group State Monitoring
-----------------------------------------------------
function NemesisChat:UpdateGroupState()
    -- Skip updates under certain conditions
    if IsInRaid() or
       not IsInGroup() or
       NCCombat:IsInactive() or
       NCRuntime:GetPlayerStatesLastCheckDelta() < 0.25 then
        return
    end

    NCRuntime:UpdatePlayerStatesLastCheck()

    -- Update party member states
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

    -- Update player's own state
    NemesisChat:UpdatePlayerState(GetMyName())
    NemesisChat:CheckLastHealDelta(GetMyName())
end

-----------------------------------------------------
-- Healing Monitoring
-----------------------------------------------------
function NemesisChat:CheckLastHealDelta(playerName)
    local player = NCRuntime:GetPlayerState(playerName)

    -- Throttle reports
    if GetTime() - player.lastDeltaReport < 2 then
        return
    end

    if NemesisChat:IsHealerAlive() and NemesisChat:GetHealer() ~= playerName then
        local lastHealDelta = math.floor((GetTime() - player.lastHeal) * 100) / 100

        -- Check if player needs healing attention
        if not UnitIsDead(playerName) and
           player.healthPercent <= 55 and
           lastHealDelta >= 2 and
           ReplaceMeIsReportingNeglectedHeals() then

            -- Construct and send appropriate message
            local message = self:ConstructHealingNeededMessage(playerName, player.healthPercent, lastHealDelta)
            SendChatMessage(message, "YELL")

            player.lastDeltaReport = GetTime()
        end
    end
end

function NemesisChat:ConstructHealingNeededMessage(playerName, healthPercent, lastHealDelta)
    local baseMsg = string.format(
        "Nemesis Chat: %s is at %.2f%% health, and has not received healing for %.2f seconds!",
        playerName, healthPercent, lastHealDelta
    )

    -- Add extra warning for nemesis players
    if NCConfig:GetNemesis(playerName) ~= nil then
        return baseMsg .. " Please do not heal them -- it's okay if they die."
    end

    return baseMsg
end

-----------------------------------------------------
-- Player Identity Management
-----------------------------------------------------
function NemesisChat:GetMyName()
    NemesisChat:SetMyName()
    return core.runtime.myName
end

function NemesisChat:SetMyName()
    if core.runtime.myName == nil or
       core.runtime.myName == "" or
       core.runtime.myName == UNKNOWNOBJECT then
        core.runtime.myName = UnitName("player")
    end
end

-----------------------------------------------------
-- Healer Management
-----------------------------------------------------
function NemesisChat:GetHealer()
    return NCRuntime:GetGroupHealer()
end

function NemesisChat:IsHealerAlive()
    local healer = NemesisChat:GetHealer()
    if healer == nil then
        return false
    end
    return not UnitIsDead(healer)
end

-----------------------------------------------------
-- Item Level Synchronization
-----------------------------------------------------
function NemesisChat:AttemptSyncItemLevels()
    if not IsInGroup() then
        return
    end

    for key, val in pairs(NCRuntime:GetGroupRoster()) do
        if val ~= nil then
            -- Sync item level if not already known
            if val.itemLevel == nil then
                local itemLevel = NemesisChat:GetItemLevel(key)
                if itemLevel ~= nil then
                    val.itemLevel = itemLevel
                end
            end

            -- Ensure unit token is set
            if not val.token then
                val.token = NCRuntime:GetUnitTokenFromName(key)
            end
        end
    end
end

-----------------------------------------------------
-- Item Level Management
-----------------------------------------------------
function NemesisChat:GetItemLevel(unit)
    -- Handle different unit types
    if type(unit) == "string" then
        -- If unit is a name, convert to proper unit token
        if not unit:match("^party%d$") and not unit:match("^raid%d+$") then
            unit = NCRuntime:GetUnitTokenFromName(unit)
        end
    end

    -- Return nil if we couldn't get a valid unit token
    if not unit then return nil end

    -- Get item level
    if unit == "player" then
        return C_PaperDollInfo.GetInspectItemLevel("player")
    end

    -- For other group members, use inspection system
    local inspectGUID = UnitGUID(unit)
    if inspectGUID then
        return C_PaperDollInfo.GetInspectItemLevel(unit)
    end

    return nil
end
