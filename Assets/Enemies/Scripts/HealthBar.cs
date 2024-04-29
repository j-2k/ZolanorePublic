using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HealthBar : MonoBehaviour
{
    private Slider slider;

    public Image fill;
    public Gradient fillColor;

    private void Awake()
    {
        slider = GetComponent<Slider>();
    }

    public void SetMaxHealth(int health)
    {
        slider.maxValue = health;
        slider.value = health;

        fill.color = fillColor.Evaluate(1f);
    }
    public void SetHealth(int health)
    {
        slider.value = health;

        fill.color = fillColor.Evaluate(slider.normalizedValue);
    }
}
