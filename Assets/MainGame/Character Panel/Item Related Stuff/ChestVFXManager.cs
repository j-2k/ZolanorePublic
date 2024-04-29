using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChestVFXManager : MonoBehaviour
{
    [SerializeField] GameObject openVFX;
    [SerializeField] GameObject sparkleVFX;
    [SerializeField] GameObject glowVFX;
    [SerializeField] Animation openAnim;

    GameObject openChestEffectOnly;
    bool isOpened = false;

    // Start is called before the first frame update
    void Start()
    {

    }

    private void Update()
    {
        
    }

    public void OpenChest()
    {
        if (!isOpened)
        {
            sparkleVFX.gameObject.SetActive(true);
            openAnim.Play();
        }
        Destroy(openChestEffectOnly);
        openChestEffectOnly = Instantiate(openVFX, transform.position, Quaternion.identity); //+ transform.up * 0.05f
        openChestEffectOnly.transform.localScale = Vector3.one * 3;
        openChestEffectOnly.transform.parent = this.transform;
        isOpened = true;
    }

    public void EmptyChestParticles()
    {
        sparkleVFX.gameObject.GetComponent<ParticleSystem>().Stop();
        glowVFX.gameObject.GetComponent<ParticleSystem>().Stop();
        //play a dissolveshader or smth then delete
    }


}
