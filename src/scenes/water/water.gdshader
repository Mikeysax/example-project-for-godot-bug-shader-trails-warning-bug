shader_type spatial;
render_mode blend_mix, specular_toon, diffuse_toon, cull_disabled;

uniform float speed : hint_range(-1,1) = 0.01;
uniform float speed2 : hint_range(-1,1) = -0.01;
uniform float foam_speed : hint_range(-10,10) = 0.025;
uniform float foam_modulation = 0.5;
uniform float ripple_speed = 0.9;
//colors
uniform sampler2D base_noise_texture;
uniform sampler2D water_noise_texture;
uniform sampler2D foam_noise_texture;
uniform float water_noise_blend = 1.5;
uniform sampler2D normalmap : hint_normal;
uniform sampler2D normalmap2 : hint_normal;
uniform float normalmap_blend = 0.1;
uniform vec4 color : source_color = vec4(0.04, 0.56, 1, 1);
uniform vec4 deep_water: source_color = vec4(0.04, 0.43, 1, 1);
uniform vec4 edge_color : source_color = vec4(1, 1, 1, 1);

//depth-fade
uniform float beer_law_factor = 2.0;
uniform float _distance = 10.0;

//foam
uniform float edge_scale = 0.5;
uniform float near = 2;
uniform float far = 400.0;
uniform float displacement_amount = 0.01;
uniform float displacement_modulation = 0.0;

//waves
uniform vec3 wave_strength = vec3(0.025, 0.025, 0.025);
uniform vec3 wave_frequency = vec3(12.0, 12.0, 12.0);
uniform vec2 time_factor = vec2(1.0, 2.0);

uniform float roughness = 0.5;
uniform float specular = 0.2;
uniform float metallic = 0.5;
uniform float rim = 0.4;

// --- Water Functions
float linearize(float depth){
	depth = 2.0 * depth - 1.0;
	return near * far / (far + depth * (near - far));
}

vec2 panning(float time, float time_scale, vec2 uv) {
	return fma(vec2(time), vec2(time_scale), uv);
}

float waves(vec3 vert, vec3 norm, float time){
	return (
		wave_strength.x *
		sin(vert.x + norm.x * wave_frequency.x + time * time_factor.x)
	) + (
		wave_strength.y *
		sin(vert.y + norm.y * wave_frequency.y + time * time_factor.y)
	) + (
		wave_strength.z *
		sin(vert.z + norm.z * wave_frequency.z + time * time_factor.x)
	);
}

void vertex() {
	VERTEX += waves(VERTEX.xyz, NORMAL, TIME);
}

float calc_depth_fade(float depth, mat4 projection_matrix, vec4 fragcoord, float beer_factor, float __distance, vec3 vertex) {
	float scene_depth = depth;

	scene_depth = scene_depth * 2.0 - 1.0;
	scene_depth = projection_matrix[3][2] / (scene_depth + projection_matrix[2][2]);
	scene_depth = scene_depth + vertex.z; // z is negative

	// application of beers law
	scene_depth = exp(-scene_depth * beer_factor);

	float screen_depth = fragcoord.z;
	float depth_fade = (scene_depth - screen_depth) / __distance;

	depth_fade = clamp(depth_fade, 0.0, 1.0);

	return depth_fade;
}

void fragment() {
	// Water Code
	float time = TIME * speed;
	float foam_time = foam_modulation * ((1.0 - sin(TIME * foam_speed)) + foam_modulation);

	vec3 n1 = texture(base_noise_texture, UV + time).rgb;
	vec3 n2 = texture(water_noise_texture, UV - time * 0.2).rgb;
	vec3 n3 = texture(foam_noise_texture, UV - foam_time * 0.2).rgb;

	vec2 uv_movement = UV * 4.0;
	uv_movement += TIME * speed * 4.0;
	
	vec2 uv_movement_negative = UV * 4.0;
	uv_movement_negative += TIME * speed2 * 4.0;

	float z_depth = linearize(texture(DEPTH_TEXTURE, SCREEN_UV).x);
	float z_pos = linearize(FRAGCOORD.z);
	float diff = z_depth - z_pos;

	// depth-fade
	float z_depth_fade = calc_depth_fade(texture(DEPTH_TEXTURE, SCREEN_UV).x, PROJECTION_MATRIX, FRAGCOORD, beer_law_factor, _distance, VERTEX);
	float z_fade = linearize(FRAGCOORD.z);
	float fade_diff = z_depth_fade - z_fade;

	vec4 gradientcolor = mix(color, deep_water, z_depth_fade);

	vec2 displacement = texture(base_noise_texture, UV - TIME / 7.0).rg;
	displacement = ((displacement * 2.0) - 1.0) * displacement_amount;
	diff += displacement.x * displacement_modulation;

	float water_noise = (n1.r + n2.r) / water_noise_blend - 1.0;
	float foam_noise = (n3.r) - 1.0;

	float noise_blend = 0.0;
	if (water_noise > 0.0 && water_noise < 0.4) noise_blend = 0.1;
	if (water_noise > 0.4 && water_noise < 0.8) noise_blend = 0.0;
	if (water_noise > 0.8) noise_blend = 1.0;

	vec4 alpha = vec4(1.0);
	alpha += texture(SCREEN_TEXTURE, SCREEN_UV + displacement);

	vec4 col = mix(
		edge_color,
		gradientcolor,
		step(
			edge_scale / (1.0 - sin(foam_noise * foam_modulation) * ripple_speed),
			diff * (1.0 - sin(foam_noise / foam_modulation) * ripple_speed)
		)
	);

	ALBEDO = mix(alpha.rgb, col.rgb, alpha.a) + vec3(noise_blend);
	
	vec4 norm1 = texture(normalmap, uv_movement);
	vec4 norm2 = texture(normalmap2, uv_movement_negative);
	NORMAL_MAP = normalize(mix(norm1.rgb, norm2.rgb, normalmap_blend));
	
	ROUGHNESS = roughness;
	METALLIC = metallic;
	SPECULAR = specular;
	RIM = rim;
}
