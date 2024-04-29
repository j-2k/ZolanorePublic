using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyHitBoxPrototype : MonoBehaviour
{
    EnemyStatManager dmg;
    CharacterManager player;

    // Start is called before the first frame update
    void Start()
    {
        dmg = GetComponentInParent<EnemyStatManager>();
        if (player == null)
        {
            player = GameObject.FindGameObjectWithTag("Player").GetComponent<CharacterManager>();
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.transform.tag == "Player")
        {
            Debug.Log("Enemy Hit Player Successfully");
            player.TakeDamageFromEnemy(dmg.DamageCalculation());
            gameObject.SetActive(false);
        }
    }
}
