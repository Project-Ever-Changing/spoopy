package spoopy.backend.native;

import spoopy.graphics.other.SpoopySwapChain;
import spoopy.graphics.SpoopyBufferType;

@:access(spoopy.graphics.other.SpoopySwapChain)
class SpoopyNativeBuffer {
    public var handle:Dynamic;

    public function new(device:SpoopySwapChain, type:SpoopyBufferType, size:Int, bucketSize:Int) {
        var coreDevice = device.__surface.device;
        handle = SpoopyNativeCFFI.spoopy_create_buffer(coreDevice, size, type, bucketSize, DYNAMIC);
    }

    public function updateBufferData(data:DataPointer, size:Int):Void {
        SpoopyNativeCFFI.spoopy_update_buffer_data(handle, data, size);
    }

    public function updateBufferSubData(offset:Int, subData:DataPointer, size:Int):Void {
        SpoopyNativeCFFI.spoopy_update_buffer_sub_data(handle, subData, offset, size);
    }

    public function beginFrame():Void {
        SpoopyNativeCFFI.spoopy_buffer_begin_frame(handle);
    }
}