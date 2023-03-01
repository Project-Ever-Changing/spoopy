package spoopy.obj;

import lime.math.Matrix4;

import spoopy.graphics.SpoopyBuffer;
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

    @:noCompletion var __verticesBuffer:SpoopyBuffer;
    @:noCompletion var __indicesBuffer:SpoopyBuffer;

    @:noCompletion var __position:SpoopyPoint;

    #if (spoopy_vulkan || spoopy_metal)
    @:allow(spoopy.frontend.storage.SpoopyCameraStorage) var __device:SpoopySwapChain;
    #end

    public function new() {
        __verticesBuffer = new SpoopyBuffer(null, 0);
        __indicesBuffer = new SpoopyBuffer(null, 0);

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
        /*
        * Empty.
        */
    }

    public function update(elapsed:Float):Void {
        /*
        * Empty.
        */
    }

    @:allow(spoopy.obj.prim.SpoopyPrimitive) function setVertices(obj:SpoopyPrimitive, buffers:Array<SpoopyPoint>):Void {
        
    }

    @:allow(spoopy.obj.prim.SpoopyPrimitive) function setIndices(obj:SpoopyPrimitive, buffers:Array<SpoopyPoint>):Void {
        
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

    public function destroy():Void {
        this.__verticesMap.clear();
        this.__incidesMap.clear();

        this.__verticesBuffer.destroy();
        this.__indicesBuffer.destroy();

        this.__position.destroy();

        this.__verticesBuffer = null;
        this.__indicesBuffer = null;

        this.__verticesMap = null;
        this.__incidesMap = null;

        this.__position = null;
    }

    public function rotate(point:SpoopyPoint, angle:Float):Void {
    }

    public function toString():String {
    }
}