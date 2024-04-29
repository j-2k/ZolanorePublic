using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EquipmentPanel : MonoBehaviour
{
    [SerializeField] Transform equipmentSlotsParent;
    public EquipmentSlot[] equipmentSlots;


    public event Action<BaseItemSlot> OnPointerEnterEvent;
    public event Action<BaseItemSlot> OnPointerExitEvent;
    public event Action<BaseItemSlot> OnRightClickEvent;
    public event Action<BaseItemSlot> OnBeginDragEvent;
    public event Action<BaseItemSlot> OnDragEvent;
    public event Action<BaseItemSlot> OnEndDragEvent;
    public event Action<BaseItemSlot> OnDropEvent;

    private void Start()
    {
        for (int i = 0; i < equipmentSlots.Length; i++)
        {
            equipmentSlots[i].OnPointerEnterEvent += slot => OnPointerEnterEvent(slot);
            equipmentSlots[i].OnPointerExitEvent += slot => OnPointerExitEvent(slot);
            equipmentSlots[i].OnRightClickEvent += slot => OnRightClickEvent(slot);
            equipmentSlots[i].OnBeginDragEvent += slot => OnBeginDragEvent(slot);
            equipmentSlots[i].OnDragEvent += slot => OnDragEvent(slot);
            equipmentSlots[i].OnEndDragEvent += slot => OnEndDragEvent(slot);
            equipmentSlots[i].OnDropEvent += slot => OnDropEvent(slot);
        }
    }

    private void OnValidate()
    {
        equipmentSlots = equipmentSlotsParent.GetComponentsInChildren<EquipmentSlot>();
    }

    public bool Additem (EquippableItem equippableItem, out EquippableItem previousItem)
    {
        for (int i = 0; i < equipmentSlots.Length; i++)
        {
            if (equipmentSlots[i].EquipmentType == equippableItem.EquipmentType)
            {
                previousItem = (EquippableItem)equipmentSlots[i].Item;
                equipmentSlots[i].Item = equippableItem;
                equipmentSlots[i].Amount = 1;
                return true;
            }
        }
        previousItem = null;
        return false;
    }

    public bool RemoveItem(EquippableItem equippableItem)
    {
        for (int i = 0; i < equipmentSlots.Length; i++)
        {
            if (equipmentSlots[i].Item == equippableItem)
            {
                equipmentSlots[i].Item = null;
                equipmentSlots[i].Amount = 0;
                return true;
            }
        }

        return false;
    }

}
