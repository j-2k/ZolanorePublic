using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Item Effects/Heal")]
public class UsableItem : Item
{
    public bool IsConsumable;

    public List<UsableItemEffect> Effects;

    [SerializeField] string itemLore;

    public virtual void Use(CharacterManager character)
    {
        foreach (UsableItemEffect effect in Effects)
        {
            effect.ExecuteEffect(this, character);
        }
    }

    public override string GetItemType()
    {
        return IsConsumable ? "Consumable" : "Usable";
    }

    public override string GetDescription()
    {
        sb.Length = 0;

        foreach (UsableItemEffect effect in Effects)
        {
            sb.AppendLine(effect.GetDescription());
        }
        return sb.ToString();
    }

    public override string GetDescriptionLore()
    {
        sbLore.Length = 0;

        foreach (UsableItemEffect effect in Effects)
        {
            //sbLore.AppendLine(effect.GetDescriptionLore());
            sbLore.AppendLine(itemLore);
        }
        return sbLore.ToString();
    }
}
