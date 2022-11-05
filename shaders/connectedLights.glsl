#define u_time iGlobalTime

float rand(float num)
{
    return fract(sin(num * 91.34588) * 4743.553);
}

float rand(vec2 p) {
	vec3 a = fract(vec3(p.xyx) * vec3(213.897, 653.453, 253.098));
    a += dot(a, a.yzx + 79.76);
    return fract((a.x + a.y) * a.z);
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


const float patternSize = 6.;

vec2 calculateCirclePos(vec2 cellId)
{
    // + vec2(1) because cell ids that are zero would result in no movement via sin/cos
    cellId += vec2(1);
    vec2 randomOffsetMult = vec2(rand(cellId), rand(cellId));
    float modulatedTime = u_time + 2. * randomOffsetMult.x +  3. * randomOffsetMult.y;
    vec2 circlePos = vec2(
        (sin(modulatedTime + rand(randomOffsetMult.x) * 6.) * -(randomOffsetMult.x + 0.01) + 1.5) / 3.,
        (cos(modulatedTime + rand(randomOffsetMult.y) * 2.) * (randomOffsetMult.y + 0.01) + 1.5) / 3.
        );
        return circlePos;
}

vec3 calcLineFrag(vec2 uv, vec2 a, vec2 b)
{
    vec3 lineColor = vec3(1.,0.,0.);
    float onLineValue = DistancePointToLineSegment(uv,a,b);
    return smoothstep(0.02,0.01,onLineValue) * lineColor;
}


vec2 toGlobalSpace(vec4 patternSpace)
{
    vec2 globalRangeLessPos = patternSpace.xy + patternSpace.zw;
    return globalRangeLessPos / patternSize;
}

vec3 calcLineFragForCells(vec2 uv, vec2 cellIdA, vec2 cellIdB)
{
    vec2 circlePosA = calculateCirclePos(cellIdA);
    vec2 circlePosB = calculateCirclePos(cellIdB);
    vec2 globalPosForCellA = toGlobalSpace(vec4(cellIdA,circlePosA));
    vec2 globalPosForCellB = toGlobalSpace(vec4(cellIdB,circlePosB));
    uv /= patternSize;
    float uvDistanceToLine = DistancePointToLineSegment(uv, globalPosForCellA, globalPosForCellB);
    float pointDistance = distance(globalPosForCellA, globalPosForCellB);

    float lineVisibilityFactor = smoothstep(0.17, 0.13, pointDistance);

    //makes line go shiny :D
    float onLineFactor = (2./pow(2.71828,80.*uvDistanceToLine)) -0.8;
    return onLineFactor * vec3(0.5) * lineVisibilityFactor;


}

vec3 calculateFragmentColor(vec2 uv)
{    
    // uv is from 0 -> 1
    uv *= patternSize;
    // now uv goes from 0 -> patternSize
    vec2 cellId = floor(uv);
    
    vec2 patternUv = fract(uv);
    vec2 circlePos = calculateCirclePos(cellId);
    float inCircleValue = 0.001/pow(distance(patternUv, circlePos),2.);

    //connectionLines
    vec3 lineFrag = vec3(0);
    for(float x = -1.; x <= 1.; x+= 1.)
    {
        for(float y = -1.; y <= 1.; y+= 1.)
        {
            lineFrag = max(lineFrag, calcLineFragForCells(uv,cellId,cellId + vec2(x,y)));
        }
    }
    //diagonal connection lines 
    lineFrag =  max(lineFrag, calcLineFragForCells(uv,cellId + vec2(0,1) ,cellId + vec2(1,0)));
    lineFrag =  max(lineFrag, calcLineFragForCells(uv,cellId + vec2(1,0) ,cellId + vec2(0,-1)));
    lineFrag =  max(lineFrag, calcLineFragForCells(uv,cellId + vec2(0,-1) ,cellId + vec2(-1,0)));
    lineFrag =  max(lineFrag, calcLineFragForCells(uv,cellId + vec2(-1,0) ,cellId + vec2(0,1)));
    

    return (inCircleValue * vec3(0.5)) + lineFrag;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord /iResolution.xy;
    vec3 pixelColor = calculateFragmentColor(uv);

    fragColor = vec4(pixelColor, 1);
}


