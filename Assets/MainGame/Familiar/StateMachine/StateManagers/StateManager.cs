using System.Collections;
using System.Collections.Generic;
using UnityEngine;
/* USAGE IN A LEAFE NODE REMEBER TO INHERIT FROM STATE

//[SerializeField] AttackState attackState;

private void Start()
{
    cache here whatever you need;
}

public override State runCurrentState()
{
    if (this.pos & enemy pos < 3)
    {
        return attackState;
    }
    else
    {
        Debug.Log("chase enemy or follow player hwatever");
        return this;
    }
}
*/
public class StateManager : MonoBehaviour
{
    [SerializeField] State currentState;

    private void Start()
    {
        currentState = GetComponentInChildren<FamiliarFollowState>();
    }

    // Update is called once per frame
    void Update()
    {
        RunStateMachine();
    }

    private void RunStateMachine()
    {
        //? = if var is null dont run  if !null run
        State nextState = currentState?.runCurrentState();

        if (nextState != null)
        {
            SwitchNextState(nextState);
        }
    }

    private void SwitchNextState(State nextState)
    {
        currentState = nextState;
    }
}
