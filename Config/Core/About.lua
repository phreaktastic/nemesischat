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
            name = "About NemesisChat v" .. core.version,
        },
        generalDesc = {
            order = 1,
            type = "description",
            fontSize = "medium",
            name =
            "NemesisChat is developed by Phreaktastic. Your feedback is invaluable! Join our Discord to share ideas, ask questions, or report issues. If you find NemesisChat useful, please consider supporting its development with a donation.",
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
        donateLink = {
            order = 6,
            type = "input",
            name = "Donate",
            desc = "Support the development of NC!",
            get = function()
                return
                "https://www.paypal.com/cgi-bin/webscr?return=https://www.curseforge.com/wow/addons/nemesis-chat&cn=Add+special+instructions+to+the+addon+author()&business=nate%40myl.io&bn=PP-DonationsBF:btn_donateCC_LG.gif:NonHosted&cancel_return=https://www.curseforge.com/wow/addons/nemesis-chat&lc=US&item_name=Nemesis+Chat+(from+www.curseforge.com)&cmd=_donations&rm=1&no_shipping=1&currency_code=USD"
            end,
            set = function() return end,
        },
        reportingPadding = {
            order = 7,
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
