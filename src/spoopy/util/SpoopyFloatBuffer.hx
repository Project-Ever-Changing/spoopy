package spoopy.util;

import spoopy.obj.geom.SpoopyPoint;

#if HXCPP_M64
typedef FloatArray = lime.utils.Float64Array;
#else
typedef FloatArray = lime.utils.Float32Array;
#end

abstract SpoopyFloatBuffer(FloatArray) {
    public function new(points:Array<SpoopyPoint>) {
        var buffer = new Array<Float>();

        for(i in 0...points.length) {
            var p:SpoopyPoint = points[i];

            buffer.push(p.x);
            buffer.push(p.y);
            buffer.push(p.z);
        }

        this = new FloatArray(buffer);
    }
}