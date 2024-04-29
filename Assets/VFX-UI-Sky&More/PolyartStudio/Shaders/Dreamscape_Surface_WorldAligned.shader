// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape Surface World Aligned"
{
	Properties
	{
		_AlbedoTexture("Albedo Texture", 2D) = "white" {}
		[Normal]_NormalTexture("Normal Texture", 2D) = "bump" {}
		_RoughnessTexture("Roughness Texture", 2D) = "white" {}
		_Tiling("Tiling", Float) = 1
		_NormalIntensity("Normal Intensity", Range( 0 , 1)) = 1
		_SmoothnessIntensity("Smoothness Intensity", Range( -1 , 1)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "NatureRendererInstancing"="True" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#include "Assets/Visual Design Cafe/Nature Shaders/Common/Nodes/Integrations/Nature Renderer.cginc"
		#pragma instancing_options procedural:SetupNatureRenderer
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float vertexToFrag29_g16;
			float vertexToFrag31_g16;
			float vertexToFrag29_g17;
			float vertexToFrag31_g17;
			float vertexToFrag29_g15;
			float vertexToFrag31_g15;
		};

		uniform sampler2D _NormalTexture;
		uniform float _Tiling;
		uniform float _NormalIntensity;
		uniform sampler2D _AlbedoTexture;
		uniform sampler2D _RoughnessTexture;
		uniform float _SmoothnessIntensity;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			o.vertexToFrag29_g16 = ase_worldNormal.x;
			o.vertexToFrag31_g16 = ase_worldNormal.z;
			o.vertexToFrag29_g17 = ase_worldNormal.x;
			o.vertexToFrag31_g17 = ase_worldNormal.z;
			o.vertexToFrag29_g15 = ase_worldNormal.x;
			o.vertexToFrag31_g15 = ase_worldNormal.z;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 break9_g16 = ( ase_worldPos * ( abs( _Tiling ) * -1.0 ) );
			float2 appendResult12_g16 = (float2(break9_g16.x , break9_g16.z));
			float2 XZ_Coord13_g16 = appendResult12_g16;
			float4 XZ_Texture21_g16 = tex2D( _NormalTexture, XZ_Coord13_g16 );
			float2 appendResult14_g16 = (float2(break9_g16.y , break9_g16.z));
			float2 YZ_Coord15_g16 = appendResult14_g16;
			float4 YZ_Texture23_g16 = tex2D( _NormalTexture, YZ_Coord15_g16 );
			float4 lerpResult33_g16 = lerp( XZ_Texture21_g16 , YZ_Texture23_g16 , abs( i.vertexToFrag29_g16 ));
			float2 appendResult10_g16 = (float2(break9_g16.x , break9_g16.y));
			float2 XY_Coord11_g16 = appendResult10_g16;
			float4 XY_Texture19_g16 = tex2D( _NormalTexture, XY_Coord11_g16 );
			float4 lerpResult36_g16 = lerp( lerpResult33_g16 , XY_Texture19_g16 , abs( i.vertexToFrag31_g16 ));
			o.Normal = UnpackScaleNormal( lerpResult36_g16, _NormalIntensity );
			float3 break9_g17 = ( ase_worldPos * ( abs( _Tiling ) * -1.0 ) );
			float2 appendResult12_g17 = (float2(break9_g17.x , break9_g17.z));
			float2 XZ_Coord13_g17 = appendResult12_g17;
			float4 XZ_Texture21_g17 = tex2D( _AlbedoTexture, XZ_Coord13_g17 );
			float2 appendResult14_g17 = (float2(break9_g17.y , break9_g17.z));
			float2 YZ_Coord15_g17 = appendResult14_g17;
			float4 YZ_Texture23_g17 = tex2D( _AlbedoTexture, YZ_Coord15_g17 );
			float4 lerpResult33_g17 = lerp( XZ_Texture21_g17 , YZ_Texture23_g17 , abs( i.vertexToFrag29_g17 ));
			float2 appendResult10_g17 = (float2(break9_g17.x , break9_g17.y));
			float2 XY_Coord11_g17 = appendResult10_g17;
			float4 XY_Texture19_g17 = tex2D( _AlbedoTexture, XY_Coord11_g17 );
			float4 lerpResult36_g17 = lerp( lerpResult33_g17 , XY_Texture19_g17 , abs( i.vertexToFrag31_g17 ));
			o.Albedo = lerpResult36_g17.rgb;
			float3 break9_g15 = ( ase_worldPos * ( abs( _Tiling ) * -1.0 ) );
			float2 appendResult12_g15 = (float2(break9_g15.x , break9_g15.z));
			float2 XZ_Coord13_g15 = appendResult12_g15;
			float4 XZ_Texture21_g15 = tex2D( _RoughnessTexture, XZ_Coord13_g15 );
			float2 appendResult14_g15 = (float2(break9_g15.y , break9_g15.z));
			float2 YZ_Coord15_g15 = appendResult14_g15;
			float4 YZ_Texture23_g15 = tex2D( _RoughnessTexture, YZ_Coord15_g15 );
			float4 lerpResult33_g15 = lerp( XZ_Texture21_g15 , YZ_Texture23_g15 , abs( i.vertexToFrag29_g15 ));
			float2 appendResult10_g15 = (float2(break9_g15.x , break9_g15.y));
			float2 XY_Coord11_g15 = appendResult10_g15;
			float4 XY_Texture19_g15 = tex2D( _RoughnessTexture, XY_Coord11_g15 );
			float4 lerpResult36_g15 = lerp( lerpResult33_g15 , XY_Texture19_g15 , abs( i.vertexToFrag31_g15 ));
			o.Smoothness = ( ( 1.0 - lerpResult36_g15 ) * _SmoothnessIntensity ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18800
882;203;2845;1556;5837.981;762.0314;1.850619;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;101;-3954.886,782.42;Inherit;True;Property;_RoughnessTexture;Roughness Texture;2;0;Create;True;0;0;0;False;0;False;27df379498a773a4abdf1795b2d01bd5;2629a988a9ded7e46b01c37f62fe801d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;91;-4222.14,546.9656;Inherit;False;Property;_Tiling;Tiling;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;96;-3948.405,523.949;Inherit;True;Property;_NormalTexture;Normal Texture;1;1;[Normal];Create;True;0;0;0;False;0;False;b7f4798948b6337489969d4a8ed40732;2629a988a9ded7e46b01c37f62fe801d;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;107;-3566.886,787.42;Inherit;False;PolyartWorldAlignedTexture;-1;;15;50170ee3abb6acd4fb2e1a9c8b24ec90;0;3;1;SAMPLER2D;0,0,0,0;False;2;FLOAT;1;False;4;FLOAT3;0,0,0;False;4;COLOR;0;COLOR;26;COLOR;27;COLOR;25
Node;AmplifyShaderEditor.TexturePropertyNode;55;-3942.295,245.9384;Inherit;True;Property;_AlbedoTexture;Albedo Texture;0;0;Create;True;0;0;0;False;0;False;2629a988a9ded7e46b01c37f62fe801d;2629a988a9ded7e46b01c37f62fe801d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.OneMinusNode;104;-3268.886,856.42;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-3616.886,672.42;Inherit;False;Property;_NormalIntensity;Normal Intensity;4;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-3467.886,964.42;Inherit;False;Property;_SmoothnessIntensity;Smoothness Intensity;5;0;Create;True;0;0;0;False;0;False;1;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;108;-3653.33,528.2086;Inherit;False;PolyartWorldAlignedTexture;-1;;16;50170ee3abb6acd4fb2e1a9c8b24ec90;0;3;1;SAMPLER2D;0,0,0,0;False;2;FLOAT;1;False;4;FLOAT3;0,0,0;False;4;COLOR;0;COLOR;26;COLOR;27;COLOR;25
Node;AmplifyShaderEditor.UnpackScaleNormalNode;97;-3322.33,597.2086;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-3068.886,857.42;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;109;-3633.666,251.3295;Inherit;False;PolyartWorldAlignedTexture;-1;;17;50170ee3abb6acd4fb2e1a9c8b24ec90;0;3;1;SAMPLER2D;0,0,0,0;False;2;FLOAT;1;False;4;FLOAT3;0,0,0;False;4;COLOR;0;COLOR;26;COLOR;27;COLOR;25
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-2759.431,322.9893;Float;False;True;-1;2;;0;0;Standard;Polyart/Dreamscape Surface World Aligned;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;1;NatureRendererInstancing=True;False;0;0;False;-1;-1;0;False;-1;3;Pragma;multi_compile_instancing;False;;Custom;Include;Assets/Visual Design Cafe/Nature Shaders/Common/Nodes/Integrations/Nature Renderer.cginc;False;;Custom;Pragma;instancing_options procedural:SetupNatureRenderer;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;107;1;101;0
WireConnection;107;2;91;0
WireConnection;104;0;107;25
WireConnection;108;1;96;0
WireConnection;108;2;91;0
WireConnection;97;0;108;25
WireConnection;97;1;105;0
WireConnection;103;0;104;0
WireConnection;103;1;106;0
WireConnection;109;1;55;0
WireConnection;109;2;91;0
WireConnection;0;0;109;25
WireConnection;0;1;97;0
WireConnection;0;4;103;0
ASEEND*/
//CHKSM=C2CF2FCBB4E3998F18FACE08AD0051BACDC7E7DC