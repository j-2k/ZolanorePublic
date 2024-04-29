using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwordVFX : MonoBehaviour
{
    [SerializeField] ParticleSystem swordTrailGlow;
    [SerializeField] PlayerManager pm;
    bool runningVFX = false;

    private void Start()
    {
        if (pm == null)
        {
            pm = PlayerManager.instance;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (pm.GetIsAttackingBool())
        {
            if (!runningVFX)
            {
                runningVFX = true;
                swordTrailGlow.Play();
            }
        }
        else
        {
            runningVFX = false;
            swordTrailGlow.Stop();
            this.enabled = false;
        }
    }

    public void PlaySwordTrails()
    {
        swordTrailGlow.Play();
    }

    public void StopSwordTrails()
    {
        swordTrailGlow.Stop();
    }
}
