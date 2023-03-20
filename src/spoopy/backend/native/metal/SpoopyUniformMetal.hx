package spoopy.backend.native.metal;

import spoopy.app.SpoopyApplication;
import spoopy.backend.native.SpoopyNativeCFFI;

class SpoopyUniformMetal {
    private static final UNIFORM_BUFFER_SIZE:Int = 8 * 1024 * 1024;

    public var bufferIndex(default, null):Int = 0;

    public var uniform_buffers:Array<Dynamic>;
    public var uniform_buffer:Dynamic;

    public function new(surface:SpoopyNativeSurface) {
        uniform_buffers = [];

        for(i in 0...SpoopyApplication.SPOOPY_CONFIG_MAX_FRAME_LATENCY) {
            uniform_buffers[i] = SpoopyNativeCFFI.spoopy_create_metal_buffer_length(surface.device, UNIFORM_BUFFER_SIZE, 0);
        }
    }

    public function apply():Void {
        uniform_buffer = uniform_buffers[bufferIndex];
        bufferIndex = (bufferIndex + 1) % SpoopyApplication.SPOOPY_CONFIG_MAX_FRAME_LATENCY;
    }
}