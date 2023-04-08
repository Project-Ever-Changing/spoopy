package spoopy.obj.prim;

#if lime

import lime.graphics.opengl.GL;

@:enum abstract SpoopyPrimitiveType(Int) {
    var POINTS = GL.POINTS;
    var LINES = GL.LINES;
    var LINE_LOOP = GL.LINE_LOOP;
    var LINE_STRIP = GL.LINE_STRIP;
    var TRIANGLES = GL.TRIANGLES;
    var TRIANGLE_STRIP = GL.TRIANGLE_STRIP;
    var TRIANGLE_FAN = GL.TRIANGLE_FAN;
}

#end