using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Boss_State : MonoBehaviour
{
    public abstract void StartState(Boss_StateMachine bsm);

    public abstract void UpdateState(Boss_StateMachine bsm);

    public abstract void BossOnCollisionEnter(Boss_StateMachine bsm, Collider collider);
}
