using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class QuestReferenceFix : MonoBehaviour
{
    [SerializeField] Button button;
   
    // Start is called before the first frame update
    void Start()
    {
        button = GetComponent<Button>();

        if (this.gameObject.name == "Accept")
        {
            button.onClick.AddListener(PlayerManager.instance.gameObject.GetComponent<QuestSystem>().AcceptQuest);
        }

        if(this.gameObject.name == "Close")
        {
            button.onClick.AddListener(GetComponentInParent<QuestWindow>().CloseWindow);
            button.onClick.AddListener(PlayerManager.instance.gameObject.GetComponent<QuestSystem>().EnableCharacterRotation);
        }

        if(this.gameObject.name == "Claim")
        {
            button.onClick.AddListener(PlayerManager.instance.gameObject.GetComponent<QuestSystem>().Claim);
            button.onClick.AddListener(PlayerManager.instance.gameObject.GetComponent<QuestSystem>().EnableCharacterRotation);
        }
    }
}
