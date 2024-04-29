using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RockScript : MonoBehaviour
{
    DealDamageToPlayer dd;
    void Start()
    {
        dd = GetComponentInParent<DealDamageToPlayer>();
        transform.parent = null;
        Destroy(gameObject, 4);
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.tag == "Player")
        {
                dd.DealDamage();
                Destroy(gameObject);
        }
    }
}