// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape Waterfall Foam Volumetric"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_ScaleWidth("Scale Width", Float) = 1
		_Acceleration("Acceleration", Float) = 0
		_VerticalSpeed("Vertical Speed", Float) = 1
		_ScaleX("Scale X", Float) = 1
		_ScaleY("Scale Y", Float) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Threshold("Threshold", Float) = 0.1
		_Height("Height", Float) = 100
		_Color0("Color 0", Color) = (0,0.9495223,1,0)
		_Color1("Color 1", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform float _ScaleX;
		uniform float _ScaleWidth;
		uniform float _Acceleration;
		uniform float _VerticalSpeed;
		uniform float _ScaleY;
		uniform float _Threshold;
		uniform float _Height;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult6 = (float2(( _ScaleWidth * v.texcoord.xy.x ) , ( v.texcoord.xy.y * _Acceleration )));
			float2 break7 = appendResult6;
			float2 appendResult20 = (float2(( _ScaleX * break7.x ) , ( ( break7.y - ( _Time.y * _VerticalSpeed ) ) * _ScaleY )));
			float4 temp_cast_0 = (_Threshold).xxxx;
			float4 temp_output_26_0 = ( ( v.texcoord.xy.y * tex2Dlod( _TextureSample0, float4( appendResult20, 0, 0.0) ) ) - temp_cast_0 );
			float4 temp_cast_1 = (( _Height / 4.0 )).xxxx;
			float grayscale34 = Luminance(( ( saturate( temp_output_26_0 ) * _Height ) - temp_cast_1 ).rgb);
			float3 appendResult33 = (float3(0.0 , grayscale34 , 0.0));
			v.vertex.xyz += appendResult33;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult6 = (float2(( _ScaleWidth * i.uv_texcoord.x ) , ( i.uv_texcoord.y * _Acceleration )));
			float2 break7 = appendResult6;
			float2 appendResult20 = (float2(( _ScaleX * break7.x ) , ( ( break7.y - ( _Time.y * _VerticalSpeed ) ) * _ScaleY )));
			float4 temp_cast_0 = (_Threshold).xxxx;
			float4 temp_output_26_0 = ( ( i.uv_texcoord.y * tex2D( _TextureSample0, appendResult20 ) ) - temp_cast_0 );
			float4 lerpResult37 = lerp( _Color0 , _Color1 , temp_output_26_0);
			o.Emission = lerpResult37.rgb;
			o.Metallic = temp_output_26_0.r;
			o.Alpha = 1;
			clip( temp_output_26_0.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18800
882;203;2845;1556;3851.512;782.5484;1;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-3086.783,40.848;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-3026.783,-62.152;Inherit;False;Property;_ScaleWidth;Scale Width;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-3046.819,235.0362;Inherit;False;Property;_Acceleration;Acceleration;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-2805.819,133.0362;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-2802.783,41.848;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;16;-2591.152,179.7028;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2610.152,282.7028;Inherit;False;Property;_VerticalSpeed;Vertical Speed;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-2576.819,71.03617;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2371.152,242.7029;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;7;-2380.819,71.03617;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;19;-2111.819,272.0361;Inherit;False;Property;_ScaleY;Scale Y;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-2112.819,170.0362;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2377.819,-16.96383;Inherit;False;Property;_ScaleX;Scale X;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1888.819,171.0362;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1884.819,56.03617;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-1707.818,86.03617;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;21;-1539.819,59.03617;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;1206ec3b97ff9e043bab9ed180f8a4d7;1206ec3b97ff9e043bab9ed180f8a4d7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1677.739,-289.4966;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-998.5308,27.1322;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1016.739,122.5034;Inherit;False;Property;_Threshold;Threshold;7;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;26;-810.7393,28.50336;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-574.7393,219.5034;Inherit;False;Property;_Height;Height;8;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;28;-603.7393,33.50336;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;-370.7393,284.5034;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-389.7393,65.50336;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-223.3173,138.2169;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;36;-534.5727,-452.478;Inherit;False;Property;_Color1;Color 1;10;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.01415092,1,0.9794242,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;35;-537.1726,-657.878;Inherit;False;Property;_Color0;Color 0;9;0;Create;True;0;0;0;False;0;False;0,0.9495223,1,0;0.01415092,1,0.9794242,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;34;-130.3122,337.982;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-34.73926,29.50336;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;37;-145.8727,-452.478;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;172,13;Float;False;True;-1;2;;0;0;Standard;Polyart/Dreamscape Waterfall Foam Volumetric;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;1;2
WireConnection;4;1;5;0
WireConnection;2;0;3;0
WireConnection;2;1;1;1
WireConnection;6;0;2;0
WireConnection;6;1;4;0
WireConnection;15;0;16;0
WireConnection;15;1;17;0
WireConnection;7;0;6;0
WireConnection;14;0;7;1
WireConnection;14;1;15;0
WireConnection;18;0;14;0
WireConnection;18;1;19;0
WireConnection;12;0;13;0
WireConnection;12;1;7;0
WireConnection;20;0;12;0
WireConnection;20;1;18;0
WireConnection;21;1;20;0
WireConnection;22;0;23;2
WireConnection;22;1;21;0
WireConnection;26;0;22;0
WireConnection;26;1;27;0
WireConnection;28;0;26;0
WireConnection;31;0;30;0
WireConnection;29;0;28;0
WireConnection;29;1;30;0
WireConnection;32;0;29;0
WireConnection;32;1;31;0
WireConnection;34;0;32;0
WireConnection;33;1;34;0
WireConnection;37;0;35;0
WireConnection;37;1;36;0
WireConnection;37;2;26;0
WireConnection;0;2;37;0
WireConnection;0;3;26;0
WireConnection;0;10;26;0
WireConnection;0;11;33;0
ASEEND*/
//CHKSM=3A3440B42D36E9F40B2F1307148398CBF4FE2072