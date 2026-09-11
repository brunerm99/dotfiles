// Ghostty 1.3+: outline the focused surface with the theme's cursor accent.
// All pixels outside the 3 px border pass through unchanged.
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord / iResolution.xy);
    vec2 edgeDistance = min(fragCoord, iResolution.xy - fragCoord);
    if (iFocus > 0 && min(edgeDistance.x, edgeDistance.y) < 3.0) {
        fragColor = vec4(iCursorColor, 1.0);
    }
}
