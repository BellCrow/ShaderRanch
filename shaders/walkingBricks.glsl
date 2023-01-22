
const float a = 12.9898;
const float b = 78.233;
const float c = 43758.5453;

float rand(vec2 co) {
  return fract(sin(dot(co.xy, vec2(a, b))) * c);
}
float rand(float val)
{
    return rand(vec2(val));
}

float smoothrand(float val, float frequency)
{
    float scaledVal = val * frequency;
    float leftInt = rand(floor(scaledVal));
    float rightInt = rand(floor(scaledVal + 1.));
    float scalarPositionOnCurve = fract(scaledVal);
    float smothedScalarPos = smoothstep(0.0,1.0,scalarPositionOnCurve);
    return mix(leftInt, rightInt, smothedScalarPos);
}

const float rowCount =20.;
const float bricksPerRow = 10.;
vec3 calcFrag(vec2 uv)
{

    vec3 fragColor = vec3(0);
    float expandedX = uv.x * bricksPerRow;
    float expandedY = uv.y * rowCount;

    //here the different velocities for the rows are added
    //every single row gets its own continous perlin 
    //funtion value based on its row id.
    //the perlin noise function defines the rows current velocity
    expandedX = (uv.x + (smoothrand(rand(floor(expandedY)) + iTime / 20.,1.) - 0.5) * 1.5) * bricksPerRow;
    //expandedX = (uv.x + smoothrand(rand(floor(expandedY)),1.) * 1.5) * bricksPerRow;


    vec2 brickUv = vec2(fract(expandedX) - 0.5,fract(expandedY)- 0.5);
    vec3 brickBorderColor = vec3(0.9);

    //put a border around the bricks
    fragColor = brickBorderColor * smoothstep(0.47,0.49,max(abs(brickUv.x),abs(brickUv.y)));
    vec3 brickFillColor = vec3(0.5,0.5,0.);
    //make the whole brick yellow(ish)
    fragColor += brickFillColor;

    //add some reflection and lightning stuff
    float distanceToShineCenter = distance(vec2(0.2), brickUv);
    fragColor += mix(fragColor/1.9,smoothstep(0.12,0.07,distanceToShineCenter)/2.9 * vec3(1.),.7);
    fragColor += mix(fragColor/4.,smoothstep(0.8,0.28,distanceToShineCenter)/1.9 * vec3(1.),.7);
    
    
    return fragColor;
}


void mainImage(out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord / iResolution.xy;
    vec2 normalizedFragCoord = uv - vec2(0.5);
    
    vec3 fragmentColor = calcFrag(normalizedFragCoord);
    fragColor = vec4(fragmentColor, 1.0);
}