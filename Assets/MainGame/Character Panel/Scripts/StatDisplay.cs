using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using Juma.CharacterStats;
using TMPro;

public class StatDisplay : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
    private CharacterStat _stat;

    public CharacterStat Stat
    {
        get
        {
            return _stat;
        }
        set
        {
            _stat = value;
            UpdateStatValue();

            if (isPointerOver)
            {
                OnPointerExit(null);
                OnPointerEnter(null);
            }
        }
    }

    private string _name;

    public string Name
    {
        get
        {
            return _name;
        }
        set
        {
            _name = value;
            nameText.text = _name.ToUpper();
        }
    }

    [SerializeField] TextMeshProUGUI nameText;
    [SerializeField] TextMeshProUGUI valueText;
    [SerializeField] StatTooltip tooltip;

    bool isPointerOver = true;

    private void OnValidate()
    {
        TextMeshProUGUI[] texts = GetComponentsInChildren<TextMeshProUGUI>();
        nameText = texts[0];
        valueText = texts[1];

        if (tooltip == null)
        {
            tooltip = FindObjectOfType<StatTooltip>();
        }
    }

    private void OnDisable()
    {
        if (isPointerOver)
        OnPointerExit(null);
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        isPointerOver = true;

        tooltip.ShowTooltip(Stat, Name);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        isPointerOver = false;

        tooltip.HideTooltip();
    }

    public void UpdateStatValue()
    {
        valueText.text = _stat.Value.ToString();
    }
}
