package spoopy.graphics.vertices;

import spoopy.backend.native.VerticesBufferNative;
import spoopy.graphics.SpoopyBuffer;
import spoopy.util.SpoopyFloatBuffer;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;
#end

/*
* Base helper class for managing buffers.
*/
class VertexBufferObject {
    public var buffers(default, null):Array<SpoopyFloatData>;

    public var offset(default, null):Int;
    public var length:Int;

    @:noCompletion var __vertices:SpoopyBuffer;
    @:noCompletion var __backend:VerticesBufferNative;

    #if (spoopy_vulkan || spoopy_metal)
    @:noCompletion var __device:SpoopySwapChain;
    #end

    public function new() {
        buffers = [];

        offset = 0;
        length = 0;

        __backend = new VerticesBufferNative();
    }

    #if (spoopy_vulkan || spoopy_metal)
    public function bindToDevice(device:SpoopySwapChain):Void {
        __device = device;
    }
    #end

    public function update():Void {
        var outputBuffers:SpoopyFloatBuffer = new SpoopyFloatBuffer(length);
        var __length:Int = 0;

        for(i in 0...buffers.length) {
            var b = buffers[i];

            outputBuffers.set(b, __length);
            __length += b.length;
        }

        if(__vertices == null) {
            __vertices = new SpoopyBuffer(outputBuffers, outputBuffers.byteLength);
            __vertices.init();

            return;
        }

        __vertices.updateBuffers(outputBuffers, outputBuffers.byteLength);
    }

    public function setVertexBuffer():Void {
        if(__device == null || __vertices == null) {
            return;
        }

        __backend.setVertexBuffer(__device, __vertices, offset, 0);
    }

    public function destroy():Void {
        __device = null;
        __vertices = null;
        __backend = null;
    }
}