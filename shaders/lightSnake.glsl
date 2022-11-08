float rand(float co) { return fract(sin(co*(91.3458)) * 47453.5453); }
float rand(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }
float rand(vec3 co){ return rand(co.xy+rand(co.z)); }

float dline( vec2 p, vec2 a, vec2 b ) {
  
    vec2 v = a, w = b;
    
    float l2 = pow(distance(w, v), 2.);
    if(l2 == 0.0) return distance(p, v);
    
    float t = clamp(dot(p - v, w - v) / l2, 0., 1.);
    vec2 j = v + t * (w - v);
    
    return distance(p, j);
    
}

float point(vec2 uv, vec2 pointPos)
{
    return 0.002 / distance(uv, pointPos);
}

float contNoise(float query)
{
    float floorPart = floor(query);
    float fractPart = fract(query);
    float randLeft = rand(floorPart);
    float randRight = rand(floorPart + 1.);
    return mix(randLeft, randRight, smoothstep(0.,1.,fractPart));
}

vec2 snakePos(float time)
{
    float shiftedTime = time + 100.;
    return vec2(contNoise(time),contNoise(shiftedTime));
}

vec3 frag(vec2 uv)
{
    vec3 snakeColor = vec3(clamp(sin(iTime),0.3,0.8),clamp(cos(iTime + 20.),0.3,0.8),clamp(cos(iTime),0.3,0.8));
    float onPointValue = 0.;
    const float loopLimit = 4.;
    for(float i = 0.; i < loopLimit; i+=0.05)
    {
        vec2 snakeElementStart = snakePos(iTime - i);
        vec2 snakeElementEnd = snakePos(iTime - i - 0.05);
        float lineDistance = dline(uv, snakeElementStart, snakeElementEnd);
        float lineEndFadeOutFactor = 1. - smoothstep(0.985,1.,i/loopLimit);
        onPointValue = max(onPointValue, (0.02 / lineDistance) * lineEndFadeOutFactor);
    }
    return snakeColor * onPointValue;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    const float numberOfSquares = 100.;
    vec2 uv = fragCoord/iResolution.xy;
    vec3 base = vec3(0);
    vec3 result = base + frag(uv);
    
    fragColor = vec4(result,1.);
    
}