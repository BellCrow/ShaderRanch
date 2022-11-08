
vec3 pattern(vec2 uv)
{
    //uv += vec2(iTime / 50., -iTime / 100.);

    const float cellCount = 10.;
    const vec3 gridColor = vec3(1);
    vec2 inflatedUv = uv * cellCount;
    float moveDist = iTime;
    if(mod(iTime, 2.) >= 1.)
    {
        vec2 move = vec2(0, moveDist);
        if(mod(inflatedUv.x,2.) >= 1.)
        {
            inflatedUv += move;
        }
        else
        {
            inflatedUv -= move;
        }
    }
    else
    {
        vec2 move = vec2(moveDist, 0);
        //cycles every .5 move units
        if(mod(inflatedUv.y,2.) >= 1.)
        {
            inflatedUv += move;
        }
        else
        {
            inflatedUv -= move;
        }
    }
    
    vec2 cellId = floor(inflatedUv);
    vec2 cellUv = fract(inflatedUv);
    
    cellUv -= 0.5;

    float absX = abs(cellUv.x);
    float absY = abs(cellUv.y);

    float leftRightBorder = step(0.45,absX);
    float upperLowerBorder = step(0.45,absY);
        
    float onBorder = max(leftRightBorder,upperLowerBorder);
    
    vec2 dotPos = vec2(sin(iTime) /3., cos(iTime)/3.);
    dotPos = vec2(0.0);
    float onDot = .01/distance(cellUv,dotPos);

    return gridColor * onBorder * 0. + onDot * gridColor;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    const float numberOfSquares = 100.;
    vec2 uv = fragCoord/iResolution.xy;
    vec3 base = vec3(0);
    vec3 result = base + pattern(uv);
    
    fragColor = vec4(result,1.);
    
}