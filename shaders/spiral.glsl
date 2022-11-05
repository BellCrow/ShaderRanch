#define u_time iGlobalTime
#define PI 3.1415926
#define origin vec2(0.)

float SinXToY(float x, float y, float value, float frequencyFactor, float frequencyOffset) {
    float sinValue = sin(value * frequencyFactor + frequencyOffset);
    //move the sine up to the interval 0->2
    float noNegativeSin = sinValue + 1.;
    //limit the sine down to 0->1
    float zeroToOneSin = noNegativeSin / 2.;
    //scales the amplitude of the sin to the desired size, that is described with x->y
    float sinOfDesiredSize = zeroToOneSin * (y - x);
    //now move the sine along the x axis, so that x is actually the lowest possible value;
    float finalSin = sinOfDesiredSize + x;
    return finalSin;
}

float SinXToY(float x, float y, float value) {
    return SinXToY(x, y, value, 1., 0.);
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

float CosXToY(float x, float y, float value) {
    return CosXToY(x, y, value, 1., 0.);
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

float Circle(vec2 uv, vec2 center, float radius)
{
    float circleSmoothNess = 0.003;
    float inCircleValue = radius - distance(uv, center);
    return smoothstep(.0,circleSmoothNess,inCircleValue);
}

float CircleHollow(vec2 uv, vec2 center, float radiusInner, float radiusOuter)
{
    float innerCircleValue = Circle(uv, center, radiusInner);
    float outerCircleValue = Circle(uv, center, radiusOuter);
    return outerCircleValue - innerCircleValue;
}

float UnitCircle(vec2 uv)
{
    float coordinateValueFunction = uv.x * uv.x + uv.y * uv.y;
    return smoothstep(1.01,0.98,coordinateValueFunction);
}

float Spiral(vec2 uv)
{
    float coordinateValueFunction = uv.x * uv.x + uv.y * uv.y;
    return smoothstep(1.01,0.98,coordinateValueFunction);
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
#define Pi2 PI*2.
void mainImage(out vec4 fragColor, in vec2 fragCoord) 
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 normalizedFragCoord = fragCoord /iResolution.xy;
    vec2 uv = normalizedFragCoord - vec2(0.5);
    uv *= 30.;
    vec3 pixelColor = vec3(1);
    float polarCoordinateAngle = atan(uv.y,uv.x) + PI;
    float polarCoordinateRadius = distance(origin,uv);
    
    if(abs(mod(polarCoordinateAngle - polarCoordinateRadius + u_time, 2.*PI)) < 0.2)
    {
        pixelColor  = vec3(0.,0.,0.);
    }

        
    fragColor = vec4(pixelColor,0.);
}