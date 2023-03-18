package spoopy.rendering.interfaces;

interface ShaderReference {
    public var name(default, null):String;

    public function fragment_and_vertex(vertex:String, fragment:String):Void;
}