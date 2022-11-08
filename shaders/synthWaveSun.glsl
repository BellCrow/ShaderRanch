bool isInYArea(float yStart, float height, vec2 uv)
{
    return uv.y >= yStart && uv.y <= yStart + height;
}

vec4 sun(vec2 uv)
{
    vec2 sunPos = vec2(0);
    float sunSize = 0.15;

    vec4 sunTopColor = vec4(148./255., 0, 99./255.,0);
    vec4 sunBottomColor = vec4(252./255., 198./255., 3./255.,0);
    vec4 colorAtHeight = mix(sunTopColor,sunBottomColor,vec4(uv.y*3. + 0.6));

    float distanceSunCenterToUv = distance(uv,sunPos);
    float inSunValue = smoothstep(sunSize,sunSize - 0.01, distanceSunCenterToUv);
    
    //TODO: make the glow more realistic
    float sunGlowFactor = 0.;
    
    sunGlowFactor = clamp(0.05/(distanceSunCenterToUv * 0.99),0.,.3);

    vec4 sunBodyColor = inSunValue * colorAtHeight;

    //add cut out rectangles at the bottom

    if(isInYArea(-0.139,0.015,uv) 
    || isInYArea(-0.11,0.014,uv)
    || isInYArea(-0.08,0.01,uv)
    || isInYArea(-0.05,0.008,uv))
    {
       sunBodyColor = mix(sunBodyColor,vec4(0),0.85);
    }
    vec4 sunGlowColor = sunGlowFactor * colorAtHeight;


    return sunBodyColor + sunGlowColor;    
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    const float numberOfSquares = 100.;

    
    vec2 uv = fragCoord/iResolution.xy;
    uv -= 0.5f;
    vec4 base = vec4(0);
    vec4 result = base + sun(uv);
    
    fragColor = result;
    
}