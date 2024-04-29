using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MenuPetMovement : MonoBehaviour
{
    public GameObject target;

    void FixedUpdate()
    {
        // Spin the object around the target at 20 degrees/second.
        transform.RotateAround(target.transform.position, Vector3.up, 20 * Time.deltaTime);
    }
}
