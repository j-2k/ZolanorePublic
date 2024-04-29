Shader "Unlit/0FRAG_ULPractiseShader"
{
    Properties
    {
        _ControlMaterial("_ControlMaterial", Range(0,1)) = 1
        _MainTex ("Texture", 2D) = "white" {}
        [HDR]
        _Color1("Color1", Color) = (1,1,1,1)
        [HDR]
        _Color2("Color2", Color) = (1,1,1,1)
        _ColorSTART("ColorSTART", Range(0,1)) = 0
        _ColorEND("ColorEND", Range(0,1)) = 1
        _Scale ("Scale1", float) = 1
        _OffSet ("OffSet1", float) = 0
    }
    SubShader
    {
        // TAGS https://docs.unity3d.com/Manual/SL-SubShaderTags.html

        Tags 
        { 
            "RenderType" = "Transparent"    //tag for ppfx / renderpipeline
            "Queue" = "Transparent"         //queue in the render pipeline order check tags on top
        }

        LOD 100

        Pass
        {
            //  BLEND MODES https://docs.unity3d.com/Manual/SL-Blend.html

            //Blend
            Cull Off //Back default / Off or Front
            ZWrite Off // Off or On//z depth buffer dont write2db
            //ZTest GEqual //GEqual very cool (put it front of another obj) // LEqual & Always r other main options and many more 
            Blend One One //this is very very important remove additive blending and see the difference
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
            float _ControlMaterial;

            float _Scale;
            float _OffSet;
            float4 _Color1;
            float4 _Color2;
            float _ColorSTART;
            float _ColorEND;

            #define TAU 6.28f

            v2f vert (MeshData v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uvs = TRANSFORM_TEX(v.uvs, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                //o.uv = (v.uvs + _OffSet) * _Scale;
                o.uv = v.uvs;
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

                /*
                float4 normalColors = float4 (i.normal.x,i.normal.y,i.normal.z,1);
                //clip(i.normal.y);
                clip(-i.normal.y);
                return normalColors;
                */
                //clip(-i.normal.y + 0.95);
                //clip(i.normal.y + 0.95); //LOOK AT SPHERE TO UNDERSTAND BETTER

                //return float4(i.uv.xy,0,1);
                //return float4(i.uv.yyy,1);

                //float t = saturate(InverseLerp(_ColorSTART,_ColorEND,i.uv.y));
                //float t = (InverseLerp(_ColorSTART,_ColorEND,i.uv.y));
                //float t = abs(frac(i.uv.y * 5) * 2 -1);
                
                

                float yOffSet =  sin(i.uv.x * TAU * _OffSet) * 0.01;
                float t = sin((i.uv.y + yOffSet + -_Time.y/10) * TAU * _Scale) * 0.5 + 0.5;

                //t *= 1 - i.uv.y; //alpha from 1 - 0 fron down to up remove 1 - to opposite

                //float topBottomRemove = (abs(i.normal.y) < 0.95);
                
                float waves = t;// * topBottomRemove;

                float4 gradient = lerp(_Color1,_Color2,i.uv.y);

                return gradient * waves * (_ControlMaterial);
                //return waves; 

                
                // return t = t.xxxx;
                //float4 colorOut = lerp(_Color1,_Color2,t);
                //return colorOut;
            }
            ENDCG
        }
    }
}
