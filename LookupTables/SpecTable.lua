function GetSpecTable(colorized, includeIcon)
    local specTable = {
        [62] = { spec = "Arcane", class = 8 },
        [63] = { spec = "Fire", class = 8 },
        [64] = { spec = "Frost", class = 8 },
        [65] = { spec = "Holy", class = 2 },
        [66] = { spec = "Protection", class = 2 },
        [70] = { spec = "Retribution", class = 2 },
        [71] = { spec = "Arms", class = 1 },
        [72] = { spec = "Fury", class = 1 },
        [73] = { spec = "Protection", class = 1 },
        [102] = { spec = "Balance", class = 11 },
        [103] = { spec = "Feral", class = 11 },
        [104] = { spec = "Guardian", class = 11 },
        [105] = { spec = "Restoration", class = 11 },
        [250] = { spec = "Blood", class = 6 },
        [251] = { spec = "Frost", class = 6 },
        [252] = { spec = "Unholy", class = 6 },
        [253] = { spec = "Beast Mastery", class = 3 },
        [254] = { spec = "Marksmanship", class = 3 },
        [255] = { spec = "Survival", class = 3 },
        [256] = { spec = "Discipline", class = 5 },
        [257] = { spec = "Holy", class = 5 },
        [258] = { spec = "Shadow", class = 5 },
        [259] = { spec = "Assassination", class = 4 },
        [260] = { spec = "Outlaw", class = 4 },
        [261] = { spec = "Subtlety", class = 4 },
        [262] = { spec = "Elemental", class = 7 },
        [263] = { spec = "Enhancement", class = 7 },
        [264] = { spec = "Restoration", class = 7 },
        [265] = { spec = "Affliction", class = 9 },
        [266] = { spec = "Demonology", class = 9 },
        [267] = { spec = "Destruction", class = 9 },
        [268] = { spec = "Brewmaster", class = 10 },
        [269] = { spec = "Windwalker", class = 10 },
        [270] = { spec = "Mistweaver", class = 10 },
        [577] = { spec = "Havoc", class = 12 },
        [581] = { spec = "Vengeance", class = 12 },
        [1467] = { spec = "Devastation", class = 13 },
        [1468] = { spec = "Preservation", class = 13 },
        [1473] = { spec = "Augmentation", class = 13 }
    }

    if colorized then
        for _, data in pairs(specTable) do
            data.spec = NCColors.ClassColor(data.class, data.spec)
        end
    end

    local sortedKeys = {}
    local returnTable = {}
    for id, data in pairs(specTable) do
        table.insert(sortedKeys, id)
        returnTable[id] = data.spec
    end

    table.sort(sortedKeys, function(a, b)
        return specTable[a].spec < specTable[b].spec
    end)

    local sortedTable = {}
    for _, id in ipairs(sortedKeys) do
        if includeIcon then
            sortedTable[id] = IconTable:GetIconString("Spec", id) .. " " .. returnTable[id]
        else
            sortedTable[id] = returnTable[id]
        end
    end

    return returnTable, sortedKeys, sortedTable
end
