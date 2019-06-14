Shader "Custom/BWobble" {
    Properties{
        _MainTex("Texture", 2D) = "white" {}
        _steps("Intensity", Range(0, 50)) = 1

    }

    SubShader{
        Pass {
            //Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
            //Blend SrcAlpha OneMinusDstAlpha
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            uniform int _steps;

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

           inline float2 Repeat(float2 t, float2 length)
		   {
		   	   return t - floor(t / length) * length;
		   }

		   inline float2 PingPong(float2 t, float2 length)
		   {
		   	   t = Repeat(t, length * 2);
			   return length - abs(t - length);
		   }

            float4 frag(v2f i) : SV_Target {
				i.uv.x += sin((_Time.y/2 - i.uv.y) * _steps)/20;
				i.uv = PingPong(i.uv, 1);
                float4 color = tex2D(_MainTex, i.uv);
 
                return color;
            }

            ENDCG
        }


    }
}
