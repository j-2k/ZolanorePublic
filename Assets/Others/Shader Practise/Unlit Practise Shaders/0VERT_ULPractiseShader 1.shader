Shader "Unlit/0VERT_ULPractiseShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color1("Color1", Color) = (1,1,1,1)
        _Color2("Color2", Color) = (1,1,1,1)
        _ColorSTART("ColorSTART", Range(0,1)) = 0
        _ColorEND("ColorEND", Range(0,1)) = 1
        _WaveAmplitude ("WaveAmp", Range(0,2)) = 0
        _OffSet ("OffSet1", float) = 0

    }
    SubShader
    {
        // TAGS https://docs.unity3d.com/Manual/SL-SubShaderTags.html

        Tags 
        { 
            "RenderType" = "Opaque"    //tag for ppfx / renderpipeline
            //"Queue" = "Geometry"         //queue in the render pipeline order check tags on top
            //queue for opaue is geometry
        }

        LOD 100

        Pass
        {
            //  BLEND MODES https://docs.unity3d.com/Manual/SL-Blend.html

            //Blend
            //Cull Off //Back default / Off or Front
            ZWrite On // Off or On//z depth buffer dont write2db
            //ZTest GEqual //GEqual very cool (put it front of another obj) // LEqual & Always r other main options and many more 
            //Blend One One //this is very very important remove additive blending and see the difference
            //adding a black color to something is nothing to it will remove black from the shader see u can see this in the current shader
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uvs : TEXCOORD0;     //THIS IS THE TRUE UV DATA PASSED TO V2F
                float3 normals : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;          //THIS IS JUST A TYPE OF TEX DATA CALLED UV OR THIS IS THE CHANNEL TO SEND DATA THROUGH eg. texcord1234...
                float3 normal : TEXCOORD1;      //example is this tex cord is the normal data  or this tex cord is the uv data its the same thing except how u use it in the vertex shader
                //normal ranges from - 1 to 1
                //UNITY_FOG_COORDS(1)

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _WaveAmplitude;
            float _OffSet;
            float4 _Color1;
            float4 _Color2;
            float _ColorSTART;
            float _ColorEND;

            #define TAU 6.28f

            float GetWave(float2 uv)
            {
                float2 centerUV = (uv * 2 - 1);
                float radialDistance = length(centerUV);
                float waves = sin((radialDistance - _Time.y*0.1) * TAU * 10) * 0.5 + 0.5;
                waves *= 1 - radialDistance;
                return waves;
            }

            v2f vert (MeshData v)
            {
                v2f o;

                v.vertex.y = GetWave(v.uvs) * _WaveAmplitude;

                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uvs = TRANSFORM_TEX(v.uvs, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uvs;//o.uv = (v.uvs + _OffSet) * _WaveAmplitude;
                
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float InverseLerp(float a, float b, float t)
            {
                return (t-a)/(b-a);
            }


            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                //fixed4 col = tex2D(_MainTex, i.uvs);

                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);

                return GetWave(i.uv);
            }
            ENDCG
        }
    }
}
