package spoopy.obj;

import spoopy.graphics.SpoopyBuffer;
import spoopy.obj.display.SpoopyNode3D;
import spoopy.obj.display.SpoopyDisplayObject;
import spoopy.obj.prim.SpoopyPrimitive;
import spoopy.obj.geom.SpoopyPoint;
import spoopy.graphics.SpoopyBuffer;
import spoopy.util.SpoopyFloatBuffer;
import haxe.ds.ObjectMap;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;
#end

class SpoopyCamera implements SpoopyNode3D implements SpoopyDisplayObject {
    /*
    * If `update()` is automatically called;
    */
    public var active(default, set):Bool = true;

    /*
    * If `render()` is automatically called.
    */
    public var visible(default, set):Bool = true;

    /*
    * Whether `update()` and `render()` are automatically called.
    */
    public var inScene(default, set):Bool = true;


    @:noCompletion var __verticesMap:ObjectMap<SpoopyPrimitive, Array<SpoopyPoint>>;
    @:noCompletion var __incidesMap:ObjectMap<SpoopyPrimitive, Array<SpoopyPoint>>;

    @:noCompletion var __verticesBuffer:SpoopyBuffer;
    @:noCompletion var __indicesBuffer:SpoopyBuffer;

    #if (spoopy_vulkan || spoopy_metal)
    @:allow(spoopy.backend.storage.SpoopyCameraStorage) var __device:SpoopySwapChain;
    #end

    public function new() {
        __verticesMap = new ObjectMap();
        __incidesMap = new ObjectMap();

        __verticesBuffer = new SpoopyBuffer(null, 0);
        __indicesBuffer = new SpoopyBuffer(null, 0);
    }

    public function render():Void {
        if(visible && inScene) {
            
        }
    }

    @:allow(spoopy.obj.prim.SpoopyPrimitive) function setVertices(obj:SpoopyPrimitive, buffers:Array<SpoopyPoint>):Void {
        var fb:SpoopyFloatBuffer = SpoopyFloatBuffer.fromObjectMap(__verticesMap);

        __verticesMap.set(obj, buffers);
        __verticesBuffer.updateBuffers(fb, fb.length);
    }

    @:allow(spoopy.obj.prim.SpoopyPrimitive) function setIndices(obj:SpoopyPrimitive, buffers:Array<SpoopyPoint>):Void {
        var fb:SpoopyFloatBuffer = SpoopyFloatBuffer.fromObjectMap(__incidesMap);

        __incidesMap.set(obj, buffers);
        __indicesBuffer.updateBuffers(fb, fb.length);
    }

    @:noCompletion function set_active(value:Bool):Bool {
        return active = value;
    }

    @:noCompletion function set_visible(value:Bool):Bool {
        return visible = value;
    }

    @:noCompletion function set_inScene(value:Bool):Bool {
        return inScene = value;
    }

    public function clear():Void {
        this.__verticesMap.clear();
        this.__incidesMap.clear();

        __verticesBuffer.clear();
        __indicesBuffer.clear();

        __verticesBuffer = null;
        __indicesBuffer = null;

        this.__verticesMap = null;
        this.__incidesMap = null;
    }
}