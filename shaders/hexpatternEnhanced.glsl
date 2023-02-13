//defines so the shader works out of the box with shadertoy
#define u_time iGlobalTime

//constants that are often used
#define PI 3.1415926

vec3 calculateFragmentColor(vec2 uv);

float SinXToY(float lowerBound, float upperBound, float value, float frequencyFactor, float frequencyOffset) {
    float sinValue = sin(value * frequencyFactor + frequencyOffset);
    //move the sine up to the interval 0->2
    float noNegativeSin = sinValue + 1.;
    //limit the sine down to 0->1
    float zeroToOneSin = noNegativeSin / 2.;
    //scales the amplitude of the sin to the desired size, that is described with x->y
    float sinOfDesiredSize = zeroToOneSin * (upperBound - lowerBound);
    //now move the sine along the x axis, so that x is actually the lowest possible value;
    float finalSin = sinOfDesiredSize + lowerBound;
    return finalSin;
}

float SinXToY(float lowerBound, float upperBound, float value) {
    return SinXToY(lowerBound, upperBound, value, 1., 0.);
}


//all of the calculations on how to create the hex tiling 
//has been taken from https://www.youtube.com/watch?v=VmrIDyYiJBA
float SHexDistance(vec2 uv)
{
    uv = abs(uv);
    float signedVerticalBorderDistance = uv.x;
    float signedSlopeBorderDistance = dot(uv, normalize(vec2(1.,sqrt(3.))));
    float signedHexDistance = max(signedSlopeBorderDistance,signedVerticalBorderDistance);
    return signedHexDistance;
}

vec3 calculateHexWall(vec2 uv)
{
    float tileCount = 30.;
    vec2 gridSpacing = vec2(sqrt(3.),3.);

     vec2 scaledGridA = uv * tileCount;
     vec2 aId = floor(scaledGridA / gridSpacing);
     vec2 aGv = mod(scaledGridA,gridSpacing) - gridSpacing * .5;

    vec2 scaledGridB = (uv * tileCount) + vec2(sqrt(3.) / 2.,1.5) ;
    vec2 bId = floor(scaledGridB / gridSpacing);
    vec2 bGv = mod(scaledGridB,gridSpacing) - gridSpacing * .5;

    vec2 hexId = aId;
    vec2 hexUv = aGv;
    if(length(aGv) > length(bGv))
    {
        hexId = bId;
        hexUv = bGv;
    }

    float hexMaxDistance = sqrt(3.) / 2.;
    float smoothedDistance = smoothstep(0.1,5.,distance(hexId, vec2(0,0)));
    float sizeModulation = SinXToY(0.5,.95, smoothedDistance - iTime,3.,0.);

    // the -0.04 prevents weird color artifacts at the borders if the hexagons reach their max size
    float hexWall = 0.02/ distance(SHexDistance(hexUv),(hexMaxDistance) * sizeModulation);
    vec3 hexColor = vec3(1.0,0.,0.0);

    

    return hexColor * hexWall;
}

vec3 calculateFragmentColor(vec2 uv)
{
    vec3 ret = vec3(0);
    ret += calculateHexWall(uv);

    return ret;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord /iResolution.xy;
       
    //make coordinates go from -0.5 to 0.5
    uv -= vec2(0.5);
    //uv += iTime / 10.;
    vec3 pixelColor = calculateFragmentColor(uv);

    fragColor = vec4(pixelColor, 1);
}
