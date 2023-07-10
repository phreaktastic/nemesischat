-----------------------------------------------------
-- CONFIGURATION UI
-----------------------------------------------------
-- Reference Tab
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

core.options.args.referenceGroup = {
    order = 4,
    type = "group",
    name = "Reference",
    args = {
        infoHeader = {
            order = 0,
            type = "header",
            name = "Nemesis Chat Reference",
        },
        infoHeaderPadding = {
            order = 1,
            type = "description",
            fontSize = "large",
            name = "",
        },
        infoRefReplacementHeader = {
            order = 2,
            type = "description",
            fontSize = "large",
            name = "Text Replacements",
        },
        infoRefReplacementPaddingTop = {
            order = 3,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        infoRefReplacements = {
            order = 4,
            type = "description",
            fontSize = "medium",
            name = function() return NemesisChat:GetReplacementTooltip() end,
        },
        infoRefReplacementPaddingBottom = {
            order = 5,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        infoChanceHeader = {
            order = 6,
            type = "description",
            fontSize = "large",
            name = "Message Chance",
        },
        infoChancePaddingTop = {
            order = 7,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        infoChance = {
            order = 8,
            type = "description",
            fontSize = "medium",
            name = "Chance is tricky for a multitude of reasons. Firstly, messages are chosen at random when an appropriate trigger event fires. That in consideration, having one message with a chance of 80% and another with a chance of 20% does NOT mean there will be a 100% chance for one of them to fire. Secondly, missing a roll means a phrase will not be sent at all. Finally, the real math behind a chance would be |c00ffcc00(1 / x) * (y / 100)|r with |c00ffcc00x|r being the number of phrases for this event, and |c00ffcc00y|r being the individual phrase's chance. So with 2 phrases for one triggered event, you have a 50% chance to get a particular phrase. If the chosen phrase's chance is 50%, that means the overall chance to send that particular phrase is 25%. Please keep this in mind!\n\nThe NC algorithm is designed with spam prevention in mind, not with weighted phrase chance accuracy. Setting a chance below 100% is useful for preventing a phrase from sending every time a particular event fires.",
            width = "full",
        },
        infoChancePaddingBottom = {
            order = 9,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        infoNemesisHeader = {
            order = 10,
            type = "description",
            fontSize = "large",
            name = "Conditions: is Nemesis vs. is [NEMESIS]",
        },
        infoNemesisPaddingTop = {
            order = 11,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        infoNemesis = {
            order = 12,
            type = "description",
            fontSize = "medium",
            name = "As you may have noticed above, [NEMESIS] will refer to the Nemesis which fired the event, or a random Nemesis in the party. In essence, this replacement is for the Nemesis that is explicitly set as the Nemesis for the event itself, either by firing it or being chosen. This is useful for an event where a Nemesis casts a spell on themself, for example. However, what if you wanted to ensure that a spell was cast on a Nemesis, but it was not a self-cast? That's where the 'is Nemesis' operator comes in handy -- it will simply check if the target of the spell is in fact a Nemesis.",
            width = "full",
        },
        infoNemesisPaddingBottom = {
            order = 13,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        infoConditionsHeader = {
            order = 14,
            type = "description",
            fontSize = "large",
            name = "Conditional Messages Flow",
        },
        infoConditionsPaddingTop = {
            order = 15,
            type = "description",
            fontSize = "large",
            name = " ",
        },
        infoConditions = {
            order = 16,
            type = "description",
            fontSize = "medium",
            name = "Generally speaking, Nemesis Chat will have two separate flows for messages. For events that have triggerers, that triggerer will always be the target of messages. Example, a Nemesis casts a spell and you have a message setup for that event: the Nemesis will be the subject of the message because they triggered the event. For non-triggered events, such as killing a boss or leaving combat, a Nemesis will be chosen at random.\n\nThat said, there is one exception to the rules: Conditional messages may have such specificity that a random Nemesis does not suffice. For example, consider a scenario where you're in a group with 3 friends, all of which are defined as Nemeses. Let's say one is a tank, another is DPS, and the last is a healer. If you have a message setup for talking smack to the DPS based on damage dealt in a combat segment, realistically you'd only see this happen 33% of the time. That in mind, if a randomly chosen Nemesis does not meet conditional criteria for a pool of messages, a new Nemesis will be chosen until either all Nemeses are checked against conditions, or a valid pool of messages are found. This allows you do define granular conditions and ensure a message will fire as expected.",
            width = "full",
        },
    }
}