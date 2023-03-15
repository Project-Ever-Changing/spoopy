package spoopy.rendering;

import spoopy.rendering.interfaces.ShaderReference;

class SpoopyShader {
    private var shaders:Map<String, ShaderReference>;

    public function new() {
        shaders = new Map<String, ShaderReference>();
    }

    private static function createShaders(name:String, vertex:String, fragment:String):Void {
        if(vertex.substring(vertex.length - 4, vertex.length) != ".spv") {
            vertex = vertex + ".spv";
        }

        if(fragment.substring(fragment.length - 4, fragment.length) != ".spv") {
            fragment = fragment + ".spv";
        }
    }
}