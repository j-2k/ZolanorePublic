// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape Grass"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.59
		_ColorTop("Color Top", Color) = (0,0,0,0)
		_ColorTopVariation("Color Top Variation", Color) = (0,0,0,0)
		_ColorBottom("Color Bottom", Color) = (0,0,0,0)
		_ColorBottomLevel("Color Bottom Level", Float) = 0
		_ColorBottomMaskFade("Color Bottom Mask Fade", Range( -1 , 1)) = 0
		_FoliageTexture("Foliage Texture", 2D) = "white" {}
		_Smoothness("Smoothness", Range( -2 , 2)) = 1
		_ColorWave("Color Wave", Color) = (0,0,0,0)
		_WaveScale("Wave Scale", Float) = 33
		_VariationMapScale("Variation Map Scale", Float) = 15
		_WaveSpeed("Wave Speed", Color) = (0.1320755,0.1320755,0.1320755,0)
		_PanningWaveTexture("Panning Wave Texture", 2D) = "white" {}
		_VariationMask("Variation Mask", 2D) = "white" {}
		_InteractionAlpha("Interaction Alpha", Float) = 1
		_WindNoiseTexture("Wind Noise Texture", 2D) = "white" {}
		_WindNoiseSmallMultiply("Wind Noise Small Multiply", Range( -10 , 10)) = 0
		_WindNoiseLargeMultiply("Wind Noise Large Multiply", Range( -10 , 10)) = 1
		_PivotLockPower("Pivot Lock Power", Range( 0 , 10)) = 2
		_WindNoiseLarge("Wind Noise Large", Float) = 20
		_WindNoiseSmall("Wind Noise Small", Float) = 20
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _WindNoiseTexture;
		uniform float _WindNoiseSmall;
		uniform float _WindNoiseSmallMultiply;
		uniform float _WindNoiseLarge;
		uniform float _WindNoiseLargeMultiply;
		uniform float _PivotLockPower;
		uniform float4 _ActorPosition;
		uniform float _InteractionStrength;
		uniform float _InteractionRadius;
		uniform float _InteractionAlpha;
		uniform sampler2D _FoliageTexture;
		uniform float4 _FoliageTexture_ST;
		uniform float4 _ColorWave;
		uniform float4 _ColorTop;
		uniform float4 _ColorTopVariation;
		uniform sampler2D _VariationMask;
		uniform float _VariationMapScale;
		uniform float4 _ColorBottom;
		uniform float _ColorBottomLevel;
		uniform float _ColorBottomMaskFade;
		uniform sampler2D _PanningWaveTexture;
		uniform float4 _WaveSpeed;
		uniform float _WaveScale;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.59;


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
			float4 color128 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 lerpResult107 = lerp( ( tex2Dlod( _WindNoiseTexture, float4( ( ( float2( 0,0.2 ) * _Time.y ) + ( (ase_worldPos).xz / _WindNoiseSmall ) ), 0, 0.0) ) * _WindNoiseSmallMultiply ) , ( tex2Dlod( _WindNoiseTexture, float4( ( ( float2( 0,0.1 ) * _Time.y ) + ( (ase_worldPos).xz / _WindNoiseLarge ) ), 0, 0.0) ) * _WindNoiseLargeMultiply ) , 0.5);
			Gradient gradient111 = NewGradient( 0, 2, 2, float4( 0, 0, 0, 0 ), float4( 1, 1, 1, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float4 temp_cast_0 = (_PivotLockPower).xxxx;
			float4 lerpResult108 = lerp( color128 , lerpResult107 , pow( SampleGradient( gradient111, v.texcoord.xy.y ) , temp_cast_0 ));
			float4 vWind116 = lerpResult108;
			Gradient gradient74 = NewGradient( 0, 2, 2, float4( 0, 0, 0, 0 ), float4( 1, 1, 1, 1 ), 0, 0, 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float4 normalizeResult69 = normalize( ( _ActorPosition - float4( ase_worldPos , 0.0 ) ) );
			float temp_output_64_0 = ( _InteractionStrength * 0.1 );
			float3 appendResult67 = (float3(temp_output_64_0 , 0.0 , temp_output_64_0));
			float clampResult68 = clamp( ( distance( _ActorPosition , float4( ase_worldPos , 0.0 ) ) / _InteractionRadius ) , 0.0 , 1.0 );
			float4 vInteraction81 = ( SampleGradient( gradient74, v.texcoord.xy.y ) * -( ( ( normalizeResult69 * float4( appendResult67 , 0.0 ) ) * ( 1.0 - clampResult68 ) ) * _InteractionAlpha ) );
			v.vertex.xyz += ( vWind116 + vInteraction81 ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_FoliageTexture = i.uv_texcoord * _FoliageTexture_ST.xy + _FoliageTexture_ST.zw;
			float4 tex2DNode22 = tex2D( _FoliageTexture, uv_FoliageTexture );
			float4 vWaveColor28 = ( tex2DNode22 * _ColorWave );
			float3 ase_worldPos = i.worldPos;
			float4 lerpResult132 = lerp( _ColorTop , _ColorTopVariation , tex2D( _VariationMask, (( ase_worldPos / _VariationMapScale )).xz ));
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult23 = lerp( lerpResult132 , _ColorBottom , saturate( ( ( ase_vertex3Pos.y + _ColorBottomLevel ) * ( _ColorBottomMaskFade * 2 ) ) ));
			float4 vColor27 = ( lerpResult23 * tex2DNode22 );
			float2 panner5 = ( _Time.y * (_WaveSpeed).rg + (( ase_worldPos / _WaveScale )).xz);
			float4 lerpResult9 = lerp( vWaveColor28 , vColor27 , tex2D( _PanningWaveTexture, panner5 ));
			o.Albedo = lerpResult9.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			float vAlpha125 = tex2DNode22.a;
			clip( vAlpha125 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18800
599;73;2462;1474;4142.914;2128.993;2.93637;True;True
Node;AmplifyShaderEditor.CommentaryNode;58;-3996.169,-2157.188;Inherit;False;2587.448;615.8922;Allows the foliage to interact with actors that have the interaction script attached.;23;81;80;79;78;77;76;74;75;73;72;71;70;68;69;67;66;65;64;62;63;61;59;60;Actor Interaction;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;60;-3946.169,-2107.188;Inherit;False;Global;_ActorPosition;_ActorPosition;11;1;[HideInInspector];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;59;-3938.709,-1932.533;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;61;-3617.68,-1864.596;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-3682.68,-1752.596;Inherit;False;Global;_InteractionRadius;_InteractionRadius;11;1;[HideInInspector];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-3616.279,-1946.777;Inherit;False;Global;_InteractionStrength;_InteractionStrength;11;1;[HideInInspector];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;31;-4297.923,-1506.582;Inherit;False;2888.247;1209.859;Comment;25;125;27;28;25;24;26;22;23;132;20;21;19;18;135;17;139;15;16;13;14;12;140;138;136;137;Cloud Tint;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;105;-3433.905,1650.35;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;66;-3382.68,-1769.596;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;86;-3438.573,962.7123;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleNode;64;-3325.034,-1942.935;Inherit;False;0.1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;65;-3646.71,-2101.534;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;83;-3298.758,853.3222;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;102;-3293.089,1540.96;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-3236.905,1731.35;Inherit;False;Property;_WindNoiseLarge;Wind Noise Large;19;0;Create;True;0;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;67;-3120.831,-1943.305;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-3241.573,1043.712;Inherit;False;Property;_WindNoiseSmall;Wind Noise Small;20;0;Create;True;0;0;0;False;0;False;20;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;103;-3291.089,1411.959;Inherit;False;Constant;_Vector1;Vector 1;14;0;Create;True;0;0;0;False;0;False;0,0.1;0,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;82;-3295.758,724.322;Inherit;False;Constant;_Vector0;Vector 0;15;0;Create;True;0;0;0;False;0;False;0,0.2;0,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;99;-3233.905,1647.35;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;68;-3229.68,-1769.596;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;69;-3468.709,-2100.534;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;87;-3238.573,957.7123;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;136;-4228,-1180.523;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;137;-4227.206,-1040.128;Inherit;False;Property;_VariationMapScale;Variation Map Scale;10;0;Create;True;0;0;0;False;0;False;15;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-3974.688,-833.8131;Inherit;False;Property;_ColorBottomLevel;Color Bottom Level;4;0;Create;True;0;0;0;False;0;False;0;-0.66;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;14;-3973.604,-976.4011;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;100;-2958.905,1648.35;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-3056.758,730.322;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;138;-3909.894,-1181.229;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;70;-3064.681,-1769.596;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-2897.708,-2099.86;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-3060.089,1416.959;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-3999.071,-749.1827;Inherit;False;Property;_ColorBottomMaskFade;Color Bottom Mask Fade;5;0;Create;True;0;0;0;False;0;False;0;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;88;-2943.573,964.7123;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-2762.541,-1689.496;Inherit;False;Property;_InteractionAlpha;Interaction Alpha;14;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-2733.758,730.322;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-2729.089,1417.959;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-2697.681,-1794.596;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;91;-2946.567,1128.167;Inherit;True;Property;_WindNoiseTexture;Wind Noise Texture;15;0;Create;True;0;0;0;False;0;False;f3a1f84b44733e44e9e06b47e364540b;f3a1f84b44733e44e9e06b47e364540b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-3699.494,-879.9042;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;16;-3731.607,-747.3055;Inherit;False;2;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;139;-3769.392,-1185.529;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-2676.72,-1997.362;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;96;-2450.918,1388.745;Inherit;True;Property;_TextureSample2;Texture Sample 2;16;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;135;-3264.898,-1231.264;Inherit;False;Property;_ColorTopVariation;Color Top Variation;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4353558,0.5849056,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;94;-2433.429,892.412;Inherit;False;Property;_WindNoiseSmallMultiply;Wind Noise Small Multiply;16;0;Create;True;0;0;0;False;0;False;0;-0.7;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;92;-2455.587,701.1088;Inherit;True;Property;_TextureSample1;Texture Sample 1;16;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientNode;74;-2643.721,-2072.362;Inherit;False;0;2;2;0,0,0,0;1,1,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-2421.761,1584.05;Inherit;False;Property;_WindNoiseLargeMultiply;Wind Noise Large Multiply;17;0;Create;True;0;0;0;False;0;False;1;0.2;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;110;-1337.543,924.8207;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-3550.329,-883.992;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;111;-1304.544,849.8207;Inherit;False;0;2;2;0,0,0,0;1,1,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-2493.132,-1794.296;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;32;-2933.341,-252.1608;Inherit;False;1528.561;709.4982;;12;29;30;9;11;5;6;2;8;7;3;1;4;Color;0.6900728,1,0.5801887,1;0;0
Node;AmplifyShaderEditor.ColorNode;18;-3250.869,-1400.156;Inherit;False;Property;_ColorTop;Color Top;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4353558,0.5849056,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;140;-3557.04,-1207.155;Inherit;True;Property;_VariationMask;Variation Mask;13;0;Create;True;0;0;0;False;0;False;-1;None;e3adc16eb3921de48a178ce82c92cbd1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-2059.43,705.412;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;20;-3248.576,-1060.461;Inherit;False;Property;_ColorBottom;Color Bottom;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.5454459,0.8018868,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;132;-2995.245,-1247.384;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;77;-2423.721,-2072.362;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;115;-2051.989,839.6182;Inherit;False;Constant;_Float1;Float 1;19;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-2054.76,1393.049;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;21;-3244.649,-883.2263;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;19;-3260.082,-739.0486;Inherit;True;Property;_FoliageTexture;Foliage Texture;6;0;Create;True;0;0;0;False;0;False;None;aa3f5c93e1b271345a875c5ef4ebf6f9;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.NegateNode;78;-2267.721,-1796.362;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2865.737,143.8742;Inherit;False;Property;_WaveScale;Wave Scale;9;0;Create;True;0;0;0;False;0;False;33;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-1056.586,1036.114;Inherit;False;Property;_PivotLockPower;Pivot Lock Power;18;0;Create;True;0;0;0;False;0;False;2;0.95;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;112;-1084.544,849.8207;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-2877.738,-2.125971;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;22;-3032.605,-736.2875;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-2883.341,250.3375;Inherit;False;Property;_WaveSpeed;Wave Speed;11;0;Create;True;0;0;0;False;0;False;0.1320755,0.1320755,0.1320755,0;0.3207546,0.0257209,0.0257209,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;107;-1782.104,707.8413;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;26;-2947.23,-517.8244;Inherit;False;Property;_ColorWave;Color Wave;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.07332758,0.2547169,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;113;-735.5861,849.1146;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;3;-2623.737,-3.125971;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-2070.721,-1820.362;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;23;-2748.578,-925.4611;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;128;-772.5911,579.454;Inherit;False;Constant;_Color2;Color2;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;8;-2629.342,249.338;Inherit;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2119.078,-922.2913;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexToFragmentNode;80;-1912.723,-1820.362;Inherit;False;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;2;-2478.736,-8.125972;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-2591.439,353.5375;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2630.227,-534.8245;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;108;-455.9001,682.441;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-2338.669,-538.0809;Inherit;False;vWaveColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-1678.723,-1824.362;Inherit;False;vInteraction;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-276.6881,677.088;Inherit;False;vWind;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;5;-2201.54,-4.462649;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-1897.878,-925.2293;Inherit;False;vColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-2601.877,-642.1128;Inherit;False;vAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-1352.14,219.8901;Inherit;False;116;vWind;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-1378.598,299.1908;Inherit;False;81;vInteraction;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;11;-2008.783,-34.95191;Inherit;True;Property;_PanningWaveTexture;Panning Wave Texture;12;0;Create;True;0;0;0;False;0;False;-1;None;e3adc16eb3921de48a178ce82c92cbd1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1896.746,-115.1608;Inherit;False;27;vColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-1917.746,-190.1609;Inherit;False;28;vWaveColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-1120.688,225.8957;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;9;-1588.783,-74.95189;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-1173.373,147.4425;Inherit;False;125;vAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-1271.161,55.96643;Inherit;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;0;False;0;False;1;-0.067;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-971.4691,-77.05649;Float;False;True;-1;2;;0;0;Standard;Polyart/Dreamscape Grass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.59;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;1;NatureRendererInstancing=True;False;0;0;False;-1;-1;0;False;-1;3;Pragma;multi_compile_instancing;False;;Custom;Pragma;instancing_options procedural:SetupNatureRenderer;False;;Custom;Include;Assets/Visual Design Cafe/Nature Shaders/Common/Nodes/Integrations/Nature Renderer.cginc;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;120;-3488.248,1339.114;Inherit;False;1598.144;507.6038;Wind Large;0;;0.9711054,0.495283,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;118;-3534.384,600.8654;Inherit;False;2133.215;1279.717;;0;Wind;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;121;-1387.543,799.1146;Inherit;False;912.9565;352;;0;Vertical Gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;119;-3488.573,651.1088;Inherit;False;1890.47;670.058;Wind Small;0;;0.2216981,1,0.9921367,1;0;0
WireConnection;61;0;60;0
WireConnection;61;1;59;0
WireConnection;66;0;61;0
WireConnection;66;1;63;0
WireConnection;64;0;62;0
WireConnection;65;0;60;0
WireConnection;65;1;59;0
WireConnection;67;0;64;0
WireConnection;67;2;64;0
WireConnection;99;0;105;0
WireConnection;68;0;66;0
WireConnection;69;0;65;0
WireConnection;87;0;86;0
WireConnection;100;0;99;0
WireConnection;100;1;97;0
WireConnection;84;0;82;0
WireConnection;84;1;83;0
WireConnection;138;0;136;0
WireConnection;138;1;137;0
WireConnection;70;0;68;0
WireConnection;71;0;69;0
WireConnection;71;1;67;0
WireConnection;101;0;103;0
WireConnection;101;1;102;0
WireConnection;88;0;87;0
WireConnection;88;1;89;0
WireConnection;85;0;84;0
WireConnection;85;1;88;0
WireConnection;98;0;101;0
WireConnection;98;1;100;0
WireConnection;73;0;71;0
WireConnection;73;1;70;0
WireConnection;15;0;14;2
WireConnection;15;1;13;0
WireConnection;16;0;12;0
WireConnection;139;0;138;0
WireConnection;96;0;91;0
WireConnection;96;1;98;0
WireConnection;92;0;91;0
WireConnection;92;1;85;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;75;0;73;0
WireConnection;75;1;72;0
WireConnection;140;1;139;0
WireConnection;93;0;92;0
WireConnection;93;1;94;0
WireConnection;132;0;18;0
WireConnection;132;1;135;0
WireConnection;132;2;140;0
WireConnection;77;0;74;0
WireConnection;77;1;76;2
WireConnection;95;0;96;0
WireConnection;95;1;106;0
WireConnection;21;0;17;0
WireConnection;78;0;75;0
WireConnection;112;0;111;0
WireConnection;112;1;110;2
WireConnection;22;0;19;0
WireConnection;107;0;93;0
WireConnection;107;1;95;0
WireConnection;107;2;115;0
WireConnection;113;0;112;0
WireConnection;113;1;114;0
WireConnection;3;0;1;0
WireConnection;3;1;4;0
WireConnection;79;0;77;0
WireConnection;79;1;78;0
WireConnection;23;0;132;0
WireConnection;23;1;20;0
WireConnection;23;2;21;0
WireConnection;8;0;7;0
WireConnection;24;0;23;0
WireConnection;24;1;22;0
WireConnection;80;0;79;0
WireConnection;2;0;3;0
WireConnection;25;0;22;0
WireConnection;25;1;26;0
WireConnection;108;0;128;0
WireConnection;108;1;107;0
WireConnection;108;2;113;0
WireConnection;28;0;25;0
WireConnection;81;0;80;0
WireConnection;116;0;108;0
WireConnection;5;0;2;0
WireConnection;5;2;8;0
WireConnection;5;1;6;0
WireConnection;27;0;24;0
WireConnection;125;0;22;4
WireConnection;11;1;5;0
WireConnection;124;0;122;0
WireConnection;124;1;123;0
WireConnection;9;0;30;0
WireConnection;9;1;29;0
WireConnection;9;2;11;0
WireConnection;0;0;9;0
WireConnection;0;4;127;0
WireConnection;0;10;126;0
WireConnection;0;11;124;0
ASEEND*/
//CHKSM=8152D834A379B15379E8E4A8C1549A8ECE51ADB3