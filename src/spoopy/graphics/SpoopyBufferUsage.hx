package spoopy.graphics;

@:enum abstract SpoopyBufferUsage(Int) from Int to Int {
    var STATIC = 0x0010;
    var DYNAMIC = 0x0020;
}