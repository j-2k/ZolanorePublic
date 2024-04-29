using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class B_Awoken : Boss_State
{
    [SerializeField] Phase2Passive startThunderPassive;
    [SerializeField] Transform center;
    [SerializeField] Transform[] waypoints;
    [SerializeField] int randWP;
    [SerializeField] float speed = 5;
    Vector3 movementVec,player;
    [SerializeField] float timer;
    [SerializeField] int end;

    [SerializeField] GameObject portalObj;

    [SerializeField] ParticleSystem awokenTornado;
    [SerializeField] ParticleSystem selfTornado;

    //>>>CHASE VARS>>>

    [SerializeField] float radius;
    [SerializeField] LayerMask environmentLayer;

    public override void BossOnCollisionEnter(Boss_StateMachine bsm, Collider collider)
    {
        //throw new System.NotImplementedException();
    }

    public override void StartState(Boss_StateMachine bsm)
    {
        portalObj.SetActive(false);
        if (!BGM.instance.isBossFight)
        {
            BGM.instance.isBossFight = true;
            BGM.instance.currentBGM.Play();
        }
        selfTornado.Play();
        speed = 30;
        increment = 0;
        bsm.anim.SetBool("Awoken", true);
        bsm.agent.enabled = false;
        timer = 0;
        radius = bsm.agent.radius * 0.9f;
        end = Random.Range(10, 15);
        if (bsm.bossPhase == 1)
        {
            bsm.transform.position = center.transform.position;
            randWP = Random.Range(0, waypoints.Length);
            movementVec = new Vector3(waypoints[randWP].position.x, 0, waypoints[randWP].position.z);
        }
        else
        {
            movementVec = center.transform.position - bsm.transform.position;
        }
    }

    public override void UpdateState(Boss_StateMachine bsm)
    {
        if (bsm.bossPhase == 1)
        {
            timer += Time.deltaTime * 1;
            if (timer > end)
            {
                MiddlePhaseChange(bsm);
            }
            else
            {
                AwokenActive(bsm);
            }
        }
        else
        {
            if (timer < end)
            {
                WakePhase2(bsm);
            }
            else
            {
                MiddlePhaseChange(bsm);
            }
        }

        player = new Vector3(bsm.player.transform.position.x, bsm.transform.position.y, bsm.player.transform.position.z);
        bsm.transform.LookAt(player);
    }

    float increment = 0;
    void ShootTornados(Boss_StateMachine bsm)
    {
        if (timer >= 2 + increment)
        {
            increment += 2;
            Instantiate(awokenTornado, bsm.transform.position - (Vector3.up * 17), Quaternion.identity);
        }
    }

    bool isGrounded;
    int state = 0;
    void MiddlePhaseChange(Boss_StateMachine bsm)
    {
        if (state == 0)
        {
            if (Vector3.Distance(bsm.transform.position, center.transform.position) <= 1)
            {
                state++;
            }
            else
            {
                movementVec = center.transform.position - bsm.transform.position;
                movementVec.y = 0;
                bsm.transform.position += movementVec.normalized * (speed / 4) * Time.deltaTime;
            }
        }
        else
        {
            selfTornado.Stop();
            bsm.transform.position += Vector3.down * (speed / 4) * Time.deltaTime;
            isGrounded = Physics.CheckSphere(bsm.transform.position, radius, environmentLayer);
            if (isGrounded)
            {
                bsm.agent.enabled = true;
                bsm.anim.SetBool("Awoken", false);
                bsm.BossSwitchState(bsm.chaseState);
            }
        }
    }

    void AwokenActive(Boss_StateMachine bsm)
    {
        WaypointDistanceCheck(bsm.transform);
        bsm.transform.position += movementVec.normalized * speed * Time.deltaTime;
        Debug.DrawRay(bsm.transform.position, movementVec);
        Debug.Log("Awoken State");
        ShootTornados(bsm);
    }

    void WaypointDistanceCheck(Transform bsm)
    {
        if (Vector3.Distance(bsm.transform.position, waypoints[randWP].position) <= 2)
        {
            randWP = Random.Range(0, waypoints.Length);
        }
        else
        {
            movementVec = waypoints[randWP].position - bsm.transform.position;
            movementVec.y = 0;
        }
    }

    void WakePhase2(Boss_StateMachine bsm)
    {
        if (Vector3.Distance(bsm.transform.position, center.transform.position) <= 1)
        {
            timer += Time.deltaTime * 1;
            //survival during phase 2 start thunder & tornados
            startThunderPassive.gameObject.SetActive(true);
            //DO TORNADOS HERE
            ShootTornados(bsm);
        }
        else
        {
            bsm.transform.position += movementVec.normalized * (speed/3) * Time.deltaTime;
        }
    }
}
