package spoopy.graphics.texture;

#if lime

import lime.graphics.opengl.GL;

@:enum abstract SpoopyTextureType(Int) from Int to Int {
    var TEXTURE_2D = GL.TEXTURE_2D;
    var TEXTURE_CUBE = GL.TEXTURE_CUBE_MAP;
}

#else

@:enum abstract SpoopyTextureType(Int) from Int to Int {
    var TEXTURE_2D = 0x0DE1;
    var TEXTURE_CUBE = 0x8513;
}

#end