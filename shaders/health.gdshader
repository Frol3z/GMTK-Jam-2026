shader_type canvas_item;

uniform sampler2D image;
uniform float amount: hint_range(0.0, 100.0, 0.01);

void fragment() {
	COLOR = texture(TEXTURE, UV);
	vec4 color = texture(image, UV);
	color.r = 100.0f;
	COLOR.a -= (color.r - amount)/100.0f;
	
	if (COLOR.a == 0.0){
		COLOR.a = 1.0;
		COLOR.r = 0.8;
		COLOR.b = 0.0;
		COLOR.g = 0.0;
	}
		
}