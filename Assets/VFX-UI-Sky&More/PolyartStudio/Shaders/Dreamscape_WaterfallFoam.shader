// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape Waterfall Foam"
{
	Properties
	{
		_ScaleWidth("Scale Width", Float) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Acceleration("Acceleration", Float) = 0
		_VerticalSpeed("Vertical Speed", Float) = 1
		_BSpeed("B Speed", Float) = 1
		_HorizontalSpeed("Horizontal Speed", Float) = 0
		_AScaleX("A Scale X", Float) = 1
		_BScaleX("B Scale X", Float) = 2
		_AScaleY("A Scale Y", Float) = 1
		_BScaleY("B Scale Y", Float) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Color0("Color 0", Color) = (0,0.9495223,1,0)
		_Color1("Color 1", Color) = (1,1,1,0)
		_Bias("Bias", Float) = 0.5
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform sampler2D _TextureSample0;
		uniform float _AScaleX;
		uniform float _HorizontalSpeed;
		uniform float _ScaleWidth;
		uniform float _Acceleration;
		uniform float _VerticalSpeed;
		uniform float _AScaleY;
		uniform sampler2D _TextureSample1;
		uniform float _BScaleX;
		uniform float _BSpeed;
		uniform float _BScaleY;
		uniform float _Bias;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult6 = (float2(( _ScaleWidth * i.uv_texcoord.x ) , ( i.uv_texcoord.y * _Acceleration )));
			float2 break7 = appendResult6;
			float2 appendResult20 = (float2(( _AScaleX * ( ( _Time.y * _HorizontalSpeed ) + break7.x ) ) , ( ( break7.y - ( _Time.y * _VerticalSpeed ) ) * _AScaleY )));
			float2 break55 = appendResult6;
			float2 appendResult45 = (float2(( _BScaleX * break55.x ) , ( ( break55.y - ( _Time.y * _BSpeed ) ) * _BScaleY )));
			float4 temp_output_67_0 = ( ( ( tex2D( _TextureSample0, appendResult20 ) * tex2D( _TextureSample1, appendResult45 ) ) * ( 1.0 - ( saturate( abs( ( i.uv_texcoord.y - _Bias ) ) ) * 2.0 ) ) ) * 1.0 );
			float4 lerpResult37 = lerp( _Color0 , _Color1 , temp_output_67_0);
			o.Emission = lerpResult37.rgb;
			o.Alpha = 1;
			clip( temp_output_67_0.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18800
882;203;2845;1556;9846.413;4175.62;5.004479;True;True
Node;AmplifyShaderEditor.RangedFloatNode;5;-5148.088,70.22366;Inherit;False;Property;_Acceleration;Acceleration;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-5128.052,-226.9645;Inherit;False;Property;_ScaleWidth;Scale Width;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-5202.173,-123.9646;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-4907.09,-31.77632;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-4904.054,-122.9646;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-3386.938,1037.784;Inherit;False;Property;_BSpeed;B Speed;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;39;-4306.352,-973.2629;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;16;-4112.523,-410.335;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;54;-3366.638,934.7844;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-4132.823,-307.335;Inherit;False;Property;_VerticalSpeed;Vertical Speed;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-4306.535,-842.1194;Inherit;False;Property;_HorizontalSpeed;Horizontal Speed;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-4678.09,-93.77634;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;55;-3340.362,734.1179;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-1891.802,872.3907;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;7;-4086.247,-611.0015;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;61;-1804.051,1088.656;Inherit;False;Property;_Bias;Bias;14;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-3892.523,-347.3349;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-3944.19,-858.0015;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-3146.638,997.7845;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-2888.305,925.1178;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-3461.19,-360.0017;Inherit;False;Property;_AScaleY;A Scale Y;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2715.305,985.1177;Inherit;False;Property;_BScaleY;B Scale Y;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;60;-1539.173,961.6563;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-3634.19,-420.0016;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-3795.19,-968.0016;Inherit;False;Property;_AScaleX;A Scale X;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-3514.352,-850.2629;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-3053.305,378.1178;Inherit;False;Property;_BScaleX;B Scale X;7;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-2492.305,884.1178;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-3238.19,-461.0016;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-3285.97,-876.6526;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;62;-1277.244,964.236;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-2540.085,468.4668;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;63;-1060.244,967.236;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-3066.189,-774.0015;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;-2320.304,571.1179;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-882.2441,966.236;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;-2083.78,542.1084;Inherit;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;0;0;0;False;0;False;-1;None;1206ec3b97ff9e043bab9ed180f8a4d7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-2829.665,-803.011;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;0;False;0;False;-1;None;1206ec3b97ff9e043bab9ed180f8a4d7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;65;-641.2441,967.236;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-1871.477,-284.3712;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-633.8656,276.5941;Inherit;False;Constant;_Thresholdbias;Threshold bias;15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-745.0889,88.15723;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;35;-537.1726,-657.878;Inherit;False;Property;_Color0;Color 0;12;0;Create;True;0;0;0;False;0;False;0,0.9495223,1,0;0.01415092,1,0.9794242,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-303.0009,87.27866;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;36;-534.5727,-452.478;Inherit;False;Property;_Color1;Color 1;13;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.01415092,1,0.9794242,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;37;-145.8727,-452.478;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;318.4444,-495.885;Float;False;True;-1;2;;0;0;Standard;Polyart/Dreamscape Waterfall Foam;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;1;2
WireConnection;4;1;5;0
WireConnection;2;0;3;0
WireConnection;2;1;1;1
WireConnection;6;0;2;0
WireConnection;6;1;4;0
WireConnection;55;0;6;0
WireConnection;7;0;6;0
WireConnection;15;0;16;0
WireConnection;15;1;17;0
WireConnection;12;0;39;0
WireConnection;12;1;40;0
WireConnection;52;0;54;0
WireConnection;52;1;51;0
WireConnection;49;0;55;1
WireConnection;49;1;52;0
WireConnection;60;0;59;2
WireConnection;60;1;61;0
WireConnection;14;0;7;1
WireConnection;14;1;15;0
WireConnection;38;0;12;0
WireConnection;38;1;7;0
WireConnection;47;0;49;0
WireConnection;47;1;53;0
WireConnection;18;0;14;0
WireConnection;18;1;19;0
WireConnection;41;0;13;0
WireConnection;41;1;38;0
WireConnection;62;0;60;0
WireConnection;46;0;56;0
WireConnection;46;1;55;0
WireConnection;63;0;62;0
WireConnection;20;0;41;0
WireConnection;20;1;18;0
WireConnection;45;0;46;0
WireConnection;45;1;47;0
WireConnection;64;0;63;0
WireConnection;43;1;45;0
WireConnection;21;1;20;0
WireConnection;65;0;64;0
WireConnection;58;0;21;0
WireConnection;58;1;43;0
WireConnection;66;0;58;0
WireConnection;66;1;65;0
WireConnection;67;0;66;0
WireConnection;67;1;68;0
WireConnection;37;0;35;0
WireConnection;37;1;36;0
WireConnection;37;2;67;0
WireConnection;0;2;37;0
WireConnection;0;10;67;0
ASEEND*/
//CHKSM=AACBB14F7D5DDBFB104D988DF1B07B37353070AD