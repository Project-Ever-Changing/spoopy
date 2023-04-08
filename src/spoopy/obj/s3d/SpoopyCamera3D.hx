package spoopy.obj.s3d;

import spoopy.rendering.command.*;

import spoopy.obj.SpoopyCamera;
import spoopy.obj.data.SpoopyRotationMode;
import spoopy.obj.s3d.SpoopyNode3D;
import spoopy.obj.geom.SpoopyPoint;
import spoopy.rendering.command.SpoopyCommand;
import spoopy.rendering.SpoopyDrawType;
import spoopy.math.SpoopyMath;
import spoopy.math.SpoopyPointMath;

import lime.math.Matrix4;

class SpoopyCamera3D extends SpoopyCamera implements SpoopyNode3D {
    public var x(default, set):Float = 0;
    public var y(default, set):Float = 0;
    public var z(default, set):Float = 0;

    public var angleX(default, set):Float = 0;
    public var angleY(default, set):Float = 0;
    public var angleZ(default, set):Float = 0;

    /*
    * The `axis` is used for 3D transformations to represent the axis of rotation for an object.
    */
    public var axis(default, set):SpoopyRotationMode = EULER;

    /*
    * `transform` handles translation, rotation, scaling, and perspective.
    */
    public var transform(default, null):Matrix4;

    /*
    * `view` handles the camera's position and rotation.
    */
    public var view(get, never):Matrix4;

    @:noCompletion private var __view:Matrix4;
    @:noCompletion private var __position:SpoopyPoint;
    @:noCompletion private var __rotation:SpoopyPoint;

    public function new() {
        super();

        __position = new SpoopyPoint(x, y, z);
        __rotation = new SpoopyPoint(angleX, angleY, angleZ);

        transform = new Matrix4();
        transform.identity();
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

    public function lookAt(targetPos:SpoopyPoint, up:SpoopyPoint):Void {
        var forward:SpoopyPoint = SpoopyPointMath.subtract(targetPos, __position);
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

        transform = rawMatrix;

        rotate(new SpoopyPoint(1, 0, 0), Math.atan2(right.z, right.x) * SpoopyMath.RADIANS_TO_DEGREES);
        rotate(new SpoopyPoint(0, 1, 0), Math.asin(right.y) * SpoopyMath.RADIANS_TO_DEGREES);
        rotate(new SpoopyPoint(0, 0, 1), Math.atan2(-forward.x, forward.z) * SpoopyMath.RADIANS_TO_DEGREES);

        if(forward.z < 0) {
            angleX -= 180;
            angleY = 180 - angleY;
            angleZ -= 180;
        }
    }

    public override function getFlags():UInt {
        var flags:UInt = super.getFlags();
        flags |= SpoopyRenderFlag.RENDER_AS_3D;
        return flags;
    }

    public override function getDepthInView():Float {
        var depth:Float = -(view[2] * transform[12] + view[6] * transform[13] + view[10] * transform[14] + view[14]);
        return depth;
    }

    public override function destroy():Void {
        super.destroy();

        this.__position.destroy();
        this.__rotation.destroy();

        this.__position = null;
        this.__rotation = null;

        this.__view = null;
        this.transform = null;
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

    @:noCompletion function set_axis(value:SpoopyRotationMode):SpoopyRotationMode {
        axis = value;

        rotate(new SpoopyPoint(1, 0, 0), angleX);
        rotate(new SpoopyPoint(0, 1, 0), angleY);
        rotate(new SpoopyPoint(0, 0, 1), angleZ);

        return axis;
    }

    @:noCompletion function get_view():Matrix4 {
        return __view;
    }
}