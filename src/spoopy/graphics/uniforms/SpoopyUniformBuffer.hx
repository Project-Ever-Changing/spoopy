package spoopy.graphics.uniforms;

import spoopy.rendering.SpoopyShader;
import spoopy.graphics.other.SpoopySwapChain;
import spoopy.obj.SpoopyObject;

import lime.utils.DataPointer;
import lime.utils.Log;

typedef UniformData = {
    var offset:Int;
    var numRegs:Int;
}

@:access(spoopy.rendering.SpoopyShader)
@:access(spoopy.graphics.other.SpoopySwapChain)
class SpoopyUniformBuffer {
    private static var UNIFORM_BUFFER_SIZE:Int = 1024 * 1024;

    @:noCompletion var __offset(default, null):Int = 0;
    @:noCompletion var __bufferIndex(default, null):Int = 0;
    @:noCompletion var __bucketSize(default, null):Int = 0;

    @:noCompletion var __device:SpoopySwapChain;
    @:noCompletion var __backend:SpoopyUniformBackend;
    @:noCompletion var __cachedBuffer:Array<SpoopyUniformBackend>;
    @:noCompletion var __cachedUniformData:Array<Map<String, UniformData>>; // Need to make sure that there would be no chance of a memory leak.

    public function new(device:SpoopySwapChain, bucketSize:Int = 3) {
        this.__bucketSize = bucketSize;

        __cachedUniformData = [];
        __cachedBuffer = [];

        for(i in 0...bucketSize) {
            __cachedBuffer[i] = new SpoopyUniformBackend(device.__surface, UNIFORM_BUFFER_SIZE);
        }

        for(i in 0...bucketSize) {
            __cachedUniformData[i] = new Map<String, UniformData>();
        }
    }

    public function apply():Void {
        if(__bufferIndex == __bucketSize - 1) {
            refresh();
        }

        __backend = __cachedBuffer[__bufferIndex];
        __bufferIndex = (__bufferIndex + 1) % __bucketSize;
    }

    public function setShaderUniform(shader:SpoopyShader, name:String, val:DataPointer, numRegs:Int):Void {
        if(__cachedUniformData[__bufferIndex].exists(name)) {
            if(__cachedUniformData[__bufferIndex].get(name).numRegs != numRegs) {
                Log.warn("Changing the uniform type in your code can cause a memory leak!");
                return;
            }
        }else {
            __cachedUniformData[__bufferIndex].set(name, {offset: __offset, numRegs: numRegs});
            __offset++;
        }

        if(__offset == UNIFORM_BUFFER_SIZE) {
            __offset = 0;
            apply();
        }

        var uniformData:UniformData = __cachedUniformData[__bufferIndex].get(name);
        __backend.setShaderUniform(shader.__shader, 0, uniformData.offset, val, numRegs);
    }

    private function refresh():Void {
        __offset = 0;
        __cachedUniformData = [];

        for(i in 0...__bucketSize) {
            __cachedBuffer[i] = new SpoopyUniformBackend(__device.__surface, UNIFORM_BUFFER_SIZE);
        }

        for(i in 0...__bucketSize) {
            __cachedUniformData[i] = new Map<String, UniformData>();
        }
    }
}

#if spoopy_metal
typedef SpoopyUniformBackend = spoopy.backend.native.metal.SpoopyUniformMetal;
#end