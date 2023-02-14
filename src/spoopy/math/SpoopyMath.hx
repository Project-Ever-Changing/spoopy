package spoopy.math;

/*
* A class that encompasses a collection of math functions.
*/

class SpoopyMath {

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
}