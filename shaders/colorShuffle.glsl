#define PI 3.1415926
float rand(float co) 
{
     return fract(sin(co*(90.5436)+0.234) * 47453.5453);
}

float isOnGrid(vec2 uv)
{
    const float cellWidth = 0.02; 
    return 
    max(1. - smoothstep(0.02, cellWidth,uv.x), 
    max(smoothstep(0.97, 1. - cellWidth,uv.x),
    max(1. - smoothstep(0.02, cellWidth,uv.y),
    smoothstep(0.97, 1.- cellWidth,uv.y))));
}

const float cellCount = 30.;
vec3 frag(vec2 uv)
{
    vec2 cellId = floor(uv * cellCount);
    vec2 cellUv = fract(uv * cellCount);
    float cellValue = cellId.x + cellId.y;
    float onGridValue = isOnGrid(cellUv);
    vec3 gridCellColor = vec3(0,0,sin((cellValue / cellCount) + iTime) - 0.4);
    gridCellColor = floor(gridCellColor * 6.) / 6.;
    return max(vec3(onGridValue), gridCellColor);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    vec3 base = vec3(0);
    vec3 result = base + frag(uv);
    
    fragColor = vec4(result,1.);
    
}