Shader "Unlit/MyFirstShader"
{
    Properties
    {
        //data we want to pass through
        _MainTex ("Texture", 2D) = "white" {}
        _MyFloat("My Float", float) = 2.0
        _ColorA("Color A", Color) = (0,0,0,1)
        _ColorB("Color B", Color) = (1,1,1,1)
    }
    SubShader
    {
        //tags for the shader
        Tags { "RenderType"="Opaque" }

        Pass
        {
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata //mesh data
            {
                float4 vertex : POSITION; //vertex position
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0; //uv0
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
            };

            //float - a single Float
            //float2 - a vector2
            //float3 - a vector3
            //float4 - a vector4
            //half(to 4) - smaller in data size (for precision)
            //fixed(to 4) - even smaller
            //float2x2
            //sampler2D - 2d texture
            //

            sampler2D _MainTex;
            float4 _MainTex_ST;   
            float4 _MyFloat;
            float4 _ColorA;
            float4 _ColorB;


            //passes data from engine to vert
            v2f vert (appdata v)
            {
                v2f o;

                //v.vertex.xyz += 0.2 * v.normal;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv; //TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = mul( (float3x3) unity_ObjectToWorld , v.normal);
                return o;
            }

            //passes data from vert to frag
            //vector4
            fixed4 frag (v2f i) : SV_Target
            {
                float4 outColor = lerp(_ColorA, _ColorB, i.uv.y);
                return outColor;
                //float4 var1;
                //swizzling - mixing
                //float3 var2 = var1.xxx
                //eturn float4(i.normal, 1);
                //return float4(i.uv, 0, 1);
                // sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);
                //return col;
            }
            ENDCG
        }
    }
}
