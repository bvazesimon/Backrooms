// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polygonmaker/Basic-PBR"
{
	Properties
	{
		_MainTex("Diffuse", 2D) = "white" {}
		_Color("Main Color", Color) = (1,1,1,0)
		_ColorR("Color (R)", Color) = (1,1,1,0)
		_ColorG("Color (G)", Color) = (1,1,1,0)
		_ColorB("Color (B)", Color) = (1,1,1,0)
		_TextureSample0("Color Mask (R,G,B)", 2D) = "black" {}
		_ColorTatooR("Color Tatoo (R) |change color opacity", Color) = (1,1,1,0)
		_ColorTatooG("Color Tatoo (G) |change color opacity", Color) = (1,1,1,0)
		_ColorTatooB("Color Tatoo (B) |change color opacity", Color) = (1,1,1,0)
		_Tatoo("Tatoo (R,G,B)", 2D) = "white" {}
		_MetallicGlossMap("Metallic (R), Gloss (Alpha)", 2D) = "black" {}
		_MetallicIntensity("Metallic Intensity", Range( 0 , 2)) = 1
		_GlossMapScale("Glossiness Intensity", Range( 0 , 2)) = 1
		_BumpMap("Normal", 2D) = "bump" {}
		_DetailNormalMap("Detail Normal", 2D) = "bump" {}
		_OcclusionMap("Occlusion (G)", 2D) = "white" {}
		_EmissionMap("Emission", 2D) = "white" {}
		_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_EmissionIntensity("Emission Intensity", Range( 0 , 10)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform sampler2D _DetailNormalMap;
		uniform float4 _DetailNormalMap_ST;
		uniform float4 _ColorR;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _ColorG;
		uniform float4 _ColorB;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _ColorTatooR;
		uniform sampler2D _Tatoo;
		uniform float4 _Tatoo_ST;
		uniform float4 _ColorTatooG;
		uniform float4 _ColorTatooB;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float4 _EmissionColor;
		uniform float _EmissionIntensity;
		uniform sampler2D _MetallicGlossMap;
		uniform float4 _MetallicGlossMap_ST;
		uniform float _MetallicIntensity;
		uniform float _GlossMapScale;
		uniform sampler2D _OcclusionMap;
		uniform float4 _OcclusionMap_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float2 uv_DetailNormalMap = i.uv_texcoord * _DetailNormalMap_ST.xy + _DetailNormalMap_ST.zw;
			o.Normal = BlendNormals( UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) ) , UnpackNormal( tex2D( _DetailNormalMap, uv_DetailNormalMap ) ) );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode27 = tex2D( _TextureSample0, uv_TextureSample0 );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv_Tatoo = i.uv_texcoord * _Tatoo_ST.xy + _Tatoo_ST.zw;
			float4 tex2DNode57 = tex2D( _Tatoo, uv_Tatoo );
			float4 lerpResult58 = lerp( ( ( ( _ColorR * tex2DNode27.r ) + ( 1.0 - tex2DNode27.r ) ) * ( ( _ColorG * tex2DNode27.g ) + ( 1.0 - tex2DNode27.g ) ) * ( ( _ColorB * tex2DNode27.b ) + ( 1.0 - tex2DNode27.b ) ) * ( _Color * tex2D( _MainTex, uv_MainTex ) ) ) , _ColorTatooR , ( _ColorTatooR.a * tex2DNode57.r ));
			float4 lerpResult62 = lerp( lerpResult58 , _ColorTatooG , ( _ColorTatooG.a * tex2DNode57.g ));
			float4 lerpResult63 = lerp( lerpResult62 , _ColorTatooB , ( _ColorTatooB.a * tex2DNode57.b ));
			float4 clampResult56 = clamp( lerpResult63 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult56.rgb;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			o.Emission = ( tex2D( _EmissionMap, uv_EmissionMap ) * _EmissionColor * _EmissionIntensity ).rgb;
			float2 uv_MetallicGlossMap = i.uv_texcoord * _MetallicGlossMap_ST.xy + _MetallicGlossMap_ST.zw;
			float4 tex2DNode5 = tex2D( _MetallicGlossMap, uv_MetallicGlossMap );
			o.Metallic = ( tex2DNode5.r * _MetallicIntensity );
			o.Smoothness = ( tex2DNode5.a * _GlossMapScale );
			float2 uv_OcclusionMap = i.uv_texcoord * _OcclusionMap_ST.xy + _OcclusionMap_ST.zw;
			o.Occlusion = tex2D( _OcclusionMap, uv_OcclusionMap ).g;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
706.6667;753.3334;1852;438;980.8705;1905.139;2.26908;True;True
Node;AmplifyShaderEditor.ColorNode;30;-549.2832,-908.6011;Float;False;Property;_ColorB;Color (B);4;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;-557.8826,-1072.001;Float;False;Property;_ColorG;Color (G);3;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;28;-552.8945,-1267.477;Float;False;Property;_ColorR;Color (R);2;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;-1004.261,-1144.086;Inherit;True;Property;_TextureSample0;Color Mask (R,G,B);5;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-230.412,-1046.133;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-984.6263,-361.8995;Inherit;True;Property;_MainTex;Diffuse;0;0;Create;False;0;0;0;False;0;False;-1;None;2edada2810320ab4cab2994de23e349a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-234.2333,-1183.411;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;9;-940.6453,-531.2382;Float;False;Property;_Color;Main Color;1;0;Create;False;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;39;-63.72692,-1122.339;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-222.1463,-938.8314;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;44;-67.0598,-860.9305;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-58.14328,-990.8495;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;59;463.287,-1819.676;Float;False;Property;_ColorTatooR;Color Tatoo (R) |change color opacity;6;0;Create;False;0;0;0;False;0;False;1,1,1,0;0,1,0.742964,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;43;325.2569,-884.7508;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-495.8877,-412.0633;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;320.5785,-1185.839;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;57;-145.9484,-1499.704;Inherit;True;Property;_Tatoo;Tatoo (R,G,B);9;0;Create;False;0;0;0;False;0;False;-1;None;d2f81d401341d3e4397436f2ff3464bc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;42;316.7738,-1043.939;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;538.6124,-1023.162;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;774.4117,-1292.501;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;60;465.1031,-1647.337;Float;False;Property;_ColorTatooG;Color Tatoo (G) |change color opacity;7;0;Create;False;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;978.6399,-1138.781;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;61;464.9185,-1477.349;Float;False;Property;_ColorTatooB;Color Tatoo (B) |change color opacity;8;0;Create;False;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;58;1086.081,-1277.777;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;62;1324.321,-1171.625;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;1182.869,-1015.805;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-632.4804,725.167;Float;False;Property;_EmissionColor;Emission Color;17;0;Create;False;0;0;0;False;0;False;0,0,0,0;0.7542542,0.04980921,0.6546905,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-696.5,310;Inherit;True;Property;_MetallicGlossMap;Metallic (R), Gloss (Alpha);10;0;Create;False;0;0;0;False;0;False;-1;d340fcb74c944e046b0860161abc4821;2c6f79ef65ca2f54d9f05bdb2c355869;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;52;-354.5217,203.7305;Float;False;Property;_MetallicIntensity;Metallic Intensity;11;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;63;1536.19,-1014.406;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-353.1679,433.4667;Float;False;Property;_GlossMapScale;Glossiness Intensity;12;0;Create;False;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-809.1061,-81.12701;Inherit;True;Property;_BumpMap;Normal;13;0;Create;False;0;0;0;False;0;False;-1;None;2a0bb66bba721364e953ba50dc11c740;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-695.2,503.3;Inherit;True;Property;_EmissionMap;Emission;16;0;Create;False;0;0;0;False;0;False;-1;None;d2f81d401341d3e4397436f2ff3464bc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;55;-812.3355,105.2629;Inherit;True;Property;_DetailNormalMap;Detail Normal;14;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-594.78,898.0663;Float;False;Property;_EmissionIntensity;Emission Intensity;18;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-315.2809,556.1683;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-28.40479,169.7599;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-27.05094,399.4961;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;56;-27.67059,-291.1469;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;54;-394.3475,-5.961193;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;20;-679.5816,986.4391;Inherit;True;Property;_OcclusionMap;Occlusion (G);15;0;Create;False;0;0;0;False;0;False;-1;None;2c6f79ef65ca2f54d9f05bdb2c355869;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;300.9698,-14.49924;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Polygonmaker/Basic-PBR;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;29;0
WireConnection;32;1;27;2
WireConnection;31;0;28;0
WireConnection;31;1;27;1
WireConnection;39;0;27;1
WireConnection;33;0;30;0
WireConnection;33;1;27;3
WireConnection;44;0;27;3
WireConnection;40;0;27;2
WireConnection;43;0;33;0
WireConnection;43;1;44;0
WireConnection;16;0;9;0
WireConnection;16;1;3;0
WireConnection;38;0;31;0
WireConnection;38;1;39;0
WireConnection;42;0;32;0
WireConnection;42;1;40;0
WireConnection;51;0;38;0
WireConnection;51;1;42;0
WireConnection;51;2;43;0
WireConnection;51;3;16;0
WireConnection;64;0;59;4
WireConnection;64;1;57;1
WireConnection;65;0;60;4
WireConnection;65;1;57;2
WireConnection;58;0;51;0
WireConnection;58;1;59;0
WireConnection;58;2;64;0
WireConnection;62;0;58;0
WireConnection;62;1;60;0
WireConnection;62;2;65;0
WireConnection;66;0;61;4
WireConnection;66;1;57;3
WireConnection;63;0;62;0
WireConnection;63;1;61;0
WireConnection;63;2;66;0
WireConnection;10;0;6;0
WireConnection;10;1;8;0
WireConnection;10;2;11;0
WireConnection;53;0;5;1
WireConnection;53;1;52;0
WireConnection;22;0;5;4
WireConnection;22;1;23;0
WireConnection;56;0;63;0
WireConnection;54;0;4;0
WireConnection;54;1;55;0
WireConnection;0;0;56;0
WireConnection;0;1;54;0
WireConnection;0;2;10;0
WireConnection;0;3;53;0
WireConnection;0;4;22;0
WireConnection;0;5;20;2
ASEEND*/
//CHKSM=EE4078DEA262FC9ABA93E3563F62EB0ADD4435E1