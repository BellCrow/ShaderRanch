#define PI 3.1415926
float rand(float co) 
{
     return fract(sin(co*(90.5436)+0.234) * 47453.5453);
}


float OneDNoise(float x)
{
    float scaledX = x * 20.;
    float floorX = floor(scaledX);
    float fractX = fract(scaledX);
    float timeChangeValue = rand(floor(iTime * 40.));
    return mix(rand(floorX + timeChangeValue),rand(floorX + timeChangeValue + 1.),fractX);
}

vec3 frag(vec2 uv)
{
    float noiseValue = OneDNoise(uv.x) * sin(uv.x * PI);
    float lightColored = .006/distance(uv.y,(noiseValue / 5.) + 0.4);
    float blueColored = smoothstep(0.005,0.004,distance(uv.y,(noiseValue / 5.) + 0.4));
    return mix(vec3(lightColored),blueColored * vec3(0,0,1),0.2);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    const float numberOfSquares = 100.;
    vec2 uv = fragCoord/iResolution.xy;
    vec3 base = vec3(0);
    vec3 result = base + frag(uv);
    
    fragColor = vec4(result,1.);
    
}