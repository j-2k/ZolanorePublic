Shader "Unlit/JumaLava"
{
    Properties
    {
        [HDR]
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Amplitude("Amplitude", float) = 1
        _WaveDensitiy("Wave Densitiy", float) = 1
        _MainTex ("Main Texture", 2D) = "white" {}
        //_NoiseTex ("Noise Texture", 2D) = "white" {}
        _NoiseVelocity("Noise Velocity", Vector) = (0, 0, 0, 0)
        _NoiseScale("Noise Scale", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 noiseUV : TEXCOORD1;
                float3 worldUV : TEXCOORD2;
                UNITY_FOG_COORDS(3)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            //sampler2D _NoiseTex;
            //float4 _NoiseTex_ST;

            float4 _Color;
            float2 _NoiseVelocity;
            float _NoiseScale;
            float _Amplitude;
            float _WaveDensitiy;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //o.noiseUV = TRANSFORM_TEX(v.uv, _NoiseTex);


                o.worldUV = mul(unity_ObjectToWorld, v.vertex);
                //return float4(i.worldUV.x,i.worldUV.z,0,0);
                //float2 worldUVScroll = float2(o.worldUV.x + _Time.y * _NoiseVelocity.x,o.worldUV.z + _Time.y * _NoiseVelocity.y);//normalize(_NoiseVelocity.x) * windspeed
                //o.worldUV.xz = (worldUVScroll.xy) * _NoiseScale;

                float noiseVal = tex2Dlod(_MainTex, v.vertex).r;
                float waveX = (_Amplitude) * cos((v.uv.x + _Time.y * 0.1) * 5 *_WaveDensitiy);//v.uv.x
                float waveY = (_Amplitude) * cos((v.uv.y+ _Time.y * 0.1) * 5 *_WaveDensitiy);
                o.vertex.y += (waveX + waveY);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 noiseTex = tex2D(_NoiseTex, i.noiseUV);
                //return noiseTex;
                //return float4(i.uv.x,i.uv.y,0,1);

                float2 scrollUV = float2(i.uv.x + _Time.y * _NoiseVelocity.x,i.uv.y + _Time.y * _NoiseVelocity.y);
                scrollUV.xy = scrollUV.xy * _NoiseScale;
                fixed4 noiseTex = tex2D(_MainTex, scrollUV.xy);
                return noiseTex * _Color;

                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
                
            }
            ENDCG
        }
    }
}
