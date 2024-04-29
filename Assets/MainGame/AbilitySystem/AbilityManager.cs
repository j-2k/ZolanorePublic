using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AbilityManager : MonoBehaviour
{
    #region Singleton LevelSystem Instance
    public static AbilityManager instance;
    private void Awake()
    {
        if (instance != null)
        {
            Destroy(this.gameObject);
        }
        else
        {
            instance = this;
            DontDestroyOnLoad(this.gameObject);
        }
    }
    #endregion

    //change ability styles here i think

    public AbilityExecuter[] allAbilities;

    /*
    public List<AbilityExecuter> meleeAbilityExecs;

    public List<AbilityExecuter> rangedAbilityExecs;

    public List<AbilityExecuter> magicAbilityExecs;

    public List<AbilityExecuter> familiarAbilityExecs;
    */

    public CombatType currentCombatStyle;

    private void Start()
    {
        currentCombatStyle = CombatType.Melee;
        for (int i = 0; i < allAbilities.Length; i++)
        {
            if (allAbilities[i].abilityType != currentCombatStyle)
            {
                allAbilities[i].enabled = false;
            }
        }

        allAbilities = GetComponents<AbilityExecuter>();   //universal abilites maybe

        /*
        for (int i = 0; i < allAbilities.Length; i++)
        {
            if (allAbilities[i].abilityType == CombatType.Melee)
            {
                meleeAbilityExecs.Add(allAbilities[i]);
            }
            else if (allAbilities[i].abilityType == CombatType.Ranged)
            {
                rangedAbilityExecs.Add(allAbilities[i]);
            }
            else if(allAbilities[i].abilityType == CombatType.Magic)
            {
                magicAbilityExecs.Add(allAbilities[i]);
            }
            else if(allAbilities[i].abilityType == CombatType.Familiar)
            {
                familiarAbilityExecs.Add(allAbilities[i]);
            }
        }
        */
    }

    private void Update()
    {
        /*
        if (Input.GetKeyDown(KeyCode.Q))
        {
            currentCombatStyle++;

            if((int)currentCombatStyle > 3)
            {
                currentCombatStyle = 0;
            }

            
            for (int i = 0; i < allAbilities.Length; i++)
            {
                if (allAbilities[i].abilityType == currentCombatStyle)
                {
                    allAbilities[i].enabled = true;
                }
                else
                {
                    allAbilities[i].enabled = false;
                }
            }
        }
        */
    }

    public void Activated(AbilityExecuter executer, CombatType type)
    {
        /*
        if (currentCombatStyle == CombatType.Melee)
        {
            CombatStyleHandler(executer, meleeAbilityExecs);
        }
        else if (currentCombatStyle == CombatType.Ranged)
        {
            CombatStyleHandler(executer, rangedAbilityExecs);
        }
        else if (currentCombatStyle == CombatType.Magic)
        {
            CombatStyleHandler(executer, magicAbilityExecs);
        }
        else if (currentCombatStyle == CombatType.Familiar)
        {
            CombatStyleHandler(executer, familiarAbilityExecs);
        }
        */
        
        for (int i = 0; i < allAbilities.Length; i++)
        {
            //FIRST SEND ALL ABILITIES ON CD TO BE ON GCD IF THEY ARE LOWER THAN GCD VALUE
            if (allAbilities[i].abilityState == AbilityExecuter.AbilityState.cooldown && allAbilities[i].cooldownTime <= 3)
            {
                allAbilities[i].abilityState = allAbilities[i].abilityState = AbilityExecuter.AbilityState.gcd;
            }

            //SECONDLY CANCEL ANY ABILITIES THAT DONT HAVE A BYPASS DURING AN ACTIVE ABILITY | EG. IF AOE ON THEN BUFF ON SHOULD NOT CANCEL AOE | EG IF AOE IS ON AND DASH IS TRUE AOE SHOULD TURN OFF & DASH
            if (allAbilities[i].abilityState == AbilityExecuter.AbilityState.active && allAbilities[i] != executer)
            {
                if (!allAbilities[i].ability.bypassCancel && !executer.ability.bypassCancel)  //finally found solution lmao
                {
                    Debug.Log("cooling down");
                    allAbilities[i].SendToCooldown();
                }
            }
        }
        
    }

    public void StopAbilities()
    {
        for (int i = 0; i < allAbilities.Length; i++)
        {
            allAbilities[i].activeTime = 0;
        }
    }

    /*
    void CombatStyleHandler(AbilityExecuter executer, List<AbilityExecuter> currentCombatStyle)
    {
        for (int i = 0; i < currentCombatStyle.Count; i++)
        {
            //FIRST SEND ALL ABILITIES ON CD TO BE ON GCD IF THEY ARE LOWER THAN GCD VALUE
            if (currentCombatStyle[i].abilityState == AbilityExecuter.AbilityState.cooldown && currentCombatStyle[i].cooldownTime <= 3)
            {
                currentCombatStyle[i].abilityState = currentCombatStyle[i].abilityState = AbilityExecuter.AbilityState.gcd;
            }

            //SECONDLY CANCEL ANY ABILITIES THAT DONT HAVE A BYPASS DURING AN ACTIVE ABILITY | EG. IF AOE ON THEN BUFF ON SHOULD NOT CANCEL AOE | EG IF AOE IS ON AND DASH IS TRUE AOE SHOULD TURN OFF & DASH
            if (currentCombatStyle[i].abilityState == AbilityExecuter.AbilityState.active && currentCombatStyle[i] != executer)
            {
                if (!currentCombatStyle[i].ability.bypassCancel && !executer.ability.bypassCancel)  //finally found solution lmao
                {
                    Debug.Log("cooling down");
                    currentCombatStyle[i].SendToCooldown();
                }
            }
        }
    }
    */
}
