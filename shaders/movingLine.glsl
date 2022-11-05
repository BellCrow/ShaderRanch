#include "funcs.glsl"

vec3 calculateFragmentColor(vec2 uv);

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord / iResolution.xy;
    uv -= vec2(0.5);
    uv.x = uv.x * (iResolution.x / iResolution.y);
    vec3 pixelColor = calculateFragmentColor(uv);

    fragColor = vec4(pixelColor, 1);
}
vec2 getContinousRandomPosition(float continousValue) {

    float xPos = sin(continousValue * 0.55);
    xPos = xPos + cos(xPos * .9);
    xPos = xPos + sin(xPos * .4);
    xPos = xPos + cos(xPos * 2.2);
    xPos = SinXToY(-0.9, 0.3, xPos, 0.9, 0.2);
    
    float yPos = sin(continousValue * .6);
    yPos = yPos + cos(yPos * .5);
    yPos = yPos + sin(yPos * 3.4);
    yPos = yPos + cos(yPos * 1.5);
    yPos = CosXToY(-1., 0.7, yPos, 1., 0.6);
        
    return vec2(xPos, yPos);
}

const vec3 lineColor = vec3(1., 0., 0.);
const float lineLength = 0.5;

vec3 calculateFragmentColor(vec2 uv) {
    vec3 fragmentColor = vec3(0);

    for(float i = 0.; i < lineLength; i += 0.002) {
        float timePointForLineElement = u_time + i;
        vec2 linePosAtTimePoint = getContinousRandomPosition(timePointForLineElement);
        float distanceUvToPointElement = distance(uv, linePosAtTimePoint);
        float onLineFactor = smoothstep(0.01, 0.009, distanceUvToPointElement);
        fragmentColor = max(fragmentColor, lineColor * onLineFactor);
    }

    return fragmentColor;
}