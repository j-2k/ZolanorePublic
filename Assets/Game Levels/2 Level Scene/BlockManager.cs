using System.Collections.Generic;
using UnityEngine;

public class BlockManager : MonoBehaviour
{
    [SerializeField] GameObject block;
    [SerializeField] GameObject magicBlock;
    [SerializeField] GameObject player;
    [SerializeField] List<GameObject> listOfBlocks;
    [SerializeField] GameObject[,] blocks2D;

    [SerializeField] bool buildCustomSize;
    [SerializeField] int customSizeX;
    [SerializeField] int customSizeY;

    [SerializeField] float blockScale;
    [SerializeField] float executeOffset;
    [SerializeField] bool usingMagicBlock;

    int shiftOffset;
    // Start is called before the first frame update
    void Start()
    {   //-2 -1 0 1 2 (5x5) | -1 0 1 (3x3) | -3 -2 -1 0 1 2 3(7x7)? 7/2 = 3.5
        
        if (!buildCustomSize)
        {
            customSizeX = 5;
            customSizeY = 5;
        }

        if (usingMagicBlock)
        {
            blockScale = 0.5f;
            shiftOffset = (int)(blockScale * 200);
            executeOffset = (blockScale * 100) / 2;
        }
        else
        {
            blockScale = 1;
            shiftOffset = (int)(blockScale * 100);
            executeOffset = (blockScale * 100) / 2;
        }

        blocks2D = new GameObject[customSizeX, customSizeY];
        block.gameObject.transform.localScale = new Vector3(blockScale, blockScale, blockScale);
        magicBlock.gameObject.transform.localScale = new Vector3(blockScale, blockScale, blockScale);

        for (int x = 0; x < (customSizeX); x++)
        {
            for (int y = 0; y < (customSizeY); y++)
            {
                if (usingMagicBlock)
                {
                    listOfBlocks.Add(Instantiate(block, new Vector3(x * (100), 0, y * (100)), Quaternion.identity));
                }
                else
                {
                    listOfBlocks.Add(Instantiate(block, new Vector3(x * (blockScale * 100), 0, y * (blockScale * 100)), Quaternion.identity));
                }
            }
        }
        lastXCycle = (customSizeY * customSizeX) - customSizeY;
        //should be doing this wherever i instanaitae but whatever
        for (int i = 0; i < listOfBlocks.Count; i++)
        {
            if (usingMagicBlock)
            {
                listOfBlocks[i].transform.position -= new Vector3(((customSizeX - 1) * (100)) / 2, 0, ((customSizeY - 1) * (100)) / 2);
            }
            else
            {
                listOfBlocks[i].transform.position -= new Vector3(((customSizeX - 1) * (blockScale * 100)) / 2, 0, ((customSizeY - 1) * (blockScale * 100)) / 2);
            }
            
        }

        //OldStart();
        lastQuad = new Vector3(0, 0, 0);
    }

    void OldStart()
    {
        if (!buildCustomSize)
        {
            for (int x = -2; x < 3; x++)
            {
                for (int y = -2; y < 3; y++)
                {
                    listOfBlocks.Add(Instantiate(block, new Vector3(x * 100, 0, y * 100), Quaternion.identity));
                }
            }
            lastXCycle = 20;
        }
        else
        {

            for (int x = 0; x < (customSizeX); x++)
            {
                for (int y = 0; y < (customSizeY); y++)
                {
                    listOfBlocks.Add(Instantiate(block, new Vector3(x * 100, 0, y * 100), Quaternion.identity));
                }
            }
            lastXCycle = (customSizeY * customSizeX) - customSizeY;
            //should be doing this wherever i instanaitae but whatever
            for (int i = 0; i < listOfBlocks.Count; i++)
            {
                listOfBlocks[i].transform.position -= new Vector3(((customSizeX - 1) * 100) / 2, 0, ((customSizeY - 1) * 100) / 2);
            }
        }
    }

    [SerializeField] Vector3 lastQuad;
    [SerializeField] Vector3 playerVector;
    [SerializeField] Vector3 magicBlockQuad;
    int arrayShift = 5;
    int arrayZShift = 0; //0 for forward 4 for back
    int arrayXShift = 0;
    int increment = 0;
    int lastXCycle;
    // Update is called once per frame
    void Update()
    {
        playerVector = player.transform.position;

        if (usingMagicBlock)
        {
            ExecuteMagicBlockShifts();
        }
        else
        {
            ExecuteBlockShifts();
        }

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            GameSceneLoader.LoadScene(GameSceneLoader.SceneEnum.MainMenu);
        }
    }

    [SerializeField] int zOffset = 0;
    [SerializeField] int xOffset = 0;

    void ExecuteMagicBlockShifts()
    {
        Debug.Log("Modulo = " + (lastQuad.z / 50) % 2);
        if (player.transform.position.z >= lastQuad.z + executeOffset)
        {
            Debug.Log("Forward Check");
            if ((lastQuad.z/50) % 2 == 0)
            {
                Debug.Log("Magic Block Forward EVEN");
                magicBlock.transform.position = new Vector3(lastQuad.x, 0, lastQuad.z + (blockScale * 100));
                lastQuad.z += (blockScale * 100);//50
                zOffset = 1;
                return;
            }

            if (Mathf.Abs((lastQuad.z / 50) % 2) == 1)
            {
                Debug.Log("Block Forward ODD");
                if (zOffset == -1)
                {
                    if ((Mathf.Abs((lastQuad.x / 50) % 2) == 1) && (Mathf.Abs((lastQuad.z / 50) % 2) == 1))
                    {
                        magicBlock.transform.position = new Vector3(lastQuad.x, 0, lastQuad.z + (blockScale * 100));
                    }
                    lastQuad.z += (blockScale * 100);
                    return;
                }

                if (zOffset == 1)
                {
                    if ((Mathf.Abs((lastQuad.x / 50) % 2) == 1) && (Mathf.Abs((lastQuad.z / 50) % 2) == 1))
                    {
                        magicBlock.transform.position = new Vector3(lastQuad.x, 0, lastQuad.z + (blockScale * 100));
                    }
                    ExecuteZforward();
                }
                return;
            }
        }
        
        if (player.transform.position.z <= lastQuad.z - executeOffset)
        {
            Debug.Log("Backward Check");
            if ((lastQuad.z / 50) % 2 == 0)
            {
                Debug.Log("Magic Block Backward EVEN");
                magicBlock.transform.position = new Vector3(lastQuad.x, 0, lastQuad.z - (blockScale * 100));
                lastQuad.z -= (blockScale * 100);//50
                zOffset = -1;
                return;
            }

            if (Mathf.Abs((lastQuad.z / 50) % 2) == 1)
            {
                Debug.Log("Block Backward ODD");
                if (zOffset == 1)
                {
                    if ((Mathf.Abs((lastQuad.x / 50) % 2) == 1) && (Mathf.Abs((lastQuad.z / 50) % 2) == 1))
                    {
                        magicBlock.transform.position = new Vector3(lastQuad.x, 0, lastQuad.z - (blockScale * 100));
                    }
                    lastQuad.z -= (blockScale * 100);
                    return;
                }

                if (zOffset == -1)
                {
                    if ((Mathf.Abs((lastQuad.x / 50) % 2) == 1) && (Mathf.Abs((lastQuad.z / 50) % 2) == 1))
                    {
                        magicBlock.transform.position = new Vector3(lastQuad.x, 0, lastQuad.z - (blockScale * 100));
                    }
                    ExecuteZbackwards();
                }
                return;
            }
        }

        if (player.transform.position.x >= lastQuad.x + executeOffset)
        {
            Debug.Log("Right Check");
            if ((lastQuad.x / 50) % 2 == 0)
            {
                Debug.Log("Magic Block Right EVEN");
                magicBlock.transform.position = new Vector3(lastQuad.x + (blockScale * 100), 0, lastQuad.z);
                lastQuad.x += (blockScale * 100);//50
                xOffset = 1;
                return;
            }

            if (Mathf.Abs((lastQuad.x / 50) % 2) == 1)
            {
                Debug.Log("Block Right ODD");
                if (xOffset == -1)
                {
                    if ((Mathf.Abs((lastQuad.x / 50) % 2) == 1) && (Mathf.Abs((lastQuad.z / 50) % 2) == 1))
                    {
                        magicBlock.transform.position = new Vector3(lastQuad.x + (blockScale * 100), 0, lastQuad.z);
                    }
                    lastQuad.x += (blockScale * 100);
                    return;
                }

                if (xOffset == 1)
                {
                    if ((Mathf.Abs((lastQuad.x / 50) % 2) == 1) && (Mathf.Abs((lastQuad.z / 50) % 2) == 1))
                    {
                        magicBlock.transform.position = new Vector3(lastQuad.x + (blockScale * 100), 0, lastQuad.z);
                    }
                    ExecuteXright();
                }
                return;
            }
        }

        if (player.transform.position.x <= lastQuad.x - executeOffset)
        {
            Debug.Log("Left Check");
            if ((lastQuad.x / 50) % 2 == 0)
            {
                Debug.Log("Magic Block Left EVEN");
                magicBlock.transform.position = new Vector3(lastQuad.x - (blockScale * 100), 0, lastQuad.z);
                lastQuad.x -= (blockScale * 100);//50
                xOffset = -1;
                return;
            }

            if (Mathf.Abs((lastQuad.x / 50) % 2) == 1)
            {
                Debug.Log("Block Left ODD");
                if (xOffset == 1)
                {
                    if ((Mathf.Abs((lastQuad.x / 50) % 2) == 1) && (Mathf.Abs((lastQuad.z / 50) % 2) == 1))
                    {
                        magicBlock.transform.position = new Vector3(lastQuad.x - (blockScale * 100), 0, lastQuad.z);
                    }
                    lastQuad.x -= (blockScale * 100);
                    return;
                }

                if (xOffset == -1)
                {
                    if ((Mathf.Abs((lastQuad.x / 50) % 2) == 1) && (Mathf.Abs((lastQuad.z / 50) % 2) == 1))
                    {
                        magicBlock.transform.position = new Vector3(lastQuad.x - (blockScale * 100), 0, lastQuad.z);
                    }
                    ExecuteXleft();
                }
                return;
            }
        }
        
    }

    void ExecuteBlockShifts()
    {
        if (player.transform.position.z >= lastQuad.z + executeOffset)
        {
            ExecuteZforward();
        }

        if (player.transform.position.z <= lastQuad.z - executeOffset)
        {
            ExecuteZbackwards();
        }

        if (player.transform.position.x >= lastQuad.x + executeOffset)
        {
            ExecuteXright();
        }

        if (player.transform.position.x <= lastQuad.x - executeOffset)
        {
            ExecuteXleft();
        }
    }

    void ExecuteZbackwards()
    {
        if (arrayZShift <= 0)
        {
            arrayZShift = customSizeY-1;
        }
        else
        {
            arrayZShift--;
        }

        Debug.Log("Executing Z backward Shift");
        for (int i = arrayZShift; i < listOfBlocks.Count;)
        {
            listOfBlocks[i].transform.position = new Vector3(listOfBlocks[i].transform.position.x, listOfBlocks[i].transform.position.y, listOfBlocks[i].transform.position.z - (customSizeY * shiftOffset));
            i += customSizeY;
        }

        lastQuad.z -= (blockScale * 100);
    }

    void ExecuteZforward()
    {
        Debug.Log("Executing Z Forward Shift");
        for (int i = arrayZShift; i < listOfBlocks.Count;)
        {
            listOfBlocks[i].transform.position = new Vector3(listOfBlocks[i].transform.position.x, listOfBlocks[i].transform.position.y, listOfBlocks[i].transform.position.z + (customSizeY * shiftOffset));
            i += customSizeY;
        }
        
        if (arrayZShift >= customSizeY-1)
        {
            arrayZShift = 0;
        }
        else
        {
            arrayZShift++;
        }


        lastQuad.z += (blockScale * 100);

    }

    void ExecuteXleft()
    {
        if (arrayXShift <= 0)
        {
            arrayXShift = lastXCycle;
        }
        else
        {
            arrayXShift -= customSizeY;
        }

        Debug.Log("Executing X Left Shift");
        for (int i = arrayXShift; i < listOfBlocks.Count;)
        {
            listOfBlocks[i].transform.position = new Vector3(listOfBlocks[i].transform.position.x - (customSizeX * shiftOffset), listOfBlocks[i].transform.position.y, listOfBlocks[i].transform.position.z);
            i++;

            increment++;
            if (increment >= customSizeY)
            {
                increment = 0;
                break;
            }
        }

        lastQuad.x -= (blockScale * 100);
    }

    void ExecuteXright()
    {
        Debug.Log("Executing X Right Shift");
        for (int i = arrayXShift; i < listOfBlocks.Count;)
        {
            listOfBlocks[i].transform.position = new Vector3(listOfBlocks[i].transform.position.x + (customSizeX * shiftOffset), listOfBlocks[i].transform.position.y, listOfBlocks[i].transform.position.z);
            i++;

            increment++;
            if (increment >= customSizeY)
            {
                increment = 0;
                break;
            }
        }

        if (arrayXShift >= lastXCycle)
        {
            arrayXShift = 0;
        }
        else
        {
            arrayXShift += customSizeY;
        }

        lastQuad.x += (blockScale * 100);
    }
}
