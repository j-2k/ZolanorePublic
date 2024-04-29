using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerCodes : MonoBehaviour
{
    public static bool godMode = false;
    string[] godString = new string[] { "j","u", "m", "a", "i", "s", "h", "e", "r", "e"};
    string[] zolanoreRealm = new string[] { "z", "o", "l", "a", "n", "o", "r", "e"};
    string[] bossRealm = new string[] { "b", "o", "s", "s"};
    int godIndex = 0, zolanoreIndex = 0, bossIndex = 0;
    // Update is called once per frame
    void Update()
    {
        if (IngameMenu.gameIsPaused)
        {
            Debug.Log("GameIsPaused");
            if(Input.anyKeyDown)
            {
                Debug.Log(godString.Length);
                if (Input.GetKeyDown(godString[godIndex]))
                {
                    godIndex++;
                }
                else
                {
                    godIndex = 0;
                }

                if (Input.GetKeyDown(zolanoreRealm[zolanoreIndex]))
                {
                    zolanoreIndex++;
                }
                else
                {
                    zolanoreIndex = 0;
                }

                if (Input.GetKeyDown(bossRealm[bossIndex]))
                {
                    bossIndex++;
                }
                else
                {
                    bossIndex = 0;
                }
            }

            if (godIndex == godString.Length)
            {
                godMode = !godMode;
                godIndex = 0;
            }

            if (zolanoreIndex == zolanoreRealm.Length)
            {
                SceneManager.LoadScene(1);
                zolanoreIndex = 0;
            }

            if (bossIndex == bossRealm.Length)
            {
                SceneManager.LoadScene(2);
                bossIndex = 0;
            }
        }
    }
}
