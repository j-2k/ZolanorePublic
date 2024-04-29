using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public static class GameSceneLoader
{

    public enum SceneEnum
    {
        MainMenu,
        ZolanoreRealm,
        BossRealm,
        Loading,
        DarkScene
    }

    public static void LoadScene(SceneEnum scene)
    {

        onLoaderCallBack = () =>
        {
            BGM.instance.SwitchAudioBGM((int)scene);
            if (scene == SceneEnum.MainMenu || scene == SceneEnum.DarkScene)
            {
                if (PlayerManager.instance != null)
                {
                    PlayerManager.instance.gameObject.SetActive(false);
                    CameraControllerMain.instance.gameObject.SetActive(false);
                    PlayerFamiliar.instance.gameObject.SetActive(false);
                    CanvasSingleton.instance.gameObject.SetActive(false);
                }
                SceneManager.LoadScene(scene.ToString());
            }
            else
            {
                SceneManager.LoadScene(scene.ToString());
            }
        };

        SceneManager.LoadScene(SceneEnum.Loading.ToString());
    }

    static Action onLoaderCallBack;

    public static void LoadCallback()
    {
        if (onLoaderCallBack != null)
        {
            onLoaderCallBack();
            onLoaderCallBack = null;
        }
    }

    public static string GetCurrentSceneName()
    {
        return SceneManager.GetActiveScene().name;
    }

    public static IEnumerator PlayerSpawn()
    {
        PlayerCodes.godMode = true;
        AbilityManager.instance.StopAbilities();
        PlayerManager.instance.enabled = false;
        yield return new WaitForEndOfFrame();
        PlayerManager.instance.gameObject.transform.position = GameObject.FindGameObjectWithTag("Respawn").transform.position;
        PlayerManager.instance.StopPlayerAnim();
        yield return new WaitForSeconds(0.25f);
        PlayerManager.instance.enabled = true;
        PlayerCodes.godMode = false;
        PlayerManager.instance.gameObject.GetComponent<MM_WorldObject>().CreateMMWOIcon();
    }
}
