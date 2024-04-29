// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape Simple Foliage"
{
	Properties
	{
		_AlphaCutoff("Alpha Cutoff", Range( 0 , 1)) = 0.35
		_ColorTint("Color Tint", Color) = (1,1,1,0)
		_FoliageTexture("Foliage Texture", 2D) = "white" {}
		_ColorMask("Color Mask", 2D) = "white" {}
		_Smoothness("Smoothness", Range( -2 , 2)) = 1
		[Header(WIND)]_WindSpeed("Wind Speed", Range( 0 , 1)) = 0.5
		_WindScale("Wind Scale", Range( 0 , 2)) = 0.2588236
		_WindIntensity("Wind Intensity", Range( 0 , 50)) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "NatureRendererInstancing"="True" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _WindSpeed;
		uniform float _WindScale;
		uniform float _WindIntensity;
		uniform sampler2D _FoliageTexture;
		uniform float4 _FoliageTexture_ST;
		uniform float4 _ColorTint;
		uniform sampler2D _ColorMask;
		uniform float4 _ColorMask_ST;
		uniform float _Smoothness;
		uniform float _AlphaCutoff;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float mulTime45 = _Time.y * ( _WindSpeed * 3 );
			float simplePerlin3D47 = snoise( ( ase_worldPos + mulTime45 )*_WindScale );
			v.vertex.xyz += ( v.color * ( ( simplePerlin3D47 * 0.015 ) * _WindIntensity ) ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_FoliageTexture = i.uv_texcoord * _FoliageTexture_ST.xy + _FoliageTexture_ST.zw;
			float4 tex2DNode10 = tex2D( _FoliageTexture, uv_FoliageTexture );
			float2 uv_ColorMask = i.uv_texcoord * _ColorMask_ST.xy + _ColorMask_ST.zw;
			float4 lerpResult58 = lerp( tex2DNode10 , ( tex2DNode10 * _ColorTint ) , tex2D( _ColorMask, uv_ColorMask ));
			float4 vColor60 = lerpResult58;
			o.Albedo = vColor60.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			clip( tex2DNode10.a - _AlphaCutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18800
882;203;2845;1556;2794.037;693.8748;1.3;True;True
Node;AmplifyShaderEditor.CommentaryNode;53;-1918.524,386.8673;Inherit;False;1713.722;584.5107;;12;57;56;49;50;51;47;48;43;45;42;46;44;Wind;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1889.286,760.1686;Inherit;False;Property;_WindSpeed;Wind Speed;5;0;Create;True;0;0;0;False;1;Header(WIND);False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;62;-1919.824,-230.0099;Inherit;False;1419.923;571.4927;;7;55;54;10;60;58;59;12;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleNode;46;-1587.286,766.1686;Inherit;False;3;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;42;-1456.87,573.8991;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;45;-1448.286,767.1686;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1896.824,-117.4465;Inherit;True;Property;_FoliageTexture;Foliage Texture;2;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-1184.285,668.1685;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1446.805,842.8475;Inherit;False;Property;_WindScale;Wind Scale;6;0;Create;True;0;0;0;False;0;False;0.2588236;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-1676.346,-118.6854;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;12;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;55;-1597.032,78.43231;Inherit;False;Property;_ColorTint;Color Tint;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;59;-1310.279,84.4828;Inherit;True;Property;_ColorMask;Color Mask;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;47;-1015.741,662.841;Inherit;False;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1313.033,-27.75702;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleNode;50;-812.804,666.8479;Inherit;False;0.015;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1014.803,806.8475;Inherit;False;Property;_WindIntensity;Wind Intensity;7;0;Create;True;0;0;0;False;0;False;5;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;58;-948.2507,-113.148;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-772.9005,-120.0099;Inherit;False;vColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;56;-688.9067,504.213;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-655.8037,666.8479;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-427.4018,603.4924;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-279.0808,-6.267761;Inherit;False;60;vColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-301.5779,-85.30359;Inherit;False;Property;_AlphaCutoff;Alpha Cutoff;0;0;Create;True;0;0;0;False;0;False;0.35;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-305.9848,87.3504;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;0;False;0;False;1;0;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;;0;0;Standard;Polyart/Dreamscape Simple Foliage;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.05;True;True;0;False;TransparentCutout;;AlphaTest;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;1;NatureRendererInstancing=True;False;0;0;False;-1;-1;0;True;1;3;Pragma;multi_compile_instancing;False;;Custom;Pragma;instancing_options procedural:SetupNatureRenderer;False;;Custom;Include;Assets/Visual Design Cafe/Nature Shaders/Common/Nodes/Integrations/Nature Renderer.cginc;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;46;0;44;0
WireConnection;45;0;46;0
WireConnection;43;0;42;0
WireConnection;43;1;45;0
WireConnection;10;0;12;0
WireConnection;47;0;43;0
WireConnection;47;1;48;0
WireConnection;54;0;10;0
WireConnection;54;1;55;0
WireConnection;50;0;47;0
WireConnection;58;0;10;0
WireConnection;58;1;54;0
WireConnection;58;2;59;0
WireConnection;60;0;58;0
WireConnection;49;0;50;0
WireConnection;49;1;51;0
WireConnection;57;0;56;0
WireConnection;57;1;49;0
WireConnection;0;0;61;0
WireConnection;0;4;36;0
WireConnection;0;10;10;4
WireConnection;0;11;57;0
ASEEND*/
//CHKSM=AE8D02DB8D4B937AD2CA6876E0219E0D6DE65552