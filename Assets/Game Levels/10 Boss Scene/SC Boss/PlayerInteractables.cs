using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInteractables : MonoBehaviour
{
    public bool isFocused = false;
    [SerializeField] bool isBossPortal = false;
    [SerializeField] GameSceneLoader.SceneEnum sceneToGo;
    [SerializeField] KeyCode interact;
    [SerializeField] GameObject bossObject;
    [SerializeField] GameObject teleportLocation;

    private void Start()
    {
        if (this.gameObject.name == "BOSSALTAR")
        {
            BGM.instance.isBossFight = false;
            BGM.instance.currentBGM.Stop();
        }
    }

    // Update is called once per frame
    void Update()
    {

        if (isFocused && Input.GetKeyDown(interact))
        {
            if (isBossPortal)
            {
                StartCoroutine(BossCor(sceneToGo));
                return;
            }
            else if (isBossAltar() == true)
            {
                return;
            }
            else
            {
                PortalsTP();
            }
        }
    }

    bool isBossAltar()
    {
        if (this.gameObject.name == "BOSSALTAR")
        {
            bossObject.SetActive(true);
            GetComponent<MM_WorldObject>().DestoryThisMMIcon();
            this.enabled = false;
            return true;
        }
        return false;
    }

    void PortalsTP()
    {
        PlayerManager.instance.gameObject.transform.position = teleportLocation.transform.position;
    }

    void BossPortal()
    {
        isFocused = false;
        CameraControllerMain.instance.interactUIPrompt.SetActive(false);
        GameSceneLoader.LoadScene(GameSceneLoader.SceneEnum.BossRealm);
    }

    IEnumerator BossCor(GameSceneLoader.SceneEnum sceneToChange)
    {
        GameSceneLoader.LoadScene(sceneToChange);
        yield return new WaitForEndOfFrame();
        isFocused = false;
        CameraControllerMain.instance.interactUIPrompt.SetActive(false);
    }
}
