package spoopy.graphics;

import spoopy.graphics.SpoopySwapChain;

import lime.utils.BytePointer;
import lime.utils.Float32Array;

@:access(spoopy.graphics.SpoopySwapChain)
class SpoopyBuffer {
    public var data(default, null):Dynamic;
    public var length(default, null):Int;

    @:noCompletion var __cachedBackend:Array<SpoopyBufferBackend>;

    @:noCompletion var __backend:SpoopyBufferBackend;
    @:noCompletion var __bufferPointer:BytePointer;

    #if (spoopy_vulkan || spoopy_metal)
    @:noCompletion var __device:SpoopySwapChain;
    #end

    public function new(data:Dynamic, length:Int, pool:UInt = 256) {
        this.data = data;
        this.length = length;

        __cachedBackend = [];
    }

    public function update():Void {
        #if (spoopy_vulkan || spoopy_metal)
        __backend = new SpoopyBufferBackend(__device.__surface);
        #end
    }

    #if (spoopy_vulkan || spoopy_metal)
    public function bindToDevice(device:SpoopySwapChain):Void {
        __device = device;
    }
    #end
}

#if spoopy_metal
typedef SpoopyBufferBackend = spoopy.backed.native.metal.SpoopyBufferMetal;
#end