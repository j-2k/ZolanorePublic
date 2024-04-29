using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class B_Chase : Boss_State
{
    //PHASE 1 (AWOKEN / CHASE / ATTACK1 ONLY)
    [SerializeField] float randChaseTimer;
    Vector3 lookAtPlayer;
    [SerializeField] InvulMatScript matScript;

    public override void BossOnCollisionEnter(Boss_StateMachine bsm, Collider collider)
    {
        throw new System.NotImplementedException();
    }

    public override void StartState(Boss_StateMachine bsm)
    {
        bsm.agent.enabled = true;
        matScript.SetMaterialValue(0);
        Debug.Log("start chase");
        randChaseTimer = Random.Range(3, 5);
        //randChaseTimer = 100;
        /*
        if (boss health is less than 50%)
            chasePhase = 2;
            else
            chasePhase = 1;
         */
    }

    public override void UpdateState(Boss_StateMachine bsm)
    {
        Debug.Log(" chasing state");
        if (bsm.bossPhase == 1)
        {//phase1
            EndChase(bsm,bsm.attack1State,1,11);
        }
        else
        {//phase2
            EndChase(bsm,bsm.attack2State,1,6);
        }

        if (Vector3.Distance(bsm.transform.position, bsm.player.transform.position) <= bsm.agent.stoppingDistance)
        {
            bsm.agent.enabled = false;
            lookAtPlayer = bsm.playerDirection.normalized;
            lookAtPlayer.y = 0;

            bsm.transform.rotation = Quaternion.RotateTowards(bsm.transform.rotation, Quaternion.LookRotation(lookAtPlayer), 120 * Time.deltaTime);
            bsm.anim.SetBool("Chase", false);
        }
        else
        {
            bsm.agent.enabled = true;
            bsm.agent.SetDestination(bsm.player.transform.position);
            bsm.anim.SetBool("Chase", true);
        }
    }

    void EndChase(Boss_StateMachine bsm, Boss_State attackState,int min, int max)
    {
        randChaseTimer -= Time.deltaTime * 1;
        if (randChaseTimer <= 0)
        {
            if (Random.Range(min, max) < 2)
            {
                matScript.SetMaterialValue(1);
            }
            bsm.anim.SetBool("Chase", false);
            bsm.agent.enabled = false;
            bsm.BossSwitchState(attackState);
        }
    }



}
