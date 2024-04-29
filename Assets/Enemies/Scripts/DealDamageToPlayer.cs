using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DealDamageToPlayer : MonoBehaviour
{
    [SerializeField] EnemyStatManager esm;
    CharacterManager player;

    void Start()
    {
        if (player == null)
        {
            player = GameObject.FindGameObjectWithTag("Player").GetComponent<CharacterManager>();
        }
    }

    public void DealDamage()
    {
        player.TakeDamageFromEnemy(esm.DamageCalculation());
        Debug.Log("Dealing Damage to player");
    }
}
