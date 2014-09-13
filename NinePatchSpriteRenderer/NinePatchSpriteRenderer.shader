Shader "Custom/NicePatch"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		_X1 ("X1", Float) = 72
		_X2("X2", Float) = 648
		_Y1 ("Y1", Float) = 128
		_Y2("Y2", Float) = 1152		
		
		 _ImageWidth ("ImageWidth", Float) = 0.5
		 _ImageHeight("ImageHeight", Float) = 0.5
		 
		 _WidthTimes("WidthTimes", Float) = 0.5
		 _HeightTimes("HeightTimes", Float) = 0.5
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		Blend SrcAlpha OneMinusSrcAlpha

		

		Pass
		{

		CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile DUMMY PIXELSNAP_ON
			#include "UnityCG.cginc"
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				fixed2 texcoord  : TEXCOORD0;
				fixed3 pos;

			};
			
			fixed4 _Color;
			float _X1;
			float _X2;
			float _Y1;
			float _Y2;
			float  _ImageWidth;
			float  _ImageHeight;
			float  _WidthTimes;
			float  _HeightTimes;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				
				float4 inVer = IN.vertex;				
				OUT.vertex = mul(UNITY_MATRIX_MVP, inVer);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			sampler2D _MainTex;

			fixed4 frag(v2f IN) : SV_Target
			{
				fixed2 tex = IN.texcoord;
				

				if(tex.x*_ImageWidth< _X1/_WidthTimes){
					tex.x =tex.x*_WidthTimes;
				}else if( (_ImageWidth-(_ImageWidth-_X2)/_WidthTimes) <tex.x*_ImageWidth){
					tex.x =(_ImageWidth *(1/_WidthTimes-1)+ tex.x*_ImageWidth)/(1/_WidthTimes)/_ImageWidth;
				}else{
					tex.x =(_X1+ (tex.x*_ImageWidth-_X1/_WidthTimes)*(_X2-_X1)/(_ImageWidth-_X1/_WidthTimes -(_ImageWidth-_X2)/_WidthTimes))/_ImageWidth;
				}
				
				if(tex.y*_ImageHeight< _Y1/_HeightTimes){
					tex.y =tex.y*_HeightTimes;
				}else if( (_ImageHeight-(_ImageHeight-_Y2)/_HeightTimes) <tex.y*_ImageHeight){
					tex.y =(_ImageHeight *(1/_HeightTimes-1)+ tex.y*_ImageHeight)/(1/_HeightTimes)/_ImageHeight;
				}else{
					tex.y =(_Y1+ (tex.y*_ImageHeight-_Y1/_HeightTimes)*(_Y2-_Y1)/(_ImageHeight-_Y1/_HeightTimes -(_ImageHeight-_Y2)/_HeightTimes))/_ImageWidth;
				}
	
				fixed4 c = tex2D(_MainTex, tex) * IN.color;
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
}
