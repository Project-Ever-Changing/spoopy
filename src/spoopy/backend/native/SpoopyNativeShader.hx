package spoopy.backend.native;

import spoopy.rendering.interfaces.ShaderReference;
import spoopy.rendering.interfaces.ShaderType;

class SpoopyNativeShader implements ShaderReference {
    private var shaders:Map<ShaderType, String>;

    #if spoopy_metal
    private var pipeline:Dynamic;
    private var descriptor:Dynamic;
    #end

    public function new() {
        shaders = new Map<ShaderType, String>();
    }

    public function fragment_and_vertex(vertex:String, fragment:String):Void {
        shaders.set(VERTEX_SHADER, vertex);
        shaders.set(FRAGMENT_SHADER, fragment);
    }

    private function createProgram():Void {

    }

    public static function decompileSPV(shader:String):String {
        #if spoopy_metal
        return SpoopyNativeCFFI.spoopy_spv_to_metal_shader(shader);
        #end

        return shader;
    }
}