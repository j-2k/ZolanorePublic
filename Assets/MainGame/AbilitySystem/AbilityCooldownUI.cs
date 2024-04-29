using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class AbilityCooldownUI : MonoBehaviour
{
    AbilityManager abilityManager;
    Image image;
    [SerializeField] int indexAbility;

    // Start is called before the first frame update
    void Start()
    {
        abilityManager = AbilityManager.instance;
        image = GetComponent<Image>();
        image.fillAmount = 0;
    }
    bool cooldownOneRun = true;
    bool gcdOneRun = true;

    // Update is called once per frame
    void Update()
    {
        //idk this implemntation is disgusting and i hate looking at it and it worked im going to bed iv been awake for 16+ hours with 2 hours of sleep prior will fix this later if needed

        //WORLD OF WARCRAFT LIKE ABILITY BAR GCD IMPLEMENTATION
        if (abilityManager.allAbilities[indexAbility].abilityState == AbilityExecuter.AbilityState.cooldown)
        {
            if (cooldownOneRun)
            {
                image.fillAmount = 1;
                cooldownOneRun = false;
            }
            else
            {
                image.fillAmount -= 1 / abilityManager.allAbilities[indexAbility].cooldownTimeMax * Time.deltaTime;
            }
            
        }
        else if (abilityManager.allAbilities[indexAbility].abilityState == AbilityExecuter.AbilityState.gcd)
        {
            if (gcdOneRun)
            {
                image.fillAmount = 1;
                gcdOneRun = false;
            }
            image.fillAmount -= 1 / 3f * Time.deltaTime; //i wasted 2 hours because the denominator had to be a float kms proven with this line                 abilityManager.meleeAbilityExecs[indexAbility].gcdMax
        }
        else
        {
            image.fillAmount = 0;
            cooldownOneRun = true;
            gcdOneRun = true;
        }
    }
}
