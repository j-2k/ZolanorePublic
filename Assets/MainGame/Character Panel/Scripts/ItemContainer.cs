using System;
using System.Collections.Generic;
using UnityEngine;

public abstract class ItemContainer : MonoBehaviour, IItemContainer
{
    public List<ItemSlot> itemSlots;

    public event Action<BaseItemSlot> OnPointerEnterEvent;
    public event Action<BaseItemSlot> OnPointerExitEvent;
    public event Action<BaseItemSlot> OnRightClickEvent;
    public event Action<BaseItemSlot> OnBeginDragEvent;
    public event Action<BaseItemSlot> OnDragEvent;
    public event Action<BaseItemSlot> OnEndDragEvent;
    public event Action<BaseItemSlot> OnDropEvent;

    protected virtual void OnValidate()
    {
        GetComponentsInChildren<ItemSlot>(includeInactive: true, result: itemSlots);
    }

    protected virtual void Awake()
    {
        //listener for the itemslots event
        for (int i = 0; i < itemSlots.Count; i++)
        {
            itemSlots[i].OnPointerEnterEvent += slot => OnPointerEnterEvent(slot);
            itemSlots[i].OnPointerExitEvent += slot => OnPointerExitEvent(slot);
            itemSlots[i].OnRightClickEvent += slot => OnRightClickEvent(slot);
            itemSlots[i].OnBeginDragEvent += slot => OnBeginDragEvent(slot);
            itemSlots[i].OnDragEvent += slot => OnDragEvent(slot);
            itemSlots[i].OnEndDragEvent += slot => OnEndDragEvent(slot);
            itemSlots[i].OnDropEvent += slot => OnDropEvent(slot);
        }
    }

    public virtual bool CanAddItem(Item item, int amount = 1)
    {
        int freeSpaces = 0;

        foreach (ItemSlot itemSlot in itemSlots)
        {
            if (itemSlot.Item == null || itemSlot.Item.ID == item.ID)
            {
                freeSpaces += item.MaxStack - itemSlot.Amount;
            }
        }

        return freeSpaces >= amount;
    }

    public virtual bool AddItem(Item item)
    {
        for (int i = 0; i < itemSlots.Count; i++)
        {
            if (itemSlots[i].CanAddStack(item))
            {
                itemSlots[i].Item = item;
                itemSlots[i].Amount++;
                return true;
            }
        }

        //loop through all item slots the first null slot will place the item in it 
        for (int i = 0; i < itemSlots.Count; i++)
        {
            if (itemSlots[i].Item == null)
            {
                itemSlots[i].Item = item;
                itemSlots[i].Amount++;
                return true;
            }
        }
        return false;
    }

    public virtual bool RemoveItem(Item item)
    {
        //vice versa of add
        for (int i = 0; i < itemSlots.Count; i++)
        {
            if (itemSlots[i].Item == item)
            {
                itemSlots[i].Amount--;
                return true;
            }
        }
        return false;
    }


    //new remove item with ID
    public Item RemoveItem(string itemID)
    {
        //vice versa of add
        for (int i = 0; i < itemSlots.Count; i++)
        {
            Item item = itemSlots[i].Item;
            //go through all items & check the slots if there is a item we compare its id to the ID we are looking for when we find it just empty & return the item reference
            if (item != null && item.ID == itemID)
            {
                itemSlots[i].Amount--;
                return item;
            }
        }
        return null;
    }

    public virtual int ItemCount(string itemID)
    {
        int number = 0;

        for (int i = 0; i < itemSlots.Count; i++)
        {
            Item item = itemSlots[i].Item;
            if (item != null && item.ID == itemID)
            {
                number += itemSlots[i].Amount;
            }
        }
        return number;
    }

    public virtual void Clear()
    {
        for (int i = 0; i < itemSlots.Count; i++)
        {
            itemSlots[i].Item = null;
        }
    }
}
