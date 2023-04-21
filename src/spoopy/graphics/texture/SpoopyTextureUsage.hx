package spoopy.graphics.texture;

@:enum abstract SpoopyTextureUsage(Int) from Int to Int from UInt to UInt {
    
    /* Indicates that the texture will be used for read-only operations. */
    public var READ = 0;

    /* Indicates that the texture will be used for write-only operations. */
    public var WRITE = 1;

    /* Indicates that the texture will be used as a render target, meaning it can be drawn to as an output of a rendering operation. */
    public var RENDER_TARGET = 2;
}