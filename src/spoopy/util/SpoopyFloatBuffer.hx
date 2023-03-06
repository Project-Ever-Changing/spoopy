package spoopy.util;

import spoopy.obj.geom.SpoopyPoint;
import haxe.ds.ObjectMap;

#if (HXCPP_M64 || HXCPP_M32)
typedef FloatArray = lime.utils.Float64Array;
#else
typedef FloatArray = lime.utils.Float32Array;
#end

abstract SpoopyFloatBuffer(FloatArray) to FloatArray {
    private function new(?b:Array<Int> = null) {
        this = new FloatArray(b);
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