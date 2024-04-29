using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class DropItemArea : MonoBehaviour, IDropHandler
{
    public event Action OnDropEvent;

    public void OnDrop(PointerEventData eventData)
    {
        if (OnDropEvent != null)
        {
            OnDropEvent();
        }
    }
}
