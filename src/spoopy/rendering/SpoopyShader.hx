package spoopy.rendering;

import spoopy.graphics.other.SpoopySwapChain;
import spoopy.graphics.uniforms.SpoopyUniformBuffer;
import spoopy.backend.native.SpoopyNativeShader;
import spoopy.rendering.interfaces.ShaderReference;
import spoopy.frontend.storage.SpoopyShaderStorage;
import spoopy.obj.geom.SpoopyPoint;

import lime.math.Matrix4;
import lime.math.Vector4;
import lime.math.Vector2;

import lime.utils.Float32Array;
import lime.utils.DataPointer;
import lime.utils.Assets;
import lime.utils.Log;

@:access(spoopy.graphics.other.SpoopySwapChain)
class SpoopyShader {
    private static var cachedShader:Map<String, String> = new Map<String, String>();

    public var name(default, null):String;

    @:noCompletion private var __shader:SpoopyNativeShader;
    @:noCompletion private var __uniform:SpoopyUniformBuffer;
    @:noCompletion private var __device:SpoopySwapChain;

    public function new() {
        /*
        * Empty.
        */
    }

    public function bind():Void {
        __uniform.apply();
        __device.useShaderProgram(__shader);
    }

    public function unbind():Void {
        __device.useShaderProgram(null);
    }

    public function setInt(name:String, value:Int):Void {
        __uniform.setShaderUniform(this, name, DataPointer.fromInt(value), 2);
    }

    public function setIntArray(name:String, value:Array<Int>):Void {
        var data32:Float32Array = new Float32Array(value);
        __uniform.setShaderUniform(this, name, data32, Math.ceil(data32.byteLength * 0.0625));
    }

    public function setFloat(name:String, value:Float):Void {
        __uniform.setShaderUniform(this, name, DataPointer.fromFloat(value), 1);
    }

    public function setVector2(name:String, value:Vector2):Void {
        var data32:Float32Array = new Float32Array([value.x, value.y]);
        __uniform.setShaderUniform(this, name, data32, Math.ceil(data32.byteLength * 0.0625));
    }

    public function setVector3(name:String, value:SpoopyPoint):Void {
        var data32:Float32Array = new Float32Array([value.x, value.y, value.z]);
        __uniform.setShaderUniform(this, name, data32, Math.ceil(data32.byteLength * 0.0625));
    }

    public function setVector4(name:String, value:Vector4):Void {
        var data32:Float32Array = new Float32Array([value.x, value.y, value.z, value.w]);
        __uniform.setShaderUniform(this, name, data32, Math.ceil(data32.byteLength * 0.0625));
    }

    public function setMatrix4x4(name:String, value:Matrix4):Void {
        __uniform.setShaderUniform(this, name, value, 4);
    }

    @:allow(spoopy.frontend.storage.SpoopyShaderStorage)
    private function bindDevice(device:SpoopySwapChain):Void {
        this.__device = device;
        __uniform = new SpoopyUniformBuffer(this.device);
    }

    public static function cacheShader(__shader:String):Void {
        if(__shader.substring(__shader.length - 4, __shader.length) != ".spv") {
            __shader = __shader + ".spv";
        }

        cachedShader.set(__shader, getShaderSource(__shader));
    }

    public static function releaseShader(__shader:String):Void {
        if(__shader.substring(__shader.length - 4, __shader.length) != ".spv") {
            __shader = __shader + ".spv";
        }else {
            Log.warn('The __shader file "${__shader}" was not found!');
        }

        cachedShader.remove(__shader);
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

        __shader = new SpoopyNativeShader(name, device);
        __shader.fragment_and_vertex(rawVertex, rawFragment);
    }

    private static function getShaderSource(__shader:String):String {
        var rawShader:String;

        if(Assets.exists(__shader)) {
            rawShader = Assets.getText(__shader);
            return SpoopyNativeShader.decompileSPV(rawShader);
        }else {
            Log.warn('The shader file "${__shader}" was not found!');
            return "";
        }
    }
}