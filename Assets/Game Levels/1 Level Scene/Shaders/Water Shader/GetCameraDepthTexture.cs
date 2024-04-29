using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GetCameraDepthTexture : MonoBehaviour
{
    [SerializeField]
    DepthTextureMode depthTextureMode;

    private void OnValidate()
    {
        SetCameraDepthTextureMode();
    }

    private void Awake()
    {
        SetCameraDepthTextureMode();
    }

    private void SetCameraDepthTextureMode()
    {
        GetComponent<Camera>().depthTextureMode = depthTextureMode;

    }
}
