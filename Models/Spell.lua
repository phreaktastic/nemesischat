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
        NCSpell = DeepCopy(core.runtimeDefaults.NCSpell)

        NemesisChat:InstantiateSpell()
    end

    function NCSpell:IsActive()
        return NCSpell.active
    end

    function NCSpell:SetActive()
        NCSpell.active = true
    end

    function NCSpell:SetInactive()
        NCSpell.active = false
    end

    function NCSpell:GetSource()
        if NCSpell.source == nil then
            return ""
        end

        return NCSpell.source
    end

    function NCSpell:SetSource(source)
        NCSpell.source = source
    end

    function NCSpell:GetTarget()
        if NCSpell.target == nil then
            return ""
        end
        
        return NCSpell.target
    end

    function NCSpell:SetTarget(target)
        NCSpell.target = target
    end

    function NCSpell:GetSpellId()
        if NCSpell.spellId == nil then
            return 0
        end
        
        return NCSpell.spellId
    end

    function NCSpell:SetSpellId(id)
        NCSpell.spellId = id
    end

    function NCSpell:GetSpellName()
        if NCSpell.spellName == nil then
            return ""
        end
        
        return NCSpell.spellName
    end

    function NCSpell:SetSpellName(name)
        NCSpell.spellName = name
    end

    function NCSpell:GetExtraSpellId()
        if NCSpell.extraSpellId == nil then
            return 0
        end
        
        return NCSpell.extraSpellId
    end

    function NCSpell:SetExtraSpellId(id)
        NCSpell.extraSpellId = id
    end

    function NCSpell:GetSpellLink()
        return GetSpellLink(NCSpell.spellId)
    end

    function NCSpell:GetExtraSpellLink()
        return GetSpellLink(NCSpell.extraSpellId)
    end

    function NCSpell:IsValidSpell()
        return NCSpell:GetSource() ~= "" and NCSpell.active == true
    end

    function NCSpell:GetDamage()
        if NCSpell.damage == nil then
            return 0
        end
        
        return NCSpell.damage
    end

    function NCSpell:SetDamage(damage)
        NCSpell.damage = damage
    end

    -- Helper for setting Interrupt event properties
    function NCSpell:Interrupt(source, target, spellId, spellName, extraSpellId)
        NCSpell:SetSource(source)
        NCSpell:SetTarget(target)
        NCSpell:SetSpellId(spellId)
        NCSpell:SetSpellName(spellName)
        NCSpell:SetExtraSpellId(extraSpellId)
        NCSpell:SetActive()
    end

    -- Helper for setting Feast event properties
    function NCSpell:Feast(source, spellId, spellName)
        NCSpell:Spell(source, source, spellId, spellName)
    end

    -- Helper for non-feast spells
    function NCSpell:Spell(source, dest, spellId, spellName)
        NCSpell:SetSource(source)
        NCSpell:SetTarget(dest)
        NCSpell:SetSpellId(spellId)
        NCSpell:SetSpellName(spellName)
        NCSpell:SetActive()

        NCState:UpdatePlayerLastSpellCast(source, spellId, spellName)
        NCState:UpdatePlayerLastSpellReceived(dest, spellId, spellName)
    end

    -- Helper for damaging spells
    function NCSpell:Damage(source, dest, spellId, spellName, damage)
        NCSpell:Spell(source, dest, spellId, spellName)
        NCSpell:SetDamage(damage)

        NCState:UpdatePlayerLastDamageReceived(source, dest, spellId, spellName, damage)
        NCState:UpdatePlayerLastDamageDealt(source, spellId, spellName, damage)
    end
end