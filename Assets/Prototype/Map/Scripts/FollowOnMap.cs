using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FollowOnMap : MonoBehaviour
{
    public GameObject GO;
    void Update()
    {
        transform.position =  new Vector3(GO.transform.position.x,transform.position.y, GO.transform.position.z);
    }
}
