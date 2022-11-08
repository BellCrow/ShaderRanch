#define seedCount 6
const vec2 seeds[seedCount] = vec2[]
(
    vec2(0.,0.),
    vec2(0.3,0.4),
    vec2(-0.1,-0.2),
    vec2(-0.1,0.3),
    vec2(0.2,-0.2),
    vec2(0.,0.)
);
const vec4 seedColors[seedCount] = vec4[]
(
    vec4(1.,1.,1.,0),
    vec4(.2,.3,.4,0),
    vec4(.1,.9,.2,0),
    vec4(.0,1.,1.,0),
    vec4(1.,1.,0.,0),
    vec4(1.,.0,0.,0)
);

vec2 getSeedCoord(int seedIndex)
{
    vec2 seed = seeds[seedIndex];
    vec2 alteredSeed = seed + 
    vec2(
        sin(iTime+float(seedIndex))/10.,
        cos(iTime+float(seedIndex))/10.);

    return alteredSeed;
}

bool equalEps(float a, float b, float eps){
    return abs(a-b) < eps;
}

vec4 voronoi(vec2 uv)
{
    vec4 currentFragmentColor = vec4(0,0,0,0);
    float currentSeedDistance = 20.;
    for(int i = 0; i < seedCount; i++)
    {
        vec2 seed = getSeedCoord(i);
        float uvToSeedDistance = distance(seed,uv);
        if(uvToSeedDistance < 0.003)
        {
            return vec4(0);
        }
        if(uvToSeedDistance < currentSeedDistance)
        {
            currentSeedDistance = uvToSeedDistance;
            currentFragmentColor = seedColors[i];
        }
    }
    
    return currentFragmentColor * 1.-clamp(0.,1., currentSeedDistance);
}
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    const float numberOfSquares = 100.;

    
    vec2 uv = fragCoord/iResolution.xy;
    uv -= 0.5f;
    vec4 base = vec4(0);
    vec4 result = base + voronoi(uv);
    
    fragColor = result;
    
}