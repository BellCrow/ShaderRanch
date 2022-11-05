#define u_time iGlobalTime
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
float CosXToY(float x, float y, float value, float frequencyFactor, float frequencyOffset) {
    float cos = cos(value * frequencyFactor + frequencyOffset);
    //move the cos up to the interval 0->2
    float noNegativeCos = cos + 1.;
    //limit the cos down to 0->1
    float zeroToOneCos = noNegativeCos / 2.;
    //scales the amplitude of the cos to the desired size, that is described with x->y
    float cosOfDesiredSize = zeroToOneCos * (y - x);
    //now move the cos along the x axis, so that x is actually the lowest possible value;
    float finalCos = cosOfDesiredSize + x;
    return finalCos;
}

float CosXToY(float lowerBound, float upperBound, float value) {
    return CosXToY(lowerBound, upperBound, value, 1., 0.);
}

float DistancePointToLineSegment(vec2 queryPoint, vec2 startLineSegment, vec2 endLineSegment) {
    // the function works by treating the point like
    // a vector and projecting it onto the line segment 
    // like described here https://en.wikipedia.org/wiki/Vector_projection

    // first we pull the line segment and the querypoint down, 
    // so that theire respective startpoints are at zero.
    vec2 groundedLineStart = vec2(0, 0);
    vec2 groundedLineEnd = endLineSegment - startLineSegment;
    vec2 groundedQueryPoint = queryPoint - startLineSegment;

    //project the vector that goes from zero to our grounded query point
    float projectionScalar = dot(groundedQueryPoint, groundedLineEnd) / pow(length(groundedLineEnd), 2.0);

    if(projectionScalar <= 0.0) {
        return distance(groundedLineStart, groundedQueryPoint);
    }
    if(projectionScalar >= 1.) {
        return distance(groundedLineEnd, groundedQueryPoint);
    }
    vec2 unitGroundedLine = groundedLineEnd;
    vec2 nearestPointOnLineToGroundedPoint = unitGroundedLine * projectionScalar;
    return distance(nearestPointOnLineToGroundedPoint, groundedQueryPoint);
}

float sFract(float value)
{
    if(value < 0.)
    {
        return -fract(value);
    }
    return fract(value);
}

vec2 sFract(vec2 value)
{
    return vec2(sFract(value.x), sFract(value.y));
}

vec2 patternSpace(vec2 fragCoord, float patterSize)
{
    vec2 stretchedCoordSystem = fragCoord * patterSize;
    vec2 patternSpace = fract(stretchedCoordSystem);
    patternSpace -= vec2(0.5);
    return patternSpace;
}