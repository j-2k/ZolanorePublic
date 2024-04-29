using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CastNode : Node<EnemyAgent>
{
    bool castab = true;
    public override NodeState Evaluate(EnemyAgent owner)
    {
        var distance = Vector3.Distance(owner.transform.position, owner.player.transform.position);
        if (distance < owner.distanceToAttack)
        {
            if (castab)
            {
                owner.StartCoroutine(CastAbility());
            }
            return NodeState.RUNNING;
        }
        else 
        {
            return NodeState.FAILURE;
        }
    }  

    IEnumerator CastAbility()
    {
        castab = false;
        yield return new WaitForSeconds(2);
        int chance = Random.Range(1, 100);
        if(chance <= 20)
        {
            Debug.Log("AOE Damage");
        }
        else
        {
            Debug.Log("Single Damage");
        }
        castab = true;
    }
}