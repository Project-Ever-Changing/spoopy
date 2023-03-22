package spoopy.graphics.uniforms;

import spoopy.graphics.other.SpoopySwapChain;

@:access(spoopy.graphics.other.SpoopySwapChain)
class SpoopyUniformBuffer {
    @:noCompletion var __bufferIndex(default, null):Int = 0;

    @:noCompletion var __backend:SpoopyUniformBackend;
    @:noCompletion var __cachedBuffer:Array<SpoopyUniformBackend>;

    public function new(device:SpoopySwapChain, bucketSize:Int = 3) {
        for(i in 0...bucketSize) {
            __cachedBuffer[i] = new SpoopyUniformBackend(device.__surface);
        }
    }

    public function apply():Void {
        __backend = __cachedBuffer[bufferIndex];
        bufferIndex = (bufferIndex + 1) % bucketSize;
    }
}

#if spoopy_metal
typedef SpoopyUniformBackend = spoopy.backend.native.metal.SpoopyUniformMetal;
#end