using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class FamiliarFollowState : State
{
    [SerializeField] FamiliarChaseState chaseState;
    [SerializeField] FamiliarAbilityState abilityState;
    PlayerFamiliar playerFamiliar;
    NavMeshAgent familiarAgent;
    GameObject player;
    [SerializeField] PlayerManager pm;

    float timeToTeleport;
    float teleTimer;

    void Start()
    {
        timeToTeleport = 6;
        playerFamiliar = GetComponentInParent<PlayerFamiliar>();
        familiarAgent = GetComponentInParent<NavMeshAgent>();
        player = playerFamiliar.player;

        if (pm == null)
        {
            pm = PlayerManager.instance;
        }
    }

    // Update is called once per frame
    public override State runCurrentState()
    {
        if (playerFamiliar.isEnemyHit)
        {
            if (Vector3.Distance(familiarAgent.transform.position, player.transform.position) >= familiarAgent.stoppingDistance + 3)//5+3
            {
                familiarAgent.enabled = false;
                familiarAgent.transform.position = player.transform.position;
            }

            if (playerFamiliar.abilityTrigger)
            {
                if (playerFamiliar.lastestEnemyHit == null)
                {
                    playerFamiliar.isEnemyHit = false;
                    return this;
                }
                else if (playerFamiliar.lastestEnemyHit != null)
                {
                    playerFamiliar.enemyAbilityFocus = playerFamiliar.lastestEnemyHit.GetComponent<EnemyStatManager>();
                    return abilityState;
                }
            }
            familiarAgent.enabled = true;
            playerFamiliar.callFamiliarBack = false;
            return chaseState;
        }
        else
        {
            if (familiarAgent.enabled && !pm.isJumping)
            {
                familiarAgent.SetDestination(player.transform.position);
            }

            if (Vector3.Distance(familiarAgent.transform.position, player.transform.position) >= familiarAgent.stoppingDistance + 3)//5+3
            {
                teleTimer += Time.deltaTime;
                if (teleTimer >= timeToTeleport && !pm.isJumping)
                {
                    familiarAgent.enabled = false;
                    familiarAgent.transform.position = player.transform.position;
                    teleTimer = 0;
                }
            }
            else
            {
                familiarAgent.enabled = true;
                teleTimer = 0;
            }
            return this;
        }
    }
}
