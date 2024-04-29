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
public abstract class State : MonoBehaviour
{
    public abstract State runCurrentState();
}
