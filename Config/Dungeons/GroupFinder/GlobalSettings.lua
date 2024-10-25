-----------------------------------------------------
-- Group Finder Global Settings Configuration
-----------------------------------------------------
local _, core = ...;

local minItemLevelMin = 0
local minItemLevelMax = 650

core.options.args.dungeonGroup.args.lfgTools.args.globalRequirements = {
    order = 1,
    type = "group",
    name = "Global Requirements",
    args = {
        minLevels = {
            order = 1,
            type = "group",
            name = "Minimum Requirements",
            inline = true,
            args = {
                description = {
                    order = 1,
                    type = "description",
                    fontSize = "medium",
                    name = "Set baseline requirements for all applicants:",
                },
                minItemLevel = {
                    order = 2,
                    type = "range",
                    name = "Minimum Item Level",
                    desc = "Global minimum item level requirement",
                    min = minItemLevelMin,
                    max = minItemLevelMax,
                    step = 1,
                    width = "full",
                    get = function() return NCConfig:GetApplicantMinItemLevel() end,
                    set = function(_, value) NCConfig:SetApplicantMinItemLevel(value) end,
                },
                minDungeonScore = {
                    order = 3,
                    type = "range",
                    name = "Minimum M+ Score",
                    desc = "Global minimum Mythic+ rating requirement",
                    min = 0,
                    max = 5000,
                    step = 10,
                    width = "full",
                    get = function() return NCConfig:GetApplicantMinDungeonScore() end,
                    set = function(_, value) NCConfig:SetApplicantMinDungeonScore(value) end,
                },
            }
        }
    }
}
