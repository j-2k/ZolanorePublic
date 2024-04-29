// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape Foliage Billboard"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_FoliageTexture("Foliage Texture", 2D) = "white" {}
		_NormalTexture("Normal Texture", 2D) = "bump" {}
		_ColorTop("Color Top", Color) = (1,1,1,0)
		_ColorBottom("Color Bottom", Color) = (1,1,1,0)
		_ColorBottomLevel("Color Bottom Level", Float) = 0
		_ColorBottomMaskFade("Color Bottom Mask Fade", Range( -1 , 0)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _NormalTexture;
		uniform float4 _NormalTexture_ST;
		uniform float4 _ColorTop;
		uniform float4 _ColorBottom;
		uniform float _ColorBottomLevel;
		uniform float _ColorBottomMaskFade;
		uniform sampler2D _FoliageTexture;
		uniform float4 _FoliageTexture_ST;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTexture = i.uv_texcoord * _NormalTexture_ST.xy + _NormalTexture_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NormalTexture, uv_NormalTexture ) );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult11 = lerp( _ColorTop , _ColorBottom , saturate( ( ( ase_vertex3Pos.y + _ColorBottomLevel ) * ( _ColorBottomMaskFade * 2 ) ) ));
			float2 uv_FoliageTexture = i.uv_texcoord * _FoliageTexture_ST.xy + _FoliageTexture_ST.zw;
			float4 tex2DNode12 = tex2D( _FoliageTexture, uv_FoliageTexture );
			o.Albedo = ( lerpResult11 * tex2DNode12 ).rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			clip( tex2DNode12.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18910
686;73;2375;1475;1315.017;313.9;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;1;-1696.424,144.8283;Inherit;False;Property;_ColorBottomLevel;Color Bottom Level;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1720.808,229.4585;Inherit;False;Property;_ColorBottomMaskFade;Color Bottom Mask Fade;6;0;Create;True;0;0;0;False;0;False;0;0;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;3;-1695.34,2.239834;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-1421.231,98.73718;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;6;-1453.344,231.3355;Inherit;False;2;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1272.067,94.64922;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;10;-973.818,188.5926;Inherit;True;Property;_FoliageTexture;Foliage Texture;1;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;4;-965.312,-281.8197;Inherit;False;Property;_ColorTop;Color Top;3;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-970.312,-81.81989;Inherit;False;Property;_ColorBottom;Color Bottom;4;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;16;-753.239,442.1195;Inherit;True;Property;_NormalTexture;Normal Texture;2;0;Create;True;0;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SaturateNode;9;-966.385,95.41502;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-523.761,443.8805;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;11;-642.312,-23.82;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;12;-746.34,191.3536;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-100.0168,142.1;Inherit;False;Property;_AlphaClip;Alpha Clip;8;0;Create;True;0;0;0;False;0;False;0.35;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;18;-203.5,448.5;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;14;-238.7034,630.4377;Inherit;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-380.812,-24.65041;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;382,-18;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Polyart/Dreamscape Foliage Billboard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;20;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;2
WireConnection;5;1;1;0
WireConnection;6;0;2;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;9;0;7;0
WireConnection;17;0;16;0
WireConnection;11;0;4;0
WireConnection;11;1;8;0
WireConnection;11;2;9;0
WireConnection;12;0;10;0
WireConnection;18;0;17;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;0;0;13;0
WireConnection;0;1;18;0
WireConnection;0;4;14;0
WireConnection;0;10;12;4
ASEEND*/
//CHKSM=F4C5E69800A56B47CEC33AFCB81E80209A83EE70