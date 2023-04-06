package spoopy.graphics.vertices;

import spoopy.obj.SpoopyObject;
import spoopy.app.SpoopyApplication;
import spoopy.util.SpoopyFloatBuffer;
import spoopy.obj.prim.SpoopyPrimitive;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;
#end

import haxe.ds.ObjectMap;

/*
* Base helper class for managing buffers.
*/
class VertexBufferObject implements SpoopyObject {
    public var vertices(default, null):SpoopyFloatBuffer = null;

    public var offset(default, null):Int = 0;
    public var length(default, null):Int = 0;

    @:noCompletion var __vertexLayoutIndex:Int = 0;
    @:noCompletion var __bucketSize:Int = 0;

    @:noCompletion var __modelLayoutIndexes:ObjectMap<SpoopyFloatBuffer, Int>;
    @:noCompletion var __vertexLayouts:Array<VertexLayout>;

    #if (spoopy_vulkan || spoopy_metal)
    @:noCompletion var __device:SpoopySwapChain;
    #end

    public function new() {
        __bucketSize = SpoopyApplication.SPOOPY_CONFIG_MAX_VERTEX_LAYOUTS;
        __modelLayoutIndexes = new ObjectMap<SpoopyFloatBuffer, Int>();
        __vertexLayouts = [];

        for(i in 0...__bucketSize) {
            __vertexLayouts[i] = new VertexLayout();
        }

        vertices = new SpoopyFloatBuffer(length);
    }

    public function addObject(obj:SpoopyFloatBuffer):Void {
        __vertexLayouts[__vertexLayoutIndex].addBuffer(obj);
        __vertexLayoutIndex = (__vertexLayoutIndex + 1) % __bucketSize;
        __modelLayoutIndexes.set(obj, __vertexLayoutIndex);

        length += obj.length;
    }

    public function removeObject(obj:SpoopyFloatBuffer):Void {
        __vertexLayouts[__modelLayoutIndexes.get(obj)].removeBuffer(obj);
        length -= obj.length;
    }

    #if (spoopy_vulkan || spoopy_metal)
    public function bindToDevice(device:SpoopySwapChain):Void {
        __device = device;
    }
    #end

    public function update():Void {
        vertices = new SpoopyFloatBuffer(length);
        var __length:Int = 0;

        for(i in 0...__bucketSize) {
            var b = __vertexLayouts[i].buffer;

            outputBuffers.set(b, __length);
            __length += b.length;
        }
    }

    public function setVertexBuffer():Void {
        if(__device == null || vertices == null) {
            return;
        }

        //__device.setVertexBuffer(vertices, offset);
    }

    public function destroy():Void {
        if(__modelLayoutIndexes == null) {
            __modelLayoutIndexes.clear();
        }

        __modelLayoutIndexes = null;

        __device = null;
        vertices = null;
    }
}