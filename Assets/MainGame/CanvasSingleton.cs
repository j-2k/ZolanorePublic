using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CanvasSingleton : MonoBehaviour
{
    public static CanvasSingleton instance;
    private void Awake()
    {
        if (instance != null)
        {
            Destroy(this.gameObject);
        }
        else
        {
            instance = this;
            DontDestroyOnLoad(this.gameObject);
        }
    }

}
