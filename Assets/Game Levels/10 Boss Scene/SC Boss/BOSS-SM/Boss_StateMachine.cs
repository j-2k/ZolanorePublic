using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Boss_StateMachine : MonoBehaviour
{
    public CharacterManager player;
    public NavMeshAgent agent;
    public int bossPhase;

    Boss_State currentState;
    public B_Awoken awokenState;// = new B_Awoken();
    public B_Chase chaseState;// = new B_Chase();
    public B_Attack1 attack1State;// = new B_Attack1();
    public B_Attack2 attack2State;// = new B_Attack2();
    public B_Death deathState;// = new B_Death();

    public Animator anim;

    public Vector3 playerDirection;


    private void Start()
    {
        bossPhase = 1;
        player = GameObject.FindGameObjectWithTag("Player").GetComponent<CharacterManager>();

        currentState = awokenState;

        currentState.StartState(this);
    }

    private void Update()
    {
        playerDirection = player.transform.position - transform.position;
        
        currentState.UpdateState(this);
    }

    public void BossSwitchState(Boss_State newState)
    {
        foreach (AnimatorControllerParameter parameter in anim.parameters)
        {
            anim.SetBool(parameter.name, false);
        }
        currentState = newState;
        newState.StartState(this);
    }
    
    public void DamageParticles()
    {
        attack1State.DelayOneShotDamage();
    }
}
