using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BossTornado : MonoBehaviour
{
    [SerializeField] CharacterManager cm;
    Vector3 playerXZ;
    ParticleSystem ps;
    float timer = 0;
    [SerializeField] float speed;

    // Start is called before the first frame update
    void Start()
    {
        cm = GameObject.FindGameObjectWithTag("Player").GetComponent<CharacterManager>();
        playerXZ = new Vector3(cm.transform.position.x, transform.position.y, cm.transform.position.z);
        transform.LookAt(playerXZ);
        ps = GetComponent<ParticleSystem>();
        Destroy(gameObject, 10);
    }

    bool oneRun = false;
    // Update is called once per frame
    void Update()
    {
        timer += Time.deltaTime;
        transform.position += (transform.forward * speed * Time.deltaTime);

        if (timer >= 3 && !oneRun)
        {
            oneRun = true;
            playerXZ = new Vector3(cm.transform.position.x, transform.position.y, cm.transform.position.z);
            transform.LookAt(playerXZ);
        }

        if (timer >= 7)
        {
            ps.Stop();
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player" && timer < 8)
        {
            cm.TakeDamageFromEnemy(15);
        }
    }
}
