package spoopy.backend.native;

class SpoopyNativeReader {
    public var handle:Dynamic;

    public function new(data:String, size:Int) {
        handle = SpoopyNativeCFFI.spoopy_create_memory_reader(data, size);
    }
}