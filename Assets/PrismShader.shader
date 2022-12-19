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

			//������ -> ���̴����� ��� ����� ������� ��ó��
			#pragma vertex vert
			#pragma fragment frag

			//������Ƽ�� ������ ���߾� ����ϴ� CG����
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
