using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInSightCheckNode : Node<EnemyAgent>
{
    private RaycastHit hit;
    Vector3 offset = new Vector3(0, 1.5f, 0);
    public override NodeState Evaluate(EnemyAgent owner)
    {
        Vector3 sensorStartPos = owner.transform.position + offset;
        Vector3 playerDirection = owner.player.transform.position + offset - sensorStartPos;
        if (Physics.Raycast(sensorStartPos, playerDirection, out hit, owner.visionRange))
        {
            if (hit.collider.tag == "Player")
            {
                owner.playerDetected = true;
                return NodeState.SUCCESS;
            }
            else
            {
                owner.playerDetected = false;
            }
        }
        return NodeState.FAILURE;
    }

}
