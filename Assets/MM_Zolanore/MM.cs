using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MM : MonoBehaviour
{
    [SerializeField]
    float currClampZoomScale = 0;

    [SerializeField]
    float scrollSpeed = 0.1f;

    [SerializeField]
    float maxZoom = 10f;

    [SerializeField]
    float minZoom = 1f;

    public static MM instance;

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

    [SerializeField]
    Terrain terrain;

    [SerializeField]
    RectTransform sViewRectTransform;

    [SerializeField]
    RectTransform contentRectTransform;

    [SerializeField]
    MM_Icon mmIconPrefab;

    Matrix4x4 transformationMatrixMap;

    MM_Icon playerMMIcon;

    Dictionary<MM_WorldObject, MM_Icon> MM_WorldObjectLookup = new Dictionary<MM_WorldObject, MM_Icon>();

    public MM_Icon CreateMMWorldObject(MM_WorldObject worldObject, bool isPlayer = false)
    {
        MM_Icon mapIcon = Instantiate(mmIconPrefab);
        mapIcon.transform.SetParent(contentRectTransform);
        mapIcon.SetIcon(worldObject.icon);
        mapIcon.SetIconScale(worldObject.scaleIcon);
        mapIcon.SetColor(worldObject.col);
        mapIcon.SetText(worldObject.text);
        mapIcon.SetTextSize(worldObject.textSize);
        MM_WorldObjectLookup[worldObject] = mapIcon;

        if (isPlayer) { playerMMIcon = mapIcon; }
        return mapIcon;
    }

    public void CalculateTransformations()
    {
        Vector2 mmDimension = contentRectTransform.rect.size;
        int offset = 1;
        float dimensionOffset = 0;
        if (SceneManager.GetActiveScene() == SceneManager.GetSceneByBuildIndex(1))
        {
            offset = 2;
            dimensionOffset = -mmDimension.y / 2;
        }
        else
        {
            offset = 1;
            dimensionOffset = 0;
        }
        Vector2 terrainDimension = new Vector2(terrain.terrainData.size.x * offset, terrain.terrainData.size.z);


        Vector2 scaleRatioOnMM = mmDimension / terrainDimension;
        Vector2 IconTranslations = new Vector2(0, dimensionOffset);

        transformationMatrixMap = Matrix4x4.TRS(IconTranslations, Quaternion.identity, scaleRatioOnMM);
        //  |scaleratio.x,         0,          0,          icoTranslation.x,   |
        //  |0,                scaleratio.y,   0,          icoTranslation.y,   |
        //  |0,                    0,          0,                  0,          |
        //  |0,                    0,          0,                  0,          |
    }

    private void Start()
    {
        CalculateTransformations();
        ScrollMap(1);
    }

    private void Update()
    {
        if (Input.GetKey(KeyCode.LeftControl))
        {
            float scroll = Input.GetAxis("Mouse ScrollWheel");
            ScrollMap(scroll);
        }
        UpdateAllIcons();
        MMPlayerOrigin();
    }

    void MMPlayerOrigin()
    {
        if (playerMMIcon != null)
        {
            float mapScale = contentRectTransform.transform.localScale.x;
            // we simply move the map in the opposite direction the player moved, scaled by the mapscale
            contentRectTransform.transform.localPosition = (-playerMMIcon.transform.localPosition * mapScale);
        }
    }

    void ScrollMap(float scroll)
    {
        if (scroll == 0)
            return;

        float currentMapScale = contentRectTransform.localScale.x;
        // we need to scale the scroll speed by the current map scale to keep the zooming linear
        float scrollAmount = (scroll > 0 ? scrollSpeed : -scrollSpeed) * currentMapScale;
        float newScale = currentMapScale + scrollAmount;
        float clampedScale = Mathf.Clamp(newScale, minZoom, maxZoom);
        contentRectTransform.localScale = Vector3.one * clampedScale;
        currClampZoomScale = clampedScale;
    }

    public void DestroyCorrespondingMiniMapIcon(MM_WorldObject miniMapWorldObject)
    {
        if (MM_WorldObjectLookup.TryGetValue(miniMapWorldObject, out MM_Icon icon))
        {
            MM_WorldObjectLookup.Remove(miniMapWorldObject);
            Destroy(icon.gameObject);
            
            //icon.gameObject.SetActive(false);
        }
    }

    void UpdateAllIcons()
    {
        float iconScale = 1 / contentRectTransform.transform.localScale.x;
        foreach (var kvp in MM_WorldObjectLookup)
        {
            MM_WorldObject mmWO = kvp.Key;
            MM_Icon mmI = kvp.Value;

            //translation
            Vector2 mapIconPos = WorldToMapPosition(mmWO.transform.position);
            mmI.rectTransform.anchoredPosition = mapIconPos;

            //rotation
            if (!mmWO.isIconQuaternionIdentity)
            {
                Vector3 iconRot = mmWO.transform.rotation.eulerAngles;
                mmI.iconRectTransform.localRotation = Quaternion.AngleAxis(-iconRot.y, Vector3.forward);
            }
            mmI.iconRectTransform.localScale = Vector3.one * iconScale;
        }
    }

    Vector2 WorldToMapPosition(Vector3 worldPos)
    {
        var pos = new Vector2(worldPos.x, worldPos.z);
        return transformationMatrixMap.MultiplyPoint3x4(pos);
    }

}
