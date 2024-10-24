shader_type canvas_item;

uniform int bonus = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (bonus == 1) {
		COLOR = color;
	}
	else if (bonus == 2) {
		if (color == vec4(1.0, 1.0, 1.0, color.a)) {
			COLOR = vec4(1.0, 1.0, 0, color.a);
		}
	}
	else {
		if (color == vec4(1.0, 1.0, 1.0, color.a)) {
			COLOR = vec4(1.0, 0, 0, color.a);
		}
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
