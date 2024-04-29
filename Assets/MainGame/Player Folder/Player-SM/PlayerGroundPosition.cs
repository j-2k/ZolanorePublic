using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerGroundPosition : MonoBehaviour
{
    [SerializeField] CharacterController cc;
    RaycastHit hit;
    [SerializeField] LayerMask environmentMask;
    [SerializeField] Transform playerNewFloorPos;

    void Update()
    {
        if (Physics.SphereCast(transform.position + Vector3.up,cc.radius,-transform.up, out hit, 5, environmentMask))
        {
            playerNewFloorPos.position = new Vector3(transform.position.x,hit.point.y,transform.position.z);
        }
        else
        {
            playerNewFloorPos.position = transform.position;
        }
    }
}
