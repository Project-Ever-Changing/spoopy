package spoopy.graphics.manager;

import spoopy.obj.SpoopyObject;
import spoopy.graphics.other.SpoopySwapChain;
import spoopy.graphics.SpoopyBuffer;
import spoopy.graphics.SpoopyBufferType;
import spoopy.app.SpoopyApplication;

import lime.utils.ArrayBufferView;

class TriangleBufferManager implements SpoopyObject {
    public var vertexBuffer(default, null):SpoopyBuffer;
    public var indexBuffer(default, null):SpoopyBuffer;

    @:noCompletion private var __vertexBuffers:Array<SpoopyBuffer>;
    @:noCompletion private var __indexBuffers:Array<SpoopyBuffer>;

    @:noCompletion var __indexPointers:Map<Int, Int>;
    @:noCompletion var __vertexPointers:Map<Int, Int>;

    @:noCompletion var __indexBufferIndex:Int = 0;
    @:noCompletion var __vertexBufferIndex:Int = 0;

    @:noCompletion private var __device:SpoopySwapChain;

    public function new() {
        __vertexBuffers = [];
        __indexBuffers = [];

        __indexPointers = new Map<Int, Int>();
        __vertexPointers = new Map<Int, Int>();
    }

    public function init(device:SpoopySwapChain) {
        __device = device;
    }

    public function createBuffer(data:ArrayBufferView, size:Int, type:SpoopyBufferType):Void {
        var buffer:SpoopyBuffer;

        switch (type) {
            case VERTEX:
                if(__vertexPointers.exists(size)) {
                    buffer = __vertexBuffers[__vertexPointers.get(size)];
                }else {
                    if(__vertexBuffers[__vertexBufferIndex] != null) {
                        __device.buffers.removeBuffer(__vertexBuffers[__vertexBufferIndex]);
                        __vertexBuffers[__vertexBufferIndex] = null;
                    }

                    buffer = new SpoopyBuffer(__device, size, 1, type);
                    __vertexBuffers[__vertexBufferIndex] = buffer;
                    __vertexPointers.set(size, __vertexBufferIndex);
                    __device.buffers.addBuffer(buffer);

                    __vertexBufferIndex = (__vertexBufferIndex + 1) % SpoopyApplication.SPOOPY_CONFIG_MAX_VERTEX_BUFFERS;
                }

                vertexBuffer = buffer;
            case INDEX:
                if(__indexPointers.exists(size)) {
                    buffer = __indexBuffers[__indexPointers.get(size)];
                }else {
                    if(__indexBuffers[__indexBufferIndex] != null) {
                        __device.buffers.removeBuffer(__indexBuffers[__indexBufferIndex]);
                        __indexBuffers[__indexBufferIndex] = null;
                    }

                    buffer = new SpoopyBuffer(__device, size, 1, type);
                    __indexBuffers[__indexBufferIndex] = buffer;
                    __indexPointers.set(size, __indexBufferIndex);
                    __device.buffers.addBuffer(buffer);

                    __indexBufferIndex = (__indexBufferIndex + 1) % SpoopyApplication.SPOOPY_CONFIG_MAX_INDEX_BUFFERS;
                }

                indexBuffer = buffer;
        }

        buffer.update(data);
    }

    public function destroy():Void {
        for(buffer in __vertexBuffers) {
            __device.buffers.removeBuffer(buffer);
            buffer.destroy();
        }

        for(buffer in __indexBuffers) {
            __device.buffers.removeBuffer(buffer);
            buffer.destroy();
        }

        __device = null;
    }
}