package spoopy.rendering;

import spoopy.graphics.other.SpoopySwapChain;
import spoopy.backend.native.SpoopyNativeShader;
import spoopy.rendering.interfaces.ShaderReference;
import spoopy.frontend.storage.SpoopyShaderStorage;

import lime.utils.Assets;
import lime.utils.Log;

class SpoopyShader {
    private static var cachedShader:Map<String, String> = new Map<String, String>();

    public var name(default, null):String;

    @:noCompletion private var shader:ShaderReference;
    @:noCompletion private var device:SpoopySwapChain;

    public function new() {
        /*
        * Empty.
        */
    }

    @:allow(spoopy.frontend.storage.SpoopyShaderStorage)
    private function bindDevice(device:SpoopySwapChain):Void {
        this.device = device;
    }

    public static function cacheShader(shader:String):Void {
        if(shader.substring(shader.length - 4, shader.length) != ".spv") {
            shader = shader + ".spv";
        }

        cachedShader.set(shader, getShaderSource(shader));
    }

    public static function releaseShader(shader:String):Void {
        if(shader.substring(shader.length - 4, shader.length) != ".spv") {
            shader = shader + ".spv";
        }else {
            Log.warn('The shader file "${shader}" was not found!');
        }

        cachedShader.remove(shader);
    }

    @:allow(spoopy.frontend.storage.SpoopyShaderStorage)
    private static function createShader(name:String, vertex:String, fragment:String, cache:Bool = false):Void {
        if(vertex.substring(vertex.length - 4, vertex.length) != ".spv") {
            vertex = vertex + ".spv";
        }

        if(fragment.substring(fragment.length - 4, fragment.length) != ".spv") {
            fragment = fragment + ".spv";
        }

        var rawVertex:String;
        var rawFragment:String;

        if(cachedShader.exists(vertex)) {
            rawVertex = cachedShader.get(vertex);
        }else {
            rawVertex = getShaderSource(vertex);

            if(cache) {
                cachedShader.set(vertex, rawVertex);
            }
        }

        if(cachedShader.exists(fragment)) {
            rawFragment = cachedShader.get(fragment);
        }else {
            rawFragment = getShaderSource(fragment);

            if(cache) {
                cachedShader.set(fragment, rawFragment);
            }
        }

        this.name = name;

        shader = new SpoopyNativeShader(name, device);
        shader.fragment_and_vertex(rawVertex, rawFragment);
    }

    private static function getShaderSource(shader:String):String {
        var rawShader:String;

        if(Assets.exists(shader)) {
            rawShader = Assets.getText(shader);
            return SpoopyNativeShader.decompileSPV(rawShader);
        }else {
            Log.warn('The shader file "${shader}" was not found!');
            return "";
        }
    }
}