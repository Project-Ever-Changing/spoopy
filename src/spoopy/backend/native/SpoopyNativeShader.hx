package spoopy.backend.native;

import spoopy.rendering.interfaces.ShaderReference;
import spoopy.rendering.interfaces.ShaderType;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;

@:access(spoopy.graphics.other.SpoopySwapChain)
#end
class SpoopyNativeShader implements ShaderReference {
    private var shaders:Map<ShaderType, String>;

    #if spoopy_metal
    private var pipeline:Dynamic;
    private var descriptor:Dynamic;
    #end

    public var handle:Dynamic;

    public function new(device:SpoopySwapChain) {
        shaders = new Map<ShaderType, String>();

        #if (spoopy_vulkan || spoopy_metal)
        handle = SpoopyNativeCFFI.spoopy_create_shader(device.__surface.handle, device.__surface.device);
        #end
    }

    public function fragment_and_vertex(vertex:String, fragment:String):Void {
        shaders.set(VERTEX_SHADER, vertex);
        shaders.set(FRAGMENT_SHADER, fragment);
    }

    private function createProgram():Void {

        
        #if (spoopy_vulkan || spoopy_metal)
        SpoopyNativeCFFI.spoopy_apply_shaders();
        #end
    }

    public static function decompileSPV(shader:String):String {
        #if spoopy_metal
        return SpoopyNativeCFFI.spoopy_spv_to_metal_shader(shader);
        #end

        return shader;
    }
}