using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OneshotMeteor : MonoBehaviour
{
    [SerializeField] int bonusDamage;
    CharacterManager cm;
    EnemyStatManager esm;

    private void Start()
    {
        esm = GameObject.FindGameObjectWithTag("Boss").GetComponent<EnemyStatManager>();
        Destroy(this, 5);
        Invoke(nameof(ApexOfVFX), 2.7f);
    }

    Collider[] playerColl;

    public void ApexOfVFX()
    {
        playerColl = Physics.OverlapSphere(transform.position, 4, 1 << 9);
        foreach (Collider coll in playerColl)
        {
            if (coll.tag == "Player")
            {
                cm = coll.GetComponent<CharacterManager>();
                cm.TakeDamageFromEnemy(esm.DamageCalculation() + bonusDamage);
            }
        }
    }
}
