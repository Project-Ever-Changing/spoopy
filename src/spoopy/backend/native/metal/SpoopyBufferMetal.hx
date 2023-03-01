package spoopy.backend.native.metal;

import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.util.SpoopyFloatBuffer;

class SpoopyBufferMetal {
    public var handle:Dynamic;

    public var length(default, null):Int;
    public var list(default, null):Array<Int>;
    public var data(default, null):SpoopyFloatBuffer;

    public function new(surface:SpoopyNativeSurface, length:Int, data:SpoopyFloatBuffer) {
        this.length = length;
        this.list = list;
        this.data = data;

        //handle = SpoopyNativeCFFI.spoopy_create_metal_buffer(surface.device);
    }

    public function lengthBytes():Int {
        SpoopyNativeCFFI.spoopy_get_buffer_length_bytes(handle);
    }

    public function copyMemory(buffer:SpoopyBufferMetal, size:Int):Void {
        SpoopyNativeCFFI.spoopy_copy_buffer_to_buffer(handle, buffer.handle, size);
    }
}