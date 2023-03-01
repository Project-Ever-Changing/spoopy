package spoopy.util;

import spoopy.obj.geom.SpoopyPoint;

import haxe.ds.ObjectMap;
import ds.HashSet;

#if HXCPP_M64
typedef FloatArray = lime.utils.Float64Array;
#else
typedef FloatArray = lime.utils.Float32Array;
#end

abstract SpoopyFloatBuffer(FloatArray) {
    private function new(b:Array<Int>) {
        this = new FloatArray(b);
    }

    public static inline function fromArray(points:Array<SpoopyPoint>):SpoopyFloatBuffer {
        var buffer = new Array<Int>();

        for(i in 0...points.length) {
            var p:SpoopyPoint = points[i];

            buffer.push(Std.int(p.x));
            buffer.push(Std.int(p.y));
            buffer.push(Std.int(p.z));
        }

        return new SpoopyFloatBuffer(buffer);
    }

    public static inline function fromObjectMap<T:{}>(map:ObjectMap<T, Array<SpoopyPoint>>):SpoopyFloatBuffer {
        var values:HashSet<SpoopyPoint> = new HashSet<SpoopyPoint>();
        var buffer = new Array<Int>();

        for (value in map.keys()) {
            for (item in map.get(value)) {
                values.set(Std.int(item.x));
                values.set(Std.int(item.y));
                values.set(Std.int(item.z));
            }
        }

        buffer = values.toArray();

        return new SpoopyFloatBuffer(buffer);
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