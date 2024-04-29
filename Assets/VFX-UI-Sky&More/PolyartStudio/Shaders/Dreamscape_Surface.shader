// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape Surface"
{
	Properties
	{
		[Header(MAIN)]_AlbedoTint("Albedo Tint", Color) = (1,1,1,0)
		_AlbedoTexture("Albedo Texture", 2D) = "white" {}
		_NormalTexture("Normal Texture", 2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Range( -2 , 2)) = 1
		_MetallicMultiplier("Metallic Multiplier", Range( 0 , 2)) = 0
		_MetallicTexture("Metallic Texture", 2D) = "black" {}
		_SmoothnessMultiplier("Smoothness Multiplier", Range( -2 , 2)) = 1
		_SmoothnessTexture("Smoothness Texture", 2D) = "white" {}
		_EmissiveMultiplier("Emissive Multiplier", Range( 0 , 20)) = 0
		_EmissiveTexture("Emissive Texture", 2D) = "black" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  "NatureRendererInstancing"="True" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalTexture;
		uniform float4 _NormalTexture_ST;
		uniform float _NormalIntensity;
		uniform float4 _AlbedoTint;
		uniform sampler2D _AlbedoTexture;
		uniform float4 _AlbedoTexture_ST;
		uniform sampler2D _EmissiveTexture;
		uniform float4 _EmissiveTexture_ST;
		uniform float _EmissiveMultiplier;
		uniform sampler2D _MetallicTexture;
		uniform float4 _MetallicTexture_ST;
		uniform float _MetallicMultiplier;
		uniform sampler2D _SmoothnessTexture;
		uniform float4 _SmoothnessTexture_ST;
		uniform float _SmoothnessMultiplier;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTexture = i.uv_texcoord * _NormalTexture_ST.xy + _NormalTexture_ST.zw;
			float3 vNormal13 = UnpackScaleNormal( tex2D( _NormalTexture, uv_NormalTexture ), _NormalIntensity );
			o.Normal = vNormal13;
			float2 uv_AlbedoTexture = i.uv_texcoord * _AlbedoTexture_ST.xy + _AlbedoTexture_ST.zw;
			float4 vColor12 = ( _AlbedoTint * tex2D( _AlbedoTexture, uv_AlbedoTexture ) );
			o.Albedo = vColor12.rgb;
			float2 uv_EmissiveTexture = i.uv_texcoord * _EmissiveTexture_ST.xy + _EmissiveTexture_ST.zw;
			float4 vEmissive31 = ( tex2D( _EmissiveTexture, uv_EmissiveTexture ) * _EmissiveMultiplier );
			o.Emission = vEmissive31.rgb;
			float2 uv_MetallicTexture = i.uv_texcoord * _MetallicTexture_ST.xy + _MetallicTexture_ST.zw;
			float4 vMetallic19 = ( tex2D( _MetallicTexture, uv_MetallicTexture ) * _MetallicMultiplier );
			o.Metallic = vMetallic19.r;
			float2 uv_SmoothnessTexture = i.uv_texcoord * _SmoothnessTexture_ST.xy + _SmoothnessTexture_ST.zw;
			float4 vSmoothness24 = ( ( 1.0 - tex2D( _SmoothnessTexture, uv_SmoothnessTexture ) ) * _SmoothnessMultiplier );
			o.Smoothness = vSmoothness24.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18800
882;203;2845;1556;1357.961;221.8126;1;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;20;-1556.385,962.6965;Inherit;True;Property;_SmoothnessTexture;Smoothness Texture;7;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1501.494,-162.2611;Inherit;True;Property;_AlbedoTexture;Albedo Texture;1;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;14;-1511.541,540.21;Inherit;True;Property;_MetallicTexture;Metallic Texture;5;0;Create;True;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;7;-1507.127,153.3116;Inherit;True;Property;_NormalTexture;Normal Texture;2;0;Create;True;0;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;26;-1511.338,1370.093;Inherit;True;Property;_EmissiveTexture;Emissive Texture;9;0;Create;True;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;21;-1296.454,963.0465;Inherit;True;Property;_TextureSample3;Texture Sample 3;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-1269.61,540.5599;Inherit;True;Property;_TextureSample4;Texture Sample 4;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-1270.118,153.3407;Inherit;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;-1269.406,1370.443;Inherit;True;Property;_TextureSample2;Texture Sample 2;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-1249.639,348.1309;Inherit;False;Property;_NormalIntensity;Normal Intensity;3;0;Create;True;0;0;0;False;0;False;1;0;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1261.117,-162.2169;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-1246.61,735.5596;Inherit;False;Property;_MetallicMultiplier;Metallic Multiplier;4;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1274.454,1167.047;Inherit;False;Property;_SmoothnessMultiplier;Smoothness Multiplier;6;0;Create;True;0;0;0;False;0;False;1;0;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;38;-978.9292,968.4904;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;3;-1178.494,-345.261;Inherit;False;Property;_AlbedoTint;Albedo Tint;0;0;Create;True;0;0;0;False;1;Header(MAIN);False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-1246.406,1565.442;Inherit;False;Property;_EmissiveMultiplier;Emissive Multiplier;8;0;Create;True;0;0;0;False;0;False;0;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;9;-936.6394,159.131;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-846.4939,-274.261;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-929.5409,546.21;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-806.3855,965.6965;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-929.3376,1376.093;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-651.0247,541.2349;Inherit;False;vMetallic;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-674.2704,1371.098;Inherit;False;vEmissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-698.8083,-278.5661;Inherit;False;vColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-643.4674,153.8047;Inherit;False;vNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-555.884,961.1329;Inherit;False;vSmoothness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-322.7171,545.1085;Inherit;False;31;vEmissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-320.7171,469.1085;Inherit;False;13;vNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-319.7171,390.1085;Inherit;False;12;vColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-322.7171,622.1085;Inherit;False;19;vMetallic;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-322.7171,696.1085;Inherit;False;24;vSmoothness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4.575642,397.8073;Float;False;True;-1;2;;0;0;Standard;Polyart/Dreamscape Surface;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;1;NatureRendererInstancing=True;False;0;0;False;-1;-1;0;False;-1;3;Pragma;multi_compile_instancing;False;;Custom;Pragma;instancing_options procedural:SetupNatureRenderer;False;;Custom;Include;Assets/Visual Design Cafe/Nature Shaders/Common/Nodes/Integrations/Nature Renderer.cginc;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;6;-1551.494,-395.261;Inherit;False;1117;458.0442;;0;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;11;-1557.127,103.3116;Inherit;False;1123.488;335.8192;;0;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;18;-1561.541,490.21;Inherit;False;1124.1;344.1497;;0;Metallic;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;30;-1561.338,1320.093;Inherit;False;1119.638;354.0339;;0;Emissive;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;25;-1568.385,903.6965;Inherit;False;1230.501;368.35;;0;Smooth;1,1,1,1;0;0
WireConnection;21;0;20;0
WireConnection;15;0;14;0
WireConnection;8;0;7;0
WireConnection;27;0;26;0
WireConnection;2;0;1;0
WireConnection;38;0;21;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;4;0;3;0
WireConnection;4;1;2;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;23;0;38;0
WireConnection;23;1;22;0
WireConnection;28;0;27;0
WireConnection;28;1;29;0
WireConnection;19;0;16;0
WireConnection;31;0;28;0
WireConnection;12;0;4;0
WireConnection;13;0;9;0
WireConnection;24;0;23;0
WireConnection;0;0;32;0
WireConnection;0;1;33;0
WireConnection;0;2;34;0
WireConnection;0;3;35;0
WireConnection;0;4;36;0
ASEEND*/
//CHKSM=68CDA423D1C77124965B61C6A5C8169D081C35C4