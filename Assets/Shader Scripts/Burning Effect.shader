Shader "SanShaders/BurningEffect"
{
    Properties
    {
        //Textures
        _MainTex ("Texture", 2D) = "white" {}
        _SecondaryTex ("Noise Texture", 2D) = "white" {}

        //Dissolve Factor. Animate this value in your code if required
        [Header(DISSOLVE FACTOR AND EDGE LENGTH)]
        [Space(10)]
        _DissolveFactor("Dissolve Factor", Range(0,1)) = 0
        _BurnEdgeLength("Buring Color Edge length", Range(0,1)) = 0

        [Space(10)]
        //Burn Char and Ember colors!!
        [Header(BURNING EMBER AND CHAR COLORS)]
        [Space(10)]
        _BurnEmberColor("Buring Ember Color", Color) = (1,1,1,1)
        _EmberColorFactor("Ember Color Factor", float) = 1

        _BurnCharColor("Buring Char Color", Color) = (1,1,1,1)
        _CharColorFactor("Char Color Factor", float) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Transparent" }

        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct vertexData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct fragmentData
            {
                float2 uv1 : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            //Textures
            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _SecondaryTex;
            float4 _SecondaryTex_ST;

            //Effect Parameters
            float _DissolveFactor;
            float4 _BurnEmberColor;
            float _BurnEdgeLength;
            float4 _BurnCharColor;
            float _EmberColorFactor;
            float _CharColorFactor;

            fragmentData vert (vertexData v)
            {
                fragmentData o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                o.uv1 = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv2 = TRANSFORM_TEX(v.uv, _SecondaryTex);

                return o;
            }

            fixed4 frag (fragmentData i) : SV_Target
            {
                // sample the texture
                float4 mainTex = tex2D(_MainTex, i.uv1);
                float4 secondaryTex = tex2D(_SecondaryTex, i.uv2);

                float3 finalColor;
                float finalAlpha;

                //Giving a burn Ember Color!!
                float edgeValue = step(secondaryTex.r - _BurnEdgeLength, _DissolveFactor);
                float3 emberColor = lerp(mainTex.rgb, _BurnEmberColor * _EmberColorFactor, edgeValue);

                //Giving a burn char Color on the edge!!
                float charValue = smoothstep(secondaryTex.r - _BurnEdgeLength, secondaryTex.r + _BurnEdgeLength, _DissolveFactor);
                finalColor = lerp(emberColor, _BurnCharColor * _CharColorFactor, charValue);

                //Dissolve Effect
                finalAlpha = saturate(mainTex.a - step(secondaryTex.r + _BurnEdgeLength, _DissolveFactor));

                return fixed4(finalColor, finalAlpha * mainTex.a);
            }

            ENDCG
        }
    }
}
