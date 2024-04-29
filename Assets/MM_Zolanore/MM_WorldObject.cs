using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MM_WorldObject : MonoBehaviour
{
    [SerializeField] bool isPlayerObject = false;
    public bool isIconQuaternionIdentity = false;

    public Sprite icon;
    public Color col = Color.white;
    public string text;
    public int textSize = 10;
    public float scaleIcon = 15;

    public MM_Icon thisWorldObjectIcon;


    // Start is called before the first frame update
    void Start()
    {
        CreateMMWOIcon();
    }

    public void DestoryThisMMIcon()
    {
        MM.instance.DestroyCorrespondingMiniMapIcon(this);
    }

    public void CreateMMWOIcon()
    {
        if (thisWorldObjectIcon == null)
        {
            thisWorldObjectIcon = MM.instance.CreateMMWorldObject(this, isPlayerObject);
        }
    }
}
