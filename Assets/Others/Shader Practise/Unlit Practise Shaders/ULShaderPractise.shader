Shader "Unlit/ULShaderPractise"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ClipAmount("Surface Noise Cutoff", Range(0, 1)) = 0.9

        _EmissionMap("Emission Map", 2D) = "black" {}
        [HDR] _EmissionColor("Emission Color", Color) = (0,0,0)
        _Color(" Color", Color) = (0,0,0)

    }
    SubShader
    {
        Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _EmissionMap;
            float4 _EmissionMap_ST;

            float _EmissionColor;
            float _ClipAmount;
            float _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.vertex.y +=  0.1 * sin((worldPos.x) + _Time.y * 1);
                //o.vertex.xy += sin(_Time.y * 5);
                o.uv = v.uv;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                clip(col.a - _ClipAmount);
                float4 output = float4(col.rgb * _LightColor0.rgb, col.a);

                float4 emission = tex2D(_EmissionMap, i.uv) * _EmissionColor;
                col.rgb += emission.rgb;
                //return float4(i.uv.x, i.uv.y,0, 1);
                return col + _Color;
            }
            ENDCG
        }
    }
}
