// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/GhostChest"
{
    Properties
    {
 

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
		
        Blend SrcAlpha OneMinusSrcAlpha
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float4 worldPos: world;
				float3 worldNormal : NORMAL;
            };

 
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
				
                UNITY_TRANSFER_FOG(o,o.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = fixed4(0,0,0,0);
				
				if (	(distance(i.worldPos.xyz, _PingLocation1) < _GlowDistance1 +0.5 &&
						 60 >  _GlowDistance1 )
				)
					col += float4(1,0,0,1)* 5/distance(i.worldPos.xyz, _PingLocation1);;
				
				if (	(distance(i.worldPos.xyz, _PingLocation2) < _GlowDistance2 +0.5 &&
						60 >  _GlowDistance2 )
				)
					col += float4(1,0,0,1)* 5/distance(i.worldPos.xyz, _PingLocation1);;
				
				if (	(distance(i.worldPos.xyz, _PingLocation3) < _GlowDistance3 +0.5 &&
						60 >  _GlowDistance3 )
				)
					col += float4(1,0,0,1)* 5/distance(i.worldPos.xyz, _PingLocation1);;
					
                // apply fog
				
				
				
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
