using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Juma.CharacterStats;

public class SkillPointSpend : MonoBehaviour
{
    LevelSystem levelSystem;
    CharacterManager character;

    // Start is called before the first frame update
    void Start()
    {

        levelSystem = LevelSystem.instance;
        character = GameObject.FindGameObjectWithTag("Player").GetComponent<CharacterManager>();

        if (levelSystem.skillPointsToSpend > 0)
        {
            gameObject.SetActive(true);
        }
        else
        {
            gameObject.SetActive(false);
        }
    }

    public void SpendSkillPointStrength()
    {
        if (levelSystem.skillPointsToSpend > 0)
        {
            levelSystem.skillPointsToSpend--;
            character.Strength.BaseValue++;
            character.UpdateStatSkillPoint();
        }

        if (levelSystem.skillPointsToSpend <= 0)
        {
            gameObject.SetActive(false);
        }
    }

    public void SpendSkillPointDexterity()
    {
        if (levelSystem.skillPointsToSpend > 0)
        {
            levelSystem.skillPointsToSpend--;
            character.Dexterity.BaseValue++;
            character.UpdateStatSkillPoint();
        }

        if (levelSystem.skillPointsToSpend <= 0)
        {
            gameObject.SetActive(false);
        }
    }

    public void SpendSkillPointIntelligence()
    {
        if (levelSystem.skillPointsToSpend > 0)
        {
            levelSystem.skillPointsToSpend--;
            character.Intelligence.BaseValue++;
            character.UpdateStatSkillPoint();
        }

        if (levelSystem.skillPointsToSpend <= 0)
        {
            gameObject.SetActive(false);
        }
    }

    public void SpendSkillPointDefence()
    {
        if (levelSystem.skillPointsToSpend > 0)
        {
            levelSystem.skillPointsToSpend--;
            character.Defence.BaseValue++;
            character.UpdateStatSkillPoint();
        }


        if (levelSystem.skillPointsToSpend <= 0)
        {
            gameObject.SetActive(false);
        }
    }


}
