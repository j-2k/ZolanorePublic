using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class QuestGiver : MonoBehaviour
{
    public Quest quest;
    public GameObject goalsPrefab;

    public bool acceptedQuest = false;
    public bool completedQuest = false;
    public bool questActive = false;
    public bool claimedQuest = false;

    GameObject marker;

    QuestSystem questSystem;
    QuestGiver questGiver;

    MM_WorldObject questIcon;


    bool onFirstLoad = true;
    
    private void Start()
    {
        questIcon = GetComponent<MM_WorldObject>();
    }
    private void Update()
    {
        if (SceneManager.GetActiveScene() == SceneManager.GetSceneByBuildIndex(1))
        {
            if (onFirstLoad)
            {
                questSystem = FindObjectOfType<QuestSystem>();
                questGiver = GetComponent<QuestGiver>();
                marker = transform.GetChild(0).Find("Marker").gameObject;
            }
        }
        else
        {
            onFirstLoad = true;
        }
        if (acceptedQuest)
        {
            questActive = true;
        }
        if (claimedQuest)
        {
            questSystem.completedQuests++;
            marker.SetActive(false);
            questActive = false;
            gameObject.tag = "Untagged";
            questGiver.enabled = false;
            Invoke("DestroyQuestGiver", 5);
            questIcon.DestoryThisMMIcon();
        }
        else
        {
            if (quest.Completed) completedQuest = true;
            if (completedQuest || !acceptedQuest)
            {
                marker.SetActive(true);
            }
            else
            {
                marker.SetActive(false);
            }
        }

    }

    void DestroyQuestGiver()
    {
        for (int i = 0; i < transform.childCount; i++)
        {
            transform.GetChild(i).gameObject.SetActive(false);
        }
    }
}