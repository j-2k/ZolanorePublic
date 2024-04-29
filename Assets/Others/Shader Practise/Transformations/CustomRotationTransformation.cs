using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CustomRotationTransformation : CustomTransformation
{
    //learn matrix multiplication first
    //https://www.mathsisfun.com/algebra/matrix-multiplying.html
    //start transformations
    //https://catlikecoding.com/unity/tutorials/rendering/part-1/
    // left hand coordinate system with thumb = +y index + z middle + x (unity)
    // sitting with default rotation adding to z  should turn thumb and middle counter clock wise
    // x & y defaulted should be (x 1 , 0) (y 0 , 1) so turning 90 on the z should result in x 0,1 y -1 0 & so on
    // rotating 45 would put u on a diag on the xy plane and youd end up with coordinates of the form of +- radical 1/2 or rad2/2 check unit circle for reference
    // if u keep rotating u get a sine wave 
    // if we defaulted with 90+ degrees so x 0,1 y -1,0 
    // if we moved it from the new pos the sin wave will match the y coordinate and the cos wave will match the x coordinate
    // TO GET A BETTER REFERENCE WATCH A VIDEO OF A SINE WAVE AND COS WAVE SIMULATION
    // https://www.youtube.com/watch?v=a_zReGTxdlQ
    // this would mean cos is x which is 0,1 also (-sin z, cos z) sin is y which is 1,0 also (cos z, sin z)
    // rotating on arbitrary points it would turn out to be (x cos Z - y sin Z) , ( x -sin Z + y cos Z) because of matrix multiplication i think??
    // https://stackoverflow.com/questions/14607640/rotating-a-vector-in-3d-space
    // https://learnopengl.com/Getting-started/Transformations
    //  ROTATING ON THE Z VECTOR AXIS IN A 3D SPACE
    //  |cos θ   −sin θ   0| |x|   |x cos θ − y sin θ|   |x'|
    //  |sin θ    cos θ   0| |y| = |x sin θ + y cos θ| = |y'|
    //  |  0       0      1| |z|   |        z        |   |z'|
    //  ROTATING AROUND Y = (X,Z) X(COS Y, -SIN Y) , Z(SIN Y,COS Y)
    //  | cos θ    0   sin θ| |x|   | x cos θ + z sin θ|   |x'|
    //  |   0      1       0| |y| = |         y        | = |y'|
    //  |−sin θ    0   cos θ| |z|   |−x sin θ + z cos θ|   |z'|

    public Vector3 rotation;


    public override Matrix4x4 Matrix
    {
        get
        {
            float radianZ = rotation.z * Mathf.Deg2Rad;
            float sinZ = Mathf.Sin(radianZ);
            float cosZ = Mathf.Cos(radianZ);

            float radianY = rotation.y * Mathf.Deg2Rad;
            float sinY = Mathf.Sin(radianY);
            float cosY = Mathf.Cos(radianY);

            float radianX = rotation.x * Mathf.Deg2Rad;
            float sinX = Mathf.Sin(radianX);
            float cosX = Mathf.Cos(radianX);

            /*
            Vector3 zAxis = new Vector3(
                point.x * cosZ - point.y * sinZ,
                point.x * sinZ + point.y * cosZ,
                point.z
            );

            Vector3 yAxis = new Vector3(
                point.x * cosY + point.z * sinY,
                point.y,
                -point.x * sinY + point.z * cosY
            );

            //try to do x axis by self

            Vector3 xAxis = new Vector3(            //  X   Y   Z
            point.x + 0 + 0,                        //  1   0   0
            0 + point.y * cosX - point.z * sinX,    //  0 cos*Y -sin*Z
            0 + point.y * sinX + point.z * cosX     //  0 sin*Y cos*Z
            );
            */
            //combining all matricies
            //rot order is Z THEN Y THEN X => X * (Y * Z) matrix order
            // after multiplying 

            Matrix4x4 matrix = new Matrix4x4();
            matrix.SetColumn(0, new Vector4(
            cosY * cosZ,
            cosX * sinZ + sinX * sinY * cosZ,
            sinX * sinZ - cosX * sinY * cosZ,
            0));

            matrix.SetColumn(1, new Vector4(
            -cosY * sinZ,
            cosX * cosZ - sinX * sinY * sinZ,
            sinX * cosZ + cosX * sinY * sinZ,
            0));

            matrix.SetColumn(2, new Vector4(
            sinY,
            -sinX * cosY,
            cosX * cosY,
            0));

            matrix.SetColumn(3, new Vector4(
            0,
            0,
            0,
            1));

            return matrix;
        }
    }
}
