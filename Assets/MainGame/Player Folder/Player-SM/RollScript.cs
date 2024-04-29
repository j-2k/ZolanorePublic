using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RollScript : StateMachineBehaviour
{
    PlayerManager player;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        if (player == null)
        {
            player = animator.gameObject.GetComponent<PlayerManager>();
        }
        animator.applyRootMotion = true;
        player.isRolling = true;
    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        animator.applyRootMotion = false;
        player.isRolling = false;
    }
}
