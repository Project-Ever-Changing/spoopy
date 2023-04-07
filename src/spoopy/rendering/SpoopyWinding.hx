package spoopy.rendering;

#if lime

import lime.graphics.opengl.GL;

@:enum abstract SpoopyWinding(Int) from Int to Int {
    
    /* The default winding order */
    var CLOCKWISE = GL.CW;

    /* The opposite of the default winding order */
    var COUNTER_CLOCKWISE = GL.CCW;
}

#end