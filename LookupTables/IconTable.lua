IconTable = {}

-- Class Icons
IconTable.Class = {
    [1] = "Interface\\Icons\\ClassIcon_Warrior",
    [2] = "Interface\\Icons\\ClassIcon_Paladin",
    [3] = "Interface\\Icons\\ClassIcon_Hunter",
    [4] = "Interface\\Icons\\ClassIcon_Rogue",
    [5] = "Interface\\Icons\\ClassIcon_Priest",
    [6] = "Interface\\Icons\\ClassIcon_DeathKnight",
    [7] = "Interface\\Icons\\ClassIcon_Shaman",
    [8] = "Interface\\Icons\\ClassIcon_Mage",
    [9] = "Interface\\Icons\\ClassIcon_Warlock",
    [10] = "Interface\\Icons\\ClassIcon_Monk",
    [11] = "Interface\\Icons\\ClassIcon_Druid",
    [12] = "Interface\\Icons\\ClassIcon_DemonHunter",
    [13] = "Interface\\Icons\\ClassIcon_Evoker"
}

-- Spec Icons
IconTable.Spec = {
    -- Warrior
    [71] = "Interface\\Icons\\Ability_Warrior_SavageBlow",
    [72] = "Interface\\Icons\\Ability_Warrior_InnerRage",
    [73] = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
    -- Paladin
    [65] = "Interface\\Icons\\Spell_Holy_HolyBolt",
    [66] = "Interface\\Icons\\Ability_Paladin_ShieldoftheTemplar",
    [70] = "Interface\\Icons\\Spell_Holy_AuraOfLight",
    -- Hunter
    [253] = "Interface\\Icons\\Ability_Hunter_BestialDiscipline",
    [254] = "Interface\\Icons\\Ability_Hunter_FocusedAim",
    [255] = "Interface\\Icons\\Ability_Hunter_Camouflage",
    -- Rogue
    [259] = "Interface\\Icons\\Ability_Rogue_DeadlyBrew",
    [260] = "Interface\\Icons\\Inv_Sword_30",
    [261] = "Interface\\Icons\\Ability_Stealth",
    -- Priest
    [256] = "Interface\\Icons\\Spell_Holy_PowerWordShield",
    [257] = "Interface\\Icons\\Spell_Holy_GuardianSpirit",
    [258] = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
    -- Death Knight
    [250] = "Interface\\Icons\\Spell_Deathknight_BloodPresence",
    [251] = "Interface\\Icons\\Spell_Deathknight_FrostPresence",
    [252] = "Interface\\Icons\\Spell_Deathknight_UnholyPresence",
    -- Shaman
    [262] = "Interface\\Icons\\Spell_Nature_Lightning",
    [263] = "Interface\\Icons\\Spell_Shaman_ImprovedStormstrike",
    [264] = "Interface\\Icons\\Spell_Nature_MagicImmunity",
    -- Mage
    [62] = "Interface\\Icons\\Spell_Holy_MagicalSentry",
    [63] = "Interface\\Icons\\Spell_Fire_FlameBolt",
    [64] = "Interface\\Icons\\Spell_Frost_FrostBolt02",
    -- Warlock
    [265] = "Interface\\Icons\\Spell_Shadow_DeathCoil",
    [266] = "Interface\\Icons\\Spell_Shadow_Metamorphosis",
    [267] = "Interface\\Icons\\Spell_Shadow_RainOfFire",
    -- Monk
    [268] = "Interface\\Icons\\Spell_Monk_BrewMaster_Spec",
    [269] = "Interface\\Icons\\Spell_Monk_Windwalker_Spec",
    [270] = "Interface\\Icons\\Spell_Monk_Mistweaver_Spec",
    -- Druid
    [102] = "Interface\\Icons\\Spell_Nature_StarFall",
    [103] = "Interface\\Icons\\Ability_Druid_CatForm",
    [104] = "Interface\\Icons\\Ability_Racial_BearForm",
    [105] = "Interface\\Icons\\Spell_Nature_HealingTouch",
    -- Demon Hunter
    [577] = "Interface\\Icons\\Ability_DemonHunter_SpecDPS",
    [581] = "Interface\\Icons\\Ability_DemonHunter_SpecTank",
    -- Evoker
    [1467] = "Interface\\Icons\\Ability_Evoker_FireBreath",         -- Devastation
    [1468] = "Interface\\Icons\\Ability_Evoker_Reversion",          -- Preservation
    [1473] = "Interface\\Icons\\Ability_Evoker_BlessingOfTheBronze" -- Augmentation
}

-- Role Icons
IconTable.Role = {
    TANK = "Interface\\LFGFrame\\UI-LFG-ICON-ROLES",
    HEALER = "Interface\\LFGFrame\\UI-LFG-ICON-ROLES",
    DAMAGER = "Interface\\LFGFrame\\UI-LFG-ICON-ROLES",
    DPS = "Interface\\LFGFrame\\UI-LFG-ICON-ROLES",
}

function IconTable:GetIcon(iconType, id)
    if not self[iconType] then
        return nil
    end
    return self[iconType][id]
end

function IconTable:GetIconString(iconType, id, size)
    local path = self:GetIcon(iconType, id)
    if not path then
        return ""
    end

    size = size or 16 -- Default size if not specified

    if iconType == "Role" then
        local roleCoords = {
            TANK = { 0, 0.25, 0.25, 0.5 },       -- Tank is bottom left quadrant
            HEALER = { 0.25, 0.5, 0, 0.25 },     -- Healer is top middle quadrant
            DAMAGER = { 0.25, 0.5, 0.25, 0.5 },   -- DPS is middle quadrant
            DPS = { 0.25, 0.5, 0.25, 0.5 },
        }
        local coords = roleCoords[id]
        return string.format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", path, size, size, 256, 256, coords[1] * 256,
            coords[2] * 256, coords[3] * 256, coords[4] * 256)
    else
        return string.format("|T%s:%d:%d:0:0|t", path, size, size)
    end
end

function IconTable:PrependIcon(str, iconType, id, size)
    local iconTexture = self:GetIconTexture(iconType, id, size)
    return iconTexture .. str
end
