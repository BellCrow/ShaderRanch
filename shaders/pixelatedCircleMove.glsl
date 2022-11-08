float rand(float co) { return fract(sin(co*(91.3458)) * 47453.5453); }
float rand(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }
float rand(vec3 co){ return rand(co.xy+rand(co.z)); }


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    const float numberOfSquares = 100.;

    
    vec2 uv = fragCoord/iResolution.xy;
    uv -= 0.5f;

    float pointCenterX = sin(iTime) / 5.;
    float pointCenterY = cos(iTime) / 5.;
    vec2 pointPos = vec2(pointCenterX,pointCenterY);

    vec2 squareNumberInWhichPointIs = (pointPos + 0.5) * numberOfSquares;

    vec2 squareNumberingVectorCoord = (uv + 0.5) * numberOfSquares;
    float squareX = floor(squareNumberingVectorCoord.x);
    float squareY = floor(squareNumberingVectorCoord.y);
    if(floor(squareNumberInWhichPointIs) == floor(squareNumberingVectorCoord))
    {
        fragColor = vec4(1,1,1,1);
    }
    else
    {
        fragColor = vec4(squareX / numberOfSquares,squareY/ numberOfSquares,0,1);
    }
    
    
}