//defines so the shader works out of the box with shadertoy
#define u_time iGlobalTime

//constants that are often used
#define PI 3.1415926

vec3 calculateFragmentColor(vec2 uv);

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

vec3 calculateFragmentColor(vec2 uv)
{
    float tileCount = 80.;
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
    
    float hexWall = smoothstep(SHexDistance(hexUv),hexMaxDistance,hexMaxDistance - 0.03) 
                  - smoothstep(SHexDistance(hexUv),hexMaxDistance,hexMaxDistance - 0.1);
    return vec3(hexUv.x,hexUv.y,0) * hexWall;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord /iResolution.xy;
    
    //make coordinates go from -0.5 to 0.5
    uv -= vec2(0.5);
    
    vec3 pixelColor = calculateFragmentColor(uv);

    fragColor = vec4(pixelColor, 1);
}
