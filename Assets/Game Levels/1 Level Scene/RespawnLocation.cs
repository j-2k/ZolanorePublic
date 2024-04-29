using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class RespawnLocation : MonoBehaviour
{
    private void Start()
    {
        StartCoroutine(GameSceneLoader.PlayerSpawn());

        PlayerManager.instance.gameObject.SetActive(true);
        CameraControllerMain.instance.gameObject.SetActive(true);
        PlayerFamiliar.instance.gameObject.SetActive(true);
        CanvasSingleton.instance.gameObject.SetActive(true);
    }
}
