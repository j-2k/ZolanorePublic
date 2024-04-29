using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KillingGoals : Quest.QuestGoal
{
    public string Enemy;

    public override string GetDescription()
    {
        return $"Kill {Enemy}";
    }
    
    public override void Initialize()
    {
        base.Initialize();
        EventManager.Instance.AddListener<KillEnemyGameEvent>(OnKill);
    }

    private void OnKill(KillEnemyGameEvent eventInfo)
    {
        if(eventInfo.EnemyName == Enemy)
        {
            CurrentAmount++;
            Evaluate();
        }
    }

}
