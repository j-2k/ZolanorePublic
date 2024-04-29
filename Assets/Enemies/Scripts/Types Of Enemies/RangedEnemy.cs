using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RangedEnemy : EnemyAgent
{
    public override void BuildBehaviorTree()
    {
        Sequence<EnemyAgent> attackSequence = new Sequence<EnemyAgent>(
            new List<Node<EnemyAgent>>()
            {
                new DetectPlayerNode(),
                new Selector<EnemyAgent>(new List<Node<EnemyAgent>>(){ new PlayerCloseCheckNode(), new PlayerInSightCheckNode() }),
                new ShootNode(),
            });

        root = new Selector<EnemyAgent>(new List<Node<EnemyAgent>>()
            {
                attackSequence,
                new ReturnToPosNode()
            });
    }
}
