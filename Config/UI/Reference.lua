-----------------------------------------------------
-- CONFIGURATION UI
-----------------------------------------------------
-- Reference Tab
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

core.options.args.messagesGroup.args.referenceGroup = {
    order = 4,
    type = "group",
    name = "Quick Guide",
    -- childGroups = "tab",
    args = {
        randomNemesesBystanders = {
            order = 0,
            type = "group",
            name = "Player Tags",
            args = {
                infoRandomNemesisHeader = {
                    order = 0,
                    type = "description",
                    fontSize = "large",
                    name = "Understanding Player Tags",
                },
                infoRandomNemesisBystander = {
                    order = 2,
                    type = "description",
                    fontSize = "medium",
                    name =
                    "Player tags like |cFF69CCF0[NEMESIS]|r or |cFF69CCF0[BYSTANDER]|r always refer to one specific player at a time. When creating messages, each tag will consistently reference the same player throughout that message.\n\n|cFFFFFF00Tip:|r If you want to mention multiple players, create separate messages for each player interaction.",
                },
            }
        },
        textReplacements = {
            order = 1,
            type = "group",
            name = "All Tags",
            args = {}
        },
        messageChance = {
            order = 2,
            type = "group",
            name = "Message Frequency",
            args = {
                infoChance = {
                    order = 2,
                    type = "description",
                    fontSize = "medium",
                    name =
                    "|cFFFFFFFFHow often will my messages appear?|r\n\n• Messages are randomly selected when triggered\n• Lower chances help prevent spam\n• Multiple messages divide the chance further\n\n|cFF00FF00Example:|r With 2 messages at |cFFFFFF0050%|r chance each, each message has a |cFFFFFF0025%|r chance to appear.",
                },
            }
        },
        conditionsNemesisVsTag = {
            order = 3,
            type = "group",
            name = "Conditions: Nemesis vs. [NEMESIS]",
            args = {
                infoNemesisHeader = {
                    order = 0,
                    type = "description",
                    fontSize = "large",
                    name = "Conditions: is Nemesis vs. is [NEMESIS]",
                },
                infoNemesisPaddingTop = {
                    order = 1,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                infoNemesis = {
                    order = 2,
                    type = "description",
                    fontSize = "medium",
                    name =
                    "As you may have noticed above, [NEMESIS] will refer to the Nemesis which fired the event, or a random Nemesis in the party. In essence, this replacement is for the Nemesis that is explicitly set as the Nemesis for the event itself, either by firing it or being chosen. This is useful for an event where a Nemesis casts a spell on themself, for example. However, what if you wanted to ensure that a spell was cast on a Nemesis, but it was not a self-cast? That's where the 'is Nemesis' operator comes in handy -- it will simply check if the target of the spell is in fact a Nemesis.",
                    width = "full",
                },
                infoNemesisPaddingBottom = {
                    order = 3,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
            }
        },
        conditionalMessagesFlow = {
            order = 4,
            type = "group",
            name = "Conditional Messages Flow",
            args = {
                infoConditionsHeader = {
                    order = 0,
                    type = "description",
                    fontSize = "large",
                    name = "Conditional Messages Flow",
                },
                infoConditionsPaddingTop = {
                    order = 1,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
                infoConditions = {
                    order = 2,
                    type = "description",
                    fontSize = "medium",
                    name =
                    "Generally speaking, Nemesis Chat will have two separate flows for messages. For events that have triggerers, that triggerer will always be the target of messages. Example, a Nemesis casts a spell and you have a message setup for that event: the Nemesis will be the subject of the message because they triggered the event. For non-triggered events, such as killing a boss or leaving combat, a Nemesis will be chosen at random.\n\nThat said, there is one exception to the rules: Conditional messages may have such specificity that a random Nemesis does not suffice. For example, consider a scenario where you're in a group with 3 friends, all of which are defined as Nemeses. Let's say one is a tank, another is DPS, and the last is a healer. If you have a message setup for talking smack to the DPS based on damage dealt in a combat segment, realistically you'd only see this happen 33% of the time. That in mind, if a randomly chosen Nemesis does not meet conditional criteria for a pool of messages, a new Nemesis will be chosen until either all Nemeses are checked against conditions, or a valid pool of messages are found. This allows you do define granular conditions and ensure a message will fire as expected.",
                    width = "full",
                },
                infoConditionsPaddingBottom = {
                    order = 3,
                    type = "description",
                    fontSize = "large",
                    name = " ",
                },
            }
        },
    }
}
