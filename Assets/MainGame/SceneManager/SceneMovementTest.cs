using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SceneMovementTest : MonoBehaviour
{
    public static SceneMovementTest instance;

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

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1))
        {
            GameSceneLoader.LoadScene(GameSceneLoader.SceneEnum.MainMenu);
        }

        if (Input.GetKeyDown(KeyCode.F2))
        {
            GameSceneLoader.LoadScene(GameSceneLoader.SceneEnum.ZolanoreRealm);
        }
        if (Input.GetKeyDown(KeyCode.F3))
        {
            GameSceneLoader.LoadScene(GameSceneLoader.SceneEnum.BossRealm);
        }
    }
}
