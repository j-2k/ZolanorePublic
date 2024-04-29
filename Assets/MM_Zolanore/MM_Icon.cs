using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class MM_Icon : MonoBehaviour
{

    public Image image;
    public TextMeshProUGUI text;
    public RectTransform rectTransform;
    public RectTransform iconRectTransform;

    public void SetIcon(Sprite iconSprite) => image.sprite = iconSprite;

    public void SetIconScale(float iconScale)
    {
        iconRectTransform.sizeDelta = new Vector2(iconScale, iconScale);
        rectTransform.sizeDelta = new Vector2(iconScale, iconScale);
        text.GetComponent<RectTransform>().sizeDelta = new Vector2(iconScale, iconScale);
    }



    public void SetColor(Color color) => image.color = color;

    public void SetText(string incText)
    {
        if (!string.IsNullOrEmpty(incText))
        {
            text.text = incText;
        }
    }

    public void SetTextSize(int size) => text.fontSize = size;
}
