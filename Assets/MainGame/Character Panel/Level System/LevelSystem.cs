using System;
using TMPro;
using UnityEngine;

public class LevelSystem : MonoBehaviour
{
    //https://docs.google.com/spreadsheets/d/19eI5ft2jUsELaEdoNECQKZm7XY9agH4JqVokp11H8Oc/edit#gid=583637899
    //LEVELING DOCUMENT DO NOT CHANGE ABS ANY VALUES IN HERE UNLESS TOLD TO THIS SCRIPT IS A REFERENCE TO THE DOCUMENT

    #region Singleton LevelSystem Instance
    public static LevelSystem instance;
    [SerializeField] bool creditObject;

    void Awake()
    {
        if (!creditObject)
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
    }
    #endregion

    public delegate void OnXPGained(int enemyLevel, int xp);
    public OnXPGained onXPGainedDelegate;

    public Action levelUpAction;

    public int currentLevel;
    public int currentXP;
    [SerializeField] int targetXP;

    int skillPointsTotal;
    public int skillPointsToSpend;

    private int skillPointsGainedPerLevel = 2;

    [SerializeField] SkillPointSpend skillPointSpend;
    [SerializeField] TextMeshProUGUI playerLevelUI;
    [SerializeField] TextMeshProUGUI playerLevelTL;

    CharacterManager character;

    [SerializeField] ParticleSystem levelUpVFX;

    // Start is called before the first frame update
    void Start()
    {
        levelUpVFX.gameObject.SetActive(true);
        playerLevelUI.text = currentLevel.ToString();
        playerLevelTL.text = currentLevel.ToString();
        character = GetComponentInParent<CharacterManager>();
        currentXP = 0;//save curr xp
        targetXP = Mathf.RoundToInt(Mathf.Pow(1 + currentLevel, 2.5f) * (currentLevel + 100)) / 16 + 100;
        skillPointsTotal = currentLevel * skillPointsGainedPerLevel;
        onXPGainedDelegate += XPGainedFunction;
        levelUpAction += LevelUp;
        levelUpAction += LevelSkillPoint;
        levelUpAction += CheckSkillPoints;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Backspace))
        {
            ResetAllSkillPoints();
        }

    }

    
    void XPGainedFunction(int incEnemyLevel,int incXP)
    {
        Debug.Log("An Enemy of Level of " + incEnemyLevel + " Died. It Dropped " + incXP + "XP! Now we will add XP based on ur level which is level " + currentLevel);

        float j = 1;
        float maxIterations = 6;
        //ENEMY LEVEL 5 CURRENT LEVEL 10 //i = 0. 5 = 10 X //i=1. 6 = 10 X // i=2. 7 = 10X// i=3. 8 =10X// i=4. 9=10X//   i = 5. 10 = 10 YES
        for (int i = 0; i < 6; i++)
        {     //5                   5 + 0  100% full xp | 5 = 6 + 0 no | 5 = 6 - 1 yes 90% of all | 5 = 7 - 2 yes 80% after j change it will be 90
            if (incEnemyLevel == currentLevel + i || incEnemyLevel == currentLevel - i || i == maxIterations - 1)
            {
                float newXP = incXP * j;
                newXP = Mathf.RoundToInt(newXP);
                currentXP += (int)newXP;

                while (currentXP >= targetXP)
                {
                    levelUpAction.Invoke();
                }

                Debug.Log(" new xp =" + newXP + " enemylvl is = " + incEnemyLevel + " currlevel is " + currentLevel);
                return;
            }
            //maybe be nicer here & dont penalize for first iterator / if lvl diff is +1/-1
            if (i >= 2)
            {
                j -= 0.15f;
            }
        }
    }

    private void LevelUp()
    {
        levelUpVFX.Play();
        currentXP = currentXP - targetXP;
        currentLevel++;
        playerLevelUI.text = currentLevel.ToString();
        playerLevelTL.text = currentLevel.ToString();
        targetXP = Mathf.RoundToInt((Mathf.Pow(1 + currentLevel,2.5f) * (currentLevel + 100)/16) + 100);
    } 

    void LevelSkillPoint()
    {
        skillPointsTotal = currentLevel * skillPointsGainedPerLevel;
        skillPointsToSpend += 2;
        CheckSkillPoints();
    }

    public void CheckSkillPoints()
    {
        if (skillPointsToSpend > 0)
        {
            skillPointSpend.gameObject.SetActive(true);
        }
        else
        {
            skillPointSpend.gameObject.SetActive(false);
        }
    }

    public void ResetAllSkillPoints()
    {
        skillPointsToSpend = skillPointsTotal - 2;

        character.Strength.BaseValue = 1;
        character.Dexterity.BaseValue = 1;
        character.Intelligence.BaseValue = 1;
        character.Defence.BaseValue = 1;

        character.UpdateStatSkillPoint();

        if (skillPointsToSpend > 0)
        {
            skillPointSpend.gameObject.SetActive(true);
        }
        else
        {
            skillPointSpend.gameObject.SetActive(false);
        }
    }
}
