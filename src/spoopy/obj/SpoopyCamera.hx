package spoopy.obj;

import lime.math.Matrix4;

import spoopy.graphics.vertices.VertexBufferObject;
import spoopy.obj.s3d.SpoopyNode3D;
import spoopy.obj.display.SpoopyDisplayObject;
import spoopy.obj.data.SpoopyRotationMode;
import spoopy.obj.prim.SpoopyPrimitive;
import spoopy.obj.geom.SpoopyPoint;
import spoopy.util.SpoopyFloatBuffer;
import spoopy.math.SpoopyMath;
import spoopy.math.SpoopyPointMath;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;
#end

class SpoopyCamera implements SpoopyNode3D implements SpoopyDisplayObject {
    public var x(default, set):Float = 0;
    public var y(default, set):Float = 0;
    public var z(default, set):Float = 0;

    public var angleX(default, set):Float = 0;
    public var angleY(default, set):Float = 0;
    public var angleZ(default, set):Float = 0;

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
    
    /*
    * `transform` handles translation, rotation, scaling, and perspective.
    */
    public var transform(default, null):Matrix4;

    /*
    * The `axis` is used for 3D transformations to represent the axis of rotation for an object.
    */
    public var axis(default, set):SpoopyRotationMode = EULAR;

    @:noCompletion var __vertices:VertexBufferObject;
    @:noCompletion var __position:SpoopyPoint;
    @:noCompletion var __rotation:SpoopyPoint;
    @:noCompletion var __vertexDirty:Bool;

    #if (spoopy_vulkan || spoopy_metal)
    @:allow(spoopy.frontend.storage.SpoopyCameraStorage) var device(default, set):SpoopySwapChain;
    #end

    public function new() {
        __vertices = new VertexBufferObject();
        __position = new SpoopyPoint(x, y, z);
        __rotation = new SpoopyPoint(angleX, angleY, angleZ);
        __transform = new Matrix4();

        transform.identity();
    }

    public function lookAt(targetPos:SpoopyPoint, up:SpoopyPoint):Void {
        var forward:SpoopyPoint = SpoopyPointMath.substract(targetPos - __position);
        forward.normalize();

        if(up == null) {
            up = new SpoopyPoint(0, 1, 0);
        }

        var right:SpoopyPoint = new SpoopyPoint(
            up.y * forward.z - up.z * forward.y,
            up.z * forward.x - up.x * forward.z,
            up.x * forward.y - up.y * forward.x
        );
        right.normalize();

        var upn:SpoopyPoint = new SpoopyPoint(
            forward.y * right.z - forward.z * right.y,
            forward.z * right.x - forward.x * right.z,
            forward.x * right.y - forward.y * right.x
        );

        var rawMatrix:Matrix4 = new Matrix4();

        rawMatrix[0] = right.x;
        rawMatrix[1] = right.y;
        rawMatrix[2] = right.z;
        rawMatrix[3] = 0;

        rawMatrix[4] = upn.x;
        rawMatrix[5] = upn.y;
        rawMatrix[6] = upn.z;
        rawMatrix[7] = 0;

        rawMatrix[8] = forward.x;
        rawMatrix[9] = forward.y;
        rawMatrix[10] = forward.z;
        rawMatrix[11] = 0;

        rawMatrix[12] = __position.x;
        rawMatrix[13] = __position.y;
        rawMatrix[14] = __position.z;
        rawMatrix[15] = 1;

        transform.copy(rawMatrix);

        rotate(new SpoopyPoint(1, 0, 0), Math.atan2(right.z, right.x) * SpoopyMath.RADIANS_TO_DEGREES);
        rotate(new SpoopyPoint(0, 1, 0), Math.asin(right.y) * SpoopyMath.RADIANS_TO_DEGREES);
        rotate(new SpoopyPoint(0, 0, 1), Math.atan2(-forward.x, forward.z) * SpoopyMath.RADIANS_TO_DEGREES);

        if(forward < 0) {
            angleX -= 180;
            angleY = 180 - angleY;
            angleZ -= 180;
        }
    }

    public function render():Void {
        if(__vertexDirty) {
            __vertices.update();
            __vertices.create();

            __vertexDirty = false;
        }

        __vertices.setVertexBuffer();
    }

    public function update(elapsed:Float):Void {
        /*
        * Empty.
        */
    }

    @:allow(spoopy.obj.prim.SpoopyPrimitive) function removeBuffer(__vertices:SpoopyFloatBuffer) {
        __vertexDirty = true;

        __vertices.buffers.remove(__vertices);
        __vertices.length -= __vertices.length;
    }

    @:allow(spoopy.obj.prim.SpoopyPrimitive) function storeBuffer(__vertices:SpoopyFloatBuffer) {
        __vertexDirty = true;

        __vertices.buffers.push(__vertices);
        __vertices.length += __vertices.length;
    }

    public function destroy():Void {
        this.__position.destroy();

        this.__verticesMap = null;
        this.__incidesMap = null;

        this.__position = null;
        this.__buffers = null;
    }

    public function rotate(point:SpoopyPoint, angle:Float):Void {
        if(__rotation == null) {
            return;
        }

        var mr:Matrix4 = new Matrix4();
        mr.prependRotation(angle, point.toVec4());

        var p:SpoopyPoint = SpoopyPoint.decomposeRotation3D(mr, axis);

        angleX = p.x * SpoopyMath.RADIANS_TO_DEGREES;
        angleY = p.y * SpoopyMath.RADIANS_TO_DEGREES;
        angleZ = p.z * SpoopyMath.RADIANS_TO_DEGREES;
    }

    public function toString():String {
        return Type.getClassName(Type.getClass(this)).split(".").pop();
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

    @:noCompletion function set_angleX(value:Float):Float {
        __rotation.x = value;
        return this.angleX = value;
    }

    @:noCompletion function set_angleY(value:Float):Float {
        __rotation.y = value;
        return this.angleY = value;
    }

    @:noCompletion function set_angleZ(value:Float):Float {
        __rotation.z = value;
        return this.angleZ = value;
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

    @:noCompletion function set_axis(value:SpoopyRotationMode):SpoopyRotationMode {
        axis = value;

        rotate(new SpoopyPoint(1, 0, 0), angleX);
        rotate(new SpoopyPoint(0, 1, 0), angleY);
        rotate(new SpoopyPoint(0, 0, 1), angleZ);

        return axis;
    }

    #if (spoopy_vulkan || spoopy_metal)
    @:noCompletion function set_device(value:SpoopySwapChain):SpoopySwapChain {
        __vertices.bindToDevice(value);
        return device = value;
    }
    #end
}