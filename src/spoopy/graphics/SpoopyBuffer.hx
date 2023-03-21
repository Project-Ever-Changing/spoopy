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

    @:noCompletion var __indexPointers:Map<Int, Int>;
    @:noCompletion var __cachedBackend:Array<SpoopyBufferBackend>;
    @:noCompletion var __bufferIndex:Int;
    @:noCompletion var __backend:SpoopyBufferBackend;
    @:noCompletion var __initialize:Bool;

    #if (spoopy_vulkan || spoopy_metal)
    @:noCompletion var __device:SpoopySwapChain;
    #end

    public function new(data:SpoopyFloatBuffer, length:Int, pool:UInt = 0) {
        this.data = data;
        this.length = length;
        this.pool = pool;

        __indexPointers = new Map<Int, Int>();
        __cachedBackend = [];

        __bufferIndex = 0;
    }

    public function updateBuffers(data:SpoopyFloatBuffer, length:Int):Void {
        #if (spoopy_vulkan || spoopy_metal)
        if(__device == null) {
            return;
        }
        #end

        var index:Int = 0;
        var bb:SpoopyBufferBackend = null;

        this.data = data;
        this.length = length;

        if(__cachedBackend.exists(length)) {
            bb = __cachedBackend[__indexPointers[length]];
            bb.copyMemory(data, length);
            backend = bb;

            return; 
        }

        bb = __cachedBackend[__bufferIndex];
        __cachedBackend.set(length, __bufferIndex);
        __bufferIndex = (__bufferIndex + 1) % pool;
        backend = bb;
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
        __indexPointers.set(length, 0);
        __bufferIndex = (__bufferIndex + 1) % pool;

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