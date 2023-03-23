package spoopy.backend.native;

import lime.utils.Log;

import spoopy.app.SpoopyApplication;
import spoopy.rendering.interfaces.ShaderReference;
import spoopy.rendering.interfaces.ShaderType;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;

@:access(spoopy.graphics.other.SpoopySwapChain)
#end
class SpoopyNativeShader implements ShaderReference {
    private var shaders:Map<ShaderType, String>;

    private var pipeline:Dynamic;
    private var descriptor:Dynamic;

    public var handle:Dynamic;

    public var name(default, null):String;

    public function new(name:String, device:SpoopySwapChain) {
        this.name = name;

        shaders = new Map<ShaderType, String>();

        #if (spoopy_vulkan || spoopy_metal)
        handle = SpoopyNativeCFFI.spoopy_create_shader(device.__surface.handle, device.__surface.device);
        #end
    }

    public function fragment_and_vertex(vertex:String, fragment:String):Void {
        shaders.set(VERTEX_SHADER, vertex);
        shaders.set(FRAGMENT_SHADER, fragment);

        var timer = SpoopyApplication.getTimer();

        createProgram();

        #if spoopy_debug
        Log.info("Shader creation took " + (SpoopyApplication.getTimer() - timer) + "ms");
        #end
    }

    private function createProgram():Void {
        SpoopyNativeCFFI.spoopy_specialize_shader(handle, name, shaders[VERTEX_SHADER], shaders[FRAGMENT_SHADER]);

        var program = SpoopyNativeCFFI.spoopy_create_shader_pipeline(handle);
        SpoopyNativeCFFI.spoopy_cleanup_shader(handle);

        pipeline = program;
    }

    public static function decompileSPV(shader:String):String {
        #if spoopy_metal
        return SpoopyNativeCFFI.spoopy_spv_to_metal_shader(shader);
        #end

        return shader;
    }
}