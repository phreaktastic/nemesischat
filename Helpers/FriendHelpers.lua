-----------------------------------------------------
-- FRIEND HELPERS
-- Handles friend list management and tracking
-----------------------------------------------------
local addonName, core = ...

-----------------------------------------------------
-- Friend List Management
-----------------------------------------------------
function NemesisChat:PopulateFriends()
    -- Throttle friend list updates
    if GetTime() - NCRuntime:GetLastFriendCheck() < 60 then
        return
    end

    -- Get online battle.net friends
    local _, onlineBnetFriends = BNGetNumFriends()
    NCRuntime:ClearFriends()

    -- Process each online friend
    for i = 1, onlineBnetFriends do
        self:ProcessBNetFriend(i)
    end

    NCRuntime:UpdateLastFriendCheck()
end

function NemesisChat:ProcessBNetFriend(index)
    local info = C_BattleNet.GetFriendAccountInfo(index)

    if info and info.gameAccountInfo then
        local character = info.gameAccountInfo.characterName
        local client = info.gameAccountInfo.clientProgram or ""

        if self:IsValidWoWFriend(character, client) then
            self:AddFriendToRuntime(character, info.gameAccountInfo.realmName)
        end
    end
end

-----------------------------------------------------
-- Friend Validation
-----------------------------------------------------
function NemesisChat:IsValidWoWFriend(character, client)
    return character and client == BNET_CLIENT_WOW
end

-----------------------------------------------------
-- Friend Data Processing
-----------------------------------------------------
function NemesisChat:AddFriendToRuntime(character, realmName)
    if realmName and realmName ~= GetNormalizedRealmName() then
        character = character .. "-" .. realmName
    end

    NCRuntime:AddFriend(character)
end

-----------------------------------------------------
-- Friend State Checks
-----------------------------------------------------
function NemesisChat:IsFriend(playerName)
    return NCRuntime:IsFriend(playerName)
end

function NemesisChat:GetFriendCount()
    return NCRuntime:GetFriendCount()
end
