using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class QuestSystem : MonoBehaviour
{
    [SerializeField] GameObject questCanvas, interactUI, questTracker, questTrackerName, questTrackerGoalPrefab, questJournal, claimButton, acceptButton;

    GameObject questInformation;

    public GameObject closestQuestGiver;

    QuestManager questManager;
    QuestWindow questWindow;
    LevelSystem levelSystem;
    public QuestGiver questGiver;

    public int completedQuests = 0;

    CameraControllerMain cameraController;
    TestMovement testMovement;

    public List<GameObject> questGivers;

    bool isClose = false;
    bool isNear = false;
    public bool questsActive = false;
    bool openedQuest = false;

    bool onFirstLoad = true;

    public bool bossPortal = false;

    private void Update()
    {
        if(SceneManager.GetActiveScene() == SceneManager.GetSceneByBuildIndex(1))
        {
            if (onFirstLoad)
            {
                IntializeReferences();
                levelSystem = LevelSystem.instance;
                Cursor.visible = false;
                questJournal.SetActive(false);
                claimButton.SetActive(false);
                questInformation.SetActive(false);
                onFirstLoad = false;
            }
            if (completedQuests >= 2)
            {
                bossPortal = true;
            }
            GetClosestQuestGiver();
            if (questGivers.Count > 0)
            {
                CheckIfCloseToQuestGiver();
                IfCloseActivateUI();

                if (isNear)
                {
                    if (Input.GetKeyDown(KeyCode.E))
                    {
                        openedQuest = true;
                        if (!questGiver.completedQuest)
                        {
                            claimButton.SetActive(false);
                        }
                        if (questInformation.activeSelf)
                        {
                            CloseQuestInfo();
                        }
                        else if (questGiver.completedQuest)
                        {
                            closestQuestGiver.GetComponent<Animator>().SetTrigger("Finish");
                            claimButton.SetActive(true);
                            DisableCharacterRotation();
                            questManager.InitializeWindow(questGiver.quest);
                            Cursor.visible = true;
                            Cursor.lockState = CursorLockMode.None;

                        }
                        else if (!questGiver.acceptedQuest)
                        {
                            closestQuestGiver.GetComponent<Animator>().SetTrigger("Talk");
                            acceptButton.SetActive(true);
                            DisableCharacterRotation();
                            questManager.InitializeWindow(questGiver.quest);
                            Cursor.visible = true;
                            Cursor.lockState = CursorLockMode.None;
                        }
                        else
                        {
                            EnableCharacterRotation();
                        }
                    }
                }

            }
        }
        else
        {
            onFirstLoad = true;
        }

    }

    private void OpenQuestJournal()
    {
        CheckIfQuestActive();
        if (questsActive)
        {
            ActivateOrDisactivateQuestJournal();
        }
    }

    void ActivateOrDisactivateQuestJournal()
    {
        if (questJournal.activeSelf == true)
        {
            questWindow.CloseWindow();
            Cursor.visible = false;
            Cursor.lockState = CursorLockMode.Locked;
            EnableCharacterRotation();
            questInformation.SetActive(false);
            questJournal.SetActive(false);
        }
        else
        {
            Cursor.visible = true;
            Cursor.lockState = CursorLockMode.None;
            DisableCharacterRotation();
            questJournal.SetActive(true);
        }
    }

    private void CheckIfQuestActive()
    {
        for (int i = 0; i < questGivers.Count; i++)
        {
            if (questGivers[i].GetComponent<QuestGiver>().questActive)
            {
                questsActive = true;
                return;
            }
            else questsActive = false;
        }
    }

    private void IfCloseActivateUI()
    {
        if (isClose && !questGiver.acceptedQuest || isClose && questGiver.completedQuest)
        {
            isNear = true;
        }
        else
        {
            isNear = false;
        }
    }

    private void CheckIfCloseToQuestGiver()
    {
        float distance = Vector3.Distance(transform.position, closestQuestGiver.transform.position);
        if (distance < 5) isClose = true;
        else isClose = false;
    }

    private void GetClosestQuestGiver()
    {
        float closestQG = Mathf.Infinity;
        for (int i = 0; i < questGivers.Count; i++)
        {
            float distance = Vector3.Distance(transform.position, questGivers[i].transform.position);
            if (distance < closestQG)
            {
                closestQG = distance;
                closestQuestGiver = questGivers[i];
                questGiver = closestQuestGiver.GetComponent<QuestGiver>();
            }
        }
    }

    public void CloseQuestInfo()
    {
        openedQuest = false;
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.None;
        if (questJournal.activeSelf)
        {
            questJournal.SetActive(false);
        }
        if (!questGiver.acceptedQuest && isClose)
        {
            questWindow.CloseWindow();
            EnableCharacterRotation();
        }
        else
        {
            questWindow.CloseWindow();
            EnableCharacterRotation();
        }
    }

    private void DisableCharacterRotation()
    {
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.Locked;
        FindObjectOfType<CameraControllerMain>().enabled = false;
        GetComponent<CharacterManager>().enabled = false;
        GetComponent<PlayerManager>().enabled = false;
        GetComponent<PlayerManager>().playerAnimator.SetFloat("rmVelocity", 0);
        GetComponent<CharacterController>().enabled = false;
    }

    public void EnableCharacterRotation()
    {
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.None;
        FindObjectOfType<CameraControllerMain>().enabled = true;
        GetComponent<CharacterManager>().enabled = true;
        GetComponent<PlayerManager>().enabled = true;
        GetComponent<CharacterController>().enabled = true;
    }

    private void InitializeQuestGiversList()
    {
        questGivers = new List<GameObject>();
        var _questGivers = GameObject.FindGameObjectsWithTag("QuestGiver");
        foreach (var questGiver in _questGivers)
        {
            questGivers.Add(questGiver);
        }
    }

    private void IntializeReferences()
    {
        InitializeQuestManagers();
        InitializeQuestUI();
        InitializeQuestGiversList();
        InitializeCharacterControls();
        questCanvas = GameObject.Find("Quest Canvas").gameObject;
        questTrackerName = questCanvas.transform.GetChild(4).gameObject;
        questTrackerName.SetActive(false);
    }

    private void InitializeQuestManagers()
    {
        questManager = FindObjectOfType<QuestManager>();
        questWindow = FindObjectOfType<QuestWindow>();
    }

    private void InitializeCharacterControls()
    {
        cameraController = FindObjectOfType<CameraControllerMain>();
        testMovement = FindObjectOfType<TestMovement>();
    }

    private void InitializeQuestUI()
    {
        questInformation = GameObject.FindGameObjectWithTag("QuestInformation");
        questJournal = GameObject.FindGameObjectWithTag("QuestContainer");
        acceptButton = GameObject.FindGameObjectWithTag("AcceptButton");
        claimButton = GameObject.FindGameObjectWithTag("ClaimButton");
    }

    public void AcceptQuest()
    {
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;

        questManager.InstantiateQuestButton(questGiver.quest);

        if(questTracker == null)
        {
            questTracker = questCanvas.transform.GetChild(3).gameObject;
        }
        questTracker.SetActive(true);
        questTrackerName.SetActive(true);
        for (int i = 0; i < closestQuestGiver.GetComponent<QuestGiver>().quest.Goals.Count; i++)
        {
            GameObject goalPrefab = Instantiate(questTrackerGoalPrefab, questTracker.transform);
            goalPrefab.transform.parent = questTracker.transform;
            goalPrefab.name = closestQuestGiver.GetComponent<QuestGiver>().quest.Goals[i].GetDescription();
            goalPrefab.transform.Find("Goal Name").GetComponent<Text>().text = closestQuestGiver.GetComponent<QuestGiver>().quest.Goals[i].GetDescription();
            goalPrefab.transform.Find("Counter").GetComponent<Text>().text = "0 / " + closestQuestGiver.GetComponent<QuestGiver>().quest.Goals[i].RequiredAmount;
        }

        questGiver.acceptedQuest = true;

        questGiver.questActive = true;

        EnableCharacterRotation();

        questWindow.CloseWindow();

        acceptButton.SetActive(false);
    }

    public void Claim()
    {
        
        interactUI.SetActive(false);
        levelSystem.onXPGainedDelegate.Invoke(levelSystem.currentLevel, questGiver.quest.Reward.XP);
        Debug.LogWarning("Congrats ! " + questGiver.quest.Reward.XP);
        Debug.LogWarning("Congrats ! " + questGiver.quest.Reward.Currency);
        //Destroy(questManager.questsContent.GetChild(questManager.CurrentQuests.IndexOf(questGiver.quest)).gameObject);
        for (int i = 0; i < questTracker.transform.childCount; i++)
        {
            for (int j = 0; j < questGiver.quest.Goals.Count; j++)
            {
                if (questGiver.quest.Goals[j].GetDescription() == questTracker.transform.GetChild(i).name)
                {
                    questTracker.transform.GetChild(i).gameObject.SetActive(false);
                }
            }
            
        }
        if(questTracker.transform.childCount ==0 )
        {
            questTracker.SetActive(false);
            questTrackerName.SetActive(false);
        }
        
        questManager.CurrentQuests.Remove(questGiver.quest);
        questWindow.CloseWindow();
        questGiver.claimedQuest = true;
        questGivers.Remove(closestQuestGiver);
    }
}