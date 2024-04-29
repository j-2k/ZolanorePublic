Shader "Custom/SS_DistortionWater"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        [NoScaleOffset] _FlowMap ("Flow (RG, A noise)", 2D) = "black" {}
        //[NoScaleOffset] _NormalMap ("Normals", 2D) = "bump" {}
        [NoScaleOffset] _DerivHeightMap ("Deriv (AG) Height (B)", 2D) = "black" {}
        _HeightScale ("Height Scale, Constant", Float) = 0.25
		_HeightScaleModulated ("Height Scale, Modulated", Float) = 0.75
        _UJump ("U jump per phase", Range(-0.25, 0.25)) = 0.25
		_VJump ("V jump per phase", Range(-0.25, 0.25)) = 0.25
        _Tiling("Tiling Texture", Float) = 1
        _Speed("Speed Texture", Float) = 1
        _FlowStrength ("Flow Strength", Float) = 1
        _FlowOffset ("Flow Offset", Float) = 0
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        ZWrite On
        Blend SrcAlpha OneMinusSrcAlpha
        Tags 
        { 
            "RenderType"="Transparent"
            "Queue"="Geometry"
        }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
        
        #include "Flow.cginc"

        sampler2D _MainTex, _FlowMap, _DerivHeightMap;
        float _UJump, _VJump, _Tiling, _Speed, _FlowStrength, _FlowOffset, _HeightScale, _HeightScaleModulated;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)
        
        float3 UnpackDerivativeHeight (float4 textureData) {
			float3 dh = textureData.agb;
			dh.xy = dh.xy * 2 - 1;
			return dh;
		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            //float2 flowmapVector = tex2D(_FlowMap,IN.uv_MainTex).rg * 2 - 1;
			float3 flowmapVector = tex2D(_FlowMap, IN.uv_MainTex).rgb;
			flowmapVector.xy = flowmapVector.xy * 2 - 1;
			flowmapVector *= _FlowStrength;

            float noise = tex2D(_FlowMap, IN.uv_MainTex).a;
            float time = _Time.y * _Speed + noise;
            float2 jump = float2(_UJump, _VJump);

            float3 uvwA = FlowUVW(IN.uv_MainTex, flowmapVector.xy, jump,_FlowOffset, _Tiling, time, false);
            float3 uvwB = FlowUVW(IN.uv_MainTex, flowmapVector.xy, jump,_FlowOffset, _Tiling, time, true);

            //float3 normalA = UnpackNormal(tex2D(_NormalMap, uvwA.xy)) * uvwA.z;
			//float3 normalB = UnpackNormal(tex2D(_NormalMap, uvwB.xy)) * uvwB.z;
			//o.Normal = normalize(normalA + normalB);

            float finalHeightScale = flowmapVector.z * _HeightScaleModulated + _HeightScale;

			float3 dhA = UnpackDerivativeHeight(tex2D(_DerivHeightMap, uvwA.xy)) * (uvwA.z * finalHeightScale);
			float3 dhB = UnpackDerivativeHeight(tex2D(_DerivHeightMap, uvwB.xy)) * (uvwB.z * finalHeightScale);
			o.Normal = normalize(float3(-(dhA.xy + dhB.xy), 1));

            float4 texA = tex2D(_MainTex, uvwA.xy) * uvwA.z;
            float4 texB = tex2D(_MainTex, uvwB.xy) * uvwB.z;

			fixed4 c = (texA + texB) * _Color;

            o.Albedo = c.rgb;
            //o.Albedo = float3(flowmapVector, 0);
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
