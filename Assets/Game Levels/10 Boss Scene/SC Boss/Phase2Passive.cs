using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Phase2Passive : MonoBehaviour
{
    [SerializeField] ParticleSystem thunderChase;
    [SerializeField] EGA_EffectSound thunderSound;
    [SerializeField] Boss_StateMachine bsm;
    [SerializeField] int thunderSpeed;
    Vector3 chaseVector;
    float timer = 8;

    private void Start()
    {
        transform.parent = null;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if (Vector3.Distance(thunderChase.transform.position, bsm.player.transform.position) <= 2)
        {
            
        }
        else
        {
            chaseVector = (bsm.player.transform.position - thunderChase.transform.position);
            thunderChase.transform.position += chaseVector.normalized * thunderSpeed * Time.deltaTime;
        }
    }

    private void Update()
    {
        timer += Time.deltaTime * 1;
        if (timer > 7)
        {
            timer = 0;
            thunderChase.Play();
            thunderSound.PlaySoundOnce();
        }
    }
}
