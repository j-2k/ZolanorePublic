using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class QuestManager : MonoBehaviour
{
    [SerializeField] private GameObject questPrefab;

    public Transform questsContent;
    public QuestSystem questSystem;
    public GameObject questHolder;
    public List<Quest> CurrentQuests;

    private void Awake()
    {
        foreach (var quest in CurrentQuests)
        {
            quest.Initialize();
            quest.QuestCompleted.AddListener(OnQuestCompleted);

        }
    }

    public void InstantiateQuestButton(Quest quest)
    {
        GameObject questObj = Instantiate(questPrefab, questsContent);
        questObj.GetComponent<Image>().sprite = quest.Information.Icon;

        questObj.GetComponent<Button>().onClick.AddListener(delegate
        {
            if (!questHolder.activeSelf)
            {
                InitializeWindow(quest);
            }
        });
    }

    public void InitializeWindow(Quest quest)
    {
        questHolder.GetComponent<QuestWindow>().Initialize(quest);
        questHolder.SetActive(true);
    }

    public void Kill(string enemyName)
    {
        EventManager.Instance.QueueEvent(new KillEnemyGameEvent(enemyName));
    }

    private void OnQuestCompleted(Quest quest)
    {
        questsContent.GetChild(CurrentQuests.IndexOf(quest)).Find("Checkmark").gameObject.SetActive(true);
    }

}
