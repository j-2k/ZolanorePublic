// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape Masked Lit"
{
	Properties
	{
		_ColorTint("Color Tint", Color) = (1,1,1,0)
		_ColorTexture("Color Texture", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.15
		_AlphaCutoff("Alpha Cutoff", Range( 0 , 1)) = 0.35
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _ColorTint;
		uniform sampler2D _ColorTexture;
		uniform float4 _ColorTexture_ST;
		uniform float _Smoothness;
		uniform float _AlphaCutoff;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_ColorTexture = i.uv_texcoord * _ColorTexture_ST.xy + _ColorTexture_ST.zw;
			float4 tex2DNode1 = tex2D( _ColorTexture, uv_ColorTexture );
			o.Albedo = ( _ColorTint * tex2DNode1 ).rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			clip( tex2DNode1.a - _AlphaCutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18800
882;203;2845;1556;1963.5;802;1;True;True
Node;AmplifyShaderEditor.SamplerNode;1;-925.5,20;Inherit;True;Property;_ColorTexture;Color Texture;1;0;Create;True;0;0;0;False;0;False;-1;None;594ed1a899dc01d488c847b35951d136;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-839.5,-185;Inherit;False;Property;_ColorTint;Color Tint;0;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.3717856,0.6603774,0.04049486,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-453.5,414;Inherit;False;Property;_AlphaCutoff;Alpha Cutoff;3;0;Create;True;0;0;0;False;0;False;0.35;0.35;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-455.5,333;Inherit;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;0;False;0;False;0.15;0.164;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-435.5,1;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1,0;Float;False;True;-1;2;;0;0;Standard;Polyart/Dreamscape Masked Lit;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;True;5;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;6;0
WireConnection;8;1;1;0
WireConnection;0;0;8;0
WireConnection;0;4;4;0
WireConnection;0;10;1;4
ASEEND*/
//CHKSM=31B632675211B912690BF53D154EC687A52442B1