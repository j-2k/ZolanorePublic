using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReturnToPosNode : Node<EnemyAgent>
{
    public override NodeState Evaluate(EnemyAgent owner)
    {
        var distance = Vector3.Distance(owner.transform.position, owner.initialPos);
        if (distance < 1f)
        {
            owner.transform.position = owner.initialPos;
            owner.transform.rotation = owner.initialRot;

            if (owner.isShooting)
            {
            }
            else
            {
                owner.anim.SetInteger("state", 0);
            }
            return NodeState.SUCCESS;
        }
        else
        {
            owner.navmesh.stoppingDistance = 0;
            owner.anim.SetInteger("state", 1);
            owner.speed = owner.walkSpeed;
            owner.Move(owner.initialPos);
            return NodeState.RUNNING;
        }
    }
}