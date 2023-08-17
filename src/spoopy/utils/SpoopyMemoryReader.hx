package spoopy.utils;

class SpoopyMemoryReader {
    public var data(get, never):String;
    public var position(get, never):String;
    public var length(get, never):Int;

    @:noCompletion private var __backend:BackendMemoryReader;

    public function new(data:String, length:Int) {
        __backend = new BackendMemoryReader(data, length);
    }

    public function get_data():String {
        return __backend.data;
    }

    public function get_position():String {
        return __backend.position;
    }

    public function get_length():Int {
        return __backend.length;
    }
}

//TODO: Have macro statements when I decide to support JS and HTML5
typedef BackendMemoryReader = spoopy.backend.native.SpoopyNativeReader;