using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ItemSaveManager : MonoBehaviour
{
    [SerializeField] ItemDatabase itemDatabase;

    private const string InventoryFileName = "Inventory";
    private const string EquipmentFileName = "Equipment";


    public void LoadInventory(CharacterManager character)
    {
        ItemContainerSaveData savedSlots = ItemSaveIO.LoadItems(InventoryFileName);
        if (savedSlots == null)
        {
            return;
        }

        character.inventory.Clear();

        for (int i = 0; i < savedSlots.SavedSlots.Length; i++)
        {
            ItemSlot itemSlot = character.inventory.itemSlots[i];
            ItemSlotSaveData savedSlot = savedSlots.SavedSlots[i];

            if (savedSlot == null)
            {
                itemSlot.Item = null;
                itemSlot.Amount = 0;
            }
            else
            {
                itemSlot.Item = itemDatabase.GetItemCopy(savedSlot.ItemID);
                itemSlot.Amount = savedSlot.itemAmount;
            }
        }
    }

    public void LoadEquipment(CharacterManager character)
    {
        ItemContainerSaveData savedSlots = ItemSaveIO.LoadItems(EquipmentFileName);
        if (savedSlots == null) return;

        foreach (ItemSlotSaveData savedSlot in savedSlots.SavedSlots)
        {
            if (savedSlot == null)
            {
                continue;
            }

            Item item = itemDatabase.GetItemCopy(savedSlot.ItemID);
            character.inventory.AddItem(item);
            character.Equip((EquippableItem)item);
        }
    }

    public void SaveInventory(CharacterManager character)
    {
        SaveItems(character.inventory.itemSlots,InventoryFileName);
    }

    public void SaveEquipment(CharacterManager character)
    {
        SaveItems(character.equipmentPanel.equipmentSlots, EquipmentFileName);
    }

    private void SaveItems(IList<ItemSlot> itemSlots, string fileName)
    {
        var saveData = new ItemContainerSaveData(itemSlots.Count);

        for (int i = 0; i < saveData.SavedSlots.Length; i++)
        {
            ItemSlot itemSlot = itemSlots[i];

            if (itemSlot.Item == null)
            {
                saveData.SavedSlots[i] = null;
            }
            else
            {
                saveData.SavedSlots[i] = new ItemSlotSaveData(itemSlot.Item.ID, itemSlot.Amount);
            }
        }

        ItemSaveIO.SaveItems(saveData, fileName);
    }
}
