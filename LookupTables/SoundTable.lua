function GetSoundTable()
    local soundTable = {
        [8959] = "Raid Warning",
        [888] = "Level Up",
        [846] = "Abandon Quest",
        [170270] = "Alert 1",
        [3332] = "Friend Join",
        [700] = "Unsheath Weapon",
        [166318] = "Runecarving Upgrade",
        [205295] = "Tradeskill Level Up",
        [268851] = "Radiant Chords",
        [89879] = "Fireworks",
        [855] = "Simple Click 1",
        [258818] = "Magic Click",
        [9379] = "Flag Taken Horde",
        [890] = "Quest Added",
        [12197] = "Raid Boss Warning",
        [169049] = "Artifact Trait Available",
        [175002] = "Azerite Buff",
        [43502] = "Garrison Mission Success",
        [73919] = "New Recipe Learned",
        [218236] = "Simple Click 2",
        [168711] = "Holy Word Impact",
        [207762] = "Adventurer Slotted",
        [12867] = "Alarm Warning 1",
        [12889] = "Alarm Warning 2",
        [247579] = "Brann: 'Fantastic!'",
        [247580] = "Brann: 'Nice find!'",
        [247520] = "Brann: 'Here we go!'",
    }

    -- Create a sorted array of keys based on the sound names
    local sortedKeys = {}
    for id in pairs(soundTable) do
        table.insert(sortedKeys, id)
    end

    table.sort(sortedKeys, function(a, b)
        return soundTable[a] < soundTable[b]
    end)

    return soundTable, sortedKeys
end
