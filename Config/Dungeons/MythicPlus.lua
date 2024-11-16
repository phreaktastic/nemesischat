local _, core = ...

core.options.args.dungeonGroup.args.mythicPlus.args = {
    pullTracking = {
        order = 1,
        type = "group",
        name = "Pull Tracking",
        inline = true,
        args = {
            pullTrackingDescription = {
                order = 0,
                type = "description",
                name =
                "Pulls are always tracked. Use the options below to customize real-time reporting and notifications.",
            },
            enablePullReporting = {
                order = 1,
                type = "toggle",
                name = "Enable Real-Time Pull Announcements",
                desc = "Toggle to send a chat message when a pull is detected",
                get = function() return NCConfig:IsReportingPulls_Realtime() end,
                set = function() NCConfig:ToggleReportingPulls_Realtime() end,
            },
            pullTrackingChannel = {
                order = 2,
                type = "select",
                name = "Pull Announcement Channel",
                desc = "Choose the chat channel for pull announcements",
                values = {
                    SAY = "Say",
                    PARTY = "Party",
                    RAID = "Raid",
                },
                get = function() return NCConfig:GetReportingPulls_Channel() end,
                set = function(_, value) NCConfig:SetReportingPulls_Channel(value) end,
                disabled = function() return not NCConfig:IsReportingPulls_Realtime() end,
            },
            showPullToast = {
                order = 3,
                type = "toggle",
                name = "Show Pull Notifications",
                desc = "Toggle to show a notification for each pull",
                get = function() return NCConfig:IsReportingPulls_Toast() end,
                set = function(_, value) NCConfig:ToggleReportingPulls_Toast(value) end,
            },
        },
    },
    playerTracking = {
        order = 2,
        type = "group",
        name = "Player Tracking",
        inline = true,
        args = {
            trackLeavers = {
                order = 1,
                type = "toggle",
                name = "Track Leavers",
                desc = "Enable or disable tracking of players who leave the group",
                get = function() return NCConfig:IsTrackingLeavers() end,
                set = function(_, value) NCConfig:SetTrackingLeavers(value) end,
            },
            reportLeavers = {
                order = 2,
                type = "toggle",
                name = "Report Leavers on Join",
                desc = "Report leaver history when a player joins the group",
                get = function() return NCConfig:IsReportingLeaversOnJoin() end,
                set = function(_, value) NCConfig:SetReportingLeaversOnJoin(value) end,
                disabled = function() return not NCConfig:IsTrackingLeavers() end,
            },
            leaverThreshold = {
                order = 3,
                type = "range",
                name = "Leaver Threshold",
                desc = "Minimum number of leaves to trigger a report",
                min = 1,
                max = 50,
                step = 1,
                get = function() return NCConfig:GetReportingLeaversOnJoinThreshold() end,
                set = function(_, value) NCConfig:SetReportingLeaversOnJoinThreshold(value) end,
                disabled = function()
                    return not NCConfig:IsTrackingLeavers() or
                        not NCConfig:IsReportingLeaversOnJoin()
                end,
            },
            reportLowPerformers = {
                order = 4,
                type = "toggle",
                name = "Report Low Performers",
                desc = "Report low performing players when a dungeon fails",
                get = function() return NCConfig:IsReportingLowPerformersOnDungeonFail() end,
                set = function(_, value) NCConfig:SetReportingLowPerformersOnDungeonFail(value) end,
            },
        },
    },
}
