Shader "KHSShader/ToonShader" 
{
    Properties 
	{
		_Color ("Main Color", Color) = (.5,.5,.5,1)
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_OutlineWidth ("Outline width", Range (0, 1)) = .1
		_MainTex ("Base (RGB)", 2D) = "white" { }
	}
 
	//vertex Shader function block
	CGINCLUDE
	#include "UnityCG.cginc"//for TransformViewToProjection
 
	struct InputV
	{
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};
	struct Output
	{
		float4 pos : POSITION;
		float4 color : COLOR;
	};
 
	float _OutlineWidth;
	float4 _OutlineColor;
	
	//outline vertex create function
	Output vertShader(InputV _in) 
	{
		Output _out;

		//_in.vertex.xyz += _in.normal * _OutlineWidth; // just make a copy of incoming vertex scaled according to normal direction
		_in.vertex *= (1+_OutlineWidth);//make vertex extension base on outline + 1

		_out.pos = UnityObjectToClipPos(_in.vertex);
 
		_out.color = _OutlineColor;
		return _out;
	}
	ENDCG
 
	SubShader 
	{
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True"}
		Cull Back

		CGPROGRAM
		#pragma surface surfShader Lambert
		
		sampler2D _MainTex;
		fixed4 _Color;
		
		struct Input 
		{
			float2 uv_MainTex;
		};
		
		void surfShader (Input _In, inout SurfaceOutput _out) 
		{
			fixed4 fixedCol = tex2D(_MainTex, _In.uv_MainTex) * _Color;
			_out.Albedo = fixedCol.rgb;
			_out.Alpha = fixedCol.a;
		}
		ENDCG

		Pass //outline
		{
			Tags { "Queue" = "Transparent" "IgnoreProjector" = "True"}
			Cull Front //카메라를 향해서 그려주는 텍스쳐만 렌더링함
			ZWrite Off //깊이 테스트 끄기
 
			CGPROGRAM
			#pragma vertex vertShader
			#pragma fragment frag
			float4 frag(Output i) :COLOR { return i.color; }
			ENDCG
		}
	}
 
	Fallback "Diffuse"
}