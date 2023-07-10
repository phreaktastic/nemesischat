-----------------------------------------------------
-- CONFIGURATION UI
-----------------------------------------------------
-- About Tab
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

core.options.args.aboutGroup = {
    order = 5,
    type = "group",
    name = "About",
    args = {
        generalHeader = {
            order = 0,
            type = "header",
            name = "About Nemesis Chat " .. core.version,
        },
        generalDesc = {
            order = 1,
            type = "description",
            fontSize = "medium",
            name = "Nemesis Chat was (poorly) written by Phreaktastic. Features essentially just come as I run M+ dungeons with my guild and new ideas are spawned.\n\nNC is NOT meant to be anything more than friendly banter. Be cool, don't use it to actually berate people. Use it to have fun and banter with your friends!\n\nThe purpose of this addon is to taunt friends while running in groups. I main DPS, so the majority of features are from a DPS player's standpoint. Other features will likely be added in the future (such as detecting if someone used defensives before a death), embracing other roles and functionality they may enjoy.",
        },
        generalPadding = {
            order = 3,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        reportingHeader = {
            order = 4,
            type = "header",
            name = "Bug Reporting / Suggestions",
        },
        discordLink = {
            order = 5,
            type = "input",
            name = "Discord",
            desc = "Join the Discord community to request features, get help, and more!",
            get = "DiscordLink",
            set = function() return end,
        },
        githubLink = {
            order = 5,
            type = "input",
            name = "Github",
            desc = "Contribute to NC!",
            get = "GithubLink",
            set = function() return end,
        },
        reportingPadding = {
            order = 6,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        plannedHeader = {
            order = 7,
            type = "header",
            name = "Potential Features, Enhancements, & Fixes",
        },
        plannedDesc = {
            order = 8,
            type = "description",
            fontSize = "medium",
            name = "|c00ffcc00Import/Export|r: The ability to export settings and defined messages as a string. This would allow you to share your setup with others, or import others' handy work.\n|c00ffcc00AI Praise Messages|r: Wrapping up the AI generated message functionality with the ability to select between taunts and praises. Further configuration to allow granular configuration based on who triggers an event.\n|c00ffcc00Selection Mode|r: A toggleable mode which will show a non-invasive pop-up to choose phrases. Example, you just finished a M+ and now have a pop-up with phrases to choose from (both from the end trigger AND Details data). This would be useful for scenarios where multiple events may trigger, but you don't want them to spam chat.\n",
        },
        plannedPadding = {
            order = 9,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        plannedDisclaimer = {
            order = 10,
            type = "description",
            fontSize = "large",
            name = "Disclaimer: None of the features, enhancements, or fixes listed above are guaranteed. I have provided a general roadmap as a guide to what is currently on the radar and being considered. It is not meant as a list of priorities or work that is in progress.",
        },
        plannedDisclaimerPadding = {
            order = 11,
            type = "description",
            fontSize = "large",
            name = " ",
        },
    }
}

function NemesisChat:DiscordLink()
    return "https://discord.gg/mqu3vk6csk"
end

function NemesisChat:GithubLink()
    return "https://github.com/phreaktastic/nemesischat"
end