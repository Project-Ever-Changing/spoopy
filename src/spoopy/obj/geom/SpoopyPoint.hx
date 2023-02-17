package spoopy.obj.geom;

import spoopy.math.SpoopyMath;
import spoopy.obj.SpoopyObject;

import lime.math.Matrix4;
import lime.math.Matrix3;

class SpoopyPoint implements SpoopyObject {
    public var x:Float;
	public var y:Float;
	public var z:Float;

    public inline function new(x:Float = 0, y:Float = 0, z:Float = 0) {
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

    public inline function copy():SpoopyPoint {
        return new SpoopyPoint(x, y, z);
    }

    public inline function clear():Void {
        this.x = 0;
        this.y = 0;
        this.z = 0;
    }

    public function toString():String {
        return '{x: ${this.x} | y: ${this.y} | z: ${this.z}}';
    }
}