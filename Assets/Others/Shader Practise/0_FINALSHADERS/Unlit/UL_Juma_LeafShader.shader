// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/UL_Juma_LeafShader"
{
    Properties
    {
        _MainTex("Leaf Texture", 2D) = "white" {}
        _NoiseTexture("Noise Texture", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
        _ColorScale("Color Multiplier", Range(0,10)) = 1
        _NoiseVelocity("Noise Velocity", Vector) = (0.5, 0.5, 0, 0)
        _UV_Leaf_Speed("Leaf Wiggle Speed", Vector) = (10, 10, 0, 0)
        _ClipAmount("Clip Amount", Range(0, 1)) = 0.01
        _WaveAmp("Wave Amp Vertex", Range(-1,1)) = 0.05
        _WaveAmpLeaf("Wave Amp Leaf", Range(-1,1)) = 0.01
        _DistortionAmount("Distortion Reduction",Range(1,100)) = 1
        _NoiseScale("NoiseScale",Range(0.01,5)) = 1

    }
    
    SubShader
    {
        Tags
        { 
            //"RenderType" = "TransparentCutout"
            //"RenderType" = "Opaque"
            "Queue" = "Transparent"   //??how does this fix idk
        }
        LOD 100

        Pass
        {
            
            Tags
            { 
                "RenderType" = "TransparentCutout"
                //"RenderType" = "Opaque"
                "Queue" = "Geometry"
                "LightMode" = "ForwardBase"
                "PassFlags" = "OnlyDirectional"
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            //#pragma multi_compile_fog
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                //float4 _ShadowCoord : TEXCOORD1;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 noiseUV : TEXCOORD1;
                float3 worldUV : TEXCOORD2;
                float4 difference : COLOR;
                //float3 viewDir : TEXCOORD3;
                //UNITY_FOG_COORDS(1)
                //SHADOW_COORDS(2)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _NoiseTexture;
            float4 _NoiseTexture_ST;

            float4 _Color;
            float _ColorScale;

            float2 _NoiseVelocity;
            float2 _UV_Leaf_Speed;

            float _ClipAmount;
            float _WaveAmp;
            float _WaveAmpLeaf;
            float _NoiseScale;
            float _DistortionAmount;

        
            

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.noiseUV = TRANSFORM_TEX(v.uv, _NoiseTexture);

                //Lighting
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float NL = max(0,dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.difference = NL * _LightColor0;

                //WORLD SPACE LEAF
                o.worldUV = mul(unity_ObjectToWorld, v.vertex);
                float2 worldUVScroll = float2(o.worldUV.x + _Time.y * _NoiseVelocity.x,o.worldUV.z + _Time.y * _NoiseVelocity.y);//normalize(_NoiseVelocity.x) * windspeed
                o.worldUV.xz = (worldUVScroll.xy) * _NoiseScale;

                //OBJECT SPACE LEAF
                //float2 noiseUV = float2(o.noiseUV.x + _Time.y * _NoiseVelocity.x,o.noiseUV.y + _Time.y * _NoiseVelocity.y);//normalize(_NoiseVelocity.x) * windspeed
                //o.noiseUV.xy = (noiseUV.xy) * _NoiseScale;
                


                float waveX = cos((v.uv.x + _Time.y * 0.1) * 6.24 * 5);
                float vertexY = (_WaveAmpLeaf * cos((o.uv.y) + _Time.y * 10));
                o.uv.x += vertexY;
                o.vertex.y += waveX * _WaveAmp; //remove1 of waves
                //UNITY_TRANSFER_FOG(o,o.vertex);
                //TRANSFER_SHADOW(o)
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {   
                //WORLD SPACE LEAF
                float2 worldUV = i.worldUV.xz;
                fixed sampleWorldNoiseR = tex2D(_NoiseTexture, worldUV).r;
                float2 uv = i.uv;
                uv = uv + sampleWorldNoiseR * sin(_Time.y * _UV_Leaf_Speed) / _DistortionAmount;
                fixed4 sampLeaf = tex2D(_MainTex, uv);
                clip(sampLeaf.a - _ClipAmount);
                //sampLeaf *= i.difference;
                return sampLeaf *(_Color * _ColorScale);
                
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                //float shadow = SHADOW_ATTENUATION(i);

                //OBJECT SPACE LEAF
                /*
                float2 uv = i.uv;
                fixed sampleNoiseRONLY = tex2D(_NoiseTexture, i.noiseUV).r;
                uv = uv + sampleNoiseRONLY * sin(_Time.y * _UV_Leaf_Speed) / _DistortionAmount;
                fixed4 sampledLeafTexture = tex2D(_MainTex, uv);
                clip(sampledLeafTexture.a - _ClipAmount);
                return sampledLeafTexture * (_Color * _ColorScale);
                */
            }
            ENDCG
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
