package spoopy.graphics;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;
#end

import spoopy.util.SpoopyArrayTools;
import spoopy.util.SpoopyFloatBuffer;

import lime.utils.BytePointer;

#if (spoopy_vulkan || spoopy_metal)
@:access(spoopy.graphics.other.SpoopySwapChain)
#end
class SpoopyBuffer {
    public var data(default, null):SpoopyFloatBuffer;

    public var length(default, null):Int;
    public var pool(default, null):UInt;

    @:noCompletion var __cachedBackend:Array<SpoopyBufferBackend>;
    @:noCompletion var __backend:SpoopyBufferBackend;
    @:noCompletion var __initialize:Bool;

    #if (spoopy_vulkan || spoopy_metal)
    @:noCompletion var __device:SpoopySwapChain;
    #end

    public function new(data:SpoopyFloatBuffer, length:Int, pool:UInt = 256) {
        this.data = data;
        this.length = length;
        this.pool = pool;

        __cachedBackend = [];
    }

    public function updateBuffers(data:SpoopyFloatBuffer, length:Int):Void {
        #if (spoopy_vulkan || spoopy_metal)
        if(__device == null) {
            return;
        }
        #end

        if(__backend.data == data && __backend.byteLength == length && __backend == null) {
            return;
        }

        var index:Int = 0;
        var bb:SpoopyBufferBackend = null;

        while(index < __cachedBackend.length) {
            bb = __cachedBackend[index++];

            if(SpoopyFloatBuffer.equals(bb.data, data) && bb.byteLength == length) {
                __backend = bb;
                return;
            }
        }

        __cachedBackend.insert(createBackendBuffer(data, length));
        __backend = __cachedBackend[0];

        if(__cachedBackend.length > pool) {
            __cachedBackend.pop();
        }

        this.data = data;
        this.length = length;
    }

    public function init():Void {
        #if (spoopy_vulkan || spoopy_metal)
        if(__device == null) {
            return;
        }
        #end

        if(__initialize) {
            return;
        }

        createBackendBuffer(data, length);
        __initialize = true;
    }

    #if (spoopy_vulkan || spoopy_metal)
    public function bindToDevice(device:SpoopySwapChain):Void {
        if(__device != null) {
            return;
        }

        __device = device;
    }
    #end

    @:noCompletion private function createBackendBuffer(data:SpoopyFloatBuffer, length:Int):SpoopyBufferBackend {
        return new SpoopyBufferBackend(__device.__surface, length, data);
    }
}

#if spoopy_metal
typedef SpoopyBufferBackend = spoopy.backend.native.metal.SpoopyBufferMetal;
#end