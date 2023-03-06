package spoopy.rendering;

@:enum abstract SpoopyCullMode(UInt) from UInt to UInt {

    /* specifies that no triangles are discarded */
    var CULL_MODE_NONE = 0;

    /* specifies that front-facing triangles are discarded */
    var CULL_MODE_FRONT = 0x00000001;

    /* specifies that back-facing triangles are discarded */
    var CULL_MODE_BACK = 0x00000002;

    /* specifies that all triangles are discarded */
    var CULL_MODE_FRONT_AND_BACK = 0x00000004;
}