using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Inventory : ItemContainer
{
    [SerializeField] Item[] startingItems;
    [SerializeField] Transform itemsParent;

    private static Inventory _instance;
    public static Inventory Instance 
    { 
        get 
        { 
            return _instance; 
        } 
    }
    

    protected override void Awake()
    {
        SingletonInstance();
        base.Awake();
        SetStartingItems();
    }

    void SingletonInstance()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
            Debug.Log("Another inventory Script?? check bug");
            return;
        }
        else
        {
            _instance = this;
        }
    }

    protected override void OnValidate()
    {
        if (itemsParent != null)
        {
            itemsParent.GetComponentsInChildren<ItemSlot>(includeInactive: true, result: itemSlots); //add objects that are even disabled
        }

        SetStartingItems();
    }

    void SetStartingItems()
    {
        Clear();
        foreach (Item item in startingItems)
        {
            AddItem(item.GetCopy());
        }
    }
}
