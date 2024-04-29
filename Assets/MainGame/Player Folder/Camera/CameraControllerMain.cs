using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraControllerMain : MonoBehaviour
{
    //keys
    //KeyCode LMB = KeyCode.Mouse0, RMB = KeyCode.Mouse1, MMB = KeyCode.Mouse2;


    //vars
    [SerializeField] float cameraVertical = 1, cameraHorizontal = 0, cameraDistanceMax = 10;
    //float cameraMaxTilt = 90;
    [Range(0,4)]
    //[SerializeField] float cameraSpeed = 2;
    float currentRotY, currentTiltX = 20, currentCameraDistance = 5;
    [Range(0, 25)]
    [SerializeField] float cameraSensitivity = 3;

    //ref
    Transform target;
    [SerializeField] Transform tiltX;
    Camera mainCam;


    //camera collisions
    //float smooth = 10f;
    Vector3 camDir;
    public Vector3 camDirAdjusted;
    float distance;

    //camcol2
    [SerializeField] bool camDebugCollision;
    [SerializeField] float camColClipping = 0.3f;
    [SerializeField] LayerMask cameraLayer;
    [SerializeField] LayerMask chestLayer;
    float adjustedCamDistance;
    Ray camRay;
    RaycastHit camRayHit;
    RaycastHit chestHit;
    [SerializeField] InventoryInput invenActiveCheck;
    bool shouldCameraRotate = true;

    [SerializeField] GameObject chestUIPrompt;
    public GameObject interactUIPrompt;//could just change txt to be interact instead...
    [SerializeField] MainMenuManager getSensitivity;

    public static CameraControllerMain instance;

    Transform firstChildRotX;
    [SerializeField] bool creditObject;
    private void Awake()
    {
        target = gameObject.transform.parent;
        if (!creditObject)
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
        transform.SetParent(null);
        firstChildRotX = transform.GetChild(0);
    }

    public void SetSens(float newSens)
    {
        cameraSensitivity = newSens;
    }

    void Start()
    {
        if (!creditObject)
        {
            DontDestroyOnLoad(this.gameObject);
        }
        cameraSensitivity = getSensitivity.mouseSensitivity;
        if (cameraSensitivity <= 0)
        {
            cameraSensitivity = 3;
        }

        
        //target = GameObject.FindGameObjectWithTag("Player").transform;

        mainCam = Camera.main;

        transform.position = target.transform.position + (Vector3.up * cameraVertical) + (Vector3.right * cameraHorizontal);
        transform.rotation = target.transform.rotation;

        tiltX.eulerAngles = new Vector3(currentTiltX, transform.eulerAngles.y, transform.eulerAngles.z);
        mainCam.transform.position += tiltX.forward * -currentCameraDistance;

        currentCameraDistance = cameraDistanceMax/2;

        //cam cols
        camDir = mainCam.transform.localPosition.normalized;
        distance = mainCam.transform.localPosition.magnitude;
    }

    void LateUpdate()
    {
        CameraHandler();
        CameraCollisions();
        CameraInput();
        CameraChestHit();
    }

    ItemChest itemChestCache;
    [SerializeField] PlayerInteractables interactable;


    void CameraChestHit()//all this needs to be refactored but running out of time.
    {
        // Does the ray intersect any objects excluding the player layer
        if (Physics.Raycast(transform.position, firstChildRotX.forward, out chestHit, 5f, chestLayer))
        {
            Debug.DrawRay(transform.position, firstChildRotX.forward * chestHit.distance, Color.yellow);
            Debug.Log("Did Hit");
            if (chestHit.transform.tag == "Chest")
            {

                if (itemChestCache == null)
                {
                    itemChestCache = chestHit.collider.gameObject.GetComponent<ItemChest>();
                }

                if (itemChestCache != chestHit.collider.gameObject.GetComponent<ItemChest>())
                {
                    itemChestCache.isInRange = false;
                    itemChestCache = chestHit.collider.gameObject.GetComponent<ItemChest>();
                }

                if (itemChestCache.amount >= 1)
                {
                    chestUIPrompt.SetActive(true);
                }
                else
                {
                    chestUIPrompt.SetActive(false);
                }
                itemChestCache.isInRange = true;
            }
            
            if (chestHit.transform.tag == "Interactable")
            {
                if (interactable == null)
                {
                    interactable = chestHit.collider.gameObject.GetComponent<PlayerInteractables>();
                }

                interactable.isFocused = true;

                interactUIPrompt.SetActive(true);
            }

            if (chestHit.transform.tag == "QuestGiver")
            {
                interactUIPrompt.SetActive(true);
            }
            isInactive = true;
        }
        else
        {
            Debug.DrawRay(transform.position, firstChildRotX.forward * 5, Color.black);
            //Debug.Log("Did not Hit");
            if (itemChestCache != null)
            {
                itemChestCache.isInRange = false;
                itemChestCache = null;
                chestUIPrompt.SetActive(false);
            }

            if (interactable != null)
            {
                interactable.isFocused = false;
                interactable = null;
                interactUIPrompt.SetActive(false);
            }

            if (isInactive)
            {
                isInactive = false;
                interactUIPrompt.SetActive(false);
                chestUIPrompt.SetActive(false);
            }

        }
    }

    bool isInactive = false;

    void CameraInput()
    {
        if (Input.GetKeyDown(KeyCode.Mouse1) && !invenActiveCheck.activePanel && !IngameMenu.gameIsPaused)
        {
            if (Cursor.visible)
            {
                Cursor.visible = false;
                Cursor.lockState = CursorLockMode.Locked;
                shouldCameraRotate = true;
            }
            else
            {
                Cursor.visible = true;
                Cursor.lockState = CursorLockMode.None;
                shouldCameraRotate = false;
            }
        }

        /*
        if (Input.GetKey(KeyCode.Mouse1) && !IngameMenu.gameIsPaused)
        {
            Cursor.visible = true;
            Cursor.lockState = CursorLockMode.None;
            shouldCameraRotate = false;
        }
        else
        {
            if (!invenActiveCheck.activePanel)
            {
                Cursor.visible = false;
                Cursor.lockState = CursorLockMode.Locked;
                shouldCameraRotate = true;
            }
        }
        */

    }

    void CameraHandler()
    {
        //currentRotY = player.transform.eulerAngles.y;



        if (shouldCameraRotate && !IngameMenu.gameIsPaused)
        {
            currentRotY += Input.GetAxisRaw("Mouse X") * (cameraSensitivity);
            currentTiltX -= Input.GetAxisRaw("Mouse Y") * (cameraSensitivity);
        }
        
        currentTiltX = Mathf.Clamp(currentTiltX, -90, 90);

        if (Input.mouseScrollDelta.y == 1 && !Input.GetKey(KeyCode.LeftControl))
        {
            currentCameraDistance -= 0.5f;
        }
        else if (Input.mouseScrollDelta.y == -1 && !Input.GetKey(KeyCode.LeftControl))
        {
            currentCameraDistance += 0.5f;
        }


        transform.position = target.transform.position + (Vector3.up * cameraVertical) + (Vector3.right * cameraHorizontal);
        transform.eulerAngles = new Vector3(transform.eulerAngles.x, currentRotY, transform.eulerAngles.z);

        tiltX.eulerAngles = new Vector3(currentTiltX, tiltX.eulerAngles.y, tiltX.eulerAngles.z);
        //THSI LINE BELOW FOR CAM MOVEMENT/SCROLLING
        //mainCam.transform.position = transform.position + tiltX.forward * -currentCameraDistance;
        //new col line
        mainCam.transform.position = transform.position + tiltX.forward * -adjustedCamDistance;


        currentCameraDistance = Mathf.Clamp(currentCameraDistance, 0, cameraDistanceMax);
    }    

    void CameraCollisions()
    {
        float camDistance = currentCameraDistance + camColClipping;

        camRay.origin = transform.position;
        camRay.direction = -tiltX.forward;

        //raycast setup
        if(Physics.Raycast(camRay,out camRayHit,camDistance, cameraLayer))
        {//VVV COLLIDING
            adjustedCamDistance = Vector3.Distance(camRay.origin, camRayHit.point) - camColClipping;
        }
        else
        {//VVV NOT COLLIDING
            adjustedCamDistance = currentCameraDistance;
        }

        if(camDebugCollision)
        {
            Debug.DrawLine(camRay.origin, camRay.origin + camRay.direction * currentCameraDistance,Color.white);
        }
    }
}
