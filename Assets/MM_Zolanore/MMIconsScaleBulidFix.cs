using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MMIconsScaleBulidFix : MonoBehaviour
{
    [SerializeField] MM_Icon[] icons;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(LateIconScaleFix());
    }

    IEnumerator LateIconScaleFix()
    {
        yield return new WaitForEndOfFrame();
        icons = GetComponentsInChildren<MM_Icon>();
        yield return new WaitForEndOfFrame();
        for (int i = 0; i < icons.Length; i++)
        {
            icons[i].GetComponent<RectTransform>().localScale = new Vector3(4, 4, 4);
        }
    }
}
