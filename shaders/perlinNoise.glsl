#define u_time iGlobalTime
#define PI 3.1415926


const float patternSize = 100.;

float rand(float num)
{
    return fract(sin(num * 911213.345858 * u_time) * 47453.554543);
}

float rand(vec2 p) {
	vec3 a = fract(vec3(p.xyx) * vec3(213.897, 653.453, 253.098));
    a += dot(a, a.yzx + 79.76);
    return fract((a.x + a.y) * a.z);
}

float map(float value, float valueMin, float valueMax,float mapMin, float mapMax)
{
    float absValueRange = valueMax - valueMin;
    float valuePercent = value / absValueRange;
    float mapValueRange = mapMax - mapMin;
    float mappedAbsValue = mapValueRange * valuePercent;
    return mappedAbsValue - mapMin;
}

float smoothnoise(vec2 uv)
{
    vec2 cellId = floor(uv );
    
    vec2 cellUv = fract(uv);

    float cellValueLt = rand(cellId + vec2(0.,1.));
    float cellValueRt = rand(cellId + vec2(1.,1.));
    float cellValueRb = rand(cellId + vec2(1.,0.));
    float cellValueLb = rand(cellId);
    float topValue = mix(cellValueLt, cellValueRt, cellUv.x);
    float bottomValue = mix(cellValueLb, cellValueRb, cellUv.x);
    float interpolatedValue = mix(bottomValue,topValue,cellUv.y);
    return interpolatedValue;
}

vec3 calculateFragmentColor(vec2 uv){

    uv -= vec2(0.,10.);
    float noise = smoothnoise(uv * 20.);
    noise = smoothnoise(uv * 10.);
    noise += smoothnoise(uv * 40.) / 4.;
    noise += smoothnoise(uv * 80.) / 8.;
    noise += smoothnoise(uv * 160.) / 16.;
    noise += smoothnoise(uv * 320.) / 32.;
    noise /= 2.;
    return vec3(noise);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord /iResolution.xy;
    
    vec3 pixelColor = calculateFragmentColor(uv);

    fragColor = vec4(pixelColor, 1);
}
