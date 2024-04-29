using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Abilities/FamiliarAbility")]
public class FamiliarAbility : Ability
{
    PlayerFamiliar playerFamiliar;
    StateManager stateManager;
    public override void CacheStart(GameObject parent, GameObject gameManagerObj)
    {
        //combatType = CombatType.Familiar;
        combatType = CombatType.Melee;
        playerFamiliar = GameObject.FindGameObjectWithTag("Familiar").GetComponent<PlayerFamiliar>();
        stateManager = playerFamiliar.gameObject.GetComponent<StateManager>();
    }

    public override void OnActivate(GameObject parent)
    {
        playerFamiliar.callFamiliarBack = true;
        playerFamiliar.isEnemyHit = false;
        playerFamiliar.abilityTrigger = true;
        playerFamiliar.agentFamiliar.speed = 7.5f;
    }

    bool once = true;

    public override void AbilityUpdateActive(GameObject parent)
    {
        if (once)
        {
            playerFamiliar.callFamiliarBack = false;
            once = false;
        }

        if (!playerFamiliar.abilityTrigger)
        {
            singleTrigger = true;
        }

        Debug.Log("FAMILIAR ABILITY ACTIVE");
    }

    public override void OnBeginCoolDown(GameObject parent)
    {
        playerFamiliar.agentFamiliar.speed = 5;
        playerFamiliar.abilityTrigger = false;
        singleTrigger = false;
        once = true;
    }

    public override void AbilityUpdateCooldown(GameObject parent)
    {

    }
}
