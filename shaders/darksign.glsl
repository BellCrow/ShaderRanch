#define u_time iGlobalTime
#define PI 3.1415926


const float a = 12.9898;
const float b = 78.233;
const float c = 43758.5453;

float rand(vec2 co) {
  return fract(sin(dot(co.xy, vec2(a, b))) * c);
}

vec3 calcFrag(vec2 uv)
{
    vec3 colorRed = vec3(1,0,0);
    vec3 fragColor = vec3(0);
    
    //draw red ring
    vec2 circleCenter = vec2(0);
    
    float distanceToCircleCenter = distance(uv,circleCenter);
    //first draw a whole circle
    float inCircleMaskValue = 1. - smoothstep(.19,.2,distanceToCircleCenter);
    //then subtract a smaller circle from it
    inCircleMaskValue -= 1. - smoothstep(.18,.19,distanceToCircleCenter);
    
    float r = length(uv)*2.0;
    float polarAngle = atan(uv.y,uv.x);

    // this subtract value creates the gaps in 
    // the circle and is supposed to be a random value, that is 
    // supposed to be continous so the the gaps arent hard but have a smooth
    // flow to the dark background 
    float subtractValue = sin(cos(sin(cos(sin(polarAngle * 2.)-.8)*10. - 5.)) * 1.4);

    inCircleMaskValue -= subtractValue;

    fragColor += inCircleMaskValue * colorRed;
    //end draw red circle

    // TODO: add fire
    return fragColor;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord /iResolution.xy;
    uv -= vec2(0.5);
    float aspectRation =  iResolution.x / iResolution.y;
    uv.x *= aspectRation;
    vec3 pixelColor = calcFrag(uv);
    //code goes here
    fragColor = vec4(pixelColor, 1);
}