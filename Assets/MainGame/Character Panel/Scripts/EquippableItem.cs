using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Juma.CharacterStats;

public enum EquipmentType
{ 
    Weapon,
    Shield,
    Helmet,
    Chestplate,
    Platelegs,
    Boots,
    Necklace,
    Book,
    Gem,
    Ring,
}


[CreateAssetMenu(menuName = "Items/Equippable Item")]
public class EquippableItem : Item
{
    public int StrengthBonus;
    public int DexterityBonus;
    public int IntelligenceBonus;
    public int DefenceBonus;
    [Space]
    public int StrengthPercentBonus;
    public int DexterityPercentBonus;
    public int IntelligencePercentBonus;
    public int DefencePercentBonus;
    [Space]
    public EquipmentType EquipmentType;

    [SerializeField] string itemLore;

    public override Item GetCopy()
    {
        return Instantiate(this);
    }

    public override void Destroy()
    {
        Destroy(this);
    }

    public void Equip(CharacterManager character)
    {
        if (StrengthBonus != 0)
        {
            character.Strength.AddModifier(new StatModifier(StrengthBonus, StatModType.Flat, this));
        }

        if (DexterityBonus != 0)
        {
            character.Dexterity.AddModifier(new StatModifier(DexterityBonus, StatModType.Flat, this));
        }

        if (IntelligenceBonus != 0)
        {
            character.Intelligence.AddModifier(new StatModifier(IntelligenceBonus, StatModType.Flat, this));
        }

        if (DefenceBonus != 0)
        {
            character.Defence.AddModifier(new StatModifier(DefenceBonus, StatModType.Flat, this));
        }


        if (StrengthPercentBonus != 0)
        {
            character.Strength.AddModifier(new StatModifier(StrengthPercentBonus, StatModType.PercentMult, this));
        }

        if (DexterityPercentBonus != 0)
        {
            character.Dexterity.AddModifier(new StatModifier(DexterityPercentBonus, StatModType.PercentMult, this));
        }

        if (IntelligencePercentBonus != 0)
        {
            character.Intelligence.AddModifier(new StatModifier(IntelligencePercentBonus, StatModType.PercentMult, this));
        }

        if (DefencePercentBonus != 0)
        {
            character.Defence.AddModifier(new StatModifier(DefencePercentBonus, StatModType.PercentMult, this));
        }

    }

    public void Unequip(CharacterManager character)
    {
        character.Strength.RemoveAllModifiersFromSource(this);
        character.Dexterity.RemoveAllModifiersFromSource(this);
        character.Intelligence.RemoveAllModifiersFromSource(this);
        character.Defence.RemoveAllModifiersFromSource(this);
    }

    public override string GetItemType()
    {
        return EquipmentType.ToString();
    }

    public override string GetDescription()
    {
        sb.Length = 0;
        AddStat(StrengthBonus, "Strength");
        AddStat(DexterityBonus, "Dexterity");
        AddStat(IntelligenceBonus, "Intelligence");
        AddStat(DefenceBonus, "Defence");

        AddStat(StrengthPercentBonus, "Strength", isPercentMult: true);
        AddStat(DexterityPercentBonus, "Dexterity", isPercentMult: true);
        AddStat(IntelligencePercentBonus, "Intelligence", isPercentMult: true);
        AddStat(DefencePercentBonus, "Defence", isPercentMult: true);
        return sb.ToString();
    }

    public override string GetDescriptionLore()
    {
        sbLore.Length = 0;
        sbLore.Append(itemLore);
        return sbLore.ToString();
    }

    private void AddStat(float value, string statName, bool isPercentMult = false)
    {
        if (value != 0)
        {
            if (sb.Length > 0)
            {
                sb.AppendLine();
            }

            if (value > 0)
            {
                sb.Append("+");
            }

            if (isPercentMult)
            {
                sb.Append(value);
                //sb.Append(value * 100);
                sb.Append("% ");
            }
            else
            {
                sb.Append(value);
                sb.Append(" ");
            }

            //sb.Append(value);
            //sb.Append(" ");
            sb.Append(statName);
        }
    }
}
