// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape Surface Coverage"
{
	Properties
	{
		[Header(MAIN)]_AlbedoTint("Albedo Tint", Color) = (1,1,1,0)
		_AlbedoTexture("Albedo Texture", 2D) = "white" {}
		_NormalTexture("Normal Texture", 2D) = "bump" {}
		_SmoothnessMultiplier("Smoothness Multiplier", Range( -2 , 2)) = 1
		_SmoothnessTexture("Smoothness Texture", 2D) = "white" {}
		_MetallicMultiplier("Metallic Multiplier", Range( 0 , 2)) = 0
		_MetallicTexture("Metallic Texture", 2D) = "black" {}
		_EmissiveMultiplier("Emissive Multiplier", Range( 0 , 20)) = 0
		_EmissiveTexture("Emissive Texture", 2D) = "black" {}
		[Header(GROUND COVERAGE)][Toggle(_GROUNDCOVERON_ON)] _GroundCoverON("Ground Cover ON", Float) = 0
		[Toggle(_BLENDNORMALSON_ON)] _BlendnormalsON("Blend normals ON", Float) = 1
		_CoverageMask("Coverage Mask", 2D) = "white" {}
		_CoverageContrast("Coverage Contrast", Range( 0.1 , 1)) = 0.25
		_CoverageLevel("Coverage Level", Float) = 0
		_CoverageFade("Coverage Fade", Range( -1 , 1)) = 0.5058824
		_CoverageTint("Coverage Tint", Color) = (1,1,1,0)
		_CoverageTexture("Coverage Texture", 2D) = "white" {}
		_CoverageMetallic("Coverage Metallic", Float) = 0
		_CoverageSmoothnessTexture("Coverage Smoothness Texture", 2D) = "white" {}
		_CoverageSmoothnessMultiplier("Coverage Smoothness Multiplier", Range( -2 , 2)) = 1
		_CoverageNormalTexture("Coverage Normal Texture", 2D) = "bump" {}
		_CoverageThickness("Coverage Thickness", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _GROUNDCOVERON_ON
		#pragma shader_feature _BLENDNORMALSON_ON
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _NormalTexture;
		uniform float4 _NormalTexture_ST;
		uniform sampler2D _CoverageNormalTexture;
		uniform float4 _CoverageNormalTexture_ST;
		uniform float _CoverageLevel;
		uniform float _CoverageFade;
		uniform sampler2D _CoverageMask;
		uniform float4 _CoverageMask_ST;
		uniform float _CoverageContrast;
		uniform float _CoverageThickness;
		uniform float4 _AlbedoTint;
		uniform sampler2D _AlbedoTexture;
		uniform float4 _AlbedoTexture_ST;
		uniform float4 _CoverageTint;
		uniform sampler2D _CoverageTexture;
		uniform float4 _CoverageTexture_ST;
		uniform sampler2D _EmissiveTexture;
		uniform float4 _EmissiveTexture_ST;
		uniform float _EmissiveMultiplier;
		uniform sampler2D _MetallicTexture;
		uniform float4 _MetallicTexture_ST;
		uniform float _MetallicMultiplier;
		uniform float _CoverageMetallic;
		uniform sampler2D _SmoothnessTexture;
		uniform float4 _SmoothnessTexture_ST;
		uniform float _SmoothnessMultiplier;
		uniform sampler2D _CoverageSmoothnessTexture;
		uniform float4 _CoverageSmoothnessTexture_ST;
		uniform float _CoverageSmoothnessMultiplier;


		float3 PerturbNormal107_g4( float3 surf_pos, float3 surf_norm, float height, float scale )
		{
			// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
			float3 vSigmaS = ddx( surf_pos );
			float3 vSigmaT = ddy( surf_pos );
			float3 vN = surf_norm;
			float3 vR1 = cross( vSigmaT , vN );
			float3 vR2 = cross( vN , vSigmaS );
			float fDet = dot( vSigmaS , vR1 );
			float dBs = ddx( height );
			float dBt = ddy( height );
			float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
			return normalize ( abs( fDet ) * vN - vSurfGrad );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTexture = i.uv_texcoord * _NormalTexture_ST.xy + _NormalTexture_ST.zw;
			float3 tex2DNode76 = UnpackNormal( tex2D( _NormalTexture, uv_NormalTexture ) );
			float2 uv_CoverageNormalTexture = i.uv_texcoord * _CoverageNormalTexture_ST.xy + _CoverageNormalTexture_ST.zw;
			float3 tex2DNode79 = UnpackNormal( tex2D( _CoverageNormalTexture, uv_CoverageNormalTexture ) );
			#ifdef _BLENDNORMALSON_ON
				float3 staticSwitch80 = BlendNormals( tex2DNode76 , tex2DNode79 );
			#else
				float3 staticSwitch80 = tex2DNode79;
			#endif
			float3 ase_worldPos = i.worldPos;
			float3 surf_pos107_g4 = ase_worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 surf_norm107_g4 = ase_worldNormal;
			float2 uv_CoverageMask = i.uv_texcoord * _CoverageMask_ST.xy + _CoverageMask_ST.zw;
			float saferPower22 = max( ( ( ( ase_worldNormal.y + _CoverageLevel ) * ( _CoverageFade * 5 ) ) + tex2D( _CoverageMask, uv_CoverageMask ).r ) , 0.0001 );
			float vCoverage27 = saturate( pow( saferPower22 , ( _CoverageContrast * 15 ) ) );
			float height107_g4 = ( vCoverage27 * ( _CoverageThickness * 8 ) );
			float scale107_g4 = 1.0;
			float3 localPerturbNormal107_g4 = PerturbNormal107_g4( surf_pos107_g4 , surf_norm107_g4 , height107_g4 , scale107_g4 );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir42_g4 = mul( ase_worldToTangent, localPerturbNormal107_g4);
			float3 lerpResult83 = lerp( tex2DNode76 , BlendNormals( staticSwitch80 , worldToTangentDir42_g4 ) , vCoverage27);
			#ifdef _GROUNDCOVERON_ON
				float3 staticSwitch81 = lerpResult83;
			#else
				float3 staticSwitch81 = tex2DNode76;
			#endif
			float3 vNormal82 = staticSwitch81;
			o.Normal = vNormal82;
			float2 uv_AlbedoTexture = i.uv_texcoord * _AlbedoTexture_ST.xy + _AlbedoTexture_ST.zw;
			float4 temp_output_5_0 = ( _AlbedoTint * tex2D( _AlbedoTexture, uv_AlbedoTexture ) );
			float2 uv_CoverageTexture = i.uv_texcoord * _CoverageTexture_ST.xy + _CoverageTexture_ST.zw;
			float4 lerpResult26 = lerp( temp_output_5_0 , ( _CoverageTint * tex2D( _CoverageTexture, uv_CoverageTexture ) ) , vCoverage27);
			#ifdef _GROUNDCOVERON_ON
				float4 staticSwitch1 = lerpResult26;
			#else
				float4 staticSwitch1 = temp_output_5_0;
			#endif
			o.Albedo = staticSwitch1.rgb;
			float2 uv_EmissiveTexture = i.uv_texcoord * _EmissiveTexture_ST.xy + _EmissiveTexture_ST.zw;
			float4 temp_output_91_0 = ( tex2D( _EmissiveTexture, uv_EmissiveTexture ) * _EmissiveMultiplier );
			float4 temp_cast_1 = (0.0).xxxx;
			float4 lerpResult93 = lerp( temp_output_91_0 , temp_cast_1 , vCoverage27);
			#ifdef _GROUNDCOVERON_ON
				float4 staticSwitch94 = lerpResult93;
			#else
				float4 staticSwitch94 = temp_output_91_0;
			#endif
			float4 vEmissive95 = staticSwitch94;
			o.Emission = vEmissive95.rgb;
			float2 uv_MetallicTexture = i.uv_texcoord * _MetallicTexture_ST.xy + _MetallicTexture_ST.zw;
			float4 temp_output_68_0 = ( tex2D( _MetallicTexture, uv_MetallicTexture ) * _MetallicMultiplier );
			float4 temp_cast_3 = (_CoverageMetallic).xxxx;
			float4 lerpResult69 = lerp( temp_output_68_0 , temp_cast_3 , vCoverage27);
			#ifdef _GROUNDCOVERON_ON
				float4 staticSwitch70 = lerpResult69;
			#else
				float4 staticSwitch70 = temp_output_68_0;
			#endif
			float4 vMetallic72 = staticSwitch70;
			o.Metallic = vMetallic72.r;
			float2 uv_SmoothnessTexture = i.uv_texcoord * _SmoothnessTexture_ST.xy + _SmoothnessTexture_ST.zw;
			float4 temp_output_48_0 = ( ( 1.0 - tex2D( _SmoothnessTexture, uv_SmoothnessTexture ) ) * _SmoothnessMultiplier );
			float2 uv_CoverageSmoothnessTexture = i.uv_texcoord * _CoverageSmoothnessTexture_ST.xy + _CoverageSmoothnessTexture_ST.zw;
			float4 lerpResult52 = lerp( temp_output_48_0 , ( ( 1.0 - tex2D( _CoverageSmoothnessTexture, uv_CoverageSmoothnessTexture ) ) * _CoverageSmoothnessMultiplier ) , vCoverage27);
			#ifdef _GROUNDCOVERON_ON
				float4 staticSwitch49 = lerpResult52;
			#else
				float4 staticSwitch49 = temp_output_48_0;
			#endif
			float4 vSmoothness51 = staticSwitch49;
			o.Smoothness = vSmoothness51.r;
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
				surfIN.worldPos = worldPos;
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
882;203;2845;1556;1044.479;37.57233;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;44;-2418.556,1654.429;Inherit;False;1507.795;709.2714;Coverage masking;13;13;15;19;16;17;18;21;23;20;29;22;24;27;Coverage;0.8867577,0.4719206,0.990566,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;19;-2311.978,1704.429;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;15;-2368.557,1938.452;Inherit;False;Property;_CoverageFade;Coverage Fade;14;0;Create;True;0;0;0;False;0;False;0.5058824;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2320.174,1848.822;Inherit;False;Property;_CoverageLevel;Coverage Level;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;17;-2104.493,1942.329;Inherit;False;5;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-2070.979,1803.731;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1919.815,1803.643;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-2064.882,2047.426;Inherit;True;Property;_CoverageMask;Coverage Mask;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-2043.373,2248.701;Inherit;False;Property;_CoverageContrast;Coverage Contrast;12;0;Create;True;0;0;0;False;0;False;0.25;0;0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-1739.982,1804.727;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;29;-1772.595,2252.498;Inherit;False;15;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;22;-1585.374,1900.701;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;24;-1406.943,1902.471;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;85;-2430.567,301.3229;Inherit;False;1916.161;775.438;Normal map blending;16;107;106;105;104;103;82;81;83;108;84;80;77;76;79;75;78;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;75;-2305.508,351.3229;Inherit;True;Property;_NormalTexture;Normal Texture;2;0;Create;True;0;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-1153.761,1897.814;Inherit;False;vCoverage;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;78;-2348.567,639.6666;Inherit;True;Property;_CoverageNormalTexture;Coverage Normal Texture;20;0;Create;True;0;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;58;-463.6308,1024.188;Inherit;False;1899.281;712.6149;;14;57;54;55;56;53;47;49;52;51;45;46;48;101;102;Smoothness;0.5322179,0.6308727,0.9811321,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-2197.149,969.4607;Inherit;False;Property;_CoverageThickness;Coverage Thickness;21;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;79;-2078.557,637.6957;Inherit;True;Property;_TextureSample6;Texture Sample 6;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;76;-2068.499,351.3519;Inherit;True;Property;_TextureSample5;Texture Sample 5;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;104;-1950.042,864.7107;Inherit;False;27;vCoverage;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;54;-418.631,1464.454;Inherit;True;Property;_CoverageSmoothnessTexture;Coverage Smoothness Texture;18;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;60;-463.8314,496.5164;Inherit;False;1869.741;446.7518;;9;72;70;69;71;68;73;64;66;61;Metallic;1,0.9475542,0.3160377,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;47;-450.8118,1075.188;Inherit;True;Property;_SmoothnessTexture;Smoothness Texture;4;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;96;-463.2606,-46.25594;Inherit;False;1766.723;468.769;;9;92;95;94;93;91;90;88;89;87;Emissive;0.7199869,1,0.4764151,1;0;0
Node;AmplifyShaderEditor.ScaleNode;105;-1909.431,975.1589;Inherit;False;8;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;77;-1726.455,480.3697;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-1722.152,909.4607;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;46;-208.8806,1075.538;Inherit;True;Property;_TextureSample2;Texture Sample 2;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;61;-301.0124,546.515;Inherit;True;Property;_MetallicTexture;Metallic Texture;6;0;Create;True;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;87;-413.2606,3.744072;Inherit;True;Property;_EmissiveTexture;Emissive Texture;8;0;Create;True;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;56;-105.6997,1464.803;Inherit;True;Property;_TextureSample3;Texture Sample 3;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;55;-31.69956,1654.804;Inherit;False;Property;_CoverageSmoothnessMultiplier;Coverage Smoothness Multiplier;19;0;Create;True;0;0;0;False;0;False;1;0;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;80;-1511.342,633.8258;Inherit;False;Property;_BlendnormalsON;Blend normals ON;10;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;False;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-148.3289,199.0939;Inherit;False;Property;_EmissiveMultiplier;Emissive Multiplier;7;0;Create;True;0;0;0;False;0;False;0;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;97;-2414.438,-711.7767;Inherit;False;1530.23;944.2198;Color map blending;11;26;28;5;25;6;2;8;9;3;7;1;Color;0.2311321,1,0.9215065,1;0;0
Node;AmplifyShaderEditor.FunctionNode;107;-1534.716,910.1623;Inherit;False;Normal From Height;-1;;4;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;89;-171.3291,4.094078;Inherit;True;Property;_TextureSample7;Texture Sample 7;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;64;-59.08107,546.8649;Inherit;True;Property;_TextureSample4;Texture Sample 4;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;-36.08094,741.8647;Inherit;False;Property;_MetallicMultiplier;Metallic Multiplier;5;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;102;260.3224,1470.523;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-35.88044,1269.538;Inherit;False;Property;_SmoothnessMultiplier;Smoothness Multiplier;3;0;Create;True;0;0;0;False;0;False;1;0;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;101;125.8173,1080.497;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-1435.211,740.0283;Inherit;False;27;vCoverage;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-2361.934,-478.7767;Inherit;True;Property;_AlbedoTexture;Albedo Texture;1;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;281.1882,1080.188;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;73;277.7107,850.284;Inherit;False;Property;_CoverageMetallic;Coverage Metallic;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;7;-2364.438,-4.250926;Inherit;True;Property;_CoverageTexture;Coverage Texture;16;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;90;181.1511,222.9539;Inherit;False;27;vCoverage;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;168.7398,9.744068;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;92;165.4627,307.5131;Inherit;False;Constant;_CoverageEmissive;Coverage Emissive;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;293.3991,765.7247;Inherit;False;27;vCoverage;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;293.5994,1293.399;Inherit;False;27;vCoverage;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;280.9878,552.515;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;422.369,1471.454;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;108;-1124.013,724.1277;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;83;-1206.406,504.9382;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;6;-2038.934,-661.7767;Inherit;False;Property;_AlbedoTint;Albedo Tint;0;0;Create;True;0;0;0;False;1;Header(MAIN);False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-2042.438,-233.2511;Inherit;False;Property;_CoverageTint;Coverage Tint;15;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;52;703.7872,1218.263;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;69;615.587,718.5897;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;8;-2124.061,-4.206614;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-2121.557,-478.7325;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;93;503.3394,175.8189;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;94;775.7406,5.744071;Inherit;False;Property;_Keyword0;Keyword 0;9;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;1;False;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1706.934,-590.7767;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;70;887.9886,548.515;Inherit;False;Property;_Keyword0;Keyword 0;9;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;1;False;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-1690.682,-400.0293;Inherit;False;27;vCoverage;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1729.249,-152.6632;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;81;-1016.406,358.9385;Inherit;False;Property;_BlendnormalsON;Blend normals ON;9;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Reference;1;False;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;49;953.1889,1077.188;Inherit;False;Property;_Keyword0;Keyword 0;9;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;1;False;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;1215.65,1076.459;Inherit;False;vSmoothness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;1172.711,548.2841;Inherit;False;vMetallic;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;26;-1412.86,-440.4881;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-734.406,357.9385;Inherit;False;vNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;1060.463,5.513175;Inherit;False;vEmissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-621.8444,-234.2803;Inherit;False;51;vSmoothness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-602.3783,-389.7672;Inherit;False;95;vEmissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-592.9684,-310.0176;Inherit;False;72;vMetallic;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-592.2321,-470.4655;Inherit;False;82;vNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;1;-1180.534,-593.0113;Inherit;False;Property;_GroundCoverON;Ground Cover ON;9;0;Create;True;0;0;0;False;1;Header(GROUND COVERAGE);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-288.047,-588.6848;Float;False;True;-1;2;;0;0;Standard;Polyart/Dreamscape Surface Coverage;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;15;0
WireConnection;16;0;19;2
WireConnection;16;1;13;0
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;20;0;18;0
WireConnection;20;1;21;1
WireConnection;29;0;23;0
WireConnection;22;0;20;0
WireConnection;22;1;29;0
WireConnection;24;0;22;0
WireConnection;27;0;24;0
WireConnection;79;0;78;0
WireConnection;76;0;75;0
WireConnection;105;0;103;0
WireConnection;77;0;76;0
WireConnection;77;1;79;0
WireConnection;106;0;104;0
WireConnection;106;1;105;0
WireConnection;46;0;47;0
WireConnection;56;0;54;0
WireConnection;80;1;79;0
WireConnection;80;0;77;0
WireConnection;107;20;106;0
WireConnection;89;0;87;0
WireConnection;64;0;61;0
WireConnection;102;0;56;0
WireConnection;101;0;46;0
WireConnection;48;0;101;0
WireConnection;48;1;45;0
WireConnection;91;0;89;0
WireConnection;91;1;88;0
WireConnection;68;0;64;0
WireConnection;68;1;66;0
WireConnection;57;0;102;0
WireConnection;57;1;55;0
WireConnection;108;0;80;0
WireConnection;108;1;107;40
WireConnection;83;0;76;0
WireConnection;83;1;108;0
WireConnection;83;2;84;0
WireConnection;52;0;48;0
WireConnection;52;1;57;0
WireConnection;52;2;53;0
WireConnection;69;0;68;0
WireConnection;69;1;73;0
WireConnection;69;2;71;0
WireConnection;8;0;7;0
WireConnection;2;0;3;0
WireConnection;93;0;91;0
WireConnection;93;1;92;0
WireConnection;93;2;90;0
WireConnection;94;1;91;0
WireConnection;94;0;93;0
WireConnection;5;0;6;0
WireConnection;5;1;2;0
WireConnection;70;1;68;0
WireConnection;70;0;69;0
WireConnection;25;0;9;0
WireConnection;25;1;8;0
WireConnection;81;1;76;0
WireConnection;81;0;83;0
WireConnection;49;1;48;0
WireConnection;49;0;52;0
WireConnection;51;0;49;0
WireConnection;72;0;70;0
WireConnection;26;0;5;0
WireConnection;26;1;25;0
WireConnection;26;2;28;0
WireConnection;82;0;81;0
WireConnection;95;0;94;0
WireConnection;1;1;5;0
WireConnection;1;0;26;0
WireConnection;0;0;1;0
WireConnection;0;1;86;0
WireConnection;0;2;98;0
WireConnection;0;3;74;0
WireConnection;0;4;59;0
ASEEND*/
//CHKSM=96E971001484C3FADE2325E0EED85BFD0F04F0F9