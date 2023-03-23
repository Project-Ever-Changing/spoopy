package spoopy.backend.native.metal;

import spoopy.app.SpoopyApplication;
import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.backend.native.SpoopyNativeShader;

import lime.utils.DataPointer;

class SpoopyUniformMetal {
    public var handle:Dynamic;

    public function new(surface:SpoopyNativeSurface, size:Int) {
        handle = SpoopyNativeCFFI.spoopy_create_metal_buffer_length(surface.device, size, 0);
    }

    public function setShaderUniform(shader:SpoopyNativeShader, offset:Int, loc:Int, val:DataPointer, numRegs:Int):Void {
        SpoopyNativeCFFI.spoopy_set_shader_uniform(handle, shader.handle, offset, loc, val, numRegs);
    }
}