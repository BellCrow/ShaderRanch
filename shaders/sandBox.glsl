#define u_time iGlobalTime
#define PI 3.1415926

float SinXToY(float x, float y, float value,  float frequencyFactor, float frequencyOffset)
{
    float sinValue = sin(value * frequencyFactor + frequencyOffset);
    //move the sine up to the interval 0->2
    float noNegativeSin = sinValue + 1.;
    //limit the sine down to 0->1
    float zeroToOneSin = noNegativeSin / 2.;
    //scales the amplitude of the sin to the desired size, that is described with x->y
    float sinOfDesiredSize = zeroToOneSin * (y-x);
    //now move the sine along the x axis, so that x is actually the lowest possible value;
    float finalSin = sinOfDesiredSize + x;
    return finalSin;
}
float SinXToY(float x, float y, float value)
{
    return SinXToY(x,y,value,1.,0.);
}
float CosXToY(float x, float y, float value, float frequencyFactor, float frequencyOffset)
{
    float cos = cos(value * frequencyFactor + frequencyOffset);
    //move the cos up to the interval 0->2
    float noNegativeCos = cos + 1.;
    //limit the cos down to 0->1
    float zeroToOneCos = noNegativeCos / 2.;
    //scales the amplitude of the cos to the desired size, that is described with x->y
    float cosOfDesiredSize = zeroToOneCos * (y-x);
    //now move the cos along the x axis, so that x is actually the lowest possible value;
    float finalCos = cosOfDesiredSize + x;
    return finalCos;
}

float CosXToY(float x, float y, float value)
{
    return CosXToY(x, y, value, 1.,0.);
}

float DistancePointToLineSegment(vec2 queryPoint, vec2 startLineSegment, vec2 endLineSegment)
{
    // the function works by treating the point like
    // a vector and projecting it onto the line segment 
    // like described here https://en.wikipedia.org/wiki/Vector_projection

    // first we pull the line segment and the querypoint down, 
    // so that theire respective startpoints are at zero.
    vec2 groundedLineStart = vec2(0,0);
    vec2 groundedLineEnd = endLineSegment - startLineSegment;
    vec2 groundedQueryPoint = queryPoint - startLineSegment;

    //project the vector that goes from zero to our grounded query point
    float projectionScalar = dot(groundedQueryPoint, groundedLineEnd) / pow(length(groundedLineEnd),2.0);
  
    if(projectionScalar <= 0.0)
    {
        return distance(groundedLineStart, groundedQueryPoint);
    }
    if(projectionScalar >= 1.)
    {
        return distance(groundedLineEnd, groundedQueryPoint);
    }
    vec2 unitGroundedLine = groundedLineEnd;
    vec2 nearestPointOnLineToGroundedPoint = unitGroundedLine * projectionScalar;
    return distance(nearestPointOnLineToGroundedPoint, groundedQueryPoint);
}

float LineMask(vec2 uv, vec2 start, vec2 end, float fuzziness)
{
    float distanceFragmentToLineSegment = DistancePointToLineSegment(uv,start,end);
    float whiteLineMask = smoothstep(0.0007,0.0007 + fuzziness,DistancePointToLineSegment(uv, start,end));
    return 0.5 - whiteLineMask;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord / iResolution.xy;
    vec2 normalizedFragCoord = uv - vec2(0.5);
    vec3 fragmentColor = vec3(0);

    float dist = dot(uv, vec2(iTime,iTime));
    // Output to screen
    fragmentColor += vec3(1) * step(1.,dist);
    
    fragColor = vec4(fragmentColor, 1.0);
}