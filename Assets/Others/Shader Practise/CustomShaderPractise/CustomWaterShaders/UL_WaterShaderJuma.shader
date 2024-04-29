Shader "Unlit/UL_WaterShaderJuma"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _NormalMap("Normal Texture", 2D) = "bump" {}
        _BumpScale("Bump Scale", Float) = 1

        _DepthGradientShallow("Depth Gradient Shallow", Color) = (0.325, 0.807, 0.971, 0.725)
        _DepthGradientDeep("Depth Gradient Deep", Color) = (0.086, 0.407, 1, 0.749)
        _DepthMaxDistance("Depth Maximum Distance", Float) = 1

        _SurfaceNoise("Surface Noise", 2D) = "white" {}
        _SurfaceNoiseScroll("Surface Noise Scroll Amount", Vector) = (0.05,0.05,0,0)
        _SurfaceNoiseCutoff("_SurfaceNoiseCutoff", Float) = 0.5
        _ShoreWidth("Shore Width", Float) = 1
        _ShoreColor("Shore Color", Color) = (1,1,1,1)
        
        _WaveNoise("_WaveNoise", 2D) = "white" {}
        _WaveNoiseScroll("Wave Noise Scroll Amount", Vector) = (0.05,0.05,0,0)

        _Amplitude("Amplitude", Float) = 1
        _SlopeLength("SlopeLength", Float) = 1


        _Smoothness("Specular Smoothness", Range(0,10)) = 1
        _SpecularColor("Specular Color", Color) = (1,1,1,1)

       _SpecularAlpha("_SpecularAlpha", Float) = 1
    }
    SubShader
    {
        Tags 
        { 
            "Queue"="Transparent"
            //"Queue" = "Geometry"
			"LightMode" = "ForwardBase"
		}
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            //#pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityStandardBRDF.cginc"
            #include "UnityStandardUtils.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 noiseUV : TEXCOORD1;
                float4 screenPosition : TEXCOORD2;
                float3 normal : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
                float2 normalUV : TEXCOORD5;
                float2 noiseWaveUV : TEXCOORD6;

                //UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _CameraDepthTexture;

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _NormalMap;
            float4 _NormalMap_ST;

            float _BumpScale;

            sampler2D _SurfaceNoise;
            float4 _SurfaceNoise_ST;

            sampler2D _WaveNoise;
            float4 _WaveNoise_ST;
            float2 _WaveNoiseScroll;

            float4 _DepthGradientShallow;
            float4 _DepthGradientDeep;
            float _DepthMaxDistance;

            float _ShoreWidth;
            float4 _ShoreColor;
            float _SurfaceNoiseCutoff;

            float2 _SurfaceNoiseScroll;
            float _Amplitude;
            float _SlopeLength;
            float _Smoothness;
            float4 _SpecularColor;
            float _SpecularAlpha;



            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.noiseUV = TRANSFORM_TEX(v.uv, _SurfaceNoise);
                o.normalUV = TRANSFORM_TEX(v.uv, _NormalMap);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.screenPosition = ComputeScreenPos(o.vertex);
                o.noiseWaveUV = TRANSFORM_TEX(v.uv, _WaveNoise);

                //UNITY_TRANSFER_FOG(o,o.vertex);

                float2 worldnoiseWaveUVScroll = float2(o.worldPos.x + _Time.y * _WaveNoiseScroll.x,o.worldPos.z + _Time.y * _WaveNoiseScroll.y);//normalize(_NoiseVelocity.x) * windspeed
                //worldnoiseWaveUVScroll *= scale;

                float sampleNoiseRONLY = tex2Dlod(_WaveNoise, float4(worldnoiseWaveUVScroll,0,0)).r;

                float wave1 = sampleNoiseRONLY * sin(((v.uv.x + _Time.y * 0.1) * 6.24 * 5)/_SlopeLength);// *_Time.y * 1;
                float wave2 = sampleNoiseRONLY * sin(((v.uv.y + _Time.y * 0.1) * 6.24 * 5)/_SlopeLength);// *_Time.y * 1;
                float combinedWaves = wave1 * wave2 * _Amplitude;
                o.vertex.y += combinedWaves;


                //float waveOffset = 

                //uv = uv + sampleNoiseRONLY * sin(_Time.y * _NoiseVelocity2) / _DistortionAmount;

                //o.vertex.y += _Amplitude * sin(2 * _Time.y/_SlopeLength);
                return o;
            }



            void InitializeFragmentNormals(inout v2f i)
            {
                //i.normal = UnpackScaleNormal(tex2D(_NormalMap, i.uv), _BumpScale);
                //i.normal = i.normal.xzy;

                i.normal = i.normal.xyz;
                i.normal = normalize(i.normal);
            }

            float3 calculateSpecularLightBP(float3 normal, float smoothness, float3 worldPos)
            {
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 viewDir = normalize(_WorldSpaceCameraPos - worldPos);
                float3 halfVector = normalize(lightDir + viewDir);

				
                float3 lightColor = _LightColor0.rgb;
                float3 diffuse = lightColor * DotClamped(lightDir, normal);

				float3 specular = _SpecularColor.rgb * pow(
					DotClamped(halfVector, normal),
					smoothness * 100
				);
                
                return specular;
                //float specularIntensitySS = smoothstep(0.1,0.5, specular);
                //return specularIntensitySS;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                InitializeFragmentNormals(i);


                //Specular
                float4 specular = float4(calculateSpecularLightBP(i.normal, _Smoothness, i.worldPos),_SpecularAlpha);
                //SpecularSteps
                /*
                float specHighlight = 0;

                specHighlight += (specular > 0.7) * 1.0;
                specHighlight += (specular > 0.35) * 0.4;
                specHighlight += (specular > 0.1) * 0.1;

                watercolor += specHighlight;

                return specHighlight;
                */


                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                float2 noiseUV = float2(i.noiseUV.x + _Time.y * _SurfaceNoiseScroll.x, i.noiseUV.y + _Time.y * _SurfaceNoiseScroll.y);
                float surfaceNoiseSample = tex2D(_SurfaceNoise, noiseUV).r;
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                float existingDepth01 = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPosition)).r;
                float existingDepthLinear = LinearEyeDepth(existingDepth01);

                float depthDifference = existingDepthLinear - i.screenPosition.w;

                float waterDepthDifference01 = saturate(depthDifference/_DepthMaxDistance);
                float4 waterColor = lerp(_DepthGradientShallow,_DepthGradientDeep,waterDepthDifference01);


                float shoreLineDepthDifference01 = saturate(depthDifference/_ShoreWidth);
                float surfaceNoiseCutoff = shoreLineDepthDifference01 * _SurfaceNoiseCutoff;
                float surfaceNoise = surfaceNoiseSample > surfaceNoiseCutoff ? 1 : 0;
                
                //float4 shoreOnly = lerp(surfaceNoise,float4(surfaceNoise.xxx,0),shoreLineDepthDifference01);
                
                //float4 shoreLine = 1 - saturate(_ShoreWidth * (existingDepthLinear - i.screenPosition.w));

                //col += shoreLine * _ShoreColor;
                
                //return float4(specular,_SpecularAlpha);

                //waterColor += float4(specularIntensitySS,1);
                waterColor += specular;
                float4 final = ((waterColor + surfaceNoise) + col);
                return final;// * shoreLine;
            }
            ENDCG
        }
    }
}
