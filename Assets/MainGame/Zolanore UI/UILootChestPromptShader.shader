Shader "Unlit/UILootChestPromptShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Color2("Color2", Color) = (1,1,1,1)
        _EmissionMap("Emission Map", 2D) = "black" {}
[HDR]   _EmissionColor("Emission Color", Color) = (0,0,0)
        _ClipAmount("Surface Noise Cutoff", Range(0, 1)) = 0.9
    }
    SubShader
    {
         Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }

        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                //float2 uv2 : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                //float2 uv2 : TEXCOORD1;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _EmissionMap;
            float4 _EmissionMap_ST;
            float4 _EmissionColor;

            float4 _Color;
            float4 _Color2;
            float _ClipAmount;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //o.uv = TRANSFORM_TEX(v.uv2, _EmissionMap);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

                //fixed4 albedo = tex2D(_MainTex, i.uv);

                //half4 output = half4(albedo.rgb, albedo.a);

                fixed4 emission = tex2D(_EmissionMap, i.uv) * _EmissionColor;

                //output.rgb += emission.rgb;

                //return col.rgba + emission.r + _Color.a;
                float flash = cos(_Time.y * 3) * 1;
                clip(col.a - _ClipAmount);
                //float3 lerpedValue = lerp(col.rgb, (flash + _Color2), flash);
                float4 lerpedValue = lerp(col * (_Color), col * (_Color2/2), flash);
                return lerpedValue;
                //return float4(lerpedValue.rgb,flash.x);
                //return float4((col.rgb) + (flash + _Color2), 1);
                //return float4(_Color + flash,1);
            }
            ENDCG
        }
    }
}
