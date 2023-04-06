package spoopy.rendering;

import lime.graphics.opengl.GL;

@:enum abstract SpoopyWindingMode(UInt) from UInt to UInt {
    /* Clock Wise */
    var CW = GL.CW;

    /* Counter Clock Wise */
    var CCW = GL.CCW;
}