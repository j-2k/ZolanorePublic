Shader "Custom/SSS_WaterTest"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Amplitude ("_Amplitude", float) = 1
        _SlopeLength ("_SlopeLength", float) = 1
        _Frequency ("_Frequency", float) = 1
        _AnimationSpeed ("_AnimationSpeed", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows addshadow vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        float _Amplitude;
        float _SlopeLength;
        float _Frequency;
        float _AnimationSpeed;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void vert (inout appdata_full data)
        {
            
            float4 modifiedPos = data.vertex;
            modifiedPos.y += sin(data.vertex.x * _Frequency + _Time.y * _AnimationSpeed) * _Amplitude;
            data.vertex = modifiedPos;
            

            /*
            float4 modifiedPos = data.vertex;
            modifiedPos.y += sin((data.vertex.x/_SlopeLength) * _Frequency + _Time.y * _AnimationSpeed) * _Amplitude;// * sin(10/_SlopeLength);

            float3 posPlusTangent = data.vertex + data.tangent * 0.01;
            posPlusTangent.y += sin((posPlusTangent.x/_SlopeLength) * _Frequency + _Time.y * _AnimationSpeed) * _Amplitude;

            float3 bitangent = cross(data.normal, data.tangent);
            float3 posPlusBitangent = data.vertex + bitangent * 0.01;
            posPlusBitangent.y += sin((posPlusBitangent.x/_SlopeLength) * _Frequency + _Time.y * _AnimationSpeed) * _Amplitude;

            float3 modifiedTangent = posPlusTangent - modifiedPos;
            float3 modifiedBitangent = posPlusBitangent - modifiedPos;

            float3 modifiedNormal = cross(modifiedTangent,modifiedBitangent);
            data.normal = normalize(modifiedNormal);
            data.vertex = modifiedPos;
            */
            
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
