package spoopy.ui;

#if (haxe >= "4.0.0")
enum SpoopyMouseMode {
    MOUSE;
    MIDDLE_MOUSE;
    RIGHT_MOUSE;
}
#else
@:enum
abstract SpoopyMouseMode(Int) {
    var MOUSE:Int = 0;
    var MIDDLE_MOUSE:Int = 1;
    var RIGHT_MOUSE:Int = 2;
}
#end