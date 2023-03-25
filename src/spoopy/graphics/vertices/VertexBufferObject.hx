package spoopy.graphics.vertices;

import spoopy.obj.SpoopyObject;
import spoopy.app.SpoopyApplication;
import spoopy.graphics.SpoopyBuffer;
import spoopy.util.SpoopyFloatBuffer;
import spoopy.obj.prim.SpoopyPrimitive;
import spoopy.obj.display.SpoopyVertexObject;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;
#end

import haxe.ds.ObjectMap;

/*
* Base helper class for managing buffers.
*/
class VertexBufferObject implements SpoopyObject {
    public var offset(default, null):Int = 0;
    public var length(default, null):Int = 0;

    @:noCompletion var __vertexLayoutIndex:Int = 0;
    @:noCompletion var __bucketSize:Int = 0;

    @:noCompletion var __modelLayoutIndexes:ObjectMap<SpoopyVertexObject, Int>;
    @:noCompletion var __vertexLayouts:Array<VertexLayout>;
    @:noCompletion var __vertices:SpoopyBuffer;

    #if (spoopy_vulkan || spoopy_metal)
    @:noCompletion var __device:SpoopySwapChain;
    #end

    public function new() {
        __bucketSize = SpoopyApplication.SPOOPY_CONFIG_MAX_VERTEX_LAYOUTS;
        __modelLayoutIndexes = new ObjectMap<SpoopyVertexObject, Int>();
        __vertexLayouts = [];

        for(i in __bucketSize) {
            __vertexLayouts[i] = new VertexLayout();
        }
    }

    public function addObject(obj:SpoopyVertexObject):Void {
        __vertexLayouts[__vertexLayoutIndex].addBuffer(obj.getSourceVertices());
        __vertexLayoutIndex = (__vertexLayoutIndex + 1) % __bucketSize;
        __modelLayoutIndexes.set(obj, __vertexLayoutIndex);

        length += obj.getSourceVertices().length;
    }

    public function removeObject(obj:SpoopyVertexObject):Void {
        __vertexLayouts[__modelLayoutIndexes[obj]].removeBuffers(obj.getSourceVertices());
        length -= obj.getSourceVertices().length;
    }

    #if (spoopy_vulkan || spoopy_metal)
    public function bindToDevice(device:SpoopySwapChain):Void {
        __device = device;
    }
    #end

    public function update():Void {
        var outputBuffers:SpoopyFloatBuffer = new SpoopyFloatBuffer(length);
        var __length:Int = 0;

        for(i in 0...__bucketSize) {
            var b = __vertexLayouts[i].buffer;

            outputBuffers.set(outputBuffers, b, __length);
            __length += b.length;
        }

        if(__vertices == null) {
            __vertices = new SpoopyBuffer(outputBuffers, outputBuffers.byteLength, SpoopyApplication.SPOOPY_CONFIG_MAX_VERTEX_BUFFERS);
            __vertices.init();

            return;
        }

        __vertices.updateBuffers(outputBuffers, outputBuffers.byteLength);
    }

    public function setVertexBuffer():Void {
        if(__device == null || __vertices == null) {
            return;
        }

        __device.setVertexBuffer(__vertices, offset);
    }

    public function destroy():Void {
        if(__modelLayoutIndexes == null) {
            __modelLayoutIndexes.clear();
        }

        __modelLayoutIndexes = null;

        __device = null;
        __vertices = null;
    }
}