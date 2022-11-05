#define iime iGlobalTime
#define PI 3.1415926

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

float ShowFunction(float xCoordinate)
{
    float sinusAmplitudeInfluence = SinXToY(5.,8.,iime);
    float sine1 = (sin(xCoordinate * 10. + iime) / sinusAmplitudeInfluence);
    float sine2 = sin(xCoordinate * 14. + iime*2.5) / sinusAmplitudeInfluence;
    return sine1 + sine2;
}


void mainImage(out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord /iResolution.xy;
    vec2 normalizedFragCoord = uv - vec2(.5);
    
    vec3 upperHalfColorTop = vec3(1, 0.48, 0.48);
    vec3 upperHalfColorBottom = vec3(1, 0, 0);
    vec3 upperHalfColorTopFragment = upperHalfColorTop * (uv.y);
    vec3 upperHalfColorBottomFragment = upperHalfColorBottom * (1. - uv.y);

    vec3 upperFinalColor = upperHalfColorTopFragment + upperHalfColorBottomFragment;

    vec3 lowerHalfColorTop = vec3(0, 0, 1);
    vec3 lowerHalfColorBottom = vec3(0.4, 0.33, 0.98);
    vec3 lowerHalfColorTopFragment = lowerHalfColorTop * (.5 - normalizedFragCoord.y);
    vec3 lowerHalfColorBottomFragment = lowerHalfColorBottom * -normalizedFragCoord.y;
    
    vec3 lowerFinalColor = lowerHalfColorTopFragment + lowerHalfColorBottomFragment;
    
    //at this point pixel that currently belongs to 
    //the top half has a 0 and every value on the lower half is 1
    //the variable topBottomFactor describes this relation of a pixel to the sine value
    float shownFunctionValue = ShowFunction(normalizedFragCoord.x);
    float topBottomFactor = smoothstep(-0.002,0.002, shownFunctionValue - normalizedFragCoord.y);

    float distanceToSinusLine = distance(normalizedFragCoord.y,shownFunctionValue);
    
    float glowLineValue = 0.0059/(distanceToSinusLine + 0.003) - 0.1;
    vec3 lineGlowColor = vec3(0.53, 1, 0.53);
    vec3 color = vec3(0);

    color = 
    upperFinalColor * (1. -topBottomFactor) +
    lowerFinalColor * topBottomFactor +
    glowLineValue * lineGlowColor;
    
    fragColor = vec4(color, 1);
}