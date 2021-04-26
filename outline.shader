shader_type canvas_item;

uniform vec4 outline_color;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (color.a == 0.0) {
		for (int i = 0; i < 4; i += 1) {
			vec2 dir = vec2(
				floor((float(i) + 1.0) / 2.0 - 1.0),
				floor((float((i + 2) % 4) + 1.0) / 2.0 - 1.0));
			if (texture(TEXTURE, UV + TEXTURE_PIXEL_SIZE * dir).a == 1.0) {
				color = outline_color;
			}
		}
	}
	COLOR = color;
}