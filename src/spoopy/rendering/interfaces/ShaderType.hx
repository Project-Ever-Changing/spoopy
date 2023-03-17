package spoopy.rendering.interfaces;

@:enum abstract ShaderType(UInt) {
    var VERTEX_SHADER = 0;
    var FRAGMENT_SHADER = 1;
}