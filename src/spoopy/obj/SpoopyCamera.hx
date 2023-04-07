package spoopy.obj;

import spoopy.graphics.SpoopyBufferType;
import spoopy.graphics.manager.TriangleBufferManager;
import spoopy.graphics.vertices.VertexBufferObject;
import spoopy.rendering.command.SpoopyCommand;
import spoopy.rendering.SpoopyDrawType;
import spoopy.obj.display.SpoopyDisplayObject;
import spoopy.obj.prim.SpoopyPrimitive;
import spoopy.util.SpoopyFloatBuffer;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;
#end

class SpoopyCamera implements SpoopyDisplayObject {

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

    @:noCompletion var __command:SpoopyCommand;

    @:noCompletion var __triangleBuffers:TriangleBufferManager;
    @:noCompletion var __vertices:VertexBufferObject;
    @:noCompletion var __vertexDirty:Bool;

    #if (spoopy_vulkan || spoopy_metal)
    @:allow(spoopy.frontend.storage.SpoopyCameraStorage) var device(default, set):SpoopySwapChain;
    #end

    public function new() {
        __triangleBuffers = new TriangleBufferManager();
        __vertices = new VertexBufferObject();
        __command = new SpoopyCommand(this, getCommandType());
    }

    public function getCommandType():SpoopyCommandType {
        return SpoopyCommandType.UNKNOWN_COMMAND;
    }

    public function getFlags():UInt {
        return 0;
    }

    public function getDepthInView():Float {
        return 0;
    }

    public function render():Void {
        if(__vertexDirty) {
            __vertices.update();
            var verticeBuffer = __vertices.vertices;
            
            __triangleBuffers.createBuffer(verticeBuffer, verticeBuffer.byteLength, VERTEX);
            __vertexDirty = false;
        }
    }

    public function update(elapsed:Float):Void {
        /*
        * Empty.
        */
    }

    @:allow(spoopy.obj.prim.SpoopyPrimitive) function removeBuffer(__vertices:SpoopyFloatBuffer):Void {
        __vertexDirty = true;
        this.__vertices.removeObject(__vertices);
    }

    @:allow(spoopy.obj.prim.SpoopyPrimitive) function storeBuffer(__vertices:SpoopyFloatBuffer):Void {
        __vertexDirty = true;
        this.__vertices.addObject(__vertices);
    }

    public function destroy():Void {
        this.__vertices.destroy();
        this.__vertices = null;
    }

    public function toString():String {
        return Type.getClassName(Type.getClass(this)).split(".").pop();
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

    #if (spoopy_vulkan || spoopy_metal)
    @:noCompletion function set_device(value:SpoopySwapChain):SpoopySwapChain {
        __vertices.bindToDevice(value);
        return device = value;
    }
    #end
}