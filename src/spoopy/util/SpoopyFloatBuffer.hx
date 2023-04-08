package spoopy.util;

import spoopy.obj.geom.SpoopyPoint;
import haxe.ds.ObjectMap;

#if (HXCPP_M64 || HXCPP_ARM64)
typedef SpoopyFloatBuffer = lime.utils.Float64Array;
#else
typedef SpoopyFloatBuffer = lime.utils.Float32Array;
#end