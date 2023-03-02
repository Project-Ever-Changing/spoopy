package spoopy.backend.native.metal;

import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.util.SpoopyFloatBuffer;

import lime.utils.DataPointer;

class SpoopyBufferMetal {
    public var handle:Dynamic;

    public var list(default, null):Array<Int>;
    public var data(default, null):SpoopyFloatBuffer;

    private var bytesLength(default, null):Int;

    public function new(surface:SpoopyNativeSurface, bytesLength:Int, data:SpoopyFloatBuffer) {
        this.bytesLength = bytesLength;
        this.list = list;
        this.data = data;

        createBuffer(surface, data, bytesLength);
    }

    public function lengthBytes():Int {
        SpoopyNativeCFFI.spoopy_get_buffer_length_bytes(handle);
    }

    public function copyMemory(buffer:SpoopyBufferMetal, size:Int):Void {
        SpoopyNativeCFFI.spoopy_copy_buffer_to_buffer(handle, buffer.handle, size);
    }

    private function createBuffer(surface:SpoopyNativeSurface, data:DataPointer, size:Int):Void {
        handle = SpoopyNativeCFFI.spoopy_create_metal_buffer(surface.device, data, size);
    }
}