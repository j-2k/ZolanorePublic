using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class B_Attack2 : Boss_State
{
    //choose from 2 attacks (dodge pattern has to be diff)
    [SerializeField] int cycleInitialization;
    [SerializeField] int attackType;
    Vector3 lookAtPlayer;

    [SerializeField] ParticleSystem meteorVFX;
    [SerializeField] ParticleSystem fireCharge;
    [SerializeField] ParticleSystem fireLineVFX;
    [SerializeField] Transform playerGroundPosition;

    [SerializeField] float timer = 0;
    [SerializeField] int cycles = 0;

    int bossTurningSpeed;
    Vector3 playerYOnly;

    public override void BossOnCollisionEnter(Boss_StateMachine bsm, Collider collider)
    {
        throw new System.NotImplementedException();
    }

    public override void StartState(Boss_StateMachine bsm)
    {
        Debug.Log("started attack phase 2");
        attackType = Random.Range(1, 3);
        timer = 0;
        bossTurningSpeed = 120;
        playerGroundPosition = bsm.player.transform.GetChild(bsm.player.transform.childCount - 1);
        playerGroundPosition = playerGroundPosition.GetChild(0);
        if (cycleInitialization == 0)
        {
            cycleInitialization = 5;
        }

        if (attackType == 1)
        {
            bsm.anim.SetTrigger("StartFireline");
            fireCharge.Play();
            Invoke(nameof(StartParticleLate), 1);
        }
        else
        {
            bsm.anim.SetTrigger("StartMeteor");
        }
    }

    void StartParticleLate()
    {
        fireLineVFX.Play();
    }

    public override void UpdateState(Boss_StateMachine bsm)
    {
        bsm.agent.enabled = false;
        bsm.anim.SetBool("Chase", false);
        Debug.Log("Phase Attack 2 > The Attack Type is 1or2 =" + attackType);
        timer += Time.deltaTime * 1;

        if (attackType == 1)
        {
            //check for invuls
            //laser dodge pattern (easy - stay on ground)
            AttackFireLine(bsm);
        }
        else
        {
            //check for invuls
            //meteor fall dodge pattern (easy - stay on ground)
            AttackCycleMeteor(bsm);
        }

        lookAtPlayer = bsm.playerDirection.normalized;
        lookAtPlayer.y = 0;
        bsm.transform.rotation = Quaternion.RotateTowards(bsm.transform.rotation, Quaternion.LookRotation(lookAtPlayer), bossTurningSpeed * Time.deltaTime);

    }

    Vector3 newDir;
    void AttackFireLine(Boss_StateMachine bsm)
    {
        bsm.anim.SetBool("LoopFireline", true);
        if (timer >=1f)
        {
            bossTurningSpeed = 300;
            //shit vector issue just guna use look at for now.
            fireLineVFX.transform.LookAt(bsm.player.transform.position + (Vector3.up * 3));
            if (timer >= 7f)
            {
                bossTurningSpeed = 120;
                fireCharge.Stop();
                fireLineVFX.Stop();
                bsm.BossSwitchState(bsm.chaseState);
            }
            if(timer>6f)
            {
                bsm.anim.SetBool("LoopFireline", false);
            }
        }
    }

    void AttackCycleMeteor(Boss_StateMachine bsm)//should be using object pool in here...
    {
        bsm.anim.SetBool("LoopMeteor", true);
        if (timer >= 1f)
        {
            timer = 0;
            cycles++;
            Instantiate(meteorVFX, playerGroundPosition.position + (Vector3.up * 0.1f), Quaternion.identity);
            Invoke(nameof(MeteorTimed), 0.33f);
            Invoke(nameof(MeteorTimed), 0.66f);
            if (cycles > cycleInitialization - 1)
            {
                cycles = 0;
                bsm.BossSwitchState(bsm.chaseState);
            }
        }
    }

    Vector3 aroundPlayerVec;
    void MeteorTimed()
    {
        aroundPlayerVec =
            (playerGroundPosition.position + (Vector3.up * 0.1f))
            + (playerGroundPosition.forward * IntWithNegativeRNG(4,8))
            + (playerGroundPosition.right * IntWithNegativeRNG(4, 8));
        Instantiate(meteorVFX, aroundPlayerVec, Quaternion.identity);
    }

    int IntWithNegativeRNG(int start, int end)
    {
        if (Random.Range(1, 3) > 1)
        {
            return Random.Range(start, end + 1);
        }
        else
        {
            return Random.Range(-end, -start - 1);
        }
    }
}
