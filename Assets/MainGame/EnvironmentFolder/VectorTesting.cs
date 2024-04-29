using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VectorTesting : MonoBehaviour
{
    [SerializeField] GameObject player;
    [SerializeField] float upAmount;
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        /*
        //transform.LookAt(player.transform.position);
        Vector3 dir = player.transform.position - transform.position;
        Debug.Log("dir xyz " + Mathf.Floor(dir.x) + "  "+ Mathf.Floor(dir.y) + "  " + Mathf.Floor(dir.z));
        //Debug.Log(Mathf.Floor(Vector3.Angle(dir, transform.forward)));

        Vector2 playerPos = new Vector2(player.transform.position.x, player.transform.position.y);
        Vector2 thisPos = new Vector2(transform.position.x, transform.position.y);

        Vector2 dir2D = playerPos - thisPos;
        Vector3 dir3D0 = player.transform.position - transform.position;
        dir3D0.x = 0;
        Debug.DrawRay(transform.position, dir3D0);
        Debug.Log(Mathf.Floor(Vector3.Angle(dir3D0, transform.forward)));
        //upAmount = Vector3.Angle(dir3D0, transform.forward);
        Debug.DrawRay(transform.position, transform.forward * 2, Color.blue);
        Debug.DrawRay(transform.position, dir.normalized * 2, Color.black);
        Debug.DrawRay(transform.position, (Vector3.up * dir.y), Color.green);
        Debug.DrawRay(transform.position, transform.forward * 1 + (Vector3.up * dir.y), Color.cyan);


        float angle = Mathf.MoveTowardsAngle(upAmount, Vector3.Angle(dir3D0, transform.forward), speed * Time.deltaTime);

        */

        Vector3 dir3D0 = player.transform.position - transform.position;
        //dir3D0.x = 0;

        Debug.DrawRay(transform.position, dir3D0);
        //Debug.Log(Mathf.Floor(Vector3.Angle(dir3D0, transform.forward)));
        //float turnAngle = (Vector3.Angle(dir3D0, transform.forward));
        //transform.eulerAngles = new Vector3(upAmount, transform.eulerAngles.y, transform.eulerAngles.z);

        float angle = Mathf.Atan2(dir3D0.y, dir3D0.z) * Mathf.Rad2Deg;

        Debug.Log(angle);
        Quaternion angleAxis = Quaternion.AngleAxis(-angle, Vector3.right);
        transform.rotation = Quaternion.Slerp(transform.rotation,angleAxis, Time.deltaTime * 50);

    }
}
