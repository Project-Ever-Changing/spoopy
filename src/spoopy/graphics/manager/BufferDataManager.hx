package spoopy.graphics.manager;

import spoopy.obj.SpoopyObject;
import spoopy.app.SpoopyApplication;
import spoopy.util.SpoopyFloatBuffer;
import spoopy.obj.prim.SpoopyPrimitive;
import spoopy.graphics.SpoopyBufferLayout;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;
#end

import haxe.ds.ObjectMap;

/*
* Base helper class for managing buffer data.
*/
class BufferDataManager implements SpoopyObject {
    public var bufferData(default, null):SpoopyFloatBuffer = null;

    public var offset(default, null):Int = 0;
    public var length(default, null):Int = 0;

    @:noCompletion var __layoutIndex:Int = 0;
    @:noCompletion var __bucketSize:Int = 0;

    @:noCompletion var __modelLayoutIndexes:ObjectMap<SpoopyFloatBuffer, Int>;
    @:noCompletion var __layouts:Array<SpoopyBufferLayout>;

    #if (spoopy_vulkan || spoopy_metal)
    @:noCompletion var __device:SpoopySwapChain;
    #end

    public function new() {
        __bucketSize = SpoopyApplication.SPOOPY_CONFIG_MAX_LAYOUTS;
        __modelLayoutIndexes = new ObjectMap<SpoopyFloatBuffer, Int>();
        __layouts = [];

        for(i in 0...__bucketSize) {
            __layouts[i] = new SpoopyBufferLayout();
        }

        bufferData = new SpoopyFloatBuffer(length);
    }

    public function addObject(obj:SpoopyFloatBuffer):Void {
        __layouts[__layoutIndex].addBuffer(obj);
        __layoutIndex = (__layoutIndex + 1) % __bucketSize;
        __modelLayoutIndexes.set(obj, __layoutIndex);

        length += obj.length;
    }

    public function removeObject(obj:SpoopyFloatBuffer):Void {
        __layouts[__modelLayoutIndexes.get(obj)].removeBuffer(obj);
        length -= obj.length;
    }

    #if (spoopy_vulkan || spoopy_metal)
    public function bindToDevice(device:SpoopySwapChain):Void {
        __device = device;
    }
    #end

    public function update():Void {
        bufferData = new SpoopyFloatBuffer(length);
        var __length:Int = 0;

        for(i in 0...__bucketSize) {
            var b = __layouts[i].buffer;

            bufferData.set(b, __length);
            __length += b.length;
        }
    }

    public function destroy():Void {
        if(__modelLayoutIndexes == null) {
            __modelLayoutIndexes.clear();
        }

        __modelLayoutIndexes = null;

        __device = null;
        bufferData = null;
    }
}