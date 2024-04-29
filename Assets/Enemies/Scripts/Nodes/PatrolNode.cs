using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PatrolNode : Node<EnemyAgent>
{
    EnemyState playerState = EnemyState.Walk;
    public override NodeState Evaluate(EnemyAgent owner)
    {
        var distance = Vector3.Distance(owner.transform.position, owner.Waypoints[owner.index].position);
        if(playerState == EnemyState.Walk)
        {
            if (distance < 1.5f)
            {
                owner.speed = 0;
                playerState = EnemyState.PlayIdle;
                Debug.Log("ss");
                if (playerState == EnemyState.PlayIdle)
                {
                    owner.StartCoroutine(IdleAnimation(owner));
                }
            }
            else
            {
                owner.speed = owner.walkSpeed;
                owner.navmesh.stoppingDistance = 0;
                owner.anim.SetInteger("state", 1);
                owner.Move(owner.Waypoints[owner.index].position);
            }
        }
        return NodeState.SUCCESS;
    }

    IEnumerator IdleAnimation(EnemyAgent owner)
    {
        playerState = EnemyState.IdlePlaying;
        owner.anim.SetInteger("state", 0);
        yield return new WaitForSeconds(2);
        owner.index++; owner.index %= owner.Waypoints.Count;
        playerState = EnemyState.Walk;
        owner.StopAllCoroutines();
    }
    enum EnemyState
    {
        Walk,
        PlayIdle,
        IdlePlaying,
    }
}
