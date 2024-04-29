using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShootNode : Node<EnemyAgent>
{
    bool isShooting = false;
    bool readyToShoot = true;
    public override NodeState Evaluate(EnemyAgent owner)
    {
        if (owner.isShooting) return NodeState.RUNNING;
        else
        {
            Debug.Log("shoot");
            owner.anim.SetInteger("state", 2);
            owner.StartCoroutine(owner.shootRoutine());
            return NodeState.SUCCESS;
        }      
    }
}