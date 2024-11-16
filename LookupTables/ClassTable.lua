function GetClassTable(colorized, includeIcon)
    local classTable = {
        [1] = "Warrior",
        [2] = "Paladin",
        [3] = "Hunter",
        [4] = "Rogue",
        [5] = "Priest",
        [6] = "Death Knight",
        [7] = "Shaman",
        [8] = "Mage",
        [9] = "Warlock",
        [10] = "Monk",
        [11] = "Druid",
        [12] = "Demon Hunter",
        [13] = "Evoker"
    }

    if colorized then
        for id, class in pairs(classTable) do
            classTable[id] = NCColors.ClassColor(id, class)
        end
    end

    local sortedKeys = {}
    for id in pairs(classTable) do
        table.insert(sortedKeys, id)
    end

    table.sort(sortedKeys, function(a, b)
        return classTable[a] < classTable[b]
    end)

    local sortedTable = {}
    for _, id in ipairs(sortedKeys) do
        if includeIcon then
            sortedTable[id] = IconTable:GetIconString("Class", id) .. " " .. classTable[id]
        else
            sortedTable[id] = classTable[id]
        end
    end

    return classTable, sortedKeys, sortedTable
end
