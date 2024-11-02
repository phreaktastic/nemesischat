local _, core = ...

local LFGHandlerTest = {}
core.LFGHandlerTest = LFGHandlerTest

-- Class/Spec data for test generation
local classSpecs = {
    WARRIOR = {
        {name = "Arms", role = "DAMAGER"},
        {name = "Fury", role = "DAMAGER"},
        {name = "Protection", role = "TANK"}
    },
    PALADIN = {
        {name = "Holy", role = "HEALER"},
        {name = "Protection", role = "TANK"},
        {name = "Retribution", role = "DAMAGER"}
    },
    -- ... (copy all the classSpecs data from original file)
}

local realms = {
    "Silvermoon", "Draenor", "Kazzak", "Tarren Mill", "Twisting Nether",
    "Ravencrest", "Argent Dawn", "Burning Legion", "Sylvanas"
}

local function GenerateRandomApplicant(groupID, groupSize)
    -- Get all class files into an array for random selection
    local classFiles = {}
    for classFile in pairs(classSpecs) do
        table.insert(classFiles, classFile)
    end

    -- Select random class
    local classFile = classFiles[math.random(#classFiles)]
    local className = LOCALIZED_CLASS_NAMES_MALE[classFile] or classFile

    -- Select random spec for that class
    local specData = classSpecs[classFile][math.random(#classSpecs[classFile])]
    local spec = specData.name
    local role = specData.role

    local realm = realms[math.random(#realms)]
    local itemLevel = math.random(565, 630)
    local dungeonScore = math.random(200, 3500)

    return {
        info = {
            primary = {
                itemLevel = floor(itemLevel),
                spec = spec,
                class = className,
                classFile = classFile,
                specIcon = "Interface\\Icons\\INV_Misc_QuestionMark"
            },
            secondary = {
                dungeonScore = floor(dungeonScore),
                realm = realm
            }
        },
        role = {
            type = role,
            texture = core.LFGHandler.ROLE_ICONS[role]
        },
        reason = core.LFGHandler.Config.FILTERS[math.random(5)],
        applicantID = math.random(1000000),
        groupID = groupID,
        groupSize = groupSize,
        isTest = true
    }
end

function LFGHandlerTest:AddTestEntries(count)
    count = count or 1
    local LFGHandler = core.LFGHandler

    -- Clear any existing test entries from the queue
    if LFGHandler.Cache.ignoredQueue then
        local i = 1
        while i <= #LFGHandler.Cache.ignoredQueue do
            if LFGHandler.Cache.ignoredQueue[i].isTest then
                table.remove(LFGHandler.Cache.ignoredQueue, i)
            else
                i = i + 1
            end
        end
    else
        LFGHandler.Cache.ignoredQueue = {}
    end

    local originalIsBlocked = LFGHandler.IsBlocked
    LFGHandler.IsBlocked = function() return false end

    for i = 1, count do
        -- Decide if this should be a group or single entry
        local isGroup = (math.random(100) <= 10) -- 10% chance of being a group
        local groupSize = isGroup and math.random(2, 4) or 1
        local groupID = isGroup and math.random(1000000) or nil

        for j = 1, groupSize do
            local entry = GenerateRandomApplicant(groupID, groupSize)
            table.insert(LFGHandler.Cache.ignoredQueue, entry)
        end
    end

    LFGHandler:ShowIgnoredPopup()
    LFGHandler.IsBlocked = originalIsBlocked
end

function NemesisChat:AddTestEntries(count)
    core.LFGHandlerTest:AddTestEntries(count)
end
