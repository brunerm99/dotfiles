// Ghostty 1.3+: outline the focused surface in Workbench orange (#f07828).
// Keep the accent independent of cursor colors changed by terminal applications.
// All pixels outside the 3 px border pass through unchanged.
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord / iResolution.xy);
    vec2 edgeDistance = min(fragCoord, iResolution.xy - fragCoord);
    if (iFocus > 0 && min(edgeDistance.x, edgeDistance.y) < 3.0) {
        fragColor = vec4(vec3(240.0, 120.0, 40.0) / 255.0, 1.0);
    }
}
