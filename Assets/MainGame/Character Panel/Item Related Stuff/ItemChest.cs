using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ItemChest : MonoBehaviour
{
    [Header("Change these ONLY if should roll is true ignore rolltype")]
    [SerializeField] bool shouldRoll = false;
    [SerializeField] AllItemTypesDB itemRollType;
    [SerializeField] bool neverDestoryChest = false;
    [SerializeField] KeyCode itemPickup = KeyCode.E;
    public int amount = 1;

    [Header("Leave everything under here")]
    [SerializeField] Item item;
    [SerializeField] Inventory inventory;
    [SerializeField] ItemDatabase itemDB;
    public bool isInRange = false;
    [SerializeField] bool isEmpty = false;       // dont need this can just null the item but if you dont want to lose the reference do this way
    float time = 0;
    ChestVFXManager chestVFX;

    // Start is called before the first frame update
    void Start()
    {//Random.Range(1, 5) is hardcoded for now
        chestVFX = GetComponentInChildren<ChestVFXManager>();
        if (shouldRoll)
        {
            int randItem = Random.Range(0, 3);
            item = itemDB.GetRandomItem((AllItemTypesDB)randItem, Random.Range(1, 5));
            if (randItem == (int)AllItemTypesDB.Coin)
            {
                amount = Random.Range(1, 10);
            }
            else
            {
                amount = 1;
            }
        }
        else
        {
            item = itemDB.GetRandomItem(itemRollType, Random.Range(1, 5));
        }
        StartCoroutine(InitInven());
    }

    //issue with script order i guess but this works really well
    IEnumerator InitInven()
    {
        inventory = Inventory.Instance;
        if (inventory != null)
        {
            yield return null;
        }
        else
        {
            yield return new WaitForEndOfFrame();
            inventory = Inventory.Instance;
        }
    }

    private void OnValidate()
    {
        if (inventory == null)
        {
            inventory = FindObjectOfType<Inventory>();
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (!isEmpty && isInRange && Input.GetKeyDown(itemPickup))
        {
            Item itemCopy = item.GetCopy();
            if (inventory.AddItem(itemCopy))
            {
                chestVFX.OpenChest();
                amount--;
                if (amount <= 0)
                {
                    time = 0;
                    isEmpty = true;
                }
            }
            else
            {
                itemCopy.Destroy();
            }
        }

        if (isEmpty)
        {
            time += Time.deltaTime;
            chestVFX.Invoke(nameof(chestVFX.EmptyChestParticles), 1.5f);

            if (time >= 30)
            {
                Destroy(this.gameObject);
            }
        }
        else if (!neverDestoryChest)
        {
            time += Time.deltaTime;
            if (time >= 180)
            {
                Destroy(this.gameObject);
            }
        }
    }

    /*
    private void OnTriggerEnter(Collider other)
    {
        InRangeTriggerCheck(other.gameObject, true);
    }

    private void OnTriggerExit(Collider other)
    {
        InRangeTriggerCheck(other.gameObject, false);
    }

    void InRangeTriggerCheck(GameObject gameObject, bool state)
    {
        if (gameObject.CompareTag("Player"))
        {
            isInRange = state;
            //text enabeled = state
        }
    }    
    */
}
