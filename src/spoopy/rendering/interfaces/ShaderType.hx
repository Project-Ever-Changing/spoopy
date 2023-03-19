package spoopy.rendering.interfaces;

@:enum abstract ShaderType(Int) {
    var FRAGMENT_SHADER = 0x10;
    var VERTEX_SHADER = 0x20;
}