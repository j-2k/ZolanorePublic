// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Dreamscape_WorldAlignedBlend"
{
	Properties
	{
		_StoneTexture("Stone Texture", 2D) = "white" {}
		_DirtTexture("Dirt Texture", 2D) = "white" {}
		_GrassTexture("Grass Texture", 2D) = "white" {}
		_StoneDirtSharpness("Stone Dirt Sharpness", Float) = 0
		_StoneDirtBias("Stone Dirt Bias", Float) = 0
		_GrassSharpness("Grass Sharpness", Float) = 0
		_GrassBias("Grass Bias", Float) = 0
		_NormalTexture("Normal Texture", 2D) = "bump" {}
		_Normal("Normal", Range( 0 , 1)) = 1
		_SmoothnessTexture("Smoothness Texture", 2D) = "white" {}
		_SmoothnessMultiplier("Smoothness Multiplier", Range( -2 , 2)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _NormalTexture;
		uniform float4 _NormalTexture_ST;
		uniform float _Normal;
		uniform sampler2D _StoneTexture;
		uniform float4 _StoneTexture_ST;
		uniform sampler2D _DirtTexture;
		uniform float4 _DirtTexture_ST;
		uniform float _StoneDirtSharpness;
		uniform float _StoneDirtBias;
		uniform sampler2D _GrassTexture;
		uniform float4 _GrassTexture_ST;
		uniform float _GrassSharpness;
		uniform float _GrassBias;
		uniform sampler2D _SmoothnessTexture;
		uniform float4 _SmoothnessTexture_ST;
		uniform float _SmoothnessMultiplier;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTexture = i.uv_texcoord * _NormalTexture_ST.xy + _NormalTexture_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _NormalTexture, uv_NormalTexture ), _Normal );
			float2 uv_StoneTexture = i.uv_texcoord * _StoneTexture_ST.xy + _StoneTexture_ST.zw;
			float2 uv_DirtTexture = i.uv_texcoord * _DirtTexture_ST.xy + _DirtTexture_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 normalizeResult44_g3 = normalize( float3(0,1,0) );
			float dotResult45_g3 = dot( ase_normWorldNormal , normalizeResult44_g3 );
			float temp_output_67_0_g3 = _StoneDirtSharpness;
			float temp_output_68_0_g3 = _StoneDirtBias;
			float clampResult41_g3 = clamp( ( ( ( ( dotResult45_g3 * 0.5 ) + 0.5 ) * temp_output_67_0_g3 ) + ( temp_output_68_0_g3 - ( temp_output_67_0_g3 * 0.5 ) ) ) , 0.0 , 1.0 );
			float4 lerpResult13 = lerp( tex2D( _StoneTexture, uv_StoneTexture ) , tex2D( _DirtTexture, uv_DirtTexture ) , clampResult41_g3);
			float2 uv_GrassTexture = i.uv_texcoord * _GrassTexture_ST.xy + _GrassTexture_ST.zw;
			float3 normalizeResult44_g4 = normalize( float3(0,1,0) );
			float dotResult45_g4 = dot( ase_normWorldNormal , normalizeResult44_g4 );
			float temp_output_67_0_g4 = _GrassSharpness;
			float temp_output_68_0_g4 = _GrassBias;
			float clampResult41_g4 = clamp( ( ( ( ( dotResult45_g4 * 0.5 ) + 0.5 ) * temp_output_67_0_g4 ) + ( temp_output_68_0_g4 - ( temp_output_67_0_g4 * 0.5 ) ) ) , 0.0 , 1.0 );
			float4 lerpResult34 = lerp( lerpResult13 , tex2D( _GrassTexture, uv_GrassTexture ) , clampResult41_g4);
			o.Albedo = lerpResult34.rgb;
			float2 uv_SmoothnessTexture = i.uv_texcoord * _SmoothnessTexture_ST.xy + _SmoothnessTexture_ST.zw;
			o.Smoothness = ( ( 1.0 - tex2D( _SmoothnessTexture, uv_SmoothnessTexture ) ) * _SmoothnessMultiplier ).r;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18800
882;203;2845;1556;2968.116;302.2629;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;29;-2227.72,25.63428;Inherit;False;Property;_StoneDirtSharpness;Stone Dirt Sharpness;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2182.728,101.5227;Inherit;False;Property;_StoneDirtBias;Stone Dirt Bias;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;41;-1779.408,776.223;Inherit;True;Property;_SmoothnessTexture;Smoothness Texture;9;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;36;-1903.741,286.7571;Inherit;False;Property;_GrassSharpness;Grass Sharpness;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1863.749,399.6456;Inherit;False;Property;_GrassBias;Grass Bias;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;31;-1978.748,28.09131;Inherit;False;PolyartWorldAlignedBlend;-1;;3;2c0b2e018c1710b44867976bd3691e95;0;3;1;FLOAT3;0,0,1;False;67;FLOAT;1;False;68;FLOAT;-1;False;2;FLOAT;25;FLOAT;55
Node;AmplifyShaderEditor.SamplerNode;15;-1846.079,-164.8248;Inherit;True;Property;_DirtTexture;Dirt Texture;1;0;Create;True;0;0;0;False;0;False;-1;16c8b94f60a47124ea195518467ad3cf;db2385b3790267144af08a3bb4d8a92b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-1846.92,-358.905;Inherit;True;Property;_StoneTexture;Stone Texture;0;0;Create;True;0;0;0;False;0;False;-1;21a72e9bfc1f0594fba8d2535f24fa37;21a72e9bfc1f0594fba8d2535f24fa37;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;42;-1520.777,779.173;Inherit;True;Property;_TextureSample3;Texture Sample 3;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-1506.477,974.5735;Inherit;False;Property;_SmoothnessMultiplier;Smoothness Multiplier;10;0;Create;True;0;0;0;False;0;False;1;0;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;32;-1779.531,492.6242;Inherit;True;Property;_NormalTexture;Normal Texture;7;0;Create;True;0;0;0;False;0;False;-1;66d3b8c174ac6d0448d6cb2d00f9d659;db2385b3790267144af08a3bb4d8a92b;True;0;True;bump;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;35;-1446.437,132.9181;Inherit;True;Property;_GrassTexture;Grass Texture;2;0;Create;True;0;0;0;False;0;False;-1;db2385b3790267144af08a3bb4d8a92b;db2385b3790267144af08a3bb4d8a92b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;13;-1443.355,-109.5932;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1757.244,682.2127;Inherit;False;Property;_Normal;Normal;8;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;33;-1579.572,321.9863;Inherit;False;PolyartWorldAlignedBlend;-1;;4;2c0b2e018c1710b44867976bd3691e95;0;3;1;FLOAT3;0,0,1;False;67;FLOAT;1;False;68;FLOAT;-1;False;2;FLOAT;25;FLOAT;55
Node;AmplifyShaderEditor.OneMinusNode;45;-1214.953,784.6169;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;39;-1386.544,499.4127;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1045.009,785.7229;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;34;-928.192,113.4975;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-631.3055,115.9967;Float;False;True;-1;2;;0;0;Standard;Dreamscape_WorldAlignedBlend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;67;29;0
WireConnection;31;68;30;0
WireConnection;42;0;41;0
WireConnection;13;0;14;0
WireConnection;13;1;15;0
WireConnection;13;2;31;25
WireConnection;33;67;36;0
WireConnection;33;68;37;0
WireConnection;45;0;42;0
WireConnection;39;0;32;0
WireConnection;39;1;40;0
WireConnection;44;0;45;0
WireConnection;44;1;43;0
WireConnection;34;0;13;0
WireConnection;34;1;35;0
WireConnection;34;2;33;25
WireConnection;0;0;34;0
WireConnection;0;1;39;0
WireConnection;0;4;44;0
ASEEND*/
//CHKSM=D625EF07F1CE50521FDD7186682F2576DED667BE