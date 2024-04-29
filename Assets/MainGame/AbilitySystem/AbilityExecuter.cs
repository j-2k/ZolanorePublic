using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AbilityExecuter : MonoBehaviour
{
    public Ability ability;
    GameObject player;
    GameObject gameManagerObj;
    [SerializeField] int IndexOfExecuter;
    public float cooldownTime;
    public float cooldownTimeMax;
    public float activeTime;
    float gcd = 3;

    AbilityManager abilityManager;
    public CombatType abilityType;

    public enum AbilityState
    {
        ready,
        active,
        cooldown,
        gcd
    }

    public AbilityState abilityState = AbilityState.ready;

    [SerializeField] KeyCode abilityKey;



    // Start is called before the first frame update
    void Start()
    {
        abilityManager = AbilityManager.instance;
        player = GameObject.FindGameObjectWithTag("Player");
        gameManagerObj = this.gameObject;
        cooldownTime = ability.cooldownTime;
        cooldownTimeMax = cooldownTime;

        ability.CacheStart(player, gameManagerObj);

        if (ability.combatType == CombatType.Melee)
        {
            abilityType = CombatType.Melee;
            return;
        }
        else if (ability.combatType == CombatType.Ranged)
        {
            abilityType = CombatType.Ranged;
            return;
        }
        else if (ability.combatType == CombatType.Magic)
        {
            abilityType = CombatType.Magic;
            return;
        }
        else if (ability.combatType == CombatType.Familiar)
        {
            abilityType = CombatType.Familiar;
            return;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (!IngameMenu.gameIsPaused && !CharacterManager.isDead)
        {
            switch (abilityState)
            {
                case AbilityState.ready:
                    if (Input.GetKeyDown(abilityKey))
                    {
                        ability.OnActivate(player);
                        abilityState = AbilityState.active;
                        activeTime = ability.activeTime;
                        abilityManager.Activated(this, abilityType);
                    }
                    break;
                case AbilityState.active:
                    ability.AbilityUpdateActive(player);
                    if (activeTime > 0)
                    {
                        //if bypass is true we dont cancel
                        //if bypass is false  && cancel is true cancel ability

                        if (ability.singleTrigger)//!ability.bypassCancel && cancelTrigger ||    //will make buff work with spin aoe example & will initiate cooldown for singletrigger if completed
                        {
                            SendToCooldown();
                        }

                        activeTime -= Time.deltaTime;
                    }
                    else
                    {
                        SendToCooldown();
                    }
                    break;
                case AbilityState.cooldown:
                    ability.AbilityUpdateCooldown(player);
                    if (cooldownTime > 0)
                    {
                        cooldownTime -= Time.deltaTime;
                    }
                    else
                    {
                        abilityState = AbilityState.ready;
                        cooldownTime = 0;
                    }
                    break;
                case AbilityState.gcd:
                    ability.AbilityUpdateCooldown(player);
                    if (gcd > 0)
                    {
                        gcd -= Time.deltaTime;
                    }
                    else
                    {
                        abilityState = AbilityState.ready;
                        gcd = 3;
                    }
                    break;
                default:
                    break;
            }
        }
    }

    public void SendToCooldown()
    {
        ability.OnBeginCoolDown(player);
        abilityState = AbilityState.cooldown;
        cooldownTime = ability.cooldownTime;
    }

}
