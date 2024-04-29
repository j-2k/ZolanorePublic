using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OneshotDMGPFX : MonoBehaviour
{
    [SerializeField] int bonusDamage;
    [SerializeField] EnemyStatManager esm;
    CharacterManager cm;
    [SerializeField] float sphereRadius;
    [SerializeField] LayerMask playerMask;

    // Start is called before the first frame update
    void Start()
    {
        cm = GameObject.FindGameObjectWithTag("Player").GetComponent<CharacterManager>();
    }

    Collider[] playerColl;

    public void ApexOfVFX()
    {
        Debug.Log("CALLING APEX OF VFX");
        playerColl = Physics.OverlapSphere(transform.position, sphereRadius, playerMask);
        foreach (Collider coll in playerColl)
        {
            if (coll.tag == "Player")
            {
                cm.TakeDamageFromEnemy(esm.DamageCalculation() + bonusDamage);
            }
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(transform.position, sphereRadius);
    }
}
