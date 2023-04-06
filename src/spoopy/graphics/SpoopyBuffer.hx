package spoopy.graphics;

import spoopy.obj.SpoopyObject;
import spoopy.graphics.other.SpoopySwapChain;
import spoopy.graphics.SpoopyBufferType;
import spoopy.backend.native.SpoopyNativeBuffer;

import lime.utils.ArrayBufferView;
import lime.utils.DataPointer;
import lime.utils.Log;

class SpoopyBuffer implements SpoopyObject {
    public var size(default, null):Int;
    public var bucketSize(default, null):Int;
    public var type(default, null):SpoopyBufferType;

    @:noCompletion var __device(default, null):SpoopySwapChain;
    @:noCompletion var __buffer(default, null):SpoopyNativeBuffer;

    public function new(device:SpoopySwapChain, size:Int, bucketSize:Int = 1, type:SpoopyBufferType) {
        this.type = type;
        this.size = size;
        this.bucketSize = bucketSize;
        this.__device = device;

        __buffer = new SpoopyNativeBuffer(device, type, size, bucketSize);
    }

    public function updateData(data:ArrayBufferView):Void {
        if(data.byteLength != size) {
            Log.error("Size of data does not match buffer size!");
            return;
        }

        __buffer.updateBufferData(data, this.size);
    }

    public function updateSubData(index:Int, subData:DataPointer, size:Int):Void {
        if(index >= size) {
            Log.error("Index out of bounds!");
            return;
        }

        this.size = size;
        __buffer.updateBufferSubData(index, subData, this.size);
    }

    public function beginFrame():Void {
        __buffer.beginFrame();
    }

    public function destroy():Void {
        __buffer = null;
        __device = null;
    }
}