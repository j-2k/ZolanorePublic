using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdleNode : Node<EnemyAgent>
{
    public override NodeState Evaluate(EnemyAgent owner)
    {
        return NodeState.SUCCESS;
    }
}
