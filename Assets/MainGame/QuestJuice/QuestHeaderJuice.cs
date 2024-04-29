using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class QuestHeaderJuice : MonoBehaviour
{
    public enum QuestState
    {
        Available,
        Active,
        Completed
    }

    private QuestState _currentQuestState;//this holds the actual value 

    public QuestState CurrentQuestState//this is public and accessible, and should be used to change "State"
    {
        get { return _currentQuestState; }
        set { 
            _currentQuestState = value;
            OnQuestStatusChanged();
            Debug.Log("Enum just got changed to: " + _currentQuestState);
        }
    }

    [SerializeField] GameObject[] headerVFXs;

    [SerializeField] bool questTriggerTest = false;

    [Range(0,2)] 
    [SerializeField] int questState = 0;

    // Update is called once per frame
    void Update()
    {
        if (questTriggerTest)
        {
            if (questState == 0)
            {
                CurrentQuestState = QuestState.Available;
            }

            if (questState == 1)
            {
                CurrentQuestState = QuestState.Active;
            }

            if (questState == 2)
            {
                CurrentQuestState = QuestState.Completed;
            }
            questTriggerTest = false;
        }
    }

    void OnQuestStatusChanged()
    {
        if (CurrentQuestState == QuestState.Available)
        {
            foreach (GameObject vfx in headerVFXs)
            {
                vfx.SetActive(false);
                if (vfx.name == "AvailableQuestVFX")
                {
                    vfx.SetActive(true);
                }
            }
        }

        if (CurrentQuestState == QuestState.Active)
        {
            foreach (GameObject vfx in headerVFXs)
            {
                vfx.SetActive(false);
                Debug.Log("Active");
                if (vfx.name == "ActiveQuestVFX")
                {
                    vfx.SetActive(true);
                }
            }
        }

        if (CurrentQuestState == QuestState.Completed)
        {
            foreach (GameObject vfx in headerVFXs)
            {
                vfx.SetActive(false);
                if (vfx.name == "CompletedQuestVFX")
                {
                    vfx.SetActive(true);
                }
            }
        }
    }
}
