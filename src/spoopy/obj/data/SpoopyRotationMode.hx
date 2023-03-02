package spoopy.obj.data;

#if (haxe >= "4.0.0")
enum SpoopyRotationMode {
    EULER;
    QUATERNION;
    AXIS;
}
#else
@:enum abstract SpoopyRotationMode(UInt) {
    var EULER = 0;
    var QUATERNION = 1;
    var AXIS = 2;
}
#end