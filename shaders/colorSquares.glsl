float clampn(float v)
{
    return clamp(0.,1.,v);
}

vec3 calculateFragmentColor(vec2 uv)
{
    uv+= iTime / 2.;
    float cellCount = 20.;
    vec2 originalUv = uv+= 0.5;

    vec2 cellId = floor(originalUv * cellCount);
    vec2 cellUv = fract(originalUv * cellCount);

    float distanceToCenterX = min(distance(cellUv.x,1.),distance(cellUv.x,0.));
    float distanceToCenterY = min(distance(cellUv.y,1.),distance(cellUv.y,0.));
    float distanceToCenter = min(distanceToCenterX, distanceToCenterY);
    float distanceToBorder = 1. - distanceToCenter;
    float borderGlow = 0.01/(distanceToCenter);
    vec3 borderFragment = borderGlow * vec3(0.,0.,1.);

    vec3 gridCellColor = 
    vec3(
        clamp(0.,1.,cos((cellId.x  + 1.0)/ (cellCount / 2.))),
        clamp(0.,1.,cos((cellId.y  + 1.0)/ (cellCount / 2.))),
        0);

    
    return gridCellColor;
    return max(borderFragment,gridCellColor);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord /iResolution.xy;
    uv -= vec2(0.5);
    vec3 pixelColor = calculateFragmentColor(uv);

    fragColor = vec4(pixelColor, 1);
}