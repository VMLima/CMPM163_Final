//https://www.shadertoy.com/view/4ljXWh Underwater shader that inspired many of the functions used.

Shader "Custom/FalseRays" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _noiseTex ("Texture", 2D) = "white" {}
        _Steps("Steps", Int) = 10
        _surface("Surface", Float) = 10.0
        _density("Water Density", Float) = 0.3

    }
    SubShader {

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _noiseTex;
            int _Steps;
            float _surface;
            float _density;

            // Backup function
            //float causticX(float x, float power, float gtime) {
            //    float pattern = ((x*6) % 6) - 250.0;
            //    float time = gtime * .5 + 23.0;

            //    float randPattern;// = p;
            //    float c = 1.0;
            //    float inten = .005;

            //    for (int n = 0; n < _Steps * .5; n++) {
            //        float t = time * (1.0 - (3.5 / float(n + 1)));
            //        randPattern = pattern + cos(t - randPattern) + sin(t + randPattern);

            //        c += 1.0 / length(pattern / (sin(randPattern + t) / inten));
            //    }
            //    c /= float(_Steps);
            //    c = 1.17 - pow(c, power);

            //    return c;
            //}

            float march(float3 pos, float3 dir) {

                float col = 0;

                for (int i = 0; i < _Steps * 0.5; i++) {
                    float3 rayPos = pos + i * dir;
                    float4 temp = tex2D(_noiseTex, float2(rayPos.x  + _Time.x, rayPos.z + _Time.x));
                    if (temp.r > .5) {
                        col += (pow(2.71828, (-1 * (_surface - rayPos.y) * _density))) * 10
                            * (pow(2.71828, (-1 * i * _density)));// *temp.x;
                    }
                }
                col *= cos(col);
                return col;
            }

            float4 LightRays(float2 uv) {
                float light = 0;

                // back up function
                //light += pow(causticX(uv.x, 2, _Time.y), 10.0)*0.04;
                // Attempt 2 at Ray Marching light, the above line works without marching
                float3 position = _WorldSpaceCameraPos;
                // Function came from shadertoy
                //float uvTime = uv.x + cos(_Time.y * .1) + sin(1-_Time.y * .1);
                float3 direction = float3(uv.x + 0.08 * uv.y, uv.y, 1);
                light += march(position, direction);
                light = clamp(light, 0.0, 1.0);

                return light;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv);

                return col + LightRays(i.uv);
            }
            ENDCG
        }
    }
}
