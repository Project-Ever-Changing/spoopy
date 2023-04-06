package spoopy.graphics;

@:enum abstract SpoopyBufferType(Int) from Int to Int {
    var VERTEX = 0x010;
    var INDEX = 0x020;
}