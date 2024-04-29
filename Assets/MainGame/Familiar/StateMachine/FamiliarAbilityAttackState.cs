using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class FamiliarAbilityAttackState : State
{
    [SerializeField] FamiliarFollowState followState;
    PlayerFamiliar playerFamiliar;
    NavMeshAgent familiarAgent;
    CharacterManager playerStats;
    
    EnemyStatManager enemyCache;

    float attackTimer;
    bool isFarFromPlayer;

    LevelSystem levelSystem;

    // Start is called before the first frame update
    void Start()
    {
        levelSystem = LevelSystem.instance;

        playerFamiliar = GetComponentInParent<PlayerFamiliar>();
        familiarAgent = GetComponentInParent<NavMeshAgent>();
        playerStats = playerFamiliar.player.GetComponent<CharacterManager>();
    }


    public override State runCurrentState()
    {
        if (playerFamiliar.enemyAbilityFocus == null || playerFamiliar.callFamiliarBack)
        {
            return FinishedAttacking();
        }
        else if (playerFamiliar.enemyAbilityFocus != null)
        {
            attackTimer += Time.deltaTime;
            if (attackTimer >= 3)
            {
                Debug.Log("<color=blue>Attacked Enemy</color>" + playerFamiliar.enemyAbilityFocus.name);
                attackTimer = 0;
                AttackEnemyWithAbility();
                return FinishedAttacking();
            }
        }
        return this;
    }

    FamiliarFollowState FinishedAttacking()
    {
        attackTimer = 0;
        familiarAgent.stoppingDistance = 5;
        familiarAgent.speed = 5;
        playerFamiliar.isEnemyHit = false;
        playerFamiliar.callFamiliarBack = false;
        return followState;
    }

    void AttackEnemyWithAbility()
    {
        if (playerFamiliar.enemyAbilityFocus != null)
        {
            playerFamiliar.enemyAbilityFocus.TakeDamageFromPlayer(AbilityCalculationFamiliar());
        }
    }

    int AbilityCalculationFamiliar()
    {
        int levelBasedDMG = (int)((levelSystem.currentLevel * 2) * Random.Range(1f, 2f));
        int finalDMG = (int)(levelBasedDMG * Random.Range(0.8f, 1.2f) + (playerStats.Strength.Value * Random.Range(0.8f,1.2f)));
        playerFamiliar.abilityTrigger = false;
        Debug.Log("Dealing " + finalDMG + " ABILITY DMG by familiar!");
        return finalDMG;
    }

}
