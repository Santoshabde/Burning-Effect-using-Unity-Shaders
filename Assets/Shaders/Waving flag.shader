Shader "ShaderLearning/Vertex Animations/WavingFlag"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _WingsSpeed("WingsSpeed", Range(0,40)) = 0
        _WingsAmplitude("WingsAmplitude", Range(0,10)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Cull Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _WingsSpeed;
            float _WingsAmplitude;

            v2f vert (appdata v)
            {
                v2f o;

                o.uv = v.uv;

                v.vertex.y += sin((v.uv.x - _Time.y) * _WingsSpeed) * _WingsAmplitude * v.uv.x;

                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
