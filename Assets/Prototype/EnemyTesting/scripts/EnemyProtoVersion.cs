using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class EnemyProtoVersion : MonoBehaviour
{
    [Header("Dummy attack script")]
    //[SerializeField] int health;
    NavMeshAgent agent;
    Transform player;
    [SerializeField] GameObject childTrigger;
    bool isAttacking;
    float timer;
    //int xp;
    //int enemyLevel;

    public uint hitID;

    LevelSystem levelSystem;
    // Start is called before the first frame update
    void Start()
    {
        //xp = 100;
        //enemyLevel = 1;
        //health = 20;
        levelSystem = LevelSystem.instance;
        timer = 0;
        //childTrigger = GetComponentInChildren<GameObject>();
        player = GameObject.FindGameObjectWithTag("Player").transform;
        agent = GetComponent<NavMeshAgent>();
    }
    bool oneRun;
    // Update is called once per frame
    void Update()
    {
        if (!isAttacking)
        {
            agent.SetDestination(player.position);

            if (Vector3.Distance(player.transform.position, transform.position) <= 3f)
            {
                isAttacking = true;
                oneRun = true;
            }
        }
        else
        {
            timer += Time.deltaTime;
            if (timer >= 1f)
            {
                if (oneRun)
                {
                    childTrigger.SetActive(true);
                    oneRun = false;
                }

                if (timer >= 3.5f)
                {
                    isAttacking = false;
                    childTrigger.SetActive(false);
                    timer = 0;
                }
            }
        }
    }

    /*
    public void TakeDamageFromPlayer(int incDmg)
    {
        health -= incDmg;
        if (health <= 0)
        {
            //SendXPToPlayer(xp);
            levelSystem.onXPGainedDelegate.Invoke(enemyLevel,xp);
            Destroy(gameObject);
        }
    }

    public void TakeDamageFromFamiliar(int incDmg)
    {
        health -= incDmg;
        if (health <= 0)
        {
            //SendXPToPlayer(xp);
            levelSystem.onXPGainedDelegate.Invoke(enemyLevel, xp);
            Destroy(gameObject);
        }
    }

    public void TakeDamageFromPlayerPrototype(int incDmg)
    {
        health -= incDmg;
        if (health <= 0)
        {
            Destroy(gameObject);
        }
    }

    /*
    void SendXPToPlayer(int xp)
    {
        Debug.Log("Giving Player " + xp);
        levelSystem.currentXP += xp;
    }
    */
}
