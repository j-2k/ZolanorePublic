// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape Water"
{
	Properties
	{
		[Header(COLOR)]_ColorShallow("Color Shallow", Color) = (0.5990566,0.9091429,1,0)
		_ColorDeep("Color Deep", Color) = (0.1213065,0.347919,0.5471698,0)
		_ColorDepthFade("Color Depth Fade", Float) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 1
		[Header(FOAM)]_FoamColor("Foam Color", Color) = (1,1,1,1)
		_FoamDepthFade("Foam Depth Fade", Float) = 0.19
		_FoamCutoff("Foam Cutoff", Float) = 0
		_FoamScale("Foam Scale", Float) = 2
		_FoamSpeed("Foam Speed", Float) = 1
		[Header(REFRACTION)]_RefractionStrength("Refraction Strength", Float) = 0
		_RefractionDepth("Refraction Depth", Float) = 0
		[Header(WAVES)]_WaveNormal("Wave Normal", 2D) = "bump" {}
		_WaveNormalIntensity("Wave Normal Intensity", Range( 0 , 1)) = 1
		[Toggle(_WORLDTOOBJECTPOSITION_ON)] _WorldtoObjectPosition("World to Object Position?", Float) = 0
		_Displacement("Displacement", 2D) = "gray" {}
		_DisplaceStrength("Displace Strength", Range( -1 , 1)) = 0
		[IntRange]_WaveTiling01("Wave Tiling 01", Range( 0 , 50)) = 1
		[IntRange]_WaveTiling02("Wave Tiling 02", Range( 0 , 50)) = 1
		[Header(REFLECTION)]_ReflectionTex("ReflectionTex", 2D) = "black" {}
		_ReflectionNormal("Reflection Normal", 2D) = "bump" {}
		_ReflectionsIntensity("ReflectionsIntensity", Range( 0 , 3)) = 1
		_TurbulenceScale("TurbulenceScale", Float) = 1
		_TurbulenceTiling("Turbulence Tiling", Float) = 0
		_TurbulenceDistortionIntensity("Turbulence Distortion Intensity", Range( 0 , 6)) = 0.8
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature _WORLDTOOBJECTPOSITION_ON
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Standard alpha:fade keepalpha noshadow exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldNormal;
			INTERNAL_DATA
			float eyeDepth;
		};

		uniform sampler2D _Displacement;
		uniform float _WaveTiling01;
		uniform float _WaveTiling02;
		uniform float _DisplaceStrength;
		uniform sampler2D _WaveNormal;
		uniform float _WaveNormalIntensity;
		uniform sampler2D _ReflectionTex;
		uniform sampler2D _ReflectionNormal;
		uniform float _TurbulenceTiling;
		uniform float _TurbulenceScale;
		uniform float _TurbulenceDistortionIntensity;
		uniform float _ReflectionsIntensity;
		uniform float4 _ColorShallow;
		uniform float4 _ColorDeep;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _ColorDepthFade;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _FoamSpeed;
		uniform float _FoamScale;
		uniform float _RefractionStrength;
		uniform float _RefractionDepth;
		uniform float4 _FoamColor;
		uniform float _FoamDepthFade;
		uniform float _FoamCutoff;
		uniform float _Smoothness;
		uniform float _Opacity;


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		float3 PerturbNormal107_g2( float3 surf_pos, float3 surf_norm, float height, float scale )
		{
			// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
			float3 vSigmaS = ddx( surf_pos );
			float3 vSigmaT = ddy( surf_pos );
			float3 vN = surf_norm;
			float3 vR1 = cross( vSigmaT , vN );
			float3 vR2 = cross( vN , vSigmaS );
			float fDet = dot( vSigmaS , vR1 );
			float dBs = ddx( height );
			float dBt = ddy( height );
			float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
			return normalize ( abs( fDet ) * vN - vSurfGrad );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_WaveTiling01).xx;
			float2 uv_TexCoord91 = v.texcoord.xy * temp_cast_0;
			float2 panner93 = ( 1.0 * _Time.y * float2( 0.07,0.07 ) + uv_TexCoord91);
			float2 temp_cast_1 = (_WaveTiling02).xx;
			float2 uv_TexCoord105 = v.texcoord.xy * temp_cast_1;
			float2 panner106 = ( 1.0 * _Time.y * float2( -0.07,-0.07 ) + uv_TexCoord105);
			float vDisplacement123 = ( saturate( ( tex2Dlod( _Displacement, float4( panner93, 0, 0.0) ).r + tex2Dlod( _Displacement, float4( panner106, 0, 0.0) ).r ) ) * _DisplaceStrength );
			float3 temp_cast_2 = (vDisplacement123).xxx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 worldToObj100 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			float3 appendResult101 = (float3(worldToObj100.x , vDisplacement123 , worldToObj100.z));
			#ifdef _WORLDTOOBJECTPOSITION_ON
				float3 staticSwitch138 = appendResult101;
			#else
				float3 staticSwitch138 = temp_cast_2;
			#endif
			v.vertex.xyz += staticSwitch138;
			v.vertex.w = 1;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_WaveTiling01).xx;
			float2 uv_TexCoord91 = i.uv_texcoord * temp_cast_0;
			float2 panner93 = ( 1.0 * _Time.y * float2( 0.07,0.07 ) + uv_TexCoord91);
			float2 temp_cast_2 = (_WaveTiling02).xx;
			float2 uv_TexCoord105 = i.uv_texcoord * temp_cast_2;
			float2 panner106 = ( 1.0 * _Time.y * float2( -0.07,-0.07 ) + uv_TexCoord105);
			float3 vNormal90 = BlendNormals( UnpackScaleNormal( tex2D( _WaveNormal, panner93 ), _WaveNormalIntensity ) , UnpackScaleNormal( tex2D( _WaveNormal, panner106 ), _WaveNormalIntensity ) );
			o.Normal = vNormal90;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 appendResult78 = (float2(( ase_screenPosNorm.x + 0.01 ) , ( ase_screenPosNorm.y + 0.01 )));
			float2 temp_cast_5 = (_TurbulenceTiling).xx;
			float2 uv_TexCoord66 = i.uv_texcoord * temp_cast_5;
			float2 panner68 = ( 1.0 * _Time.y * float2( 0.1,0.1 ) + ( uv_TexCoord66 * _TurbulenceScale ));
			float temp_output_77_0 = ( UnpackNormal( tex2D( _ReflectionNormal, panner68 ) ).g * _TurbulenceDistortionIntensity );
			float Turbulence86 = temp_output_77_0;
			float4 lerpResult80 = lerp( ase_screenPosNorm , float4( appendResult78, 0.0 , 0.0 ) , Turbulence86);
			float4 vReflection132 = ( tex2D( _ReflectionTex, lerpResult80.xy ) * _ReflectionsIntensity );
			float screenDepth18 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth18 = abs( ( screenDepth18 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _ColorDepthFade ) );
			float4 lerpResult22 = lerp( _ColorShallow , _ColorDeep , saturate( distanceDepth18 ));
			float vDisplacement123 = ( saturate( ( tex2D( _Displacement, panner93 ).r + tex2D( _Displacement, panner106 ).r ) ) * _DisplaceStrength );
			float4 lerpResult102 = lerp( lerpResult22 , ( lerpResult22 + float4( 0.5,0.5,0.5,0 ) ) , vDisplacement123);
			float4 vColorWaves122 = lerpResult102;
			float4 blendOpSrc85 = vReflection132;
			float4 blendOpDest85 = vColorWaves122;
			float4 temp_output_85_0 = ( saturate( ( blendOpSrc85 + blendOpDest85 ) ));
			float3 ase_worldPos = i.worldPos;
			float3 surf_pos107_g2 = ase_worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 surf_norm107_g2 = ase_worldNormal;
			float mulTime7 = _Time.y * 0.1;
			float2 temp_cast_7 = (_FoamSpeed).xx;
			float2 temp_cast_8 = (_FoamScale).xx;
			float2 uv_TexCoord5 = i.uv_texcoord * temp_cast_8;
			float2 panner8 = ( mulTime7 * temp_cast_7 + uv_TexCoord5);
			float simpleNoise13 = SimpleNoise( panner8*50.0 );
			float height107_g2 = simpleNoise13;
			float scale107_g2 = 2.0;
			float3 localPerturbNormal107_g2 = PerturbNormal107_g2( surf_pos107_g2 , surf_norm107_g2 , height107_g2 , scale107_g2 );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir42_g2 = mul( ase_worldToTangent, localPerturbNormal107_g2);
			float3 vRefractionNormal31 = worldToTangentDir42_g2;
			float eyeDepth28_g3 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float2 temp_output_20_0_g3 = ( (vRefractionNormal31).xy * ( _RefractionStrength / max( i.eyeDepth , 0.1 ) ) * saturate( ( eyeDepth28_g3 - i.eyeDepth ) ) );
			float eyeDepth2_g3 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( float4( temp_output_20_0_g3, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ));
			float2 temp_output_32_0_g3 = (( float4( ( temp_output_20_0_g3 * saturate( ( eyeDepth2_g3 - i.eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
			float2 temp_output_1_0_g3 = ( ( floor( ( temp_output_32_0_g3 * (_CameraDepthTexture_TexelSize).zw ) ) + 0.5 ) * (_CameraDepthTexture_TexelSize).xy );
			float4 screenColor36 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_1_0_g3);
			float4 vRefraction35 = screenColor36;
			float4 blendOpSrc58 = temp_output_85_0;
			float4 blendOpDest58 = vRefraction35;
			float screenDepth50 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth50 = abs( ( screenDepth50 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _RefractionDepth ) );
			float4 lerpResult32 = lerp( ( saturate( (( blendOpDest58 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest58 ) * ( 1.0 - blendOpSrc58 ) ) : ( 2.0 * blendOpDest58 * blendOpSrc58 ) ) )) , temp_output_85_0 , saturate( distanceDepth50 ));
			float screenDepth4 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth4 = abs( ( screenDepth4 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FoamDepthFade ) );
			float vFoam15 = step( ( saturate( distanceDepth4 ) * _FoamCutoff ) , simpleNoise13 );
			float4 lerpResult24 = lerp( lerpResult32 , _FoamColor , ( _FoamColor.a * vFoam15 ));
			float4 vFinalColor62 = lerpResult24;
			o.Albedo = vFinalColor62.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = _Opacity;
		}

		ENDCG
	}
}
/*ASEBEGIN
Version=18800
1128;81;1928;1462;4050.077;2290.279;3.534298;True;True
Node;AmplifyShaderEditor.CommentaryNode;131;-2199.885,1676.364;Inherit;False;2331.656;642.8052;;13;64;66;65;67;68;87;69;73;71;74;77;79;86;Reclection Distortion;0.6179246,0.6739129,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;128;-4025.901,992.7787;Inherit;False;2302.552;611.5479;;14;92;104;91;105;106;93;112;108;89;95;94;109;111;90;Wave Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2067.551,2016.169;Inherit;False;Property;_TurbulenceTiling;Turbulence Tiling;23;0;Create;True;0;0;0;False;0;False;0;7.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-3975.901,1463.092;Inherit;False;Property;_WaveTiling02;Wave Tiling 02;18;1;[IntRange];Create;True;0;0;0;False;0;False;1;8;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-3949.457,1087.783;Inherit;False;Property;_WaveTiling01;Wave Tiling 01;17;1;[IntRange];Create;True;0;0;0;False;0;False;1;16;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-1832.837,2115.939;Float;False;Property;_TurbulenceScale;TurbulenceScale;22;0;Create;True;0;0;0;False;0;False;1;12.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-1861.836,1998.939;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;105;-3584.01,1446.757;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;91;-3584.262,1071.448;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1597.838,1998.939;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;127;-3479.284,464.3482;Inherit;False;1538.236;486.9069;;8;115;116;97;123;98;114;96;113;Displacement;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1;-3489.25,-1144.444;Inherit;False;1848.67;580.5197;;16;15;14;12;10;11;4;3;31;30;13;8;9;6;7;5;2;Foam;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-3439.25,-805.126;Inherit;False;Property;_FoamScale;Foam Scale;8;0;Create;True;0;0;0;False;0;False;2;25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;114;-3429.284,685.7327;Inherit;True;Property;_Displacement;Displacement;15;0;Create;True;0;0;0;False;0;False;b166ccd7e871a3948ac1028410a7fe76;b166ccd7e871a3948ac1028410a7fe76;False;gray;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;68;-1397.837,1996.939;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;93;-3304.246,1071.018;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.07,0.07;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;106;-3326.994,1448.327;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.07,-0.07;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;113;-3034.705,721.2551;Inherit;True;Property;_Displace2;Displace 2;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;134;-4025.538,1676.491;Inherit;False;1781.178;536.5786;;11;72;70;76;75;78;130;80;82;81;83;132;Reflections;0.3443396,1,0.6541642,1;0;0
Node;AmplifyShaderEditor.SamplerNode;96;-3030.169,514.3482;Inherit;True;Property;_Displace1;Displace 1;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;16;-3482.801,-490.967;Inherit;False;1918.707;925.1205;Comment;11;103;102;125;122;23;22;21;20;19;18;17;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-1172.842,2166.939;Float;False;Property;_TurbulenceDistortionIntensity;Turbulence Distortion Intensity;24;0;Create;True;0;0;0;False;0;False;0.8;1.84;0;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;87;-1169.538,1968.639;Inherit;True;Property;_ReflectionNormal;Reflection Normal;20;0;Create;True;0;0;0;False;0;False;-1;70546bb8eb214354e83b7f57e5a4821c;70546bb8eb214354e83b7f57e5a4821c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-3223.128,-822.689;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-2961.248,-753.126;Inherit;False;Property;_FoamSpeed;Foam Speed;9;0;Create;True;0;0;0;False;0;False;1;-0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;7;-2968.083,-663.844;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-3432.801,-65.24258;Inherit;False;Property;_ColorDepthFade;Color Depth Fade;2;0;Create;True;0;0;0;False;0;False;0;10.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-2700.11,629.774;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-3885.538,2078.07;Float;False;Constant;_Float4;Float 4;5;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-620.2406,2017.639;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;72;-3975.538,1750.069;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-2651.709,-699.8627;Inherit;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;0;False;0;False;50;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;8;-2679.568,-824.427;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-2602.299,818.5098;Inherit;False;Property;_DisplaceStrength;Displace Strength;16;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;18;-3227.801,-66.24252;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;-111.2278,1870.304;Float;False;Turbulence;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;116;-2561.409,629.4742;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-3576.539,2080.07;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-3574.539,1948.07;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;13;-2465.634,-828.3259;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-3104.985,-239.9671;Inherit;False;Property;_ColorDeep;Color Deep;1;0;Create;True;0;0;0;False;0;False;0.1213065,0.347919,0.5471698,0;0,0.2996509,0.4056603,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;130;-3370.322,2090.697;Inherit;False;86;Turbulence;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;21;-2968.8,-67.24252;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-3078.985,-408.9668;Inherit;False;Property;_ColorShallow;Color Shallow;0;0;Create;True;0;0;0;False;1;Header(COLOR);False;0.5990566,0.9091429,1,0;0,0.4749352,0.6132076,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;30;-2175.383,-826.6631;Inherit;False;Normal From Height;-1;;2;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;2;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-2347.951,745.2076;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;78;-3368.539,1997.07;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;129;-1617.562,-1141.604;Inherit;False;1288.338;330.5057;;5;38;37;29;36;35;Refraction;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1894.384,-831.6631;Inherit;False;vRefractionNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;80;-3133.538,1755.07;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-2197.049,739.3414;Inherit;False;vDisplacement;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2958.535,-1076.027;Inherit;False;Property;_FoamDepthFade;Foam Depth Fade;6;0;Create;True;0;0;0;False;0;False;0.19;0.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;22;-2625.206,-113.3675;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-2373.227,336.0485;Inherit;False;123;vDisplacement;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;4;-2694.736,-1094.127;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1546.187,-1006.432;Inherit;False;Property;_RefractionStrength;Refraction Strength;10;0;Create;True;0;0;0;False;1;Header(REFRACTION);False;0;0.71;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-2361.698,203.3883;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.5,0.5,0.5,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-2950.053,1929.34;Float;False;Property;_ReflectionsIntensity;ReflectionsIntensity;21;0;Create;True;0;0;0;False;0;False;1;0.083;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-1567.562,-1091.604;Inherit;False;31;vRefractionNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;81;-2963.539,1727.07;Inherit;True;Property;_ReflectionTex;ReflectionTex;19;0;Create;True;0;0;0;False;1;Header(REFLECTION);False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;29;-1270.5,-1087.091;Inherit;False;DepthMaskedRefraction;-1;;3;c805f061214177c42bca056464193f81;2,40,0,103,0;2;35;FLOAT3;0,0,0;False;37;FLOAT;0.02;False;1;FLOAT2;38
Node;AmplifyShaderEditor.LerpOp;102;-2071.087,176.7405;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-2643.131,1731.462;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;11;-2447.805,-1094.444;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2614.805,-981.4434;Inherit;False;Property;_FoamCutoff;Foam Cutoff;7;0;Create;True;0;0;0;False;0;False;0;0.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-2285.805,-1093.444;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;36;-785.8376,-1090.775;Inherit;False;Global;_GrabScreen0;Grab Screen 0;4;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-1863.157,172.0844;Inherit;False;vColorWaves;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-2487.359,1726.491;Inherit;False;vReflection;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;135;-1522.758,988.5527;Inherit;False;1647.683;631.2351;;14;62;24;28;27;25;32;54;58;26;85;50;133;84;49;Color Blending;1,0.3537736,0.3968199,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1372.582,1298.788;Inherit;False;Property;_RefractionDepth;Refraction Depth;11;0;Create;True;0;0;0;False;0;False;0;9.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-1467.475,1038.553;Inherit;False;132;vReflection;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;14;-2083.804,-1094.444;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-1472.758,1121.829;Inherit;False;122;vColorWaves;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-572.2237,-1090.303;Inherit;False;vRefraction;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;85;-1147.858,1068.929;Inherit;False;LinearDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;112;-3437.403,1243.091;Inherit;True;Property;_WaveNormal;Wave Normal;12;0;Create;True;0;0;0;False;1;Header(WAVES);False;70546bb8eb214354e83b7f57e5a4821c;70546bb8eb214354e83b7f57e5a4821c;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DepthFade;50;-1133.582,1281.788;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-1132.364,1193.508;Inherit;False;35;vRefraction;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-1892.176,-1099.347;Inherit;False;vFoam;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;89;-2911.149,1042.779;Inherit;True;Property;_Tex1;Tex1;1;0;Create;True;0;0;0;False;0;False;-1;None;70546bb8eb214354e83b7f57e5a4821c;True;0;True;bump;LockedToTexture2D;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;108;-2912.896,1356.088;Inherit;True;Property;_Tex;Tex;3;0;Create;True;0;0;0;False;0;False;-1;None;70546bb8eb214354e83b7f57e5a4821c;True;0;True;bump;LockedToTexture2D;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;25;-535.4624,1533.403;Inherit;False;15;vFoam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;137;-1249.946,393.4792;Inherit;False;1224.4;249.704;;5;138;101;126;100;99;Vertex Offset;0.4985158,1,0.3632075,1;0;0
Node;AmplifyShaderEditor.ColorNode;27;-559.1514,1360.318;Inherit;False;Property;_FoamColor;Foam Color;5;0;Create;True;0;0;0;False;1;Header(FOAM);False;1,1,1,1;1,1,1,0.145098;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;95;-2901.776,1249.447;Inherit;False;Property;_WaveNormalIntensity;Wave Normal Intensity;13;0;Create;True;0;0;0;False;0;False;1;0.249;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;54;-868.0813,1282.187;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;58;-784.3503,1071.296;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;99;-969.9398,461.4792;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;32;-555.1415,1236.295;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-325.2072,1457.519;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;109;-2573.524,1361.756;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.UnpackScaleNormalNode;94;-2567.777,1045.447;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;126;-1182.946,495.5646;Inherit;False;123;vDisplacement;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;111;-2199.949,1219.803;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformPositionNode;100;-782.9399,457.4792;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;24;-271.7448,1239.201;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-1966.35,1216.137;Inherit;False;vNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-94.07522,1234.259;Inherit;False;vFinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;101;-512.5461,490.1832;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-215.1826,32.32179;Inherit;False;90;vNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-923.9795,1850.365;Float;False;Property;_WaveDistortionIntensity;Wave Distortion Intensity;25;0;Create;True;0;0;0;False;0;False;0.6;4;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-314.0891,264.4019;Inherit;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;138;-357.2596,486.1949;Inherit;False;Property;_WorldtoObjectPosition;World to Object Position?;14;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-607.9788,1773.364;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-2291.895,-115.9809;Inherit;False;vDepthColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-432.2787,1772.364;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-228.2217,-44.82281;Inherit;False;62;vFinalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-883.9799,1726.364;Inherit;False;31;vRefractionNormal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-315.6348,185.9828;Inherit;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;32,0;Float;False;True;-1;2;;0;0;Standard;Polyart/Dreamscape Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;66;0;64;0
WireConnection;105;0;104;0
WireConnection;91;0;92;0
WireConnection;67;0;66;0
WireConnection;67;1;65;0
WireConnection;68;0;67;0
WireConnection;93;0;91;0
WireConnection;106;0;105;0
WireConnection;113;0;114;0
WireConnection;113;1;106;0
WireConnection;96;0;114;0
WireConnection;96;1;93;0
WireConnection;87;1;68;0
WireConnection;5;0;2;0
WireConnection;115;0;96;1
WireConnection;115;1;113;1
WireConnection;77;0;87;2
WireConnection;77;1;71;0
WireConnection;8;0;5;0
WireConnection;8;2;6;0
WireConnection;8;1;7;0
WireConnection;18;0;17;0
WireConnection;86;0;77;0
WireConnection;116;0;115;0
WireConnection;75;0;72;2
WireConnection;75;1;70;0
WireConnection;76;0;72;1
WireConnection;76;1;70;0
WireConnection;13;0;8;0
WireConnection;13;1;9;0
WireConnection;21;0;18;0
WireConnection;30;20;13;0
WireConnection;97;0;116;0
WireConnection;97;1;98;0
WireConnection;78;0;76;0
WireConnection;78;1;75;0
WireConnection;31;0;30;40
WireConnection;80;0;72;0
WireConnection;80;1;78;0
WireConnection;80;2;130;0
WireConnection;123;0;97;0
WireConnection;22;0;20;0
WireConnection;22;1;19;0
WireConnection;22;2;21;0
WireConnection;4;0;3;0
WireConnection;103;0;22;0
WireConnection;81;1;80;0
WireConnection;29;35;38;0
WireConnection;29;37;37;0
WireConnection;102;0;22;0
WireConnection;102;1;103;0
WireConnection;102;2;125;0
WireConnection;83;0;81;0
WireConnection;83;1;82;0
WireConnection;11;0;4;0
WireConnection;12;0;11;0
WireConnection;12;1;10;0
WireConnection;36;0;29;38
WireConnection;122;0;102;0
WireConnection;132;0;83;0
WireConnection;14;0;12;0
WireConnection;14;1;13;0
WireConnection;35;0;36;0
WireConnection;85;0;133;0
WireConnection;85;1;84;0
WireConnection;50;0;49;0
WireConnection;15;0;14;0
WireConnection;89;0;112;0
WireConnection;89;1;93;0
WireConnection;108;0;112;0
WireConnection;108;1;106;0
WireConnection;54;0;50;0
WireConnection;58;0;85;0
WireConnection;58;1;26;0
WireConnection;32;0;58;0
WireConnection;32;1;85;0
WireConnection;32;2;54;0
WireConnection;28;0;27;4
WireConnection;28;1;25;0
WireConnection;109;0;108;0
WireConnection;109;1;95;0
WireConnection;94;0;89;0
WireConnection;94;1;95;0
WireConnection;111;0;94;0
WireConnection;111;1;109;0
WireConnection;100;0;99;0
WireConnection;24;0;32;0
WireConnection;24;1;27;0
WireConnection;24;2;28;0
WireConnection;90;0;111;0
WireConnection;62;0;24;0
WireConnection;101;0;100;1
WireConnection;101;1;126;0
WireConnection;101;2;100;3
WireConnection;138;1;126;0
WireConnection;138;0;101;0
WireConnection;74;0;73;0
WireConnection;74;1;69;0
WireConnection;23;0;22;0
WireConnection;79;0;74;0
WireConnection;79;1;77;0
WireConnection;0;0;63;0
WireConnection;0;1;39;0
WireConnection;0;4;61;0
WireConnection;0;9;136;0
WireConnection;0;11;138;0
ASEEND*/
//CHKSM=4DD8176F80382791983FDC43FFC19DB5C58B3B24