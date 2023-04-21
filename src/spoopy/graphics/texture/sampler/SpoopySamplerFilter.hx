package spoopy.graphics.texture.sampler;

#if lime

import lime.graphics.opengl.GL;

@:enum abstract SpoopySamplerFilter(Int) from Int to Int {
    public var NEAREST = GL.NEAREST;
    public var LINEAR = GL.LINEAR;
    public var NEAREST_MIPMAP_NEAREST = GL.NEAREST_MIPMAP_NEAREST;
    public var LINEAR_MIPMAP_NEAREST = GL.LINEAR_MIPMAP_NEAREST;
    public var NEAREST_MIPMAP_LINEAR = GL.NEAREST_MIPMAP_LINEAR;
    public var LINEAR_MIPMAP_LINEAR = GL.LINEAR_MIPMAP_LINEAR;
    public var NO_FILTER = GL.NONE;
}

#else

@:enum abstract SpoopySamplerFilter(Int) from Int to Int {
    public var NEAREST = 0x2600;
    public var LINEAR = 0x2601;
    public var NEAREST_MIPMAP_NEAREST = 0x2700;
    public var LINEAR_MIPMAP_NEAREST = 0x2701;
    public var NEAREST_MIPMAP_LINEAR = 0x2702;
    public var LINEAR_MIPMAP_LINEAR = 0x2703;
    public var NO_FILTER = 0x0000;
}

#end