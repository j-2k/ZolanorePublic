using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class FamiliarChaseState : State
{
    [SerializeField] FamiliarFollowState followState;
    [SerializeField] FamiliarAttackState attackState;
    PlayerFamiliar playerFamiliar;
    NavMeshAgent familiarAgent;
    GameObject player;

    float catchUpTimer;

    void Start()
    {
        playerFamiliar = GetComponentInParent<PlayerFamiliar>();
        familiarAgent = GetComponentInParent<NavMeshAgent>();
        player = playerFamiliar.player;
    }

    public override State runCurrentState()
    {
        if (playerFamiliar.lastestEnemyHit == null || playerFamiliar.callFamiliarBack)
        {
            return FollowState();
        }
        else
        {
            familiarAgent.SetDestination(playerFamiliar.lastestEnemyHit.transform.position);

            familiarAgent.stoppingDistance = 4;

            if (Vector3.Distance(familiarAgent.transform.position, playerFamiliar.lastestEnemyHit.transform.position) <= familiarAgent.stoppingDistance) //familiarAgent.stoppingDistance this shit fucked me for 2 hours i had another number instead
            {   //IF U WANT TO CHANGE THE DISTANCE OF THE ATTACK RANGE YOU MUST CHANGE THE STOPPING DISTANCE  = familiarAgent.stoppingDistance I MESSED UP BEFORE
                Debug.Log("FAMILIAR IS IN RANGE CHANGING TO ATTACK STATE");
                return attackState;
            }
            else if (Vector3.Distance(familiarAgent.transform.position, player.transform.position) >= 15)
            {
                catchUpTimer += Time.deltaTime;
                Debug.Log("inside catchup");
                if (catchUpTimer >= 5)
                {
                    return FollowState();
                }
            }
            else
            {
                catchUpTimer = 0;
            }

            return this;
        }
    }

    FamiliarFollowState FollowState()
    {
        Debug.Log("Attack To Following State");
        familiarAgent.stoppingDistance = 5;
        playerFamiliar.isEnemyHit = false;
        playerFamiliar.callFamiliarBack = false;
        catchUpTimer = 0;
        return followState;
    }
}
