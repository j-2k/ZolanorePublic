using UnityEngine;
using Juma.CharacterStats;

public class StatPanel : MonoBehaviour
{

    [SerializeField] StatDisplay[] statDisplays;
    [SerializeField] string[] statNames;

    private CharacterStat[] stats;

    private void OnValidate()
    {
        statDisplays = GetComponentsInChildren<StatDisplay>();
        UpdateStatNames();
    }

    
    public void SetStats(params CharacterStat[] charStats)
    {
        stats = charStats;

        if (stats.Length > statDisplays.Length)
        {
            Debug.LogError("Too many stats, not enough displays ");
            return;
        }

        for (int i = 0; i < statDisplays.Length; i++)
        {
            statDisplays[i].gameObject.SetActive(i < stats.Length);

            if (i < stats.Length)
            {
                statDisplays[i].Stat = stats[i];
            }    
        }
    }
    
    //UIrefresh
    public void UpdateStatValue()
    {
        for (int i = 0; i < stats.Length; i++)
        {
            statDisplays[i].UpdateStatValue();
        }
    }

    public void ResetAllStatValue()
    {
        for (int i = 0; i < stats.Length; i++)
        {
            stats[i].BaseValue = 0;
        }
        UpdateStatValue();
    }

    public void UpdateStatNames()
    {
        for (int i = 0; i < statNames.Length; i++)
        {
            statDisplays[i].Name = statNames[i];
        }
    }    
}
