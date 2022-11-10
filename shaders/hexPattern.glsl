#define PI 3.1415926
#define PI2 (PI * 2.)
#define PI4TH (PI / 4.)
float rand(float co) 
{
    return fract(sin(co*(90.5436)+0.234) * 47453.5453);
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


float isOnHex(vec2 uv)
{
    float polarDistance = distance(vec2(0), uv);
    if(polarDistance < 0.23 || polarDistance > 0.25)
    {
        return 0.;
    }

    
    float polarAngle = degrees(atan(uv.y , uv.x) + PI);
    float angledStart = polarAngle - mod(polarAngle, 60.);
    float angledEnd = angledStart + 60.;
    vec2 segmentStart = vec2(polarDistance * cos(radians(angledStart)), polarDistance * sin(radians(angledStart)));
    vec2 segmentEnd = vec2(polarDistance * cos(radians(angledEnd)), polarDistance * sin(radians(angledEnd)));
    float distanceUvToHexSegment = DistancePointToLineSegment(uv, segmentStart, segmentEnd);
    return angledStart;
}

vec3 frag(vec2 uv)
{
    vec3 hexColor = vec3(1);
    float onHexValue = isOnHex(uv);
    return onHexValue * hexColor;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    uv -= 0.5;
    vec3 base = vec3(0);
    vec3 result = base + frag(uv);
    
    fragColor = vec4(result,1.);
    
}