-----------------------------------------------------
-- SPELL
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- Spell getters, setters, etc.
-----------------------------------------------------

function NemesisChat:InstantiateSpell()
    function NCSpell:Initialize()
        NCSpell = DeepCopy(core.runtimeDefaults.ncSpell)

        NemesisChat:InstantiateSpell()
    end

    function NCSpell:IsActive()
        return self.active
    end

    function NCSpell:SetActive()
        self.active = true
    end

    function NCSpell:SetInactive()
        self.active = false
    end

    function NCSpell:GetSource()
        if self.source == nil then
            return ""
        end

        return NCSpell.source
    end

    function NCSpell:SetSource(source)
        self.source = source
    end

    function NCSpell:GetTarget()
        if self.target == nil then
            return ""
        end

        return self.target
    end

    function NCSpell:SetTarget(target)
        self.target = target
    end

    function NCSpell:GetSpellId()
        if self.spellId == nil then
            return 0
        end

        return self.spellId
    end

    function NCSpell:SetSpellId(id)
        self.spellId = id
    end

    function NCSpell:GetSpellName()
        if self.spellName == nil then
            return ""
        end

        return self.spellName
    end

    function NCSpell:SetSpellName(name)
        self.spellName = name
    end

    function NCSpell:GetExtraSpellId()
        if self.extraSpellId == nil then
            return 0
        end

        return self.extraSpellId
    end

    function NCSpell:SetExtraSpellId(id)
        self.extraSpellId = id
    end

    function NCSpell:GetSpellLink()
        return C_Spell.GetSpellLink(self.spellId)
    end

    function NCSpell:GetExtraSpellLink()
        return C_Spell.GetSpellLink(self.extraSpellId)
    end

    function NCSpell:IsValidSpell()
        return self.source ~= "" and self.active == true
    end

    function NCSpell:GetDamage()
        if self.damage == nil then
            return 0
        end

        return self.damage
    end

    function NCSpell:SetDamage(damage)
        self.damage = damage
    end

    -- Helper for setting Interrupt event properties
    function NCSpell:Interrupt(source, target, spellId, spellName, extraSpellId)
        self:SetSource(source)
        self:SetTarget(target)
        self:SetSpellId(spellId)
        self:SetSpellName(spellName)
        self:SetExtraSpellId(extraSpellId)
        self:SetActive()
    end

    -- Helper for setting Feast event properties
    function NCSpell:Feast(source, spellId)
        self:SetSource(source)
        self:SetSpellId(spellId)
        self:SetActive()
    end

    -- Helper for non-feast spells
    function NCSpell:Spell(source, dest, spellId, spellName)
        self:SetSource(source)
        self:SetTarget(dest)
        self:SetSpellId(spellId)
        self:SetSpellName(spellName)
        self:SetActive()
    end

    -- Helper for damaging spells/swings
    function NCSpell:Damage(source, dest, spellId, spellName, damage)
        self:Spell(source, dest, spellId, spellName)
        self:SetDamage(damage)
    end
end
