#define u_time iGlobalTime
#define PI 3.1415926


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

struct LineSegment {
    vec2 start;
    vec2 end;
};

float DistancePointToLineSegment(vec2 queryPoint, LineSegment lineSegment) {
    return DistancePointToLineSegment(queryPoint, lineSegment.start, lineSegment.end);
}

float Rectangle(vec2 uv, vec2 tl, vec2 br)
{
    
    float height = tl.y - br.y;
    float width = br.x - tl.x;

    vec2 topLeft = tl;
    vec2 topRight = tl+vec2(width,0.);
    vec2 bottomRight = br; 
    vec2 bottomLeft = tl+vec2(0.,-height);



    LineSegment topLine = LineSegment(topLeft,topRight);
    LineSegment rightLine = LineSegment(topRight, bottomRight);
    LineSegment bottomLine = LineSegment(bottomLeft,bottomRight);
    LineSegment leftLine = LineSegment(topLeft,bottomLeft);

    float distanceToTop = DistancePointToLineSegment(uv,topLine);
    float distanceToRight = DistancePointToLineSegment(uv,rightLine);
    float distanceToBottom = DistancePointToLineSegment(uv,bottomLine);
    float distanceToLeft = DistancePointToLineSegment(uv,leftLine);

    float onLineDistance = 0.002;
    if(distanceToTop < onLineDistance 
    || distanceToRight < onLineDistance 
    || distanceToBottom < onLineDistance 
    || distanceToLeft < onLineDistance)
    {
        return 0.;
    }
    float isInsideSign = 1.;
    //check if the point is inside the rectangle
    if(distanceToTop <= height && distanceToBottom <= height
    && distanceToLeft <= width && distanceToRight <= width)
    {
        isInsideSign = -1.;
    }
    return min(distanceToTop, min(distanceToLeft, min(distanceToBottom, distanceToRight))) * isInsideSign;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized pixel coordinates (from 0 to 1)
    //vec2 uv = fragCoord /iResolution.xy;
    vec2 uv = fragCoord - iResolution.xy*0.5;
    uv /= iResolution.y;
    //1uv -= vec2(0.5);
    
    vec3 fragmentColor = vec3(0);

    vec2 rectTl = vec2(-0.2,0.3);
    vec2 rectBl = vec2(0.2,-0.3);
    float signedRectDistance = Rectangle(uv,rectTl, rectBl);
    vec3 rectColor = vec3(0.12, 0.16, 0.1);
    if(signedRectDistance == 0.)
    {
        fragmentColor = rectColor;
    }

    if(signedRectDistance < 0.)
    {
        float absDistance = abs(signedRectDistance);
        float glowValue = (0.04/(pow(absDistance,1.))) / 9.;
        vec3 glowColor = vec3(0.77, 0.83, 0);
        fragmentColor = glowValue * glowColor;
    }
    if(signedRectDistance > 0.)
    {
        float absDistance = abs(signedRectDistance);
        float glowValue = 0.09/(absDistance / .1);
        // float glowValue =  - 1.2 * absDistance + 0.3;
        vec3 glowColor = vec3(0.98, 1, 0);
        fragmentColor = glowValue * glowColor;
    }
    fragColor = vec4(fragmentColor, 1.);
}