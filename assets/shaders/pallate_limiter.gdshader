shader_type canvas_item;

uniform vec4 color_1 = vec4(0.08984375, 0.125, 0.21875, 1.0);
uniform vec4 color_2 = vec4(0.14453125, 0.2265625, 0.3671875, 1.0);
uniform vec4 color_3 = vec4(0.234375, 0.3671875, 0.54296875, 1.0);
uniform vec4 color_4 = vec4(0.30859375, 0.55859375, 0.7265625, 1.0);
uniform vec4 color_5 = vec4(0.44921875, 0.7421875, 0.82421875, 1.0);
uniform vec4 color_6 = vec4(0.640625, 0.86328125, 0.85546875, 1.0);
uniform vec4 color_7 = vec4(0.09765625, 0.19921875, 0.17578125, 1.0);
uniform vec4 color_8 = vec4(0.14453125, 0.3359375, 0.1796875, 1.0);
uniform vec4 color_9 = vec4(0.2734375, 0.5078125, 0.1953125, 1.0);
uniform vec4 color_10 = vec4(0.45703125, 0.65234375, 0.26171875, 1.0);
uniform vec4 color_11 = vec4(0.65625, 0.7890625, 0.34375, 1.0);
uniform vec4 color_12 = vec4(0.8125, 0.8515625, 0.56640625, 1.0);
uniform vec4 color_13 = vec4(0.30078125, 0.16796875, 0.1953125, 1.0);
uniform vec4 color_14 = vec4(0.4765625, 0.28125, 0.25390625, 1.0);
uniform vec4 color_15 = vec4(0.67578125, 0.46484375, 0.33984375, 1.0);
uniform vec4 color_16 = vec4(0.75, 0.578125, 0.44921875, 1.0);
uniform vec4 color_17 = vec4(0.83984375, 0.70703125, 0.578125, 1.0);
uniform vec4 color_18 = vec4(0.90234375, 0.83203125, 0.69921875, 1.0);
uniform vec4 color_19 = vec4(0.203125, 0.109375, 0.15234375, 1.0);
uniform vec4 color_20 = vec4(0.375, 0.171875, 0.171875, 1.0);
uniform vec4 color_21 = vec4(0.53125, 0.29296875, 0.16796875, 1.0);
uniform vec4 color_22 = vec4(0.7421875, 0.46484375, 0.16796875, 1.0);
uniform vec4 color_23 = vec4(0.8671875, 0.6171875, 0.25390625, 1.0);
uniform vec4 color_24 = vec4(0.90625, 0.75390625, 0.4375, 1.0);
uniform vec4 color_25 = vec4(0.140625, 0.08203125, 0.15234375, 1.0);
uniform vec4 color_26 = vec4(0.25390625, 0.11328125, 0.19140625, 1.0);
uniform vec4 color_27 = vec4(0.45703125, 0.140625, 0.21875, 1.0);
uniform vec4 color_28 = vec4(0.64453125, 0.1875, 0.1875, 1.0);
uniform vec4 color_29 = vec4(0.80859375, 0.33984375, 0.234375, 1.0);
uniform vec4 color_30 = vec4(0.8515625, 0.5234375, 0.2421875, 1.0);
uniform vec4 color_31 = vec4(0.1171875, 0.11328125, 0.22265625, 1.0);
uniform vec4 color_32 = vec4(0.25, 0.15234375, 0.31640625, 1.0);
uniform vec4 color_33 = vec4(0.4765625, 0.2109375, 0.48046875, 1.0);
uniform vec4 color_34 = vec4(0.6328125, 0.2421875, 0.546875, 1.0);
uniform vec4 color_35 = vec4(0.7734375, 0.31640625, 0.58984375, 1.0);
uniform vec4 color_36 = vec4(0.87109375, 0.515625, 0.64453125, 1.0);
uniform vec4 color_37 = vec4(0.03515625, 0.0390625, 0.078125, 1.0);
uniform vec4 color_38 = vec4(0.0625, 0.078125, 0.12109375, 1.0);
uniform vec4 color_39 = vec4(0.08203125, 0.11328125, 0.15625, 1.0);
uniform vec4 color_40 = vec4(0.125, 0.1796875, 0.21484375, 1.0);
uniform vec4 color_41 = vec4(0.22265625, 0.2890625, 0.3125, 1.0);
uniform vec4 color_42 = vec4(0.33984375, 0.4453125, 0.46484375, 1.0);
uniform vec4 color_43 = vec4(0.50390625, 0.58984375, 0.5859375, 1.0);
uniform vec4 color_44 = vec4(0.65625, 0.70703125, 0.6953125, 1.0);
uniform vec4 color_45 = vec4(0.77734375, 0.80859375, 0.796875, 1.0);
uniform vec4 color_46 = vec4(0.91796875, 0.92578125, 0.91015625, 1.0);

void fragment() {
	vec4 colors[46] = {color_1, color_2, color_3, color_4, color_5, color_6, color_7, 
	color_8, color_9, color_10, color_11, color_12, color_13,
	color_14, color_15, color_16, color_17, color_18, color_19,
	color_20, color_21, color_22, color_23, color_24, color_25,
	color_26, color_27, color_28, color_29, color_30, color_31,
	color_32, color_33, color_34, color_35, color_36, color_37,
	color_38, color_39, color_40, color_41, color_42,
	color_43, color_44, color_45, color_46};

	float min_diff = -1.0;
	vec4 min_color = vec4(0.0, 0.0, 0.0, 1.0);

	vec2 uv = SCREEN_UV;

	vec4 temp = textureLod(SCREEN_TEXTURE, uv, 0.0);

	min_diff = 1000.0;
	for (int i = 0; i < colors.length(); i++) {

		float curr_dist = distance(colors[i], temp);
		if (curr_dist < min_diff) {
			min_diff = curr_dist;
			min_color = colors[i];
		}
	}

	COLOR.rgb = min_color.rgb;
}