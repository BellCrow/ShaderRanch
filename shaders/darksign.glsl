#define u_time iGlobalTime
#define PI 3.1415926


const float a = 12.9898;
const float b = 78.233;
const float c = 43758.5453;

float rand(vec2 co) {
  return fract(sin(dot(co.xy, vec2(a, b))) * c);
}

float rand(float val) {
  return rand(vec2(val));
}

float smoothRand(float val)
{
    val *= 5.;
    float leftInt = rand(floor(val));
    float rightInt = rand(floor(val)+1.);
    float fractPart = fract(val);
    return (mix(leftInt,rightInt,fractPart));
}

float smoothnoise(vec2 uv)
{
    vec2 cellId = floor(uv );
    
    vec2 cellUv = fract(uv);

    float cellValueLt = rand(cellId + vec2(0.,1.));
    float cellValueRt = rand(cellId + vec2(1.,1.));
    float cellValueRb = rand(cellId + vec2(1.,0.));
    float cellValueLb = rand(cellId);
    float topValue = mix(cellValueLt, cellValueRt, cellUv.x);
    float bottomValue = mix(cellValueLb, cellValueRb, cellUv.x);
    float interpolatedValue = mix(bottomValue,topValue,cellUv.y);
    return interpolatedValue;
}

float layeredNoise(vec2 uv){
    float noise = smoothnoise(uv * 20.);
    noise = smoothnoise(uv * 10.);
    noise += smoothnoise(uv * 40.) / 4.;
    noise += smoothnoise(uv * 80.) / 8.;
    noise += smoothnoise(uv * 160.) / 16.;
    noise += smoothnoise(uv * 320.) / 32.;
    noise /= 2.;
    return noise;
}

float darkSignCircle(vec2 uv)
{
    //draw ring
    vec2 circleCenter = vec2(0);
        
    float polarAngle = atan(uv.y,uv.x);
    float circleRandomOffset = smoothnoise(vec2(polarAngle)) / 60.;

    float distanceToCircleCenter = distance(uv,circleCenter);
    //first draw a whole circle
    float inCircleMaskValue = 1. - smoothstep(.19 + circleRandomOffset,.2 + circleRandomOffset,distanceToCircleCenter);
    //then subtract a smaller circle from it
    inCircleMaskValue -= 1. - smoothstep(.18 + circleRandomOffset,.19 + circleRandomOffset,distanceToCircleCenter);
    
    // this subtract value creates the gaps in 
    // the circle and is supposed to be a random value, that is 
    // supposed to be continous so the the gaps arent hard but have a smooth
    // flow to the dark background 
    // TODO: this causes issues later on in regards to 
    // adding and multiplying as there are artifacts
    float subtractValue = layeredNoise(vec2(polarAngle));
    //sin(cos(sin(cos(sin(polarAngle * 2.)-.8)*10. - 5.)) * 1.4);

    inCircleMaskValue -= subtractValue;
    return inCircleMaskValue;
}
float darkSignCircle(vec2 uv, bool overload)
{
    //draw ring
    vec2 circleCenter = vec2(0);
    float circleSize = 0.2;
    float polarAngle = atan(uv.y,uv.x);
    float inCircleMaskValue = 0.;
    // we have to smoothly randomize the position and the thickness of the dark sign line.
    //that way it looks more natural

    float distanceFromCenter = circleSize + smoothRand(polarAngle);
    float thickness = fract(smoothRand(polarAngle)) / 100.;

    float fragmentDistanceToSignCenter = distance(uv,circleCenter);
    //first draw a whole circle
    inCircleMaskValue = 1. - smoothstep(distanceFromCenter, distanceFromCenter +  0.0, fragmentDistanceToSignCenter);
    //then subtract a smaller circle from it
    inCircleMaskValue -= 1. - smoothstep(.18,.19,fragmentDistanceToSignCenter);

    
    return inCircleMaskValue;
}

float fireFactor(vec2 uv)
{
    float circleRadius = 0.2;

    float randNoise = layeredNoise(uv - vec2(0,iTime/5.));
    float maxFlameHeightForYPos = max(smoothstep((uv.x * uv.x + 1.5), 0., uv.y), 0.);
    float flameStrenghtHorizontal = smoothstep(circleRadius, 0., abs(uv.x));
    float overRingValue = (1. - step(uv.x * uv.x + uv.y * uv.y + 0.003, circleRadius * circleRadius)) * smoothstep(0., maxFlameHeightForYPos, uv.y);
    
    return randNoise * 2. * maxFlameHeightForYPos * overRingValue * flameStrenghtHorizontal;
}

vec3 calcFrag(vec2 uv)
{
    vec3 colorRed = vec3(1,0,0);
    vec3 fragColor = vec3(0);

    float inCircleMaskValue = darkSignCircle(uv, true);

    float fireValue = fireFactor(uv);

    fragColor += inCircleMaskValue * colorRed;

    float randValue = smoothRand(uv.x);
    float onLineValue = smoothstep(randValue  - 0.01, randValue + 0.01,uv.y) - smoothstep((randValue + 0.01)  - 0.01, (randValue + 0.01) + 0.01,uv.y);
    fragColor = vec3(onLineValue) * colorRed;
    //end draw red circle

    // TODO: add fire
    return fragColor;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord /iResolution.xy;
    uv -= vec2(0.5);
    //"camera movement"
    //uv *= 4.;
    //uv.y += 0.2;
    float aspectRation =  iResolution.x / iResolution.y;
    uv.x *= aspectRation;
    vec3 pixelColor = calcFrag(uv);
    //code goes here
    fragColor = vec4(pixelColor, 1);
}