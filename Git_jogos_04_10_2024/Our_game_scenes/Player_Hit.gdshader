shader_type canvas_item;

uniform vec4 flash_color : source_color; // Cor do flash
uniform float flash_value : hint_range(0.0, 1.0, 0.1); // Controle de intensidade do flash

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV); // Corrigida a linha 4
    COLOR = mix(texture_color, flash_color, flash_value); // Mistura a textura com a cor do flash
    COLOR.a = texture_color.a; // Mantém a transparência original
}
