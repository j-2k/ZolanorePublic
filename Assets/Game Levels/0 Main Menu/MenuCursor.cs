using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MenuCursor : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(LateCursorStart());
    }

    IEnumerator LateCursorStart()
    {
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
        yield return new WaitForEndOfFrame();
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
    }
}
