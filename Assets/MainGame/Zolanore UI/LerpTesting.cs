using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LerpTesting : MonoBehaviour
{
    [SerializeField] bool ui = true;
    [SerializeField] float maxUp = 1;
    [SerializeField] float maxDown = -1;
    float interpolater = 0; //0-1
    float up;
    RectTransform uiTransform;
    Vector3 upPos;
    Vector3 downPos;
    Vector3 upPosUI;
    Vector3 downPosUI;

    private void Start()
    {
        if (ui)
        {
            uiTransform = GetComponent<RectTransform>();
            upPosUI = new Vector2(uiTransform.anchoredPosition.x, uiTransform.anchoredPosition.y + maxUp);
            downPosUI = new Vector2(uiTransform.anchoredPosition.x, uiTransform.anchoredPosition.y + maxDown);
        }
        else
        {
            upPos = new Vector3(transform.position.x, transform.position.y + maxUp, transform.position.z);
            downPos = new Vector3(transform.position.x, transform.position.y + maxDown, transform.position.z);
        }
    }
    // Update is called once per frame
    void FixedUpdate()
    {
        if (ui)
        {
            uiTransform.anchoredPosition = Vector2.Lerp(upPosUI, downPosUI, interpolater);
        }
        else
        {
            transform.position = Vector3.Lerp(upPos, downPos, interpolater);
        }


        interpolater += 0.5f * Time.deltaTime;

        if (interpolater > 1)
        {
            if (ui)
            {
                Vector3 temp = upPosUI;
                upPosUI = downPosUI;
                downPosUI = temp;
                interpolater = 0;
            }
            else
            {
                Vector3 temp = upPos;
                upPos = downPos;
                downPos = temp;
                interpolater = 0;
            }
        }
    }
}
