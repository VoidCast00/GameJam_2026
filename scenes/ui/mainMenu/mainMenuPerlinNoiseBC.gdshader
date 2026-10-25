shader_type canvas_item;

//look
uniform vec4 color_dark : source_color = vec4(0.01, 0.03, 0.08, 1.0);
uniform vec4 color_light : source_color = vec4(0.18, 0.6, 0.72, 1.0);
uniform float contrast = 2.5;      //higher = sharper light and dark
uniform float depth_fade = 0.5;    //darker at the bottom

//motion
uniform float scale = 0.004;       //smaller = bigger blobs
uniform float speed = 0.05;
uniform float warp = 1.5;          //how much it swirls

//pixel look (1 = off)
uniform float pixel_size = 1.0;

varying vec2 local_pos;

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
	for (int k = 0; k < 5; k++) {
		v += amp * noise(p);
		p *= 2.0;
		amp *= 0.5;
	}
	return v;
}

void vertex() {
	local_pos = VERTEX;
}

void fragment() {
	//pixelate
	vec2 pos = floor(local_pos / pixel_size) * pixel_size;
	vec2 p = pos * scale;
	float t = TIME * speed;

	//swirl the noise with more noise
	vec2 q = vec2(
		fbm(p + vec2(0.0, t)),
		fbm(p + vec2(5.2, 1.3) - vec2(t, 0.0))
	);
	float n = fbm(p + q * warp + vec2(t * 0.5, -t * 0.3));
	n = n * 0.5 + 0.5;

	//push light and dark apart
	n = clamp((n - 0.5) * contrast + 0.5, 0.0, 1.0);
	n = smoothstep(0.0, 1.0, n);

	//darker deeper down
	float depth = mix(1.0, 1.0 - depth_fade, UV.y);

	COLOR = vec4(mix(color_dark.rgb, color_light.rgb, n) * depth, 1.0);
}