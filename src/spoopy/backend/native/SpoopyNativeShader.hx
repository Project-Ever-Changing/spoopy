package spoopy.backend.native;

import spoopy.rendering.interfaces.ShaderReference;

class SpoopyNativeShader implements ShaderReference {
    public var handle:Dynamic;

    public function new() {

    }

    public function decompileSPV(shader:String):Void {
        #if spoopy_metal

        #end
    }
}