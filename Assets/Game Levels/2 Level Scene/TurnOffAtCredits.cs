using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TurnOffAtCredits : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(TurnOff());
    }

    IEnumerator TurnOff()
    {
        yield return new WaitForEndOfFrame();
        gameObject.SetActive(false);
    }
}
