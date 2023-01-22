//defines so the shader works out of the box with shadertoy
#define u_time iTime

//constants that are often used
#define PI 3.1415926

vec3 calculateFragmentColor(vec2 uv);

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord /iResolution.xy;
    uv -= vec2(0.5);
    vec3 pixelColor = calculateFragmentColor(uv);

    fragColor = vec4(pixelColor, 1);
}

vec3 calculateFragmentColor(vec2 uv)
{
    return vec3(sin(u_time));
}