shader_type canvas_item;

void fragment() {
	vec4 b = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 c = texture(TEXTURE, UV);
	if (b.r >= 0.2 && b.g == 0.0 && b.b == 0.0) {
		c.rgb = vec3(0.0);
	}
	COLOR = c;
}