using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EGA_EffectSound : MonoBehaviour
{
    [SerializeField] bool oneShotOnly = false;
    [SerializeField] float invokeDelay = 0;
    public bool Repeating = true;
    public float RepeatTime = 2.0f;
    public float StartTime = 0.0f;
    public bool RandomVolume;
    public float minVolume = .4f;
    public float maxVolume = 1f;
    private AudioClip clip;

    private AudioSource soundComponent;

    void Start ()
    {
        soundComponent = GetComponent<AudioSource>();
        clip = soundComponent.clip;
        if (RandomVolume == true)
        {
            soundComponent.volume = Random.Range(minVolume, maxVolume);
            RepeatSound();
        }
        if (Repeating == true)
        {
            InvokeRepeating("RepeatSound", StartTime, RepeatTime);
        }
        if (oneShotOnly)
        {
            Invoke(nameof(RepeatSound), invokeDelay);
        }
    }

    void RepeatSound()
    {
        soundComponent.PlayOneShot(clip);
    }

    public void PlaySoundOnce()
    {
        soundComponent.PlayOneShot(clip);
    }
}
