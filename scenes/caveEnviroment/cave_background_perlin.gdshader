shader_type canvas_item;

//settings
uniform vec2 offset = vec2(0.0);
uniform float scale = 0.004;
uniform float parallax = 0.5;
uniform vec4 color_a : source_color = vec4(0.02, 0.04, 0.12, 1.0);
uniform vec4 color_b : source_color = vec4(0.06, 0.25, 0.4, 1.0);
uniform vec2 camera_pos = vec2(0.0);
varying vec2 world_pos;

//random gradient
vec2 hash(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
	return -1.0 + 2.0 * fract(sin(p) * 43758.5453);
}

//perlin noise
float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	float a = dot(hash(i), f);
	float b = dot(hash(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0));
	float c = dot(hash(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0));
	float d = dot(hash(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0));
	return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

//layered noise
float fbm(vec2 p) {
	float v = 0.0;
	float amp = 0.5;
	for (int k = 0; k < 4; k++) {
		v += amp * noise(p);
		p *= 2.0;
		amp *= 0.5;
	}
	return v;
}

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}
void fragment() {
	vec2 p = (world_pos - camera_pos * (1.0 - parallax)) * scale;
	float n = fbm(p) * 0.5 + 0.5;
	COLOR = mix(color_a, color_b, n);
}