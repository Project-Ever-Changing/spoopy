package spoopy.backend.native;

class SpoopyNativeReader {
    public var handle:Dynamic;

    public var data(get, never):String;
    public var position(get, never):Int;
    public var length(get, never):Int;

    public function new(data:String, length:Int) {
        handle = SpoopyNativeCFFI.spoopy_create_memory_reader(data, length);
    }

    @:noCompletion private function get_data():String {
        return SpoopyNativeCFFI.spoopy_get_memory_data(handle);
    }

    @:noCompletion private function get_position():Int {
        return SpoopyNativeCFFI.spoopy_get_memory_position(handle);
    }

    @:noCompletion private function get_length():Int {
        return SpoopyNativeCFFI.spoopy_get_memory_length(handle);
    }
}