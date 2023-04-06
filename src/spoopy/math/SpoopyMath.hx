package spoopy.math;

import lime.math.Matrix3;
import lime.math.Matrix4;

/*
* A class that encompasses a collection of math functions.
*/

class SpoopyMath {
    /*
    * Used to convert radians to degrees.
    */
    public static var RADIANS_TO_DEGREES:Float = 180 / Math.PI;

    /*
    * Used to convert degrees to radians.
    */
    public static var DEGREES_TO_RADIANS:Float = Math.PI / 180;

    /*
    * Used for precision and tolerance level in comparisons involving floating point numbers.
    */
    public static inline var EPSILON:Float = 1e-10;

    /*
    * Caculate the linear interpolation between two numbers by the `ratio.`
    */
    public static inline function lerp(a:Float, b:Float, ratio:Float):Float {
        return a + ratio * (b - a);
    }

    /*
    * Normalize input between value the range of `a` and `b.`
    */
    public static inline function normalize(value:Float, a:Float, b:Float):Float {
        return (value - a) / (b - a);
    }

    /*
    * Remap a value from one range to another.
    */
    public static inline function remap(value:Float, inStart:Float, inEnd:Float, outStart:Float, outEnd:Float):Float {
        return (value - inStart) / (inEnd - inStart) * (outEnd - outStart) + outStart;
    }

    /*
    * Wrap a value from min to max.
    */
    public inline static function wrap(value:Float, min:Float, max:Float) {
		return value < min ? min : value > max ? max : value;
    }

    /*
    * Return the inverse squareroot of `value.`
    */
    public inline static function inverseSqrt(value:Float):Float {
        return 1 / Math.sqrt(value);
    }

    /*
    * Return a rounded value of 4 significant digits.
    */
    public static function fmt(v:Float) {
        var neg;

		if( v < 0 ) {
			neg = -1.0;
			v = -v;
		}else {
			neg = 1.0;
        }

		if(Math.isNaN(v) || !Math.isFinite(v)) {
			return v;
        }

		var digits = Std.int(4 - Math.log(v) / Math.log(10));

		if(digits < 1) {
			digits = 1;
        }else if(digits >= 10) {
			return 0;
        }

		var exp = Math.pow(10, digits);
		return Math.ffloor(v * exp + .49999) * neg / exp;
    }
}