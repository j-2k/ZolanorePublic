using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class WanderNode : Node<EnemyAgent>
{
    public override NodeState Evaluate(EnemyAgent owner)
    {
        Vector3 finalPosition = Vector3.zero;
        Vector3 randomPos = Random.insideUnitSphere * owner.walkRadius;
        owner.speed = owner.wanderSpeed;
        randomPos += owner.transform.position;
        if(NavMesh.SamplePosition(randomPos, out NavMeshHit hit, owner.walkRadius, 1))
        {
            finalPosition = hit.position;
        }
        owner.Move(finalPosition);
        return NodeState.SUCCESS;
    }
}
