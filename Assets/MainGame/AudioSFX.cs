using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioSFX : MonoBehaviour
{
    [SerializeField] AudioClip[] sfxClips;
    [SerializeField] AudioSource aSource;
    [SerializeField] MainMenuManager settingsSo;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void SwordSwingSFX()
    {
        aSource.volume = settingsSo.SFXVolume;
        aSource.clip = sfxClips[Random.Range(0,sfxClips.Length)];
        aSource.Play();
    }
}
