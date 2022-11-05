#define u_time iGlobalTime 

float expStep( float x, float k, float n )
{
    return exp( -k*pow(x,n) );
}

float drawStar(vec2 starPos, vec2 pixelPos)
{
    float starBrightness = 8.0;
    float starSize = 0.04;
    float distanceToStarCenter = starBrightness/exp(distance(starPos, pixelPos) * 1.0/starSize);

    return distanceToStarCenter;
}

float Sin0To1(float value)
{
    return sin(value) / 2. + 0.5;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord /iResolution.xy;
    uv -= vec2(0.5);
    vec3 drawColor =vec3(0.51, 0.03, 0.11);
    vec3 drawColor2 =vec3(0.51, 0.03, 0.11);

    vec2 starPosition = vec2(sin(u_time + Sin0To1(u_time)) / 4.,cos(u_time + Sin0To1(u_time)) /4.);
    vec2 starPosition2 = vec2(sin(u_time ) / 4.,cos(u_time) /4.);
    vec3 col = vec3(0);
    col += drawStar(starPosition,uv) * drawColor;
    col += drawStar(starPosition2,uv) * drawColor2;
    // Output to screen
    fragColor = vec4(col,1.0);
}