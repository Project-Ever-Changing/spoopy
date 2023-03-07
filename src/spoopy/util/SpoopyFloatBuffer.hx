package spoopy.util;

import spoopy.obj.geom.SpoopyPoint;
import haxe.ds.ObjectMap;

#if (HXCPP_M64 || HXCPP_ARM64)
typedef FloatArray = lime.utils.Float64Array;
#else
typedef FloatArray = lime.utils.Float32Array;
#end

#if (HXCPP_M64 || HXCPP_ARM64)
private typedef FloatData = Array<cpp.Float64>;
#elseif (HXCPP_M64 || HXCPP_ARM64)
private typedef FloatData = Array<cpp.Float32>;
#else
private typedef FloatData = Array<Float>;
#end

@:transitive
@:forward
abstract SpoopyFloatBuffer(FloatArray) from FloatArray to FloatArray {
    public inline function new<T>(?elements:Int, ?array:Array<T>) {
        this = new FloatArray(elements, array);
    }

    public static function equals(a1:FloatArray, a2:FloatArray):Bool {
        if (a1.length != a2.length) {
            return false;
        }

        var length = a1.length;
        var half = Std.int(length * 0.5);

        for(i in 0...half) {
            var j = a1.length - i;

            if (a1[i] != a2[i] || a1[j] != a2[j]) {
                return false;
            }
        }

        return true;
    }
}

@:transitive
@:forward
abstract SpoopyFloatData(FloatData) from FloatData to FloatData {
    /*
    * Empty.
    */
}