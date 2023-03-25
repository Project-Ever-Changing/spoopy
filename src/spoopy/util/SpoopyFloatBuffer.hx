package spoopy.util;

import spoopy.obj.geom.SpoopyPoint;
import haxe.ds.ObjectMap;

#if (HXCPP_M64 || HXCPP_ARM64)
typedef FloatArray = lime.utils.Float64Array;
#else
typedef FloatArray = lime.utils.Float32Array;
#end

@:transitive
@:forward
abstract SpoopyFloatBuffer(FloatArray) from FloatArray to FloatArray {
    public inline function new<T>(?elements:Int, ?array:Array<T>) {
        this = new FloatArray(elements, array);
    }
}