local _, core = ...;

core.options.args.dungeonGroup.args.delves.args = {
    brannMessages = {
        order = 1,
        type = "group",
        name = "Brann Bronzebeard Messages",
        inline = true,
        args = {
            soloDelveWarning = {
                order = 1,
                type = "description",
                name =
                "Note: Solo delves will not benefit from Nemesis Chat metric tracking if Brann messages are disabled, as it treats Brann as an NPC when disabled.",
                fontSize = "medium",
                width = "full",
            },
            enableBrannMessages = {
                order = 2,
                type = "toggle",
                name = "Enable Brann Messages",
                desc = "Toggle Brann Bronzebeard's messages during Delves",
                width = "full",
                get = function() return NCConfig:IsAllowingBrannMessages() end,
                set = function(_, value) NCConfig:SetAllowingBrannMessages(value) end,
            },
        },
    },
}
