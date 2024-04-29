using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LoaderCall : MonoBehaviour
{
    bool isFirstUpdate = true;

    // Update is called once per frame
    void Update()
    {
        if (isFirstUpdate)
        {
            isFirstUpdate = false;
            GameSceneLoader.LoadCallback();
        }
    }
}
