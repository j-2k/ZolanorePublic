using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BGM : MonoBehaviour
{
    public List<AudioClip> audioClips;

    public AudioSource currentBGM;

    public bool isBossFight = false;

    public static BGM instance;
    private void Awake()
    {
        if (instance != null)
        {
            Destroy(this.gameObject);
        }
        else
        {
            instance = this;
            DontDestroyOnLoad(this.gameObject);
        }
    }

    private void Start()
    {
        currentBGM.clip = audioClips[0];
        currentBGM.Play();
    }

    public void SwitchAudioBGM(int index)
    {
        currentBGM.clip = audioClips[index];
        if (index == 2)
        {
            currentBGM.Stop();
        }
        else
        {
            currentBGM.Play();
        }
    }

    public void BeatBoss()
    {
        SwitchAudioBGM(audioClips.Count-1);
    }

}
