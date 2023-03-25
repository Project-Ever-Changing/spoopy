package spoopy.obj.geom;

import spoopy.math.SpoopyMath;
import spoopy.obj.SpoopyObject;
import spoopy.obj.data.SpoopyRotationMode;

import lime.math.Vector4;
import lime.math.Matrix4;
import lime.math.Matrix3;

class SpoopyPoint implements SpoopyObject {
    public var x:Float;
	public var y:Float;
	public var z:Float;

    public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
        set(x, y, z);
	}

    public inline function set(x:Float = 0, y:Float = 0, z:Float = 0):Void {
        this.x = x;
		this.y = y;
		this.z = z;
    }

    public inline function scale(size:Float):Void {
        x *= size;
        y *= size;
        z *= size;
    }

    public inline function normalize():Void {
        var value:Float = x * x + y * y + z * z;

        if(value < SpoopyMath.EPSILON) {
            value = 0;
        }else {
            value = SpoopyMath.inverseSqrt(value);
        }

        x *= value;
        y *= value;
        z *= value;
    }

    public inline function transform4x4(matrix:Matrix4):Void {
        var m11:Float = matrix[0];
        var m21:Float = matrix[4];
        var m31:Float = matrix[8];
        var m41:Float = matrix[12];
        var m12:Float = matrix[1];
        var m22:Float = matrix[5];
        var m32:Float = matrix[9];
        var m42:Float = matrix[13];
        var m13:Float = matrix[2];
        var m23:Float = matrix[6];
        var m33:Float = matrix[10];
        var m43:Float = matrix[14];
        var m14:Float = matrix[3];
        var m24:Float = matrix[7];
        var m34:Float = matrix[11];
        var m44:Float = matrix[15];

        var p_x:Float = x * m11 + y * m21 + z * m31 + m41;
        var p_y:Float = x * m12 + y * m22 + z * m32 + m42;
        var p_z:Float = x * m13 + y * m23 + z * m33 + m43;

        x = p_x;
        y = p_y;
        z = p_z;
    }

    public inline function transform(matrix:Matrix3):Void {
        var m11:Float = matrix.a;
        var m21:Float = matrix.b;
        var m31:Float = 0;
        var m12:Float = matrix.c;
        var m22:Float = matrix.d;
        var m32:Float = 0;
        var m13:Float = matrix.tx;
        var m23:Float = matrix.ty;
        var m33:Float = 1;

        var p_x:Float = x * m11 + y * m21 + z * m31;
        var p_y:Float = x * m12 + y * m22 + z * m32;
        var p_z:Float = x * m13 + y * m23 + z * m33;

        x = p_x;
        y = p_y;
        z = p_z;
    }

    public inline static function decomposeRotation3D(m:Matrix4, mode:SpoopyRotationMode = EULER):SpoopyPoint {
        var rot:Vector4 = new Vector4();

        switch(mode) {
            case SpoopyRotationMode.AXIS:
                rot.w = Math.acos((m[0] + m[5] + m[10] - 1) * 0.5);

                var length = Math.sqrt((m[6] - m[9]) * (m[6] - m[9]) + (m[8] - m[2]) * (m[8] - m[2]) + (m[1] - m[4]) * (m[1] - m[4]));

                if(length != 0) {
                    rot.x = (m[6] - m[9]) / length;
                    rot.y = (m[8] - m[2]) / length;
                    rot.z = (m[1] - m[4]) / length;
                }else {
                    rot.x = rot.y = rot.z = 0;
                }
            case SpoopyRotationMode.QUATERNION:
                var tr = m[0] + m[5] + m[10];

                if(tr > 0) {
                    rot.w = Math.sqrt(1 + tr) * 0.5;

                    rot.x = (m[6] - m[9]) / (4 * rot.w);
					rot.y = (m[8] - m[2]) / (4 * rot.w);
					rot.z = (m[1] - m[4]) / (4 * rot.w);
                }else if((m[0] > m[5]) && (m[0] > m[10])) {
                    rot.x = Math.sqrt(1 + m[0] - m[5] - m[10]) / 2;

					rot.w = (m[6] - m[9]) / (4 * rot.x);
					rot.y = (m[1] + m[4]) / (4 * rot.x);
					rot.z = (m[8] + m[2]) / (4 * rot.x);
                }else if(m[5] > m[10]) {
                    rot.y = Math.sqrt(1 + m[5] - m[0] - m[10]) * 0.5;

					rot.x = (m[1] + m[4]) / (4 * rot.y);
					rot.w = (m[8] - m[2]) / (4 * rot.y);
					rot.z = (m[6] + m[9]) / (4 * rot.y);
                }else {
                    rot.z = Math.sqrt(1 + m[10] - m[0] - m[5]) * 0.5;

					rot.x = (m[8] + m[2]) / (4 * rot.z);
					rot.y = (m[6] + m[9]) / (4 * rot.z);
					rot.w = (m[1] - m[4]) / (4 * rot.z);
                }
            case SpoopyRotationMode.EULER:
                rot.y = Math.asin(-m[2]);

                if(m[2] != 1 && m[2] != -1) {
                    rot.x = Math.atan2(m[6], m[10]);
					rot.z = Math.atan2(m[1], m[0]);
                }else {
                    rot.z = 0;
					rot.x = Math.atan2(m[4], m[5]);
                }
        }

        return new SpoopyPoint(rot.x, rot.y, rot.z);
    }

    public inline function copy():SpoopyPoint {
        return new SpoopyPoint(x, y, z);
    }

    public inline function toVec4():Vector4 {
        return new Vector4(x, y, z);
    }

    public inline function destroy():Void {
        this.x = 0;
        this.y = 0;
        this.z = 0;
    }

    public function toString():String {
        return '{x: ${this.x} | y: ${this.y} | z: ${this.z}}';
    }
}