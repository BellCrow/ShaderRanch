#define u_time iGlobalTime 

vec2 calculatePointPosition(float time)
{
    float pointCoordX = sin(time * 3.) / 10.;
    float pointCoordY = cos(time * 3.) / 10.;
    vec2 pointCoord = vec2(pointCoordX,pointCoordY);
    return pointCoord;
}

const float pointTrailLength = 1.1;

const vec4 pointColor = vec4(0.2,0.9,0.4,1.);

vec4 calculateTrailFrag(vec2 uv, float time)
{
    vec4 trailFrag = vec4(0);
    for(float i = 0.; i < pointTrailLength; i += 0.01)
    {
        vec2 pointCoord = calculatePointPosition(time - i);
        float distanceToPoint = distance(uv,pointCoord);
        float pointValue = smoothstep(0.04,0.036,distanceToPoint);
        pointValue *= 1. - (i / pointTrailLength);
        trailFrag = max(trailFrag,pointColor * pointValue);
    }
    return trailFrag;
}

vec4 calculatePointFrag(vec2 uv, float time)
{
    vec2 pointCoord = calculatePointPosition(u_time);
    float distanceToPoint = distance(uv,pointCoord);
    float pointValue = smoothstep(0.04,0.038,distanceToPoint);
    return pointValue * pointColor;
}

vec4 calculateFrag(vec2 uv)
{
    // calculate trail
    vec4 trailFrag = calculateTrailFrag(uv, u_time);
    // calculte the white point
    vec4 pointFrag = calculatePointFrag(uv, u_time + pointTrailLength);

    
    return mix(pointFrag, trailFrag,0.7);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord /iResolution.xy;
    uv -= vec2(0.5);
    
    // Output to screen
    fragColor = calculateFrag(uv);
}