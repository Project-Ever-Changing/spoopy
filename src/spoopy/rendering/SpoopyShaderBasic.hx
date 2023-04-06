package spoopy.rendering;

import spoopy.graphics.other.SpoopySwapChain;
import spoopy.frontend.storage.SpoopyShaderStorage;
import spoopy.rendering.interfaces.ShaderType;

class SpoopyShaderBasic {
    public var name(default, null):String;
    public var parent(default, null):SpoopyShaderStorage;

    private var __device:SpoopySwapChain;

    public function new() {
        /*
        * Empty.
        */
    }

    public function bind():Void {
        /*
        *  This is a stub for the shader binding.
        */
    }

    public function unbind():Void {
        __device.useShaderProgram(null);
    }

    @:allow(spoopy.frontend.storage.SpoopyShaderStorage)
    private function assignParent(parent:SpoopyShaderStorage):Void {
        this.parent = parent;
    }

    @:allow(spoopy.frontend.storage.SpoopyShaderStorage)
    private function assignName(name:String):Void {
        this.name = name;
    }

    @:allow(spoopy.frontend.storage.SpoopyShaderStorage)
    private function assignDevice(device:SpoopySwapChain):Void {
        this.__device = device;
    }

    public function toString():String {
        return name;
    }

    public function destroy():Void {
        parent = null;
        name = null;

        __device = null;
    }
}