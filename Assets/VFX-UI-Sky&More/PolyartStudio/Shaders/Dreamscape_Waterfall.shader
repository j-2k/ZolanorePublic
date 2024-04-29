// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape Waterfall"
{
	Properties
	{
		_LineScaleWidth("Line Scale Width", Float) = 0
		[Header(COLOR)]_ColorShallow("Color Shallow", Color) = (0.5990566,0.9091429,1,0)
		_ColorDeep("Color Deep", Color) = (0.1213065,0.347919,0.5471698,0)
		_Smoothness("Smoothness", Float) = 0
		_LineAcceleration("Line Acceleration", Float) = 1
		_NormalWave("Normal Wave", 2D) = "bump" {}
		_ColorDepthFade("Color Depth Fade", Float) = 0
		_Line01ScaleX("Line 01 Scale X", Float) = 0
		_Line02ScaleX("Line 02 Scale X", Float) = 0
		_Line01Speed("Line 01 Speed", Float) = 0
		_Line02Speed("Line 02 Speed", Float) = 0
		_Line01ScaleY("Line 01 Scale Y", Float) = 0
		_Line02ScaleY("Line 02 Scale Y", Float) = 0
		_LineUVFade("Line UV Fade", Float) = 0
		_LineTreshold("Line Treshold", Range( 0 , 1)) = 0.1
		_Displace1("Displace 1", 2D) = "white" {}
		_WaveNormalIntensity("Wave Normal Intensity", Range( 0 , 1)) = 1
		[IntRange]_WaveTiling01("Wave Tiling 01", Range( 0 , 50)) = 1
		[IntRange]_WaveTiling02("Wave Tiling 02", Range( 0 , 50)) = 1
		_DisplaceStrength("Displace Strength", Range( -1 , 1)) = 0
		_WaterLines("Water Lines", 2D) = "white" {}
		_LineColor("Line Color", Color) = (1,1,1,0)
		_DisplacementMovement("Displacement Movement", Vector) = (0,3,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _Displace1;
		uniform float2 _DisplacementMovement;
		uniform float _WaveTiling02;
		uniform float _DisplaceStrength;
		uniform sampler2D _NormalWave;
		uniform float _WaveTiling01;
		uniform float _WaveNormalIntensity;
		uniform float4 _LineColor;
		uniform float4 _ColorShallow;
		uniform float4 _ColorDeep;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _ColorDepthFade;
		uniform float _LineUVFade;
		uniform sampler2D _WaterLines;
		uniform float _Line01ScaleX;
		uniform float _LineScaleWidth;
		uniform float _LineAcceleration;
		uniform float _Line01Speed;
		uniform float _Line01ScaleY;
		uniform float _Line02ScaleX;
		uniform float _Line02Speed;
		uniform float _Line02ScaleY;
		uniform float _LineTreshold;
		uniform float _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_WaveTiling02).xx;
			float2 uv_TexCoord142 = v.texcoord.xy * temp_cast_0;
			float2 panner143 = ( 1.0 * _Time.y * _DisplacementMovement + uv_TexCoord142);
			float4 vDisplacement136 = ( saturate( tex2Dlod( _Displace1, float4( panner143, 0, 0.0) ) ) * _DisplaceStrength );
			v.vertex.xyz += vDisplacement136.rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_WaveTiling01).xx;
			float2 uv_TexCoord72 = i.uv_texcoord * temp_cast_0;
			float2 panner76 = ( 1.0 * _Time.y * float2( 0,0.75 ) + uv_TexCoord72);
			float3 vNormal91 = UnpackScaleNormal( tex2D( _NormalWave, panner76 ), _WaveNormalIntensity );
			o.Normal = vNormal91;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth105 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth105 = abs( ( screenDepth105 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _ColorDepthFade ) );
			float4 lerpResult109 = lerp( _ColorShallow , _ColorDeep , saturate( distanceDepth105 ));
			float2 temp_cast_2 = (_WaveTiling02).xx;
			float2 uv_TexCoord142 = i.uv_texcoord * temp_cast_2;
			float2 panner143 = ( 1.0 * _Time.y * _DisplacementMovement + uv_TexCoord142);
			float4 vDisplacement136 = ( saturate( tex2D( _Displace1, panner143 ) ) * _DisplaceStrength );
			float4 lerpResult140 = lerp( lerpResult109 , ( lerpResult109 + float4( 0.4414383,0.5903998,0.6037736,1 ) ) , vDisplacement136);
			float4 vDepthColor110 = lerpResult140;
			float2 appendResult26 = (float2(( _LineScaleWidth * i.uv_texcoord.x ) , pow( i.uv_texcoord.y , _LineAcceleration )));
			float2 vMovementLines112 = appendResult26;
			float2 break27 = vMovementLines112;
			float2 appendResult30 = (float2(( _Line01ScaleX * break27.x ) , ( ( break27.y - ( _Time.y * _Line01Speed ) ) * _Line01ScaleY )));
			float4 vLine01113 = tex2D( _WaterLines, appendResult30 );
			float2 break55 = vMovementLines112;
			float2 appendResult61 = (float2(( _Line02ScaleX * break55.x ) , ( ( break55.y - ( _Time.y * _Line02Speed ) ) * _Line02ScaleY )));
			float4 vLine02120 = tex2D( _WaterLines, appendResult61 );
			float4 vLinesCombined122 = floor( saturate( ( saturate( ( ( i.uv_texcoord.y * _LineUVFade ) + ( ( vLine01113 * vLine02120 ) * 2.0 ) ) ) + ( 1.0 - _LineTreshold ) ) ) );
			float4 lerpResult124 = lerp( _LineColor , vDepthColor110 , vLinesCombined122);
			o.Albedo = lerpResult124.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
}
/*ASEBEGIN
Version=18800
882;203;2845;1556;2159.865;613.5785;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;103;-5925.46,-1196.435;Inherit;False;947.9863;506.6378;Comment;7;112;19;17;26;21;20;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-5854.262,-1146.435;Inherit;False;Property;_LineScaleWidth;Line Scale Width;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-5855.265,-880.6656;Inherit;False;Property;_LineAcceleration;Line Acceleration;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-5882.46,-1015.529;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-5602.265,-1089.666;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;20;-5606.265,-968.6658;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-5420.265,-1043.666;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;118;-5924.976,183.2707;Inherit;False;1591.424;543.0001;Comment;13;120;55;62;51;57;60;56;61;58;59;116;54;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;117;-5926.216,-649.3807;Inherit;False;1653.576;567;Comment;13;115;27;113;31;32;37;30;29;33;34;35;28;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-5210.358,-1047.171;Inherit;False;vMovementLines;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;32;-5746.667,-324.381;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-5772.667,-195.381;Inherit;False;Property;_Line01Speed;Line 01 Speed;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;53;-5737.1,517.2708;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-5913.293,360.2041;Inherit;False;112;vMovementLines;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-5876.216,-470.2855;Inherit;False;112;vMovementLines;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-5747.1,607.2706;Inherit;False;Property;_Line02Speed;Line 02 Speed;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;55;-5665.021,364.7377;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;27;-5532.667,-466.3811;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-5535.101,518.2708;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-5543.667,-266.3809;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-5523.667,-599.3807;Inherit;False;Property;_Line01ScaleX;Line 01 Scale X;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-5390.101,488.2708;Inherit;False;Property;_Line02ScaleY;Line 02 Scale Y;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-5537.667,-170.3808;Inherit;False;Property;_Line01ScaleY;Line 01 Scale Y;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-5348.667,-375.3811;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;-5404.101,384.2705;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-5649.1,243.2707;Inherit;False;Property;_Line02ScaleX;Line 02 Scale X;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-5195.099,384.2704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-5403.101,278.2705;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-5173.667,-332.3811;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-5281.667,-536.3809;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;114;-5292.276,-47.79972;Inherit;True;Property;_WaterLines;Water Lines;19;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DynamicAppendNode;30;-5055.666,-498.381;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;61;-5040.1,279.2705;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;147;-2610.132,924.887;Inherit;False;1827.8;353.1616;Comment;9;141;142;146;143;133;135;132;136;134;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;37;-4871.832,-526.1271;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;0;False;0;False;-1;1206ec3b97ff9e043bab9ed180f8a4d7;1206ec3b97ff9e043bab9ed180f8a4d7;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;62;-4871.55,251.369;Inherit;True;Property;_TextureSample1;Texture Sample 1;12;0;Create;True;0;0;0;False;0;False;-1;1206ec3b97ff9e043bab9ed180f8a4d7;1206ec3b97ff9e043bab9ed180f8a4d7;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-4559.208,251.103;Inherit;False;vLine02;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-4514.64,-523.5189;Inherit;False;vLine01;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;123;-4226.807,-688.6647;Inherit;False;1862.952;602.3098;Comment;16;38;63;119;121;39;44;122;67;42;40;41;64;65;68;66;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-2579.132,1017.458;Inherit;False;Property;_WaveTiling02;Wave Tiling 02;17;1;[IntRange];Create;True;0;0;0;False;0;False;1;1;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-4176.807,-272.4482;Inherit;False;120;vLine02;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-4174.514,-352.2248;Inherit;False;113;vLine01;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;142;-2277.937,999.1235;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;146;-2307.071,1150.668;Inherit;False;Property;_DisplacementMovement;Displacement Movement;21;0;Create;True;0;0;0;False;0;False;0,3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;43;-3971.402,-521.4871;Inherit;False;Property;_LineUVFade;Line UV Fade;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-4029.029,-638.6647;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-3849.75,-335.8206;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-3855.389,-233.15;Inherit;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;111;-5909.783,-1791.83;Inherit;False;1433.906;525.7242;Comment;6;104;105;106;107;108;109;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;143;-2000.921,1020.693;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.75;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;132;-1786.452,991.8869;Inherit;True;Property;_Displace1;Displace 1;15;0;Create;True;0;0;0;False;0;False;-1;1206ec3b97ff9e043bab9ed180f8a4d7;1206ec3b97ff9e043bab9ed180f8a4d7;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-3655.402,-560.4871;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-5859.783,-1398.106;Inherit;False;Property;_ColorDepthFade;Color Depth Fade;6;0;Create;True;0;0;0;False;0;False;0;0.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-3664.225,-334.3129;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-3520.325,-201.3544;Inherit;False;Property;_LineTreshold;Line Treshold;14;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;69;-2818.594,1315.4;Inherit;False;2035.247;346.9634;;7;91;89;86;85;76;72;70;Wave Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.DepthFade;105;-5654.783,-1399.106;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-1753.582,1181.048;Inherit;False;Property;_DisplaceStrength;Displace Strength;18;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;133;-1448.692,998.0129;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-3404.196,-359.5352;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-2805.265,1410.404;Inherit;False;Property;_WaveTiling01;Wave Tiling 01;16;1;[IntRange];Create;True;0;0;0;False;0;False;1;1;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-1261.234,998.7463;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;106;-5395.782,-1400.106;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;41;-3245.623,-359.2041;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;108;-5531.967,-1572.83;Inherit;False;Property;_ColorDeep;Color Deep;2;0;Create;True;0;0;0;False;0;False;0.1213065,0.347919,0.5471698,0;0.121306,0.3479185,0.5471698,0.2156863;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;107;-5505.967,-1741.83;Inherit;False;Property;_ColorShallow;Color Shallow;1;0;Create;True;0;0;0;False;1;Header(COLOR);False;0.5990566,0.9091429,1,0;0.1556599,0.5173416,0.6226414,0.5529412;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;66;-3248.725,-197.7543;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-3072.038,-359.0066;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;109;-5052.188,-1446.231;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-1031.332,994.8801;Inherit;False;vDisplacement;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;72;-2440.07,1394.069;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;76;-2160.055,1392.639;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.75;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;67;-2944.32,-357.8803;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;138;-4766.857,-1271.836;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.4414383,0.5903998,0.6037736,1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-4778.387,-1139.176;Inherit;False;136;vDisplacement;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;85;-1766.958,1365.4;Inherit;True;Property;_NormalWave;Normal Wave;5;0;Create;True;0;0;0;False;0;False;-1;None;70546bb8eb214354e83b7f57e5a4821c;True;0;True;bump;LockedToTexture2D;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;86;-1757.585,1572.068;Inherit;False;Property;_WaveNormalIntensity;Wave Normal Intensity;15;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;140;-4387.247,-1338.484;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FloorOpNode;68;-2769.319,-357.8803;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-2621.859,-362.7851;Inherit;False;vLinesCombined;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-4097.877,-1305.844;Inherit;False;vDepthColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;89;-1423.586,1368.068;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;127;-1279.859,-203.0497;Inherit;False;Property;_LineColor;Line Color;20;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;126;-1282.402,-36.06396;Inherit;False;110;vDepthColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-1023.159,1362.758;Inherit;False;vNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-1309.353,40.62239;Inherit;False;122;vLinesCombined;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-772.2092,217.5058;Inherit;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;124;-890.6232,-26.58241;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-779.139,141.6138;Inherit;False;91;vNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-816.5879,293.8264;Inherit;False;136;vDisplacement;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-491.0047,124.6019;Float;False;True;-1;2;;0;0;Standard;Polyart/Dreamscape Waterfall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;18;0
WireConnection;19;1;17;1
WireConnection;20;0;17;2
WireConnection;20;1;21;0
WireConnection;26;0;19;0
WireConnection;26;1;20;0
WireConnection;112;0;26;0
WireConnection;55;0;116;0
WireConnection;27;0;115;0
WireConnection;54;0;53;0
WireConnection;54;1;51;0
WireConnection;33;0;32;0
WireConnection;33;1;34;0
WireConnection;31;0;27;1
WireConnection;31;1;33;0
WireConnection;58;0;55;1
WireConnection;58;1;54;0
WireConnection;60;0;58;0
WireConnection;60;1;56;0
WireConnection;59;0;57;0
WireConnection;59;1;55;0
WireConnection;35;0;31;0
WireConnection;35;1;36;0
WireConnection;29;0;28;0
WireConnection;29;1;27;0
WireConnection;30;0;29;0
WireConnection;30;1;35;0
WireConnection;61;0;59;0
WireConnection;61;1;60;0
WireConnection;37;0;114;0
WireConnection;37;1;30;0
WireConnection;62;0;114;0
WireConnection;62;1;61;0
WireConnection;120;0;62;0
WireConnection;113;0;37;0
WireConnection;142;0;141;0
WireConnection;63;0;119;0
WireConnection;63;1;121;0
WireConnection;143;0;142;0
WireConnection;143;2;146;0
WireConnection;132;1;143;0
WireConnection;44;0;42;2
WireConnection;44;1;43;0
WireConnection;38;0;63;0
WireConnection;38;1;39;0
WireConnection;105;0;104;0
WireConnection;133;0;132;0
WireConnection;40;0;44;0
WireConnection;40;1;38;0
WireConnection;134;0;133;0
WireConnection;134;1;135;0
WireConnection;106;0;105;0
WireConnection;41;0;40;0
WireConnection;66;0;65;0
WireConnection;64;0;41;0
WireConnection;64;1;66;0
WireConnection;109;0;107;0
WireConnection;109;1;108;0
WireConnection;109;2;106;0
WireConnection;136;0;134;0
WireConnection;72;0;70;0
WireConnection;76;0;72;0
WireConnection;67;0;64;0
WireConnection;138;0;109;0
WireConnection;85;1;76;0
WireConnection;140;0;109;0
WireConnection;140;1;138;0
WireConnection;140;2;139;0
WireConnection;68;0;67;0
WireConnection;122;0;68;0
WireConnection;110;0;140;0
WireConnection;89;0;85;0
WireConnection;89;1;86;0
WireConnection;91;0;89;0
WireConnection;124;0;127;0
WireConnection;124;1;126;0
WireConnection;124;2;125;0
WireConnection;0;0;124;0
WireConnection;0;1;93;0
WireConnection;0;4;128;0
WireConnection;0;11;137;0
ASEEND*/
//CHKSM=63AA1A3B14FA683E964B5001F41CCFD43DACE730