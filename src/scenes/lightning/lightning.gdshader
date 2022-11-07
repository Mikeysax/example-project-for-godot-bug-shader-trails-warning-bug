shader_type spatial;
render_mode blend_mix, specular_toon, diffuse_toon, cull_disabled, particle_trails;

uniform vec4 lightning_color: source_color = vec4(0.82, 0.88, 0.0, 1);

uniform float size: hint_range (0.,1.) = 0.05;
uniform float width: hint_range (0.,1.) = 0.1;
uniform float speed = 1.35;
uniform float cycle = 1.5;
uniform float flash_ratio = 0.0;
uniform float time_shift = 7.0;
uniform float time_scale = 2.0;

uniform float bolt_ends_affect : hint_range(0,1) = 0.5;
uniform float bolt_modulation : hint_range(0,1) = 0.5;
uniform float bolt_position : hint_range(0,1) = 0.5;
uniform float bolt_angularity : hint_range(-10, 10) = 2.0;

//// ANCHOR: varying
//varying vec3 world_coord;
//varying float world_x_dot;
//// END: varying
//
//void vertex() {
//	// ANCHOR: matworld_1
//	// Billboard code, taken directly from a spatial material
//	// create a spatial material, enable billboard with billboard keep scale, and then convert
//	// to shader material, and it will create a shader with this code.
//	mat4 mat_world = mat4(
//			normalize(INV_VIEW_MATRIX[0]) * length(MODEL_MATRIX[0]),
//			normalize(INV_VIEW_MATRIX[1]) * length(MODEL_MATRIX[0]),
//			normalize(INV_VIEW_MATRIX[2]) * length(MODEL_MATRIX[2]),
//			MODEL_MATRIX[3]);
//	// END: matworld_1
//	// ANCHOR: matworld_2
//	mat_world *= mat4(
//			vec4(cos(INSTANCE_CUSTOM.x), -sin(INSTANCE_CUSTOM.x), 0.0, 0.0), 
//			vec4(sin(INSTANCE_CUSTOM.x), cos(INSTANCE_CUSTOM.x), 0.0, 0.0),
//			vec4(0.0, 0.0, 1.0, 0.0),
//			vec4(0.0, 0.0, 0.0, 1.0));
//	// END: matworld_2
//	// ANCHOR: modelview
//	MODELVIEW_MATRIX = VIEW_MATRIX * mat_world;
//	// END: modelview
//	// ANCHOR: varying_calculations
//	// We map the coordinates on the vertical planes xy and zy
//	// we also calculate how to blend between the two based on where the world space normal
//	// is pointing.
//	world_coord = (mat_world * vec4(VERTEX, 1.0)).xyz;
//	vec4 world_normal = (mat_world * vec4(NORMAL, 0.0));
//	world_x_dot =  abs(dot(normalize(world_normal.xyz), vec3(1.0, 0.0, 0.0)));
//	// END: varying_calculations
//}

float rand(float x) {
	return fract(sin(x) * 100000.0);
}

void fragment() {
	float bolt = abs(mod(UV.y * cycle + ((TIME * time_scale) + time_shift) * speed * -1.0, 0.5) - 0.25) - 0.125;
	bolt *= 4. * width;
	bolt *=  (bolt_ends_affect - abs(UV.y - bolt_modulation)) * bolt_angularity; 
	
	float wave = abs(UV.x - bolt_position + bolt);
	wave = 1. - step(size * .5, wave);
	
	float flashing = step(rand(TIME) * flash_ratio, .5);
	wave *= flashing;
	
	vec4 display = lightning_color * vec4(wave);
	
//	ALBEDO = COLOR.rgb * display.rgb;
	ALPHA = display.a;
	EMISSION = display.rgb;
	ALPHA_SCISSOR_THRESHOLD = 0.1;
}
