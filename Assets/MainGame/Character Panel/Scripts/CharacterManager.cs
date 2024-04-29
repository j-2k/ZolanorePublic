using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Juma.CharacterStats;
using TMPro;

public class CharacterManager : MonoBehaviour
{
    //Player Stats
    public int playerMaxHealth = 100;
    public int playerCurrentHealth = 100;

    public static bool isDead;

    //ADD NEW STATS HERE
    public CharacterStat Strength;
    public CharacterStat Dexterity;
    public CharacterStat Intelligence;
    public CharacterStat Defence;
    //

    //THISIS THE WHOLE CHARACTER PANEL MANAGER
    public Inventory inventory;
    public EquipmentPanel equipmentPanel;
    [SerializeField] StatPanel statPanel;
    [SerializeField] ItemTooltip itemTooltip;
    [SerializeField] Image draggableItem;
    [SerializeField] DropItemArea dropItemArea;
    [SerializeField] DestoryQuestion destroyQuestion;
    [SerializeField] ItemSaveManager itemSaveManager;

    [SerializeField] Image healthBar;
    [SerializeField] Image staminaBar;

    TextMeshProUGUI healthText;
    TextMeshProUGUI staminaText;

    private BaseItemSlot dragItemSlot;

    LevelSystem levelSystem;
    PlayerManager playerScript;
    [SerializeField] Animator playerAnimator;

    float timeOfHit;

    [SerializeField] ScreenDarken deathScreen;

    private void OnValidate()
    {
        if (itemTooltip == null)
        {
            itemTooltip = FindObjectOfType<ItemTooltip>();
        }
    }

    private void Awake()
    {
        statPanel.SetStats(Strength, Dexterity, Intelligence, Defence);
        statPanel.UpdateStatValue();


        //setup events;
        inventory.OnRightClickEvent += InventoryRightClick;
        equipmentPanel.OnRightClickEvent += EquipmentRightClick;

        inventory.OnPointerEnterEvent += ShowTooltip;
        equipmentPanel.OnPointerEnterEvent += ShowTooltip;

        inventory.OnPointerExitEvent += HideTooltip;
        equipmentPanel.OnPointerExitEvent += HideTooltip;

        inventory.OnBeginDragEvent += BeginDrag;
        equipmentPanel.OnBeginDragEvent += BeginDrag;

        inventory.OnEndDragEvent += EndDrag;
        equipmentPanel.OnEndDragEvent += EndDrag;

        inventory.OnDragEvent += Drag;
        equipmentPanel.OnDragEvent += Drag;

        inventory.OnDropEvent += Drop;
        equipmentPanel.OnDropEvent += Drop;
        dropItemArea.OnDropEvent += DropItemOutsideUI;

        itemSaveManager.LoadEquipment(this);
        itemSaveManager.LoadInventory(this);

        levelSystem = LevelSystem.instance;

        //levelSystem.levelUpAction += OnLevelUp;

        playerScript = GetComponent<PlayerManager>();
        healthText = healthBar.GetComponentInChildren<TextMeshProUGUI>();
        staminaText = staminaBar.GetComponentInChildren<TextMeshProUGUI>();
    }

    private void OnDestroy()
    {
        itemSaveManager.SaveEquipment(this);
        itemSaveManager.SaveInventory(this);
    }

    private void Start()
    {
        playerMaxHealth = 100;
        playerCurrentHealth = playerMaxHealth;
        healthText.text = playerCurrentHealth.ToString();
        healthBar.fillAmount -= healthBar.fillAmount - ((float)playerCurrentHealth / (float)playerMaxHealth);
        maxStamina = 100;
        curStamina = maxStamina;
    }

    
    //trying out level skill system where when u level up u gain 2 points to spend fre ein each skill slot seems to work
    private void Update()
    {
        HealthRegeneration();
    }

    float lastTimeRolled;
    float lastTimeDamageTaken;
    float cringeAdder = 0;
    [SerializeField] float healthRegenMulti = 2;
    [SerializeField] float staminaRegenMulti = 1;

    public float curStamina;
    public float maxStamina;

    void HealthRegeneration()
    {
        if (playerCurrentHealth < playerMaxHealth && !isDead)
        {   //5 is the seconds of offset to start regenerating
            if (lastTimeDamageTaken + 10 <= Time.time)
            {
                cringeAdder += (healthRegenMulti * Time.deltaTime);
                if (cringeAdder >= 1)
                {
                    cringeAdder = 0;
                    playerCurrentHealth += 1;
                    RefreshPlayerUI();
                }
            }
        }
    }

    public void CombatRoll()
    {
        if (curStamina >= 20)
        {
            curStamina -= 20;
            lastTimeRolled = Time.time;
            playerScript.playerAnimator.SetTrigger("RollTrigger");
            RefreshStaminaUI(curStamina, maxStamina);
        }
    }

    public void StaminaRegeneration()
    {
        if (curStamina <= maxStamina && !isDead)
        {   //5 is the seconds of offset to start regenerating
            if (lastTimeRolled + 5 <= Time.time)
            {
                curStamina += staminaRegenMulti * Time.deltaTime;
                RefreshStaminaUI(curStamina, maxStamina);
            }
        }
    }

    public void TakeDamageFromEnemy(int incDmg)
    {
        if (playerScript.isRolling || PlayerCodes.godMode){return;}
        lastTimeDamageTaken = Time.time;
        incDmg -= (Mathf.RoundToInt(Defence.Value)) + Mathf.RoundToInt(Defence.BaseValue * 1.5f);
        incDmg = Mathf.Clamp(incDmg, 0, int.MaxValue);
        playerCurrentHealth -= incDmg;
        Debug.Log("Final Dmg Taken is " + incDmg);
        //healthBar.fillAmount -= healthBar.fillAmount - ((float)playerCurrentHealth / (float)playerMaxHealth);
        if (playerCurrentHealth < 1)
        {
            KillPlayer();

            //player died
            //respawn in some location
            //play death animation then at the end of death animation trigger anim event to send the player to respawn location

        }
        else
        {
            isDead = false;
        }
        RefreshPlayerUI();
    }

    public void KillPlayer()
    {
        if (PlayerCodes.godMode) { return; }
        AbilityManager.instance.StopAbilities();
        playerCurrentHealth = 0;
        RefreshPlayerUI();
        isDead = true;
        foreach (AnimatorControllerParameter parameter in playerAnimator.parameters)
        {
            playerAnimator.SetBool(parameter.name, false);
        }
        playerAnimator.SetBool("DeadBool", true);
        deathScreen.gameObject.SetActive(true);
    }

    public void RespawnPlayer()
    {
        playerAnimator.SetBool("DeadBool", false);
        playerCurrentHealth = playerMaxHealth;
        curStamina = maxStamina;
        RefreshPlayerUI();
        isDead = false;
    }

    public void RefreshPlayerUI()
    {
        healthBar.fillAmount = ((float)playerCurrentHealth / (float)playerMaxHealth);
        healthText.text = playerCurrentHealth.ToString();
    }

    public void RefreshStaminaUI(int cur, int max)
    {
        staminaBar.fillAmount = ((float)cur / (float)max);
        stamString = (int)curStamina;
        staminaText.text = stamString.ToString();
    }

    int stamString;
    public void RefreshStaminaUI(float cur, float max)
    {
        staminaBar.fillAmount = (cur / max);
        stamString = (int)curStamina;
        staminaText.text = stamString.ToString();
    }

    void OnLevelUp()
    {
        playerMaxHealth += 20;
        playerCurrentHealth = playerMaxHealth;
    }



    private void InventoryRightClick(BaseItemSlot itemSlot)
    {
        if (itemSlot.Item is EquippableItem)
        {
            Equip((EquippableItem)itemSlot.Item);
        }
        else if (itemSlot.Item is UsableItem)
        {
            UsableItem usableItem = (UsableItem)itemSlot.Item;
            usableItem.Use(this);

            if (usableItem.IsConsumable)
            {
                inventory.RemoveItem(usableItem);
                usableItem.Destroy();
            }
        }
    }

    private void EquipmentRightClick(BaseItemSlot itemSlot)
    {
        if (itemSlot.Item is EquippableItem)
        {
            Unequip((EquippableItem)itemSlot.Item);
        }
    }


    private void ShowTooltip(BaseItemSlot itemSlot)
    {
        if (itemSlot.Item != null)
        {
            itemTooltip.ShowTooltip(itemSlot.Item);
        }
    }

    private void HideTooltip(BaseItemSlot itemSlot)
    {
        itemTooltip.HideTooltip();
    }

    private void BeginDrag(BaseItemSlot itemSlot)
    {
        if (itemSlot.Item != null)
        {
            dragItemSlot = itemSlot;
            draggableItem.sprite = itemSlot.Item.Icon;
            draggableItem.transform.position = Input.mousePosition;
            draggableItem.enabled = true;
        }
    }

    private void EndDrag(BaseItemSlot itemSlot)
    {
        dragItemSlot = null;
        draggableItem.enabled = false;
    }

    private void Drag(BaseItemSlot itemSlot)
    {
        if (draggableItem.enabled)
        {
            draggableItem.transform.position = Input.mousePosition;
        }
    }

    private void Drop(BaseItemSlot dropItemSlot)
    {
        if (dragItemSlot == null) return;

        if (dropItemSlot.CanAddStack(dragItemSlot.Item))
        {
            AddStacks(dropItemSlot);
        }
        else if (dropItemSlot.CanReceiveItem(dragItemSlot.Item) && dragItemSlot.CanReceiveItem(dropItemSlot.Item))
        {
            SwapItems(dropItemSlot);
        }
    }

    private void DropItemOutsideUI()
    {
        if (dragItemSlot == null)
        {
            return;
        }

        destroyQuestion.Show();
        BaseItemSlot baseItemSlot = dragItemSlot;
        destroyQuestion.OnYesEvent += () => DestoryItemInSlot(baseItemSlot); //() => lambra expression creating a empty function that receieves no arguments with ()
    }

    private void DestoryItemInSlot(BaseItemSlot baseItemSlot)
    {
        baseItemSlot.Item.Destroy();
        baseItemSlot.Item = null;
    }
    
    private void SwapItems(BaseItemSlot dropItemSlot)
    {
		EquippableItem dragEquipItem = dragItemSlot.Item as EquippableItem;
		EquippableItem dropEquipItem = dropItemSlot.Item as EquippableItem;

		if (dropItemSlot is EquipmentSlot)
		{
			if (dragEquipItem != null) dragEquipItem.Equip(this);
			if (dropEquipItem != null) dropEquipItem.Unequip(this);
		}
		if (dragItemSlot is EquipmentSlot)
		{
			if (dragEquipItem != null) dragEquipItem.Unequip(this);
			if (dropEquipItem != null) dropEquipItem.Equip(this);
		}
		statPanel.UpdateStatValue();

		Item draggedItem = dragItemSlot.Item;
		int draggedItemAmount = dragItemSlot.Amount;

		dragItemSlot.Item = dropItemSlot.Item;
		dragItemSlot.Amount = dropItemSlot.Amount;

		dropItemSlot.Item = draggedItem;
		dropItemSlot.Amount = draggedItemAmount;
    }

    private void AddStacks(BaseItemSlot dropItemSlot)
    {
        //Add stacks untill drgpitemslot is full
        //remove the same number of stacks from drag itemslot
        int numAddableStacks = dropItemSlot.Item.MaxStack - dropItemSlot.Amount;
        int stacksToAdd = Mathf.Min(numAddableStacks, dragItemSlot.Amount);

        dropItemSlot.Amount += stacksToAdd;
        dragItemSlot.Amount -= stacksToAdd;
    }

    public void Equip(EquippableItem equippableItem)
    {
        //first remove item from inventory
        if (inventory.RemoveItem(equippableItem))
        {
            EquippableItem previousItem;
            if (equipmentPanel.Additem(equippableItem, out previousItem))
            {
                //adding the new item to the equipment panel

                //first check if there was a item in that equipment panel 
                //if there is put that previous item back in the inventory
                if (previousItem != null)
                {
                    inventory.AddItem(previousItem);
                    previousItem.Unequip(this);
                    statPanel.UpdateStatValue();
                }
                equippableItem.Equip(this);
                statPanel.UpdateStatValue();
            }
            else
            {
                //if we cant equip fsr return to inventory
                inventory.AddItem(equippableItem);
            }
        }
    }

    public void Unequip(EquippableItem equippableItem)
    {
        //check if the inven is full first
        if (inventory.CanAddItem(equippableItem) && equipmentPanel.RemoveItem(equippableItem))
        {
            equippableItem.Unequip(this);
            statPanel.UpdateStatValue();
            inventory.AddItem(equippableItem);
        }
    }

    private ItemContainer openItemContainer;

    private void TransferToItemContainer(BaseItemSlot baseItemSlot)
    {
        Item item = baseItemSlot.Item;
        if(item != null && openItemContainer.CanAddItem(item))
        {
            inventory.RemoveItem(item);
            openItemContainer.AddItem(item);
        }
    }

    private void TransferToInventory(BaseItemSlot baseItemSlot)
    {
        Item item = baseItemSlot.Item;
        if (item != null && openItemContainer.CanAddItem(item))
        {
            openItemContainer.RemoveItem(item);
            inventory.AddItem(item);
        }
    }

    public void OpenItemContainer(ItemContainer itemContainer)
    {
        openItemContainer = itemContainer;

        inventory.OnRightClickEvent -= InventoryRightClick;
        inventory.OnRightClickEvent += TransferToItemContainer;

        itemContainer.OnRightClickEvent += TransferToInventory;

        itemContainer.OnPointerEnterEvent += ShowTooltip;
        itemContainer.OnPointerExitEvent += HideTooltip;
        itemContainer.OnBeginDragEvent += BeginDrag;
        itemContainer.OnEndDragEvent += EndDrag;
        itemContainer.OnDragEvent += Drag;
        itemContainer.OnDropEvent += Drop;
    }

    public void CloseItemContainer(ItemContainer itemContainer)
    {
        openItemContainer = itemContainer;

        inventory.OnRightClickEvent += InventoryRightClick;
        inventory.OnRightClickEvent -= TransferToItemContainer;

        itemContainer.OnRightClickEvent -= TransferToInventory;

        itemContainer.OnPointerEnterEvent -= ShowTooltip;
        itemContainer.OnPointerExitEvent -= HideTooltip;
        itemContainer.OnBeginDragEvent -= BeginDrag;
        itemContainer.OnEndDragEvent -= EndDrag;
        itemContainer.OnDragEvent -= Drag;
        itemContainer.OnDropEvent -= Drop;
    }

    public void UpdateStatSkillPoint()
    {
        statPanel.UpdateStatValue();
    }

    /*
    public void OpenItemContainer(ItemBank itemBank)
    {

    }

    public void CloseItemContainer(ItemBank itemBank)
    {

    }
    */
}
