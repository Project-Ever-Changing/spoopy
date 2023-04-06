package spoopy.rendering.optimization;

@:enum abstract SpoopyBasicType(Int) {
    var TYPE_FLOAT = 0;
    var TYPE_BOOL = 1;
    var TYPE_INT = 2;
    var TYPE_TEX2D = 4;
    var TYPE_TEX3D = 8;
    var TYPE_TEXCUBE = 16;
    var TYPE_TEX2DSHADOW = 32;
    var TYPE_TEX2DARRAY = 64;
    var TYPE_OTHER = 128;
    var TYPE_COUNT = 6;
}