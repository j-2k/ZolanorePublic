Shader "Unlit/UVLeafShader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _ColorScale("Color Multiplier", float) = 1
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _NoiseVelocity("Noise Velocity", Vector) = (0.03, 0.03, 0, 0)
        _NoiseVelocity2("Noise Velocity2", Vector) = (0.03, 0.03, 0, 0)
        _ClipAmount("Clip Amount", Range(0, 1)) = 0.9
        _RotationSpeed("Rot Speed", Range(-20,20)) = 0
        _WaveAmp("WaveAmp", Range(-1,1)) = 0.05
        _WaveAmpLeaf("_WaveAmpLeaf", Range(-1,1)) = 0.05
        _NoiseValue("_NoiseValue", Range(-1,1)) = 0
        _UVValue("_UVValue", Range(-1,1)) = 0
        _OffsetWorldPos("_OffsetWorldPos", Vector) = (0.03, 0.03, 0, 0)
        _DistortionAmount("Distortion Reduction",Range(1,50)) = 1
        _NoiseScale("NoiseScale",float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry"}
        
        ZWrite On
        Cull Off
        //Blend One One

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
                float3 normal : NORMAL;
                float2 uv0 : TEXCOORD0;
                //float2 uv1 : TEXCOORD1;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPosUV : TEXCOORD1;
                float3 normal : TEXCOORD2;
                float2 noiseUV : TEXCOORD3;
                //UNITY_FOG_COORDS(1)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;

            float2 _NoiseVelocity;
            float2 _NoiseVelocity2;
            float _ClipAmount;

            float _RotationSpeed;
            float4 _Color;
            float _ColorScale;
            float _WaveAmp;
            float _WaveAmpLeaf;
            float _NoiseValue;
            float _UVValue;
            float2 _OffsetWorldPos;
            float _NoiseScale;
            float _DistortionAmount;
            v2f vert (appdata v)
            {
                v2f o;
                o.worldPosUV = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv0, _MainTex);
                o.noiseUV = TRANSFORM_TEX(v.uv0, _NoiseTex);

                /*
                float sinX = sin ( _RotationSpeed * _Time );
                float cosX = cos ( _RotationSpeed * _Time );
                float sinY = sin ( _RotationSpeed * _Time );
                float2x2 rotationMatrix = float2x2( cosX, -sinX, sinY, cosX);
                //v.uv0.xy = mul ( v.uv0.xy, rotationMatrix );
                o.noiseUV = mul( v.uv1.xy, rotationMatrix );
                */
                
                
                float3 worldPosUV = mul(unity_ObjectToWorld, v.vertex).xyz;
                float2 noiseUV = float2(o.noiseUV.x + _Time.y * _NoiseVelocity.x,o.noiseUV.y + _Time.y * _NoiseVelocity.y);//normalize(_NoiseVelocity.x) * windspeed
                //float2 animUV = float2(o.uv.x + _Time.y * _NoiseVelocity.x,o.uv.y + _Time.y * _NoiseVelocity.y);
                float2 animUV = float2(o.uv.x + _UVValue,o.uv.y + _UVValue);
                //float2 noiseUV = float2(o.noiseUV.x,o.noiseUV.y);
                //float2 offsetUV = 
                //o.vertex.xz += abs(cos((worldPosUV + _Time.y * 1)) * _WaveAmp);  //_Time.y * clamp(noiseUV.xy,-2,2)
                //o.vertex.xz += abs(0.1 * cos((worldPosUV.x) + _Time.y * 1) * 0.5);
                //o.vertex.y += abs(1 * cos((worldPosUV.y) + _Time.y * 1));
                float waveX = cos((v.uv0.x + _Time.y * 0.1) * 6.24 * 5);
                float waveY = cos((v.uv0.y + _Time.y * 0.1) * 6.24 * 5);
                float vertexY = (_WaveAmpLeaf * cos((o.uv.y) + _Time.y * 10));
                //o.noiseUV.xy += noiseUV;//(vertexY);
                //o.uv = animUV;
                //o.uv.y += vertexY;
                o.noiseUV.xy = (noiseUV.xy)*_NoiseScale + _NoiseValue;
                //o.uv.x = _NoiseValue;
                o.uv.x += vertexY;
                //o.uv += (waveX * waveY) * (_WaveAmp - 0.05);
                //o.vertex.y += (waveX * waveY) * (_WaveAmp - 0.05); //remove1 of waves
                o.vertex.y += waveX* _WaveAmp; //remove1 of waves
                //o.vertex.xy += (vertexY); //remove1 of waves
                //UNITY_TRANSFER_FOG(o,o.vertex);
                
                //world pos stuff
                //o.worldPosUV.xz += _OffsetWorldPos;//+ _Time.y* _NoiseVelocity;

                //o.vertex = UnityObjectToClipPos(worldPosUV);

                //o.vertex
                //o.vertex += float4(o.worldPosUV.xz,0,1);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;

                //return float4(0.5,0.5,0,1);
                float2 worldSpaceUV = i.worldPosUV.xz;
                //float2 noiseUV = float2(i.noiseUV.x + _Time.y * _NoiseVelocity.x,i.noiseUV.y + _Time.y * _NoiseVelocity.y);
                //return float4(i.noiseUV.xy,0,1);
                
                //float2 worldSpaceUV = i.worldPosUV.xz;
                //worldSpaceUV += abs(0.1 * cos((worldSpaceUV.xy) + _Time.y * 1) * 0.5);
                // sample the texture
                //float2 noiseUV = float2(i.noiseUV.x,i.noiseUV.y);
                
                fixed4 sampleNoise = tex2D(_NoiseTex, i.noiseUV);
                fixed sampleNoiseRONLY = tex2D(_NoiseTex, i.noiseUV).r;
                uv = uv + sampleNoiseRONLY * sin(_Time.y * _NoiseVelocity2) / _DistortionAmount;

                fixed4 sampleNoiseWithWORLDUV = tex2D(_NoiseTex, worldSpaceUV/5);
                //float sampleNoiseWithWORLDUVREDONLY = tex2D(_NoiseTex, worldSpaceUV/5).r;
                //alering wold space uv with noise
                //worldSpaceUV = worldSpaceUV + sampleNoiseWithWORLDUVREDONLY * sin(_Time.y * _NoiseVelocity) / _DistortionAmount;
                
                //return float4(worldSpaceUV,0,1); //show worldspace uv
                //worldSpaceUV
                //return float4(worldSpaceUV,0,1);
                //return sampleNoiseWithWORLDUV;
                //fixed4 sampleNoiseWithUV = tex2D(_NoiseTex, i.uv);
                //return float4(i.uv.xy,0,1); //DISPLAY UV

                //return sampleNoise * float4(i.uv.xy,0,1); //DISPLAY UV

                float vertexY = abs(1 * cos((worldSpaceUV.y) + _Time.y * 1));
                float vertexX = sin((i.uv.y - _Time.y*0.1) * 6.28 * 10) * 0.5 + 0.5;
                fixed4 mainTex = tex2D(_MainTex, uv);
                //fixed4 mainTexFedNoiseWorldUVRED = tex2D(_MainTex, worldSpaceUV);

                clip(mainTex.a - _ClipAmount);
                //return sampleNoiseRONLY;
                //return float4(uv,0,1);
                return mainTex * (_Color * _ColorScale);// * vertexY;

                //return mainTex * sampleNoise;
                

                
                


                //clip(col.a);

                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                //float4 showUV = float4(i.uv.xy,0,1);// i.uv.xy * 2 - 1

                //float4 finalFrag = showUV * sampleNoise;

                //return finalFrag;
                
            }
            ENDCG
        }
    }
}
