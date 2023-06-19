-----------------------------------------------------
-- BOSS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Boss getters, setters, etc.
-----------------------------------------------------

function NemesisChat:InstantiateBoss()
    function NCBoss:Initialize()
        NCBoss = DeepCopy(core.runtimeDefaults.ncBoss)

        NemesisChat:InstantiateBoss()
    end

    function NCBoss:IsActive()
        return NCBoss.active
    end

    function NCBoss:SetActive(active)
        NCBoss.active = active
    end

    function NCBoss:GetStartTime()
        return NCBoss.startTime
    end

    function NCBoss:SetStartTime(startTime)
        NCBoss.startTime = startTime
    end

    function NCBoss:GetName()
        return NCBoss.name
    end

    function NCBoss:SetName(name)
        NCBoss.name = name
    end

    function NCBoss:IsComplete()
        return NCBoss.complete
    end

    function NCBoss:SetComplete(complete)
        NCBoss.complete = complete
    end

    function NCBoss:IsSuccess()
        return NCBoss.success
    end

    function NCBoss:SetSuccess(success)
        NCBoss.success = success
    end

    function NCBoss:Start(bossName)
        NCBoss:Initialize()
        NCBoss.active = true
        NCBoss.startTime = GetTime()
        NCBoss.name = bossName
        NCBoss.complete = false
        NCBoss.success = false

        NCEvent:StartBoss()

        core.runtime.NCBoss = NCBoss
    end

    function NCBoss:End(isSuccess)
        NCBoss.active = false
        NCBoss.complete = true
        NCBoss.success = isSuccess

        NCEvent:EndBoss()

        core.runtime.NCBoss = nil
    end
end