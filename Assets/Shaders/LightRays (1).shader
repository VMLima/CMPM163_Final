Shader "Custom/LightRays" {
    Properties{
        _MainTex("Texture", 2D) = "white" {}
        _steps("Ray Distance", Int) = 50.0
        _lightIntensity("Light Intensity", Float) = 20.0
        _density("Density", Float) = 0.2
        _surface("Surface", Float) = 8.0
        _noiseTex("Noise for Surface", 2D) = "white" {}
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
            uniform float _lightIntensity;
            uniform float _density;
            uniform float _surface;
            uniform sampler2D _noiseTex;

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
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);;

                return o;
            }

            fixed4 raymarch(float3 position, float3 direction) {
                float4 temp;
                float4 finalIntensity = float4(0, 0, 0, 1);

                bool brokeSurface = false;

                for (int i = 0; i < _steps; i++) {
                    // Check the xz position of the texture
					float3 rayPos = position + i*direction;
                    temp = tex2D(_noiseTex, float2(rayPos.x, rayPos.z));
                    // if above a threshold add intensity
                    if (temp.r > 0.5) {
                        // Distance from camera to ray end
                        float dist = distance(_WorldSpaceCameraPos, position);
                        finalIntensity += _lightIntensity 
										  * pow(2.71828, (-1 * abs(_surface - rayPos.y) * _density))
                                          * pow(2.71828, (-1 * i * _density))
                                          * temp.x;
                            //(2.71828 * pow(-dist, 0.2)) * (2.71828 * pow(-5, 0.2));
                    }

                    //if (!brokeSurface && (i * direction).y > _surface) {
                    //    brokeSurface = true;
                    //    finalIntensity += float4(0, 0, 1, 1);
                    //    //i = 40.0;
                    //}

                    // else continue
                    position += direction * _steps;
                }
                return finalIntensity;
            }

            float4 frag(v2f i) : SV_Target {
                float4 color = tex2D(_MainTex, i.uv);
                // The camera's origin position
                float3 pos = _WorldSpaceCameraPos;
                // Ray direction
                float3 dir = float3(i.uv.x, i.uv.y, 5);

                float4 finalColor;
                // send the position and direction to the raymarch function
                finalColor = raymarch(pos, dir);

                color += finalColor;
                return color;
            }

            ENDCG
        }


    }
}
