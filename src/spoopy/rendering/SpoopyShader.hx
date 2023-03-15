package spoopy.rendering;

import spoopy.rendering.interfaces.ShaderReference;

class SpoopyShader {
    private var shaders:Map<String, ShaderReference>;

    public function new() {
        shaders = new Map<String, ShaderReference>();
    }

    //public static function createShaders(name:String, vertex):Void {

    //}
}