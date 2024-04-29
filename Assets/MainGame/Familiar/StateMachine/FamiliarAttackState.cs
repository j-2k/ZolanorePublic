using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class FamiliarAttackState : State
{
    [SerializeField] FamiliarFollowState followState;
    [SerializeField] FamiliarChaseState chaseState;
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

    bool assignOnce = true;

    public override State runCurrentState()
    {
        if (assignOnce)
        {
            enemyCache = playerFamiliar.lastestEnemyHit.GetComponent<EnemyStatManager>();
            assignOnce = false;
        }

        if (playerFamiliar.lastestEnemyHit == null || playerFamiliar.callFamiliarBack || enemyCache == null || enemyCache.isDead)
        {
            return FinishedAttacking();
        }
        else
        {
            attackTimer += Time.deltaTime;
        }
        


        if (playerFamiliar.isAggressiveFamiliar && !isFarFromPlayer)//if player is not far continue attacking
        {//keep attacking the enemy untill it dies player must be in range at all times
            if (attackTimer >= 3)
            {
                Debug.Log("<color=blue>Attacked Enemy</color>" + enemyCache.name);
                attackTimer = 0;
                AttackEnemyCache();
                return AggressiveAttack();
            }
        }
        else//if player is far attack the enemy & go back to player
        {//attack once and return if not aggro
            if (attackTimer >= 3)
            {
                attackTimer = 0;
                Debug.Log("<color=blue>Attacked Enemy</color>" + enemyCache.name);
                AttackEnemyCache();
                return FinishedAttacking();
            }
        }

        if (Vector3.Distance(familiarAgent.transform.position, playerStats.transform.position) >= 15)
        {
            isFarFromPlayer = true;
        }
        else
        {
            isFarFromPlayer = false;
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
        assignOnce = true;
        return followState;
    }

    FamiliarChaseState AggressiveAttack()
    {
        attackTimer = 0;
        playerFamiliar.isEnemyHit = false;
        playerFamiliar.callFamiliarBack = false;
        assignOnce = true;
        return chaseState;
    }

    void AttackEnemyCache()
    {
        if (enemyCache != null)
        {
            enemyCache.TakeDamageFromPlayer(DamageCalculationFamiliar());
        }
    }

    int DamageCalculationFamiliar()
    {
        int levelBasedDMG = (int)((levelSystem.currentLevel * 2)* Random.Range(0.5f,1.5f));
        int finalDMG = (int)(levelBasedDMG * Random.Range(0.8f, 1.2f));
        Debug.Log("Dealing " + finalDMG + " DMG by familiar!");
        
        return finalDMG;
    }
}
