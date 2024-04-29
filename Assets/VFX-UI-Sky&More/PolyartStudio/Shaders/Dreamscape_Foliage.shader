// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape Foliage"
{
	Properties
	{
		_AlphaCutoff("Alpha Cutoff", Range( 0 , 1)) = 0.35
		_FoliageTexture("Foliage Texture", 2D) = "white" {}
		_ColorTop("Color Top", Color) = (0,0,0,0)
		_ColorBottom("Color Bottom", Color) = (0,0,0,0)
		_ColorBottomLevel("Color Bottom Level", Float) = 0
		_ColorBottomMaskFade("Color Bottom Mask Fade", Range( -1 , 0)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[Header(WIND)]_WindSpeed("Wind Speed", Range( 0 , 1)) = 0.5
		_WindScale("Wind Scale", Range( 0 , 2)) = 0.2588236
		_WindIntensity("Wind Intensity", Range( 0 , 50)) = 5
		_InteractionAlpha("Interaction Alpha", Float) = 1
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustom keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		struct SurfaceOutputStandardCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Translucency;
		};

		uniform float _WindSpeed;
		uniform float _WindScale;
		uniform float _WindIntensity;
		uniform float4 _ActorPosition;
		uniform float _InteractionStrength;
		uniform float _InteractionRadius;
		uniform float _InteractionAlpha;
		uniform float4 _ColorTop;
		uniform float4 _ColorBottom;
		uniform float _ColorBottomLevel;
		uniform float _ColorBottomMaskFade;
		uniform sampler2D _FoliageTexture;
		uniform float4 _FoliageTexture_ST;
		uniform float _Smoothness;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
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


		struct Gradient
		{
			int type;
			int colorsLength;
			int alphasLength;
			float4 colors[8];
			float2 alphas[8];
		};


		Gradient NewGradient(int type, int colorsLength, int alphasLength, 
		float4 colors0, float4 colors1, float4 colors2, float4 colors3, float4 colors4, float4 colors5, float4 colors6, float4 colors7,
		float2 alphas0, float2 alphas1, float2 alphas2, float2 alphas3, float2 alphas4, float2 alphas5, float2 alphas6, float2 alphas7)
		{
			Gradient g;
			g.type = type;
			g.colorsLength = colorsLength;
			g.alphasLength = alphasLength;
			g.colors[ 0 ] = colors0;
			g.colors[ 1 ] = colors1;
			g.colors[ 2 ] = colors2;
			g.colors[ 3 ] = colors3;
			g.colors[ 4 ] = colors4;
			g.colors[ 5 ] = colors5;
			g.colors[ 6 ] = colors6;
			g.colors[ 7 ] = colors7;
			g.alphas[ 0 ] = alphas0;
			g.alphas[ 1 ] = alphas1;
			g.alphas[ 2 ] = alphas2;
			g.alphas[ 3 ] = alphas3;
			g.alphas[ 4 ] = alphas4;
			g.alphas[ 5 ] = alphas5;
			g.alphas[ 6 ] = alphas6;
			g.alphas[ 7 ] = alphas7;
			return g;
		}


		float4 SampleGradient( Gradient gradient, float time )
		{
			float3 color = gradient.colors[0].rgb;
			UNITY_UNROLL
			for (int c = 1; c < 8; c++)
			{
			float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, (float)gradient.colorsLength-1));
			color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
			}
			#ifndef UNITY_COLORSPACE_GAMMA
			color = half3(GammaToLinearSpaceExact(color.r), GammaToLinearSpaceExact(color.g), GammaToLinearSpaceExact(color.b));
			#endif
			float alpha = gradient.alphas[0].x;
			UNITY_UNROLL
			for (int a = 1; a < 8; a++)
			{
			float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, (float)gradient.alphasLength-1));
			alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
			}
			return float4(color, alpha);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float mulTime45 = _Time.y * ( _WindSpeed * 3 );
			float simplePerlin3D47 = snoise( ( ase_worldPos + mulTime45 )*_WindScale );
			float vWind54 = ( ( simplePerlin3D47 * 0.015 ) * _WindIntensity );
			Gradient gradient91 = NewGradient( 0, 2, 2, float4( 0, 0, 0, 0 ), float4( 1, 1, 1, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float4 normalizeResult76 = normalize( ( _ActorPosition - float4( ase_worldPos , 0.0 ) ) );
			float temp_output_79_0 = ( _InteractionStrength * 0.1 );
			float3 appendResult80 = (float3(temp_output_79_0 , 0.0 , temp_output_79_0));
			float clampResult84 = clamp( ( distance( _ActorPosition , float4( ase_worldPos , 0.0 ) ) / _InteractionRadius ) , 0.0 , 1.0 );
			float4 vInteraction97 = ( SampleGradient( gradient91, v.texcoord.xy.y ) * -( ( ( normalizeResult76 * float4( appendResult80 , 0.0 ) ) * ( 1.0 - clampResult84 ) ) * _InteractionAlpha ) );
			v.vertex.xyz += ( vWind54 + vInteraction97 ).rgb;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			#if !DIRECTIONAL
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult7 = lerp( _ColorTop , _ColorBottom , saturate( ( ( ase_vertex3Pos.y + _ColorBottomLevel ) * ( _ColorBottomMaskFade * 2 ) ) ));
			float2 uv_FoliageTexture = i.uv_texcoord * _FoliageTexture_ST.xy + _FoliageTexture_ST.zw;
			float4 tex2DNode10 = tex2D( _FoliageTexture, uv_FoliageTexture );
			o.Albedo = ( lerpResult7 * tex2DNode10 ).rgb;
			o.Smoothness = _Smoothness;
			float3 temp_cast_1 = (1.0).xxx;
			o.Translucency = temp_cast_1;
			o.Alpha = 1;
			clip( tex2DNode10.a - _AlphaCutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18800
599;73;2462;1474;4834.073;2166.452;2.411333;True;True
Node;AmplifyShaderEditor.CommentaryNode;100;-3406.513,-1040.341;Inherit;False;2587.448;615.8922;Allows the foliage to interact with actors that have the interaction script attached.;23;97;96;94;89;92;93;87;91;86;88;85;77;76;84;80;82;75;79;83;78;81;73;74;Actor Interaction;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;73;-3356.513,-990.3409;Inherit;False;Global;_ActorPosition;_ActorPosition;11;1;[HideInInspector];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;74;-3349.053,-815.6851;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;81;-3028.024,-747.748;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-3093.024,-635.7481;Inherit;False;Global;_InteractionRadius;_InteractionRadius;11;1;[HideInInspector];Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-3026.623,-829.929;Inherit;False;Global;_InteractionStrength;_InteractionStrength;11;1;[HideInInspector];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;75;-3057.054,-984.6862;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;82;-2793.024,-652.7481;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;79;-2735.378,-826.0875;Inherit;False;0.1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;53;-2540.636,399.6094;Inherit;False;1720.628;427.0284;;11;54;49;50;51;47;48;43;42;45;46;44;Wind;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;84;-2640.024,-652.7481;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-2490.636,635.8793;Inherit;False;Property;_WindSpeed;Wind Speed;7;0;Create;True;0;0;0;False;1;Header(WIND);False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;76;-2879.053,-983.6862;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;80;-2531.175,-826.4569;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;85;-2475.025,-652.7481;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;46;-2188.636,641.8793;Inherit;False;3;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-2308.052,-983.0119;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-2108.025,-677.7481;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-2172.885,-572.6478;Inherit;False;Property;_InteractionAlpha;Interaction Alpha;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;42;-2058.219,449.6096;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;45;-2049.636,642.8793;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;52;-2459.277,-383.4121;Inherit;False;1644.996;753.1735;;14;4;18;32;33;35;34;6;8;12;5;7;10;15;71;Color;0.3254717,1,0.957823,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-1785.635,543.8792;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;93;-2087.064,-880.5146;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-1903.476,-677.4487;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2048.155,718.5583;Inherit;False;Property;_WindScale;Wind Scale;8;0;Create;True;0;0;0;False;0;False;0.2588236;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;91;-2054.065,-955.5146;Inherit;False;0;2;2;0,0,0,0;1,1,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2384.894,93.23599;Inherit;False;Property;_ColorBottomLevel;Color Bottom Level;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;92;-1834.065,-955.5146;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;89;-1678.065,-679.5145;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2409.277,177.8662;Inherit;False;Property;_ColorBottomMaskFade;Color Bottom Mask Fade;5;0;Create;True;0;0;0;False;0;False;0;0;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;47;-1617.09,538.5517;Inherit;False;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;32;-2383.81,-49.3525;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-1481.065,-703.5145;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1616.152,682.5583;Inherit;False;Property;_WindIntensity;Wind Intensity;9;0;Create;True;0;0;0;False;0;False;5;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;50;-1414.153,542.5586;Inherit;False;0.015;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-2109.7,47.1448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;35;-2141.813,179.7432;Inherit;False;2;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1960.536,43.05689;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1257.152,542.5586;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;96;-1323.065,-703.5145;Inherit;False;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;8;-1658.781,-133.4123;Inherit;False;Property;_ColorBottom;Color Bottom;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;5;-1654.854,43.8227;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1662.287,137.0003;Inherit;True;Property;_FoliageTexture;Foliage Texture;1;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-1089.065,-707.5145;Inherit;False;vInteraction;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;6;-1653.781,-333.4121;Inherit;False;Property;_ColorTop;Color Top;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-1069.466,537.9222;Inherit;False;vWind;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;7;-1330.781,-75.41228;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-417.9478,286.1945;Inherit;False;54;vWind;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-1434.809,139.7614;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;12;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;99;-442.4053,386.4952;Inherit;False;97;vInteraction;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-511.9848,85.3504;Inherit;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-513.5779,7.474875;Inherit;False;Property;_AlphaCutoff;Alpha Cutoff;0;0;Create;True;0;0;0;False;0;False;0.35;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-117.4962,291.2001;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1069.281,-76.24271;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-418.6611,158.4278;Inherit;False;Constant;_Translucency;Translucency;7;0;Create;True;0;0;0;False;0;False;1;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-999.1423,86.40125;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;198.6407,-68.82959;Float;False;True;-1;2;;0;0;Standard;Polyart/Dreamscape Foliage;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.05;True;True;0;False;TransparentCutout;;AlphaTest;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;11;-1;-1;0;False;0;0;False;-1;-1;0;True;1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;81;0;73;0
WireConnection;81;1;74;0
WireConnection;75;0;73;0
WireConnection;75;1;74;0
WireConnection;82;0;81;0
WireConnection;82;1;83;0
WireConnection;79;0;78;0
WireConnection;84;0;82;0
WireConnection;76;0;75;0
WireConnection;80;0;79;0
WireConnection;80;2;79;0
WireConnection;85;0;84;0
WireConnection;46;0;44;0
WireConnection;77;0;76;0
WireConnection;77;1;80;0
WireConnection;86;0;77;0
WireConnection;86;1;85;0
WireConnection;45;0;46;0
WireConnection;43;0;42;0
WireConnection;43;1;45;0
WireConnection;87;0;86;0
WireConnection;87;1;88;0
WireConnection;92;0;91;0
WireConnection;92;1;93;2
WireConnection;89;0;87;0
WireConnection;47;0;43;0
WireConnection;47;1;48;0
WireConnection;94;0;92;0
WireConnection;94;1;89;0
WireConnection;50;0;47;0
WireConnection;33;0;32;2
WireConnection;33;1;18;0
WireConnection;35;0;4;0
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;49;0;50;0
WireConnection;49;1;51;0
WireConnection;96;0;94;0
WireConnection;5;0;34;0
WireConnection;97;0;96;0
WireConnection;54;0;49;0
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;7;2;5;0
WireConnection;10;0;12;0
WireConnection;98;0;55;0
WireConnection;98;1;99;0
WireConnection;15;0;7;0
WireConnection;15;1;10;0
WireConnection;0;0;15;0
WireConnection;0;4;36;0
WireConnection;0;7;37;0
WireConnection;0;10;10;4
WireConnection;0;11;98;0
ASEEND*/
//CHKSM=31B7A509219E80161FA01C1673520D15D7552F0B