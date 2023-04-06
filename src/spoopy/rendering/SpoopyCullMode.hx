package spoopy.rendering;

import lime.graphics.opengl.GL;

@:enum abstract SpoopyCullMode(UInt) from UInt to UInt {

    /* specifies that no triangles are discarded */
    var CULL_MODE_NONE = 0;

    /* specifies that front-facing triangles are discarded */
    var CULL_MODE_FRONT = GL.FRONT;

    /* specifies that back-facing triangles are discarded */
    var CULL_MODE_BACK = GL.BACK;

    /* specifies that all triangles are discarded */
    var CULL_MODE_FRONT_AND_BACK = GL.FRONT_AND_BACK;
}