package spoopy.graphics.texture.sampler;

#if lime

import lime.graphics.opengl.GL;

@:enum abstract SpoopySamplerAddressMode(Int) from Int to Int {
    public var CLAMP_TO_EDGE = GL.CLAMP_TO_EDGE;
    public var MIRROR_REPEAT = GL.MIRRORED_REPEAT;
    public var REPEAT = GL.REPEAT;
    public var NO_MODE = GL.NONE;
}

#else

@:enum abstract SpoopySamplerAddressMode(Int) from Int to Int {
    public var CLAMP_TO_EDGE = 0x812F;
    public var MIRROR_REPEAT = 0x8370;
    public var REPEAT = 0x2901;
    public var NO_MODE = 0x0000;
}

#end