using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InventoryInput : MonoBehaviour
{
    [SerializeField] KeyCode toggleInventoryPanelKey;
    [SerializeField] GameObject inventoryPanelGameobject;
    [SerializeField] KeyCode toggleEquipmentPanelKey;
    [SerializeField] GameObject equipmentPanelGameObject;

    [SerializeField] GameObject abilityBarGameObject;

    public bool activePanel;

    private void Start()
    {
        activePanel = false;
        StartCoroutine(InventoryFixEarly());
    }

    // Update is called once per frame
    void Update()
    {
        if (!IngameMenu.gameIsPaused)
        {
            if (Input.GetKeyDown(toggleInventoryPanelKey))
            {
                inventoryPanelGameobject.SetActive(!inventoryPanelGameobject.activeSelf);
                if (inventoryPanelGameobject.activeSelf || equipmentPanelGameObject.activeSelf)
                {
                    ShowMouseCursor();
                }
                else
                {
                    HideMouseCursor();
                }

                if (!inventoryPanelGameobject.activeSelf && !equipmentPanelGameObject.activeSelf)
                {
                    abilityBarGameObject.SetActive(true);
                }
                else
                {
                    abilityBarGameObject.SetActive(false);
                }
                CheckActivePanels();
            }


            if (Input.GetKeyDown(toggleEquipmentPanelKey))
            {
                equipmentPanelGameObject.SetActive(!equipmentPanelGameObject.activeSelf);
                if (inventoryPanelGameobject.activeSelf || equipmentPanelGameObject.activeSelf)
                {
                    ShowMouseCursor();
                }
                else
                {
                    HideMouseCursor();
                }

                if (!inventoryPanelGameobject.activeSelf && !equipmentPanelGameObject.activeSelf)
                {
                    abilityBarGameObject.SetActive(true);
                }
                else
                {
                    abilityBarGameObject.SetActive(false);
                }
                CheckActivePanels();
            }
        }
    }

    public void CheckActivePanels()
    {
        if (inventoryPanelGameobject.activeSelf || equipmentPanelGameObject.activeSelf)
        {
            activePanel = true;
        }
        else
        {
            activePanel = false;
        }
    }

    public void ShowMouseCursor()
    {
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
    }

    public void HideMouseCursor()
    {
        Cursor.visible = false;
        //Cursor.lockState = CursorLockMode.Confined;
        Cursor.lockState = CursorLockMode.Locked;
    }

    public void ToggleEquipmentPanel()
    {
        equipmentPanelGameObject.SetActive(!equipmentPanelGameObject.activeSelf);
    }

    IEnumerator InventoryFixEarly()
    {
        inventoryPanelGameobject.SetActive(true);
        equipmentPanelGameObject.SetActive(true);
        yield return new WaitForEndOfFrame();
        inventoryPanelGameobject.SetActive(false);
        equipmentPanelGameObject.SetActive(false);
    }

}
