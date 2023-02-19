package spoopy.backend.native.metal;

import spoopy.backend.native.SpoopyNativeCFFI;

import lime.utils.DataPointer;

class SpoopyBufferMetal {
    public var handle:Dynamic;

    public var length(default, null):Int;
    public var data(default, null)::DataPointer;

    public function new(surface:SpoopyNativeSurface, length:Int, data:DataPointer) {
        this.length = length;
        this.data = data;

        //handle = SpoopyNativeCFFI.spoopy_create_metal_buffer(surface.device);
    }

    public function copyMemory(buffer:SpoopyBufferMetal):Void {
        SpoopyNativeCFFI.spoopy_copy_buffer_to_buffer(handle, buffer.handle);
    }
}