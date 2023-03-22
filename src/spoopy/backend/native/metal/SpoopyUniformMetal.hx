package spoopy.backend.native.metal;

import spoopy.app.SpoopyApplication;
import spoopy.backend.native.SpoopyNativeCFFI;

class SpoopyUniformMetal {
    private static var UNIFORM_BUFFER_SIZE:Int = 8 * 1024 * 1024;

    public var handle:Dynamic;

    public function new(surface:SpoopyNativeSurface) {
        handle = SpoopyNativeCFFI.spoopy_create_metal_buffer_length(surface.device, UNIFORM_BUFFER_SIZE, 0);
    }
}