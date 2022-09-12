#version 450

#ifdef COMPILE_VERTEX
vec2 vertices[] = vec2[] (
    vec2(0.0, -0.5),
    vec2(0.5, 0.5),
    vec2(-0.5, 0.5)
);

void main() {
    gl_Position = vec4(vertices[gl_VertexIndex], 0.0, 1.0);
}
#endif

#ifdef COMPILE_FRAGMENT
layout(location == 0) out vec4 DST_color;

void main() {
    DST_color = vec4(1.0, 1.0, 0.0, 1.0);
}
#endif