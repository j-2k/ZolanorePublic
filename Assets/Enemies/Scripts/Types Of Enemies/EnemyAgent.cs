using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class EnemyAgent : MonoBehaviour
{
    [HideInInspector] public GameObject player;
    [HideInInspector] public int index;
    [HideInInspector] public float speed;
    [HideInInspector] public bool playerDetected = false;
    [HideInInspector] public bool isShooting = false;
    [HideInInspector] public bool Shot = false;
    [HideInInspector] public Vector3 initialPos;
    [HideInInspector] public Quaternion initialRot;
    [HideInInspector] public Animator anim;

    [Header("Movement")]
    public List<Transform> Waypoints;
    public float walkSpeed;
    public float chaseSpeed;
    public float stoppingDistance;

    [Header("Wander")]
    public float walkRadius;
    public float wanderSpeed;

    [Header("Distance Check")]
    public float distanceToDetect;      // Distance to start Checking for player
    public float proximityDistance;     // Distance to detech player without vision
    public float distanceToAttack;      // Distance to switch to attack behavior
    public float visionRange;           // Distance to see player

    [Header("Shooting")]
    public Transform shootPos;
    public GameObject bullet;
    public float bulletSpeed, fireRate;

    [HideInInspector] public NavMeshAgent navmesh;
    public Selector<EnemyAgent> root;

    private void Awake()
    {
        player = GameObject.FindGameObjectWithTag("Player");
        navmesh = GetComponent<NavMeshAgent>();
        anim = GetComponent<Animator>();
    }

    private void Start()
    {
        initialPos = transform.position;
        initialRot = transform.rotation;
        BuildBehaviorTree();
    }

    private void Update()
    {
        if (playerDetected)
        {
            transform.LookAt(player.transform.position);
            transform.eulerAngles = new Vector3(0, transform.eulerAngles.y, 0);
        }

        navmesh.speed = speed;
        root.Evaluate(this);
    }

    public virtual void BuildBehaviorTree()
    {

    }

    public void Move(Vector3 destination)
    {
        navmesh.destination = destination;
        transform.LookAt(destination);
    }

    public void Patrol(Vector3 destination)
    {
        navmesh.speed = 0;
        if (navmesh.speed < speed)
        {
            navmesh.speed += Time.deltaTime * 2;
        }
        else
        {
            navmesh.speed = speed;
        }
        navmesh.destination = destination;
    }
    public IEnumerator shootRoutine()
    {
        if (isShooting) yield break;
        isShooting = true;
        yield return new WaitForSeconds(1.5f);
        if (Shot == false)
        {
            GameObject tempBullet = Instantiate(bullet, shootPos.position, Quaternion.identity,transform);
            Rigidbody bulletRB = tempBullet.GetComponent<Rigidbody>();
            Vector3 targetDir = (player.transform.position - transform.position).normalized;
            bulletRB.AddForce(targetDir * bulletSpeed, ForceMode.Impulse);
            Shot = true;
        }
        yield return new WaitForSeconds(1f);
        anim.SetInteger("state", 0);
        yield return new WaitForSeconds(fireRate - 1);
        Shot = false;
        isShooting = false;
        StopAllCoroutines();
    }
}
