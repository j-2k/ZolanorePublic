using UnityEngine;
using TMPro;

public class ItemTooltip : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI ItemNameText;
    [SerializeField] TextMeshProUGUI ItemTypeText;
    [SerializeField] TextMeshProUGUI ItemStatsText;
    [SerializeField] TextMeshProUGUI ItemDescriptionText;

    public void ShowTooltip (Item item)
    {
        ItemNameText.text = item.ItemName;
        ItemTypeText.text = item.GetItemType();

        /*
         * this allocates so much memory especially if ran many times
         * creating a new copy of a string with the concatenation
         * we will allocate tons of strings & will be very bad for performance 
        ItemStatsText.text = equippableItem.StrengthBonus + " Strength";
        ItemStatsText.text += "\n" + equippableItem.IntelligenceBonus + " Intelligence";
        */

        ItemStatsText.text = item.GetDescription();
        ItemDescriptionText.text = item.GetDescriptionLore();

        gameObject.SetActive(true);
    }

    public void HideTooltip()
    {
        gameObject.SetActive(false);
    }
}
