-- Known spells with spell IDs and descriptions
local KnownSpells = {
    -- Damage Spells
    [133] = "Fireball",            -- Deals fire damage
    [116] = "Frostbolt",           -- Deals frost damage and slows the target
    [78] = "Heroic Strike",        -- Warrior melee attack
    -- Healing Spells
    [2061] = "Flash Heal",         -- Quick healing spell
    [774] = "Rejuvenation",        -- Heal over time spell
    -- Interrupt Spells
    [2139] = "Counterspell",       -- Interrupts spellcasting
    [6552] = "Pummel",             -- Warrior interrupt
    -- Crowd Control Spells
    [118] = "Polymorph",           -- Transforms the enemy into a sheep
    [339] = "Entangling Roots",    -- Roots the target in place
    -- Dispel Spells
    [527] = "Dispel Magic",        -- Removes magic effects
    [4987] = "Cleanse",            -- Paladin dispel
    -- Defensive Abilities
    [498] = "Divine Protection",   -- Reduces damage taken
    [871] = "Shield Wall",         -- Warrior damage reduction
    -- Periodic Damage Spells
    [30108] = "Unstable Affliction", -- DoT spell
    [348] = "Immolate",            -- DoT spell
}

-- Mapping of subevents to their parameter lists
local CombatLogSubeventParameters = {
    SPELL_DAMAGE = {
        "spellId", "spellName", "spellSchool",
        "amount", "overkill", "school", "resisted", "blocked", "absorbed",
        "critical", "glancing", "crushing", "isOffHand"
    },
    SWING_DAMAGE = {
        "amount", "overkill", "school", "resisted", "blocked", "absorbed",
        "critical", "glancing", "crushing", "isOffHand"
    },
    SPELL_HEAL = {
        "spellId", "spellName", "spellSchool",
        "amount", "overhealing", "absorbed", "critical"
    },
    SPELL_INTERRUPT = {
        "spellId", "spellName", "spellSchool",
        "extraSpellId", "extraSpellName", "extraSchool"
    },
    SPELL_CAST_SUCCESS = {
        "spellId", "spellName", "spellSchool",
    },
    SPELL_CAST_START = {
        "spellId", "spellName", "spellSchool",
    },
    SPELL_AURA_APPLIED = {
        "spellId", "spellName", "spellSchool", "auraType"
    },
    SPELL_AURA_APPLIED_DOSE = {
        "spellId", "spellName", "spellSchool", "auraType", "amount"
    },
    PARTY_KILL = {},
    UNIT_DIED = {},
    SPELL_PERIODIC_DAMAGE = {
        "spellId", "spellName", "spellSchool",
        "amount", "overkill", "school", "resisted", "blocked", "absorbed",
        "critical", "glancing", "crushing", "isOffHand"
    },
    RANGE_DAMAGE = {
        "spellId", "spellName", "spellSchool",
        "amount", "overkill", "school", "resisted", "blocked", "absorbed",
        "critical", "glancing", "crushing", "isOffHand"
    },
    SPELL_DISPEL = {
        "spellId", "spellName", "spellSchool",
        "extraSpellId", "extraSpellName", "extraSchool", "auraType"
    },
    SPELL_AURA_REMOVED = {
        "spellId", "spellName", "spellSchool", "auraType"
    },
    -- Add other events as needed
}

-- Mock function to emulate CombatLogGetCurrentEventInfo()
function MockCombatLogGetCurrentEventInfo(eventData)
    -- If no eventData is provided, generate random eventData
    if not eventData then
        eventData = {}
        -- Randomly select a subevent
        local subevents = {}
        for k in pairs(CombatLogSubeventParameters) do table.insert(subevents, k) end
        eventData.subevent = subevents[math.random(#subevents)]
    end

    local subevent = eventData.subevent

    -- Generate default data for common fields if not provided
    eventData.timestamp = eventData.timestamp or GetTime()
    eventData.hideCaster = eventData.hideCaster or false
    eventData.sourceGUID = eventData.sourceGUID or "SourceGUID" .. math.random(1000)
    eventData.sourceName = eventData.sourceName or "SourceName" .. math.random(1000)
    eventData.sourceFlags = eventData.sourceFlags or 0x511
    eventData.sourceRaidFlags = eventData.sourceRaidFlags or 0
    eventData.destGUID = eventData.destGUID or "DestGUID" .. math.random(1000)
    eventData.destName = eventData.destName or "DestName" .. math.random(1000)
    eventData.destFlags = eventData.destFlags or 0x511
    eventData.destRaidFlags = eventData.destRaidFlags or 0

    local timestamp = eventData.timestamp
    local hideCaster = eventData.hideCaster
    local sourceGUID = eventData.sourceGUID
    local sourceName = eventData.sourceName
    local sourceFlags = eventData.sourceFlags
    local sourceRaidFlags = eventData.sourceRaidFlags
    local destGUID = eventData.destGUID
    local destName = eventData.destName
    local destFlags = eventData.destFlags
    local destRaidFlags = eventData.destRaidFlags

    local rest = {}

    local subeventParams = CombatLogSubeventParameters[subevent]

    if not subeventParams then
        error("Unsupported subevent: " .. tostring(subevent))
    end

    for _, paramName in ipairs(subeventParams) do
        local value = eventData[paramName]
        if value == nil then
            -- Generate default or random values for parameters
            if paramName == "spellId" then
                -- Randomly pick a spell ID from KnownSpells
                local spellIds = {}
                for id in pairs(KnownSpells) do table.insert(spellIds, id) end
                value = spellIds[math.random(#spellIds)]
            elseif paramName == "spellName" then
                local spellId = eventData["spellId"]
                value = KnownSpells[spellId] or "UnknownSpell"
            elseif paramName == "spellSchool" or paramName == "school" then
                value = 0x1 -- Physical
            elseif paramName == "amount" then
                value = math.random(100, 5000)
            elseif paramName == "overkill" or paramName == "overhealing" or paramName == "resisted" or paramName == "blocked" or paramName == "absorbed" then
                value = 0
            elseif paramName == "critical" or paramName == "glancing" or paramName == "crushing" or paramName == "isOffHand" then
                value = false
            elseif paramName == "auraType" then
                value = "BUFF"
            elseif paramName == "extraSpellId" then
                -- For interrupts, dispels, etc.
                local spellIds = {}
                for id in pairs(KnownSpells) do table.insert(spellIds, id) end
                value = spellIds[math.random(#spellIds)]
            elseif paramName == "extraSpellName" then
                local extraSpellId = eventData["extraSpellId"]
                value = KnownSpells[extraSpellId] or "UnknownSpell"
            elseif paramName == "extraSchool" then
                value = 0x1
            elseif paramName == "amount" then
                value = math.random(1, 10)
            else
                value = nil
            end
        end
        table.insert(rest, value)
    end

    return timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
           destGUID, destName, destFlags, destRaidFlags, unpack(rest)
end

-- Helper functions to simulate specific events

-- Simulate Damage to Player
function DamageToPlayer(playerName, amount, spellId)
    local spellId = spellId or 133 -- Default to Fireball
    local spellName = KnownSpells[spellId]
    local eventData = {
        subevent = "SPELL_DAMAGE",
        destName = playerName,
        spellId = spellId,
        spellName = spellName,
        amount = amount or math.random(1000, 3000),
        spellSchool = 0x4, -- Fire
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Heal to Player
function HealToPlayer(playerName, amount, spellId)
    local spellId = spellId or 2061 -- Default to Flash Heal
    local spellName = KnownSpells[spellId]
    local eventData = {
        subevent = "SPELL_HEAL",
        destName = playerName,
        spellId = spellId,
        spellName = spellName,
        amount = amount or math.random(1000, 3000),
        spellSchool = 0x2, -- Holy
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Spell Interrupt
function InterruptSpell(sourceName, destName, spellId, extraSpellId)
    spellId = spellId or 2139 -- Default to Counterspell
    extraSpellId = extraSpellId or 116 -- Spell being interrupted (Frostbolt)
    local eventData = {
        subevent = "SPELL_INTERRUPT",
        sourceName = sourceName,
        destName = destName,
        spellId = spellId,
        spellName = KnownSpells[spellId],
        spellSchool = 0x40, -- Arcane
        extraSpellId = extraSpellId,
        extraSpellName = KnownSpells[extraSpellId],
        extraSchool = 0x10, -- Frost
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Spell Cast Success
function SpellCastSuccess(sourceName, spellId)
    spellId = spellId or 498 -- Default to Divine Protection
    local eventData = {
        subevent = "SPELL_CAST_SUCCESS",
        sourceName = sourceName,
        spellId = spellId,
        spellName = KnownSpells[spellId],
        spellSchool = 0x2, -- Holy
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Spell Cast Start
function SpellCastStart(sourceName, spellId)
    spellId = spellId or 116 -- Default to Frostbolt
    local eventData = {
        subevent = "SPELL_CAST_START",
        sourceName = sourceName,
        spellId = spellId,
        spellName = KnownSpells[spellId],
        spellSchool = 0x10, -- Frost
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Aura Applied
function AuraApplied(destName, spellId, auraType)
    spellId = spellId or 774 -- Default to Rejuvenation
    auraType = auraType or "BUFF"
    local eventData = {
        subevent = "SPELL_AURA_APPLIED",
        destName = destName,
        spellId = spellId,
        spellName = KnownSpells[spellId],
        spellSchool = 0x8, -- Nature
        auraType = auraType,
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Aura Dose
function AuraDose(destName, spellId, auraType, amount)
    spellId = spellId or 774 -- Default to Rejuvenation
    auraType = auraType or "BUFF"
    amount = amount or math.random(2, 5)
    local eventData = {
        subevent = "SPELL_AURA_APPLIED_DOSE",
        destName = destName,
        spellId = spellId,
        spellName = KnownSpells[spellId],
        spellSchool = 0x8, -- Nature
        auraType = auraType,
        amount = amount,
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Party Kill
function PartyKill(sourceName, destName)
    local eventData = {
        subevent = "PARTY_KILL",
        sourceName = sourceName,
        destName = destName,
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Unit Died
function UnitDied(destName)
    local eventData = {
        subevent = "UNIT_DIED",
        destName = destName,
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Swing Damage
function SwingDamage(destName, amount)
    local eventData = {
        subevent = "SWING_DAMAGE",
        destName = destName,
        amount = amount or math.random(500, 2000),
        school = 0x1, -- Physical
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Range Damage
function RangeDamage(destName, amount, spellId)
    spellId = spellId or 75 -- Default to Auto Shot
    local eventData = {
        subevent = "RANGE_DAMAGE",
        destName = destName,
        spellId = spellId,
        spellName = "Auto Shot",
        spellSchool = 0x1, -- Physical
        amount = amount or math.random(500, 2000),
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Spell Periodic Damage
function PeriodicDamage(destName, amount, spellId)
    spellId = spellId or 30108 -- Default to Unstable Affliction
    local eventData = {
        subevent = "SPELL_PERIODIC_DAMAGE",
        destName = destName,
        spellId = spellId,
        spellName = KnownSpells[spellId],
        spellSchool = 0x20, -- Shadow
        amount = amount or math.random(200, 800),
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Dispel
function Dispel(sourceName, destName, spellId, extraSpellId, auraType)
    spellId = spellId or 527 -- Default to Dispel Magic
    extraSpellId = extraSpellId or 774 -- Default to Rejuvenation
    auraType = auraType or "BUFF"
    local eventData = {
        subevent = "SPELL_DISPEL",
        sourceName = sourceName,
        destName = destName,
        spellId = spellId,
        spellName = KnownSpells[spellId],
        spellSchool = 0x2, -- Holy
        extraSpellId = extraSpellId,
        extraSpellName = KnownSpells[extraSpellId],
        extraSchool = 0x8, -- Nature
        auraType = auraType,
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Casting Defensive Ability
function CastDefensiveAbility(sourceName, spellId)
    spellId = spellId or 498 -- Default to Divine Protection
    local eventData = {
        subevent = "SPELL_CAST_SUCCESS",
        sourceName = sourceName,
        spellId = spellId,
        spellName = KnownSpells[spellId],
        spellSchool = 0x2, -- Holy
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Simulate Crowd Control (e.g., Polymorph)
function ApplyCrowdControl(destName, spellId)
    spellId = spellId or 118 -- Default to Polymorph
    local eventData = {
        subevent = "SPELL_AURA_APPLIED",
        destName = destName,
        spellId = spellId,
        spellName = KnownSpells[spellId],
        spellSchool = 0x40, -- Arcane
        auraType = "DEBUFF",
    }
    return MockCombatLogGetCurrentEventInfo(eventData)
end

-- Example Usage:
-- Simulate a Fireball hitting 'PlayerOne' for 2000 damage
local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
      destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool,
      amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand =
          DamageToPlayer("PlayerOne", 2000, 133)

return {
MockCombatLogGetCurrentEventInfo = MockCombatLogGetCurrentEventInfo,
DamageToPlayer = DamageToPlayer,
HealToPlayer = HealToPlayer,
InterruptSpell = InterruptSpell,
SpellCastSuccess = SpellCastSuccess,
SpellCastStart = SpellCastStart,
AuraApplied = AuraApplied,
AuraDose = AuraDose,
PartyKill = PartyKill,
UnitDied = UnitDied,
SwingDamage = SwingDamage,
RangeDamage = RangeDamage,
PeriodicDamage = PeriodicDamage,
Dispel = Dispel,
CastDefensiveAbility = CastDefensiveAbility,
ApplyCrowdControl = ApplyCrowdControl,
}