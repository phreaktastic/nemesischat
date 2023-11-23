-----------------------------------------------------
-- DUNGEON
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Dungeon getters, setters, etc.
-----------------------------------------------------

NCDungeon = NCSegment:New()

NCDungeon.Level = 0
NCDungeon.Affixes = {}

function NCDungeon:StartCallback()
    NCEvent:SetCategory("CHALLENGE")
    NCEvent:SetEvent("START")
    NCEvent:SetTarget("NA")
    NCEvent:RandomNemesis()
    NCEvent:RandomBystander()
    NCDungeon:SetDetailsSegment(DETAILS_SEGMENTID_OVERALL)

    local keystoneLevel, affixIDs = C_ChallengeMode.GetActiveKeystoneInfo()
    local name, mapChallengeModeID, timeLimit = C_ChallengeMode.GetMapUIInfo(C_ChallengeMode.GetActiveChallengeMapID())

    NCDungeon:SetIdentifier(name)
    NCDungeon:SetLevel(keystoneLevel)
    NCDungeon:SetAffixes(affixIDs)

    NCInfo:Update()
end

function NCDungeon:FinishCallback(success)
    NCEvent:SetCategory("CHALLENGE")
    NCEvent:SetEvent("FAIL")
    NCEvent:SetTarget("NA")
    NCEvent:RandomNemesis()
    NCEvent:RandomBystander()

    if success then
        NCEvent:SetEvent("SUCCESS")
    end

    local lowestPerformer, score = NCDungeon:GetLowestPerformer()

    if lowestPerformer ~= nil and score ~= nil then
        local player = NCRuntime:GetGroupRosterPlayer(lowestPerformer)

        if score >= 5 and player ~= nil and player.guid ~= nil then
            NemesisChat:AddLowPerformer(player.guid)

            NemesisChat:Print("Added low performer to DB:", lowestPerformer)
            NemesisChat:Print("Score:", score)
        end
    end
end

function NCDungeon:ResetCallback()
    NCDungeon:SetLevel(0)
end

function NCDungeon:GetLevel()
    return (NCDungeon.Level or 0)
end

function NCDungeon:SetLevel(level)
    NCDungeon.Level = (level or 0)
end

function NCDungeon:SetAffixes(affixes)
    NCDungeon.Affixes = affixes
end

function NCDungeon:GetAffixes()
    return NCDungeon.Affixes
end