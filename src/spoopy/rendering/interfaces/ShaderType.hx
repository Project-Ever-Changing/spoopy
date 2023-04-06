package spoopy.rendering.interfaces;

#if lime

import lime.graphics.opengl.GL;

@:enum abstract ShaderType(Int) {
    var FRAGMENT_SHADER = GL.FRAGMENT_SHADER;
    var VERTEX_SHADER = GL.VERTEX_SHADER;
    var VERTEX_AND_FRAGMENT_SHADER = -1;

    public inline function getIndex():Int {
        switch (this) {
            case GL.VERTEX_SHADER: return 0;
            case GL.FRAGMENT_SHADER: return 1;
            default: return -1;
        }
    }
}

#end