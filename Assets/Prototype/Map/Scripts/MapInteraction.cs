using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapInteraction : MonoBehaviour
{
    public GameObject map;
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.M))
        {
            ActivateOrDisactivateMap();
        }
    }
    void ActivateOrDisactivateMap()
    {
        if(map.activeSelf == true)
        {
            map.SetActive(false);
        }
        else map.SetActive(true);
    }
}

