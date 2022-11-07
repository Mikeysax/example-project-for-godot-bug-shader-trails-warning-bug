shader_type canvas_item;
 
uniform float pixelate: hint_range(2, 512, 4) = 512;
 
void fragment()
{
    vec2 uv = floor(UV * pixelate) / pixelate;
    COLOR = textureLod(SCREEN_TEXTURE, uv, 0.0);
}