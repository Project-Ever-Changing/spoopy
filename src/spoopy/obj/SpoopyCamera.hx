package spoopy.obj;

import lime.math.Matrix4;

import spoopy.graphics.SpoopyBuffer;
import spoopy.graphics.vertices.VertexBufferObject;
import spoopy.obj.s3d.SpoopyNode3D;
import spoopy.obj.display.SpoopyDisplayObject;
import spoopy.obj.prim.SpoopyPrimitive;
import spoopy.obj.geom.SpoopyPoint;
import spoopy.util.SpoopyFloatBuffer;
import spoopy.math.SpoopyPointMath;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;
#end

class SpoopyCamera implements SpoopyNode3D implements SpoopyDisplayObject {
    public var x(default, set):Float = 0;
    public var y(default, set):Float = 0;
    public var z(default, set):Float = 0;

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

    @:noCompletion var __vertexDirty:Bool;
    @:noCompletion var __vertices:VertexBufferObject;
    @:noCompletion var __position:SpoopyPoint;

    #if (spoopy_vulkan || spoopy_metal)
    @:allow(spoopy.frontend.storage.SpoopyCameraStorage) var device(default, set):SpoopySwapChain;
    #end

    public function new() {
        __position = new SpoopyPoint(x, y, z);
    }

    public function lookAt(targetPos:SpoopyPoint, up:SpoopyPoint):Void {
        var forward:SpoopyPoint = SpoopyPointMath.substract(targetPos - __position);
        forward.normalize();

        if(up == null) {
            up = new SpoopyPoint(0, 1, 0);
        }

        var right:SpoopyPoint = new SpoopyPoint(
            up.y * forwardPoint.z - up.z * forwardPoint.y,
            up.z * forwardPoint.x - up.x * forwardPoint.z,
            up.x * forwardPoint.y - up.y * forwardPoint.x
        );
        right.normalize();

        var upn:SpoopyPoint = new SpoopyPoint(
            forward.y * right.z - forward.z * right.y,
            forward.z * right.x - forward.x * right.z,
            forward.x * right.y - forward.y * right.x
        );

        var rawMatrix:Matrix4 = new Matrix4();

        //rawMatrix[0] = 
    }

    public function render():Void {
        if(__vertexDirty) {
            __vertices.create();
            __vertexDirty = false;
        }
    }

    public function update(elapsed:Float):Void {
        /*
        * Empty.
        */
    }

    @:allow(spoopy.obj.prim.SpoopyPrimitive) function storeBuffer(__vertices:SpoopyFloatBuffer, __lengthCache:Int) {
        for(camera in __cameras) {
            __vertexDirty = true;

            if(__vertices.length != __lengthCache) {
                __vertices.length -= __lengthCache;
                __vertices.length += __vertices.length;
            }

            #if (haxe >= "4.0.0")
            if(__vertices.buffers.contains(__vertices)) continue;
            #else
            if(__vertices.buffers.indexOf(__vertices) != -1) continue;
            #end

            __vertices.buffers.push(__vertices);
        }

        __vertices.update();
    }

    public function destroy():Void {
        this.__position.destroy();

        this.__verticesMap = null;
        this.__incidesMap = null;

        this.__position = null;
        this.__buffers = null;
    }

    public function rotate(point:SpoopyPoint, angle:Float):Void {
    }

    public function toString():String {
    }

    @:noCompletion function set_x(value:Float):Float {
        __position.x = value;
        return this.x = value;
    }

    @:noCompletion function set_y(value:Float):Float {
        __position.y = value;
        return this.y = value;
    }

    @:noCompletion function set_z(value:Float):Float {
        __position.z = value;
        return this.z = value;
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