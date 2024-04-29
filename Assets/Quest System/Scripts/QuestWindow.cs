using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityEngine.UI;

public class QuestWindow : MonoBehaviour
{
    [SerializeField] private Text titleText;
    [SerializeField] private Text descriptionText;
    [SerializeField] private GameObject goalPrefab;
    [SerializeField] private Transform goalsContent;
    [SerializeField] private Text xpText;
    [SerializeField] private Text coinsText;

    GameObject counter;

    private Quest _Quest;
    private QuestManager questManager;

    private void Awake()
    {
        questManager = FindObjectOfType<QuestManager>();
    }

    public void Initialize(Quest quest)
    {
        _Quest = quest;
        titleText.text = quest.Information.Name;
        descriptionText.text = quest.Information.Description;

        foreach (var goal in quest.Goals)
        {
            GameObject goalObj = Instantiate(goalPrefab, goalsContent);
            goalObj.transform.Find("Goal Name").GetComponent<Text>().text = Regex.Replace(goal.GetDescription(), @"[\d-]", string.Empty);

            counter = goalObj.transform.Find("Counter").gameObject;

            if (goal.Completed)
            {
                counter.SetActive(false);
                goalObj.transform.Find("Done").gameObject.SetActive(true);
            }
            else
            {
                counter.GetComponent<Text>().text = goal.CurrentAmount + "/" + goal.RequiredAmount;
            }
        }
        xpText.text = quest.Reward.XP.ToString();
        coinsText.text = quest.Reward.Currency.ToString();
    }

    public void CloseWindow()
    {
        gameObject.SetActive(false);

        for (int i = 0; i < goalsContent.childCount; i++)
        {
            Destroy(goalsContent.GetChild(i).gameObject);
        }
    }
}
