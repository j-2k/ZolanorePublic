using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using TMPro;

public class IngameMenu : MonoBehaviour
{
    [SerializeField] GameObject menu;
    [SerializeField] MainMenuManager mmm;
    CameraControllerMain cam;

    [SerializeField] TMP_InputField mouseInputField;
    [SerializeField] Slider mouseSlider;
    [SerializeField] Slider musicSlider;
    [SerializeField] Slider SFXSlider;

    public static bool gameIsPaused;

    // Start is called before the first frame update
    void Start()
    {
        cam = GameObject.FindGameObjectWithTag("CameraManager").GetComponent<CameraControllerMain>();
        Cursor.visible = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            gameIsPaused = !gameIsPaused;
            PauseGame();
        }
    }

    public void PauseGameButton()
    {
        gameIsPaused = !gameIsPaused;
        PauseGame();
    }

    void PauseGame()
    {
        if (gameIsPaused)
        {
            Cursor.visible = true;
            Cursor.lockState = CursorLockMode.None;
            menu.SetActive(true);
            AudioListener.pause = true;
            mouseInputField.text = mmm.mouseSensitivity.ToString();
            mouseSlider.value = mmm.mouseSensitivity;
            musicSlider.value = (mmm.musicVolume * 100);
            SFXSlider.value = (mmm.SFXVolume * 100);
            Time.timeScale = 0;
        }
        else
        {
            Cursor.visible = false;
            Cursor.lockState = CursorLockMode.Locked;
            ApplyAllChanges();
            menu.SetActive(false);
            AudioListener.pause = false;
            Time.timeScale = 1;
        }

    }

    public void BackToMainMenu()
    {
        gameIsPaused = !gameIsPaused;
        PauseGame();
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
        GameSceneLoader.LoadScene(GameSceneLoader.SceneEnum.MainMenu);
    }

    public void CloseMenu()
    {
        ApplyAllChanges();
        menu.SetActive(false);
    }

    public void ApplyAllChanges()
    {
        cam.SetSens(mmm.mouseSensitivity);
        BGM.instance.currentBGM.volume = mmm.musicVolume;
    }

    //IEnumerator HideCursorDelay()
    //{
    //    Cursor.visible = false;
    //    Cursor.lockState = CursorLockMode.Locked;
    //    yield return new WaitForEndOfFrame();
    //    Cursor.visible = false;
    //    Cursor.lockState = CursorLockMode.Locked;
    //}
}
