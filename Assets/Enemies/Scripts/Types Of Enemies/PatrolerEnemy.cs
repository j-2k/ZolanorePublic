using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PatrolerEnemy : EnemyAgent
{
    public override void BuildBehaviorTree()
    {
        Sequence<EnemyAgent> attackSequence = new Sequence<EnemyAgent>(
            new List<Node<EnemyAgent>>()
            {
                new DetectPlayerNode(),
                new Selector<EnemyAgent>(new List<Node<EnemyAgent>>(){ new PlayerCloseCheckNode(), new PlayerInSightCheckNode() }),
                new ChaseNode(),
                new AttackNode()
            });

        root = new Selector<EnemyAgent>(new List<Node<EnemyAgent>>()
            {
                attackSequence,
                new PatrolNode()
            });


    }
}