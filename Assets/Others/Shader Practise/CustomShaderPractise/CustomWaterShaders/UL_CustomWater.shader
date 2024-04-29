Shader "Unlit/ULCustomWater"
{
    //https://catlikecoding.com/unity/tutorials/flow/texture-distortion/
    //learn and do texture distortion first
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _Color ("Color", Color) = (0.1,0.6,0.9,0.5)

        _Amplitude("Amplitude", Float) = 1
        _SlopeLength("Slope Length", Float) = 1

        _DepthGradientShallow("Depth Gradient Shallow", Color) = (0.325, 0.807, 0.971, 0.725)
        _DepthGradientDeep("Depth Gradient Deep", Color) = (0.086, 0.407, 1, 0.749)
        _DepthMaxDistance("Depth Maximum Distance", Float) = 1
    }
    SubShader
    {
        Tags 
        { 
            "Queue"="Transparent"
			"LightMode" = "ForwardBase"
		}
        LOD 100
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityStandardBRDF.cginc"
            #include "UnityStandardUtils.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 screenPosition : TEXCOORD2;
                float4 vertex : SV_POSITION;
                UNITY_FOG_COORDS(1)
            };

            sampler2D _CameraDepthTexture;

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Amplitude;
            float _SlopeLength;

            float4 _Color;

            float4 _DepthGradientShallow;
            float4 _DepthGradientDeep;
            float _DepthMaxDistance;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.screenPosition = ComputeScreenPos(o.vertex);
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

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
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

                float existingDepth01 = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPosition)).r;
                float existingDepthLinear = LinearEyeDepth(existingDepth01);

                float depthDifference = existingDepthLinear - i.screenPosition.w;

                float waterDepthDifference01 = saturate(depthDifference / _DepthMaxDistance);
                float4 waterColor = lerp(_DepthGradientShallow, _DepthGradientDeep, waterDepthDifference01);

                return waterColor;
            }
            ENDCG
        }
    }
}
