//calculating at gpu make shader can handling faster than cpu
Shader "KHSShader/PrismShaderr"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
	}

	SubShader
	{
		Pass//actually working shader code
		{
			CGPROGRAM

			//지시자 -> 셰이더에서 어떠한 기능을 사용할지 전처리
			#pragma vertex vert
			#pragma fragment frag

			//프로퍼티의 변수와 맞추어 사용하는 CG변수
			float4 _Color;

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float4 col : TEXCOORD0;
			};

			vertexOutput vert(float4 vertexPos : POSITION)
			{
				vertexOutput output;
				output.pos = UnityObjectToClipPos(vertexPos);
				output.col = vertexPos + float4(0.5, 0.5, 0.5, 0.0 ) + _Color;

				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
				return input.col;
			}

			ENDCG
		}
	}
}
