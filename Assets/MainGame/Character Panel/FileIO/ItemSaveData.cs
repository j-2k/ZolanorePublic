using System;

[Serializable] //seri for saving and loading
public class ItemSlotSaveData
{
    public string ItemID;
    public int itemAmount;

    public ItemSlotSaveData(string id, int amount)
    {
        ItemID = id;
        itemAmount = amount; 
    }
}

[Serializable]
public class ItemContainerSaveData
{
    public ItemSlotSaveData[] SavedSlots;

    public ItemContainerSaveData(int numItems)
    {
        SavedSlots = new ItemSlotSaveData[numItems];
    }
}
