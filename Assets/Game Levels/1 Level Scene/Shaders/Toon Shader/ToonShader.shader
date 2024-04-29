Shader "Custom/ToonShader"
{
    Properties
    {
        _EmissionMap ("Emission Map", 2D) = "black" {}
        [HDR] _EmissionColor ("Emission Color", Color) = (0,0,0)

        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
        [HDR]
        _AmbientColor("Ambient Color", Color) = (0.4,0.4,0.4,1)
        [HDR]
        _SpecularColor("Specular Color", Color) = (0.9,0.9,0.9,1)
        _Glossiness("Glossiness", Float) = 32
        [HDR]
        _RimColor("Rim Color", Color) = (1,1,1,1)
        _RimAmount("Rim Amount", Range(0, 1)) = 0.716
        _RimThreshold("Rim Threshold", Range(0, 1)) = 0.1
    }
    SubShader
    {
        Pass
        {
            Tags 
            {
                "LightMode" = "ForwardBase"
                "PassFlags" = "OnlyDirectional"
            }
            //LOD 100

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            // make fog work
            //#pragma multi_compile_fog

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
                float4 pos : SV_POSITION;
                float3 worldNormal : NORMAL;
                float2 uv : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
                //UNITY_FOG_COORDS(1)
                SHADOW_COORDS(2)
            };

            sampler2D _EmissionMap;
            float4 _EmissionColor;

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _Color;
            float4 _AmbientColor;

            float _Glossiness;
            float4 _SpecularColor;

            float4 _RimColor;
            float _RimAmount;  
            float _RimThreshold; 

            v2f vert (appdata v)
            {
                v2f o;
                //o.vertex clashing with usepass???
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                //specular reflection
                o.viewDir = WorldSpaceViewDir(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_SHADOW(o)
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.worldNormal);
                //specular reflection
                float3 viewDir = normalize(i.viewDir);

                
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                float NdotL = dot(_WorldSpaceLightPos0, normal); //dot 1 to -1 / 1 to 0 lit / 0 to -1 dark
                
                float shadow = SHADOW_ATTENUATION(i);

                //float lightIntensity = NdotL > 0 ? 1 : 0; //if NdotL > 0 true = 1 else 0
                float lightIntensity = smoothstep(0,0.01f, NdotL * shadow);
                float4 light = lightIntensity * _LightColor0;


                float3 halfVector = normalize(_WorldSpaceLightPos0 + viewDir);
                float NdotH = dot(normal, halfVector);

                float specularIntensity = pow(NdotH * lightIntensity, _Glossiness * _Glossiness);

                float specularIntensitySmooth = smoothstep(0.005,0.01, specularIntensity);

                float4 specular = specularIntensitySmooth * _SpecularColor;

                float4 rimDot = 1- dot(viewDir, normal); 

                float rimIntensity = rimDot * pow(NdotL, _RimThreshold);
                rimIntensity = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, rimIntensity);
                float4 rim = rimIntensity * _RimColor;

                //float4 finalLightCalculation = (_AmbientColor + light + specular + rim);
                
                // sample the texture
                fixed4 texSample = tex2D(_MainTex, i.uv);

                half4 emission = tex2D(_EmissionMap, i.uv) * _EmissionColor;

                return  (texSample + emission) * _Color * (_AmbientColor + light + specular + rim);
            }
            ENDCG
        }

        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
