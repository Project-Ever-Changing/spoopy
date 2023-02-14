package spoopy.ui;

#if (haxe >= "4.0.0")
enum SpoopyKeyMode {
    KEY_DOWN;
    KEY_UP;
}
#else
@:enum
abstract SpoopyKeyMode(Bool) {
    var KEY_DOWN:Bool = true;
    var KEY_UP:Bool = false;
}
#end