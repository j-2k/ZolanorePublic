Shader "Custom/WaterShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DepthGradientShallow("Depth Gradient Shallow", Color) = (0.325, 0.807, 0.971, 0.725)
        _DepthGradientDeep("Depth Gradient Deep", Color) = (0.086, 0.407, 1, 0.749)
        _DepthMaxDistance("Depth Maximum Distance", Float) = 1
        _SurfaceNoise("Surface Noise", 2D) = "white" {}
        _SurfaceNoiseCutoff("Surface Noise Cutoff", Range(0, 1)) = 0.777
        _FoamDistance("Foam Distance", Float) = 0.4
        _SurfaceNoiseScroll("Surface Noise Scroll Amount", Vector) = (0.03, 0.03, 0, 0)


        _SurfaceDistortion("Surface Distortion", 2D) = "white" {}	
        _SurfaceDistortionAmount("Surface Distortion Amount", Range(0, 1)) = 0.27

        _SlopeLength("_SlopeLength", Float) = 1
        _Amplitude("_Amplitude", Float) = 1
        _FoamColor("Foam Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Pass
        {
            CGPROGRAM
            #define SMOOTHSTEP_AA 0.01
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 noiseUV : TEXCOORD0;
                float2 distortUV : TEXCOORD1;
                float4 screenPosition : TEXCOORD2;
                float4 vertex : SV_POSITION;
                UNITY_FOG_COORDS(3)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _DepthGradientShallow;
            float4 _DepthGradientDeep;
            float _DepthMaxDistance;

            sampler2D _CameraDepthTexture;
sampler2D _SurfaceNoise;
float4 _SurfaceNoise_ST;
float _SurfaceNoiseCutoff;
float _FoamDistance;
float2 _SurfaceNoiseScroll;


sampler2D _SurfaceDistortion;
float4 _SurfaceDistortion_ST;

float _SurfaceDistortionAmount;
float4 _FoamColor;
float _SlopeLength;
float _Amplitude;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPosition = ComputeScreenPos(o.vertex);
                o.distortUV = TRANSFORM_TEX(v.uv, _SurfaceDistortion);
                o.noiseUV = TRANSFORM_TEX(v.uv, _MainTex);

                float wave1 = sin(((v.uv.x + _Time.y * 0.1) * 6.24 * 5)/_SlopeLength);// *_Time.y * 1;
                float wave2 = sin(((v.uv.y + _Time.y * 0.1) * 6.24 * 5)/_SlopeLength);// *_Time.y * 1;
                float combinedWaves = wave1 * wave2 * _Amplitude;
                o.vertex.y += combinedWaves;

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }


            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                //fixed4 sampleTex = tex2D(_MainTex, i.uv);
                float linearDepth = LinearEyeDepth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPosition)).r);

                float depthDifference = linearDepth - i.screenPosition.w;

                float waterDepthDifference01 = saturate(depthDifference / _DepthMaxDistance);

                float4 waterColor = lerp(_DepthGradientShallow, _DepthGradientDeep, waterDepthDifference01);


                float2 distortSample = (tex2D(_SurfaceDistortion, i.distortUV).xy * 2 - 1) * _SurfaceDistortionAmount;

                float2 noiseUV = float2((i.noiseUV.x + _Time.y * _SurfaceNoiseScroll.x) + distortSample.x, (i.noiseUV.y + _Time.y * _SurfaceNoiseScroll.y) + distortSample.y);

                float surfaceNoiseSample = tex2D(_SurfaceNoise, noiseUV).r;
                
                float foamDepthDifference01 = saturate(depthDifference / _FoamDistance);
                float surfaceNoiseCutoff = foamDepthDifference01 * _SurfaceNoiseCutoff;

                //float surfaceNoise = smoothstep(surfaceNoiseCutoff - SMOOTHSTEP_AA, surfaceNoiseCutoff + SMOOTHSTEP_AA, surfaceNoiseSample);
                float surfaceNoise = surfaceNoiseSample > surfaceNoiseCutoff ? 1 : 0;

                float4 surfaceNoiseColor = _FoamColor * surfaceNoise;
                UNITY_APPLY_FOG(i.fogCoord, waterColor);
                return waterColor + surfaceNoiseColor;



                //return sampleTex;
            }
            ENDCG
        }
    }
}
