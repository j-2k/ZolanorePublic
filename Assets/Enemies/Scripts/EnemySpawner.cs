using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpawner : MonoBehaviour
{
    public GameObject enemy;
    public float radius;
    public int numberOfEnemies;
    void Start()
    {
        SpawnEnemies();
    }

    void SpawnEnemies()
    {
        for (int i = 0; i < numberOfEnemies; i++)
        {
            Vector2 spawnCircle = Random.insideUnitCircle * radius;
            Vector3 spawnPos = this.transform.position + new Vector3(spawnCircle.x, 0f, spawnCircle.y);
            GameObject tempEnemy = Instantiate(enemy, spawnPos, Quaternion.identity);
        }      
    }
}