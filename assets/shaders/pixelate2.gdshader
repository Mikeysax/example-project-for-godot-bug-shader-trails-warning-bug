shader_type canvas_item;
 
uniform int pixelSize: hint_range(2, 16, 2) = 4;
 
void fragment()
{
    vec2 iRes = 1.0 / SCREEN_PIXEL_SIZE;
    
    float onePixelSizeX = 1.0 / iRes.x;
    float onePixelSizeY = 1.0 / iRes.y;
    
    float cellSizeX =  float(pixelSize) * onePixelSizeX;
    float cellSizeY = float(pixelSize) * onePixelSizeY; 
    
    float x = cellSizeX * floor(UV.x / cellSizeX);
    float y = cellSizeY * floor(UV.y / cellSizeY);
    
    COLOR = texture(SCREEN_TEXTURE, vec2(x, y));
}