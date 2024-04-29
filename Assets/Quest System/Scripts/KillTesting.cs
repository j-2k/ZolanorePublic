using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KillTesting : MonoBehaviour
{
    QuestManager questManager;

    private void Awake()
    {
        questManager = FindObjectOfType<QuestManager>();
    }
    public void KillGoblin()
    {
        questManager.Kill("Goblin");
    }
    public void KillMinion()
    {
        questManager.Kill("Minion");

    }
    public void KillGolem()
    {
        questManager.Kill("Golem");
    }

}