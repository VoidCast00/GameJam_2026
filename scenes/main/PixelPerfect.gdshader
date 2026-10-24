shader_type canvas_item;

uniform vec2 cam_offset  = vec2(0.0,0.0);

void vertex() {
	VERTEX += cam_offset;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
