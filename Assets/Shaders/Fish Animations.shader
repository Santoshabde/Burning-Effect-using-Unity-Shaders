Shader "ShaderLearning/Vertex Animations/FishAnimations"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        //Fish Translate Properties
        [Header(Translate Inputs)]
        [Space(10)]
        _FishTranslateAmplitude("FishTranslateAmplitude", Range(0,10)) = 0
        _FishTranslateSpeed("FishTranslateSpeed", Range(0,10)) = 0

        //Fish Yaw Properties
        [Space(10)]
        [Header(Yaw Inputs)]
        [Space(10)]
        _FishYawAmplitude("FishYawAmplitude", Range(0,10)) = 0
        _FishYawSpeed("FishYawSpeed", Range(0,10)) = 0

        //Tail Yaw Properties
        [Space(10)]
        [Header(Tail Yaw Inputs)]
        [Space(10)]
        _FishTailYawAmplitude("FishTailYawAmplitude", Range(0,10)) = 0
        _FishTailYawSpeed("FishTailYawSpeed", Range(0,10)) = 0
        
        //Tail Roll Properties
        [Space(10)]
        [Header(Tail Roll Inputs)]
        [Space(10)]
        _FishTailRollAmplitude("FishTailRollAmplitude", Range(0,10)) = 0
        _FishTailRollSpeed("FishTailRollSpeed", Range(0,10)) = 0
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
            float _FishTranslateAmplitude;
            float _FishTranslateSpeed;
            float _FishYawAmplitude;
            float _FishYawSpeed;
            float _FishTailYawAmplitude;
            float _FishTailYawSpeed;
            float _FishTailRollAmplitude;
            float _FishTailRollSpeed;

            v2f vert (appdata v)
            {
                v2f o;

                o.uv = v.uv;

                //Fish Translate Amplitude
                v.vertex.z += sin(( _Time.y) * _FishTranslateSpeed) * _FishTranslateAmplitude;

                //Fish Yaw Amplitude
                v.vertex.z += sin(( _Time.y) * _FishYawSpeed) * _FishYawAmplitude * (0.5 - v.uv.x);

                //Fish Tail Yaw
                v.vertex.z += sin((v.uv.x * UNITY_PI - _Time.y) * _FishTailYawSpeed) * _FishTailYawAmplitude /** (1 - v.uv.x)*/;

                //Fish Tail Roll
                v.vertex.z += sin((v.uv.y - _Time.y) * _FishTailRollSpeed) * _FishTailRollAmplitude /** (1 - v.uv.x)*/;
                
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
