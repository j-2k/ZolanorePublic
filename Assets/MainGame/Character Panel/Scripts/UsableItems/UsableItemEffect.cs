using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class UsableItemEffect : ScriptableObject
{
    public abstract void ExecuteEffect(UsableItem parentItem, CharacterManager characterPanelManager);

    public abstract string GetDescription();

    public abstract string GetDescriptionLore();
}
