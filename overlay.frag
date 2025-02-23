// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

// Shadertoy-compatible Blue Tint Shader with Blend Modes
// Use iChannel0 as your main texture input

#define TINT_OPACITY 0.5  // Adjust how strong the blue tint is
#define BLEND_MODE 2      // 0 = Multiply, 1 = Additive, 2 = Overlay

// Blend mode functions
vec3 blendMultiply(vec3 base, vec3 blend) {
    return base * blend;
}

vec3 blendAdditive(vec3 base, vec3 blend) {
    return min(base + blend, 1.0);
}

vec3 blendOverlay(vec3 base, vec3 blend) {
    return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), step(0.5, base));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    
    // Sample the base color
    vec3 color = texture(iChannel0, uv).rgb;

    // Define blue tint color
    vec3 blueTint = vec3(0.2, 0.3, 1.0); // Adjust for different blue shades
    vec3 tintedColor = color;

    // Apply the selected blend mode
    if (BLEND_MODE == 0) {
        tintedColor = blendMultiply(color, blueTint);
    } else if (BLEND_MODE == 1) {
        tintedColor = blendAdditive(color, blueTint);
    } else if (BLEND_MODE == 2) {
        tintedColor = blendOverlay(color, blueTint);
    }

    // Mix the original and tinted color based on opacity
    color = mix(color, tintedColor, TINT_OPACITY);

    fragColor = vec4(color, texture(iChannel0, uv).a);
}


void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}