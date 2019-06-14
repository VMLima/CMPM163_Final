// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/PingEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Sand ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_PingLocation1 ("PingLocation", Vector) = (0,0,0)
		_GlowDistance1 ("GlowDistance", Float) = 0
		_PingLocation2 ("PingLocation", Vector) = (0,0,0)
		_GlowDistance2 ("GlowDistance", Float) = 0
		_PingLocation3 ("PingLocation", Vector) = (0,0,0)
		_GlowDistance3 ("GlowDistance", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float3 normal : Normal;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float2 uvSand : TEXCOORD2;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float4 worldPos: world;
				float3 worldNormal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			sampler2D _Sand;
            float4 _Sand_ST;
			float4 _Color;
			float3 _PingLocation1;
			float _GlowDistance1;
			float3 _PingLocation2;
			float _GlowDistance2;
			float3 _PingLocation3;
			float _GlowDistance3;

            v2f vert (appdata v)
            {
                v2f o;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvSand = TRANSFORM_TEX(v.uv, _Sand);
				
                UNITY_TRANSFER_FOG(o,o.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv + _Time.x) + (tex2D(_Sand, i.uvSand)*_Color);
				
				col *= i.worldNormal.y;
				
				if (	(distance(i.worldPos.xyz, _PingLocation1) < _GlowDistance1 +0.5 &&
						distance(i.worldPos.xyz, _PingLocation1) > _GlowDistance1 -0.5)
				)
					col += float4(0,1,1,1) * 5/distance(i.worldPos.xyz, _PingLocation1);
				
				if (	(distance(i.worldPos.xyz, _PingLocation2) < _GlowDistance2 +0.5 &&
						distance(i.worldPos.xyz, _PingLocation2) > _GlowDistance2 -0.5)
				)
					col += float4(0,1,1,1) * 5/distance(i.worldPos.xyz, _PingLocation2);
				
				if (	(distance(i.worldPos.xyz, _PingLocation3) < _GlowDistance3 +0.5 &&
						distance(i.worldPos.xyz, _PingLocation3) > _GlowDistance3 -0.5)
				)
					col += float4(0,1,1,1) * 5/distance(i.worldPos.xyz, _PingLocation3);
					
                // apply fog
				
				
				
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
