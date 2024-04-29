using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class Learn_Grid : MonoBehaviour
{
    //https://catlikecoding.com/unity/tutorials/procedural-grid/
    //learnt from CLC - procedural grid generation from scratch

    [Header("This is the GRID size (the literal square shape in the grid) NOT 'Vertices' size")]

    [TextArea]
    public string Notes = "Comment Here.";



    [SerializeField] int xSize;
    [SerializeField] int ySize;
    Mesh mesh;


    private void Awake()
    {
        StartCoroutine(GenerateGridCoroutine());
        //Generate();
    }

    Vector3[] vertices;

    void Generate()
    {
        vertices = new Vector3[(xSize + 1) * (ySize + 1)];
        int i = 0;

        for (int x = 0; x <= xSize; x++)
        {
            for (int y = 0; y <= ySize; y++)
            {
                vertices[i] = new Vector3(x + transform.position.x , y + transform.position.y);
                i++;
            }
        }
    }

    IEnumerator GenerateGridCoroutine()
    {
        mesh = new Mesh();
        GetComponent<MeshFilter>().mesh = mesh;
        mesh.name = "Procedutal Grid Learning";
        
        vertices = new Vector3[(xSize + 1) * (ySize + 1)];
        Vector2[] uv = new Vector2[vertices.Length];


        //dont get this part yet but its used for norm map & we are switching the direction here to the correct dir
        //see results from without tan & with tan calcs by commenting out mesh.tangets = tangents & see the inverse bumps
        Vector4[] tangents = new Vector4[vertices.Length];
        Vector4 tangent = new Vector4(1f, 0f, 0f, -1f);


        int i = 0;

        for (int x = 0; x <= xSize; x++)
        {
            for (int y = 0; y <= ySize; y++)
            {
                vertices[i] = new Vector3(x + transform.position.x, y + transform.position.y);
                uv[i] = new Vector2((float)x / xSize,(float)y / ySize);
                tangents[i] = tangent;

                i++;
            }
        }

        mesh.vertices = vertices;
        mesh.uv = uv;
        mesh.tangents = tangents;
        int[] triangles = new int[6 * xSize * ySize];
        int tx = 0;
        int ty = 0;
        for (int x = 0; x < xSize; x++)
        {
            for (int y = 0; y < ySize; y++)
            {
                triangles[tx] = ty;
                triangles[tx + 1] = ty + 1;
                triangles[tx + 2] = ty + xSize + 1;
                triangles[tx + 3] = ty + xSize + 1;
                triangles[tx + 4] = ty + 1;
                triangles[tx + 5] = ty + xSize + 2;
                //
                tx += 6;
                ty++;
                mesh.triangles = triangles;
                mesh.RecalculateNormals();
                yield return new WaitForSeconds(0.1f);
            }
            ty++;
        }

        /* a full triangle or quad
        mesh.vertices = vertices;
        int[] triangles = new int[6];
                                    //condensed versions
        triangles[0] = 0;           //triangles[0] = 0;
        triangles[1] = 1;           //triangles[3] = triangles[2] = 1;
        triangles[2] = xSize + 1;   //triangles[4] = triangles[1] = xSize + 1;
        triangles[3] = xSize + 1;   //triangles[5] = xSize + 2;
        triangles[4] = 1;
        triangles[5] = xSize + 2;
        mesh.triangles = triangles;
        */

    }

    private void OnDrawGizmos()
    {
        if (vertices != null)
        {
            Gizmos.color = Color.yellow;
            for (int i = 0; i < vertices.Length; i++)
            {
                Gizmos.DrawSphere(vertices[i] + transform.position, 0.25f);
            }
        }
        else
        {
            return;
        }
    }
}
