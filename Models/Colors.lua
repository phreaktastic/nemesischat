-----------------------------------------------------
-- COLORS
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Helpful color methods
-----------------------------------------------------

NCColors = {
    colors = {
        channels = {
            ["SAY"] = "FFFFFF",
            ["EMOTE"] = "FF8040",
            ["PARTY"] = "AAAAFF",
            ["YELL"] = "FF4040",
            ["WHISPER"] = "FF80FF",
            ["GUILD"] = "40FF40",
            ["OFFICER"] = "40c040",
            ["RAID"] = "FF7F00",
            ["INSTANCE"] = "FF780A", -- Best guess, potentially wrong.
        },
        classes = {
            ["1"] = "C79C6E",
            ["2"] = "F58CBA",
            ["3"] = "ABD473",
            ["4"] = "FFF569",
            ["5"] = "FFFFFF",
            ["6"] = "C41F3B",
            ["7"] = "0070DE",
            ["8"] = "69CCF0",
            ["9"] = "9482C9",
            ["10"] = "00FF96",
            ["11"] = "FF7D0A",
            ["12"] = "FF0000",
        },
        other = {
            ["EMPHASIS"] = "FFCC00"
        }
    },

    Say = function(msg)
        return "|cff" .. NCColors.colors.channels.SAY .. msg .. "|r"
    end,

    Emote = function(msg)
        return "|cff" .. NCColors.colors.channels.EMOTE .. msg .. "|r"
    end,

    Group = function(msg)
        return "|cff" .. NCColors.colors.channels.GROUP .. msg .. "|r"
    end,

    Party = function(msg)
        return "|cff" .. NCColors.colors.channels.PARTY .. msg .. "|r"
    end,

    Yell = function(msg)
        return "|cff" .. NCColors.colors.channels.YELL .. msg .. "|r"
    end,

    Whisper = function(msg)
        return "|cff" .. NCColors.colors.channels.WHISPER .. msg .. "|r"
    end,

    ClassColor = function(class, msg)
        if not NCColors.colors.classes[class] then
            return msg
        end

        return "|cff" .. NCColors.colors.classes[class] .. msg .. "|r"
    end,

    Emphasize = function(msg)
        return "|cff" .. NCColors.colors.other.EMPHASIS .. msg .. "|r"
    end,
}

NCColors.colors.classes["WARRIOR"] = NCColors.colors.classes["1"]
NCColors.colors.classes["PALADIN"] = NCColors.colors.classes["2"]
NCColors.colors.classes["HUNTER"] = NCColors.colors.classes["3"]
NCColors.colors.classes["ROGUE"] = NCColors.colors.classes["4"]
NCColors.colors.classes["PRIEST"] = NCColors.colors.classes["5"]
NCColors.colors.classes["DEATHKNIGHT"] = NCColors.colors.classes["6"]
NCColors.colors.classes["SHAMAN"] = NCColors.colors.classes["7"]
NCColors.colors.classes["MAGE"] = NCColors.colors.classes["8"]
NCColors.colors.classes["WARLOCK"] = NCColors.colors.classes["9"]
NCColors.colors.classes["MONK"] = NCColors.colors.classes["10"]
NCColors.colors.classes["DRUID"] = NCColors.colors.classes["11"]
NCColors.colors.classes["DEMONHUNTER"] = NCColors.colors.classes["12"]