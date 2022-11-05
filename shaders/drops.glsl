#define u_time iGlobalTime
#define PI 3.1415926

const float a = 12.9898;
const float b = 78.233;
const float c = 43758.5453;
float rand(float co) 
{
    return fract(sin(dot(vec2(co,co+123333.), vec2(a, b))) * c);
}

float inRing(vec2 uv, float radius, vec2 pos)
{
    float radius2 = radius - 0.0009;
    float polarCoordinateAngle = atan(uv.y,uv.x) + PI;
    float polarCoordinateRadius = distance(pos,uv);

    const float borderSmothness = 0.002;
    float inBigCircle = smoothstep(radius, radius- borderSmothness, polarCoordinateRadius);
    float insmallCircle = smoothstep(radius2,radius2 - borderSmothness, polarCoordinateRadius);
    float inRing = inBigCircle - insmallCircle;
    return inRing;
}

float drop(vec2 uv, float time)
{
    float scaledTime = time / 3.;
    float timeSlot = floor(scaledTime);
    float progressInTimeSlot = fract(scaledTime);
    vec2 dropCoordinate = vec2(rand(timeSlot), rand((rand(timeSlot))));
    float inRingValue = inRing(uv,progressInTimeSlot, dropCoordinate); 
    inRingValue *= 0.03/progressInTimeSlot;
    return inRingValue;
}

vec3 frag(vec2 uv)
{
    float dropValue = drop(uv, u_time);
    //the loop variable controls how many simultaneous drops can occur
    // try changing it to 0 to see what i mean.
    for(float i = 0.; i < 30.; i += 1.)
    {
        float loopDropValue = drop(uv, (u_time / (rand(i) * 15.)) + 1000. * i);
        dropValue = max(dropValue, loopDropValue);
    }    
    
    return  dropValue * vec3(1);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord /iResolution.xy;
    uv.x = uv.x * ( iResolution.x / iResolution.y);
    fragColor = vec4(frag(uv), 1);
}