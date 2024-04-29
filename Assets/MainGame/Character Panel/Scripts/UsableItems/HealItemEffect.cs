using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//THIS LAYOUT CAN BE USED WITH MULTIPLE OTHER EFFECTS EVEN IN A SPELL SYSTEM FOR EXAMPLE
[CreateAssetMenu]
public class HealItemEffect : UsableItemEffect
{
    public int healthAmount;

    public override void ExecuteEffect(UsableItem parentItem, CharacterManager characterPanelManager)
    {
        characterPanelManager.playerCurrentHealth += healthAmount;

        if (characterPanelManager.playerCurrentHealth >= characterPanelManager.playerMaxHealth)
        {
            characterPanelManager.playerCurrentHealth = characterPanelManager.playerMaxHealth;
        }

        characterPanelManager.RefreshPlayerUI();
    }

    public override string GetDescription()
    {
        return "Heals for " + healthAmount + " health.";
    }

    public override string GetDescriptionLore()
    {
        return "this text should be changed to the scriptable object description!!";
    }
}
