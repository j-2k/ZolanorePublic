Shader "Custom/SSS_Juma_Leaf"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _ColorScale("Color Multiplier", Range(0,10)) = 1
        _ClipAmount("Clip Amount", Range(0, 1)) = 0.01
        _UV_Leaf_Speed("Leaf Wiggle Speed", Vector) = (10, 10, 0, 0)
        _WaveAmpLeaf("Wave Amp Leaf", Range(-1,1)) = 0.01

        _NoiseTex("Noise Texture", 2D) = "white" {}
        _NoiseVelocity("Noise Velocity", Vector) = (0.5, 0.5, 0, 0)
        _NoiseScale("NoiseScale",Range(0.01,5)) = 1

        _WaveAmpVertex("Wave Amp Vertex", Range(-1,1)) = 0.01

        _DistortionAmount("Distortion Reduction",Range(1,100)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="TransparentCutout"}
        LOD 200

        Cull Off

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surfaceFunction Lambert addshadow vertex:v2f
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NoiseTex;

        struct Input
        {
            float2 uv_MainTex : TEXCOORD0;
            float2 worldPosUV : TEXCOORD1;
            float3 worldPos : POSITION;
            
        };

        fixed4 _Color;
        fixed _ClipAmount;
        fixed _ColorScale;

        float2 _NoiseVelocity;
        float _NoiseScale;
        float2 _UV_Leaf_Speed;

        float _WaveAmpVertex;
        float _WaveAmpLeaf;
        float _DistortionAmount;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void v2f(inout appdata_full v, out Input o) 
        {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            o.worldPos = mul(unity_ObjectToWorld, v.vertex);
            float2 worldUVScrollXZ = float2(o.worldPos.x + _Time.y * _NoiseVelocity.x,o.worldPos.z + _Time.y * _NoiseVelocity.y);//normalize(_NoiseVelocity.x) * windspeed
            o.worldPosUV = worldUVScrollXZ * _NoiseScale;

            float vertexY = (_WaveAmpLeaf * cos((o.uv_MainTex.y) + _Time.y * 10));
            float waveX = cos((v.texcoord.x + _Time.y * 0.1) * 6.24 * 5);
            v.texcoord.x += vertexY;
            v.vertex.y += waveX * _WaveAmpVertex;
        }


        void surfaceFunction (Input IN, inout SurfaceOutput o)
        {
            fixed sampleNoiseWorldUV = tex2D (_NoiseTex, IN.worldPosUV).r;
            float2 leafuv = IN.uv_MainTex;
            leafuv = leafuv + sampleNoiseWorldUV * sin(_Time.y * _UV_Leaf_Speed) / _DistortionAmount;
            fixed4 sampleLeaf = tex2D (_MainTex, leafuv) * (_Color * _ColorScale);
            clip(sampleLeaf.a - _ClipAmount);
            o.Albedo = sampleLeaf.rgb;
            o.Alpha = sampleLeaf.a;
        }
        //SURFACE OUTPUT STRUCT
        /*
        struct SurfaceOutput
        {
            fixed3 Albedo;  // diffuse color
            fixed3 Normal;  // tangent space normal, if written
            fixed3 Emission;
            half Specular;  // specular power in 0..1 range
            fixed Gloss;    // specular intensity
            fixed Alpha;    // alpha for transparencies
        };
        */

        // INPUT STRUCT
        /*
        Surface Shader input structure
        The input structure Input generally has any texture coordinates needed by the shader. Texture coordinates must be named “uv” followed by texture name (or start it with “uv2” to use second texture coordinate set).

        Additional values that can be put into Input structure:

        float3 viewDir - contains view direction, for computing Parallax effects, rim lighting etc.
        float4 with COLOR semantic - contains interpolated per-vertex color.
        float4 screenPos - contains screen space position for reflection or screenspace effects. Note that this is not suitable for GrabPass; you need to compute custom UV yourself using ComputeGrabScreenPos function.
        float3 worldPos - contains world space position.
        float3 worldRefl - contains world reflection vector if surface shader does not write to o.Normal. See Reflect-Diffuse shader for example.
        float3 worldNormal - contains world normal vector if surface shader does not write to o.Normal.
        float3 worldRefl; INTERNAL_DATA - contains world reflection vector if surface shader writes to o.Normal. To get the reflection vector based on per-pixel normal map
        , use WorldReflectionVector (IN, o.Normal). See Reflect-Bumped shader for example.
        float3 worldNormal; INTERNAL_DATA - contains world normal vector if surface shader writes to o.Normal. To get the normal vector based on per-pixel normal map, use WorldNormalVector (IN, o.Normal).
        */
        ENDCG
    }
    FallBack "Diffuse"
}
