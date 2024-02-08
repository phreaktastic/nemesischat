-----------------------------------------------------
-- SYNCHRONIZATION
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Logic for synchronizing data between clients
-----------------------------------------------------

NCSync = {
    lastSyncType = ""
}

function NCSync:TransmitSyncData()
    if NCRuntime:GetLastSyncType() == "" or NCRuntime:GetLastSyncType() == nil or NCRuntime:GetLastSyncType() == "LEAVERS" then
        NCRuntime:SetLastSyncType("LOWPERFORMERS")
        NemesisChat:TransmitLowPerformers()
    else
        NCRuntime:SetLastSyncType("LEAVERS")
        NemesisChat:TransmitLeavers()
    end
end