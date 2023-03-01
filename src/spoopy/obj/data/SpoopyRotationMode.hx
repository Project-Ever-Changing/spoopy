package spoopy.obj.data;

#if (haxe >= "4.0.0")
enum SpoopyRotationMode {
    EULAR;
    QUATERNION;
    BASIS;
}
#else
@:enum abstract SpoopyRotationMode(UInt) {
    var EULAR = 0;
    var QUATERNION = 1;
    var BASIS = 2;
}
#end