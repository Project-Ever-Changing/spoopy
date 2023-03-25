package spoopy.rendering;

import spoopy.graphics.other.SpoopySwapChain;
import spoopy.graphics.uniforms.SpoopyUniformBuffer;
import spoopy.backend.native.SpoopyNativeShader;
import spoopy.rendering.interfaces.ShaderReference;
import spoopy.rendering.interfaces.ShaderType;
import spoopy.frontend.storage.SpoopyShaderStorage;
import spoopy.obj.SpoopyObject;
import spoopy.obj.geom.SpoopyPoint;

import lime.math.Matrix4;
import lime.math.Vector4;
import lime.math.Vector2;

import lime.utils.Float32Array;
import lime.utils.DataPointer;
import lime.utils.Assets;
import lime.utils.Log;

@:access(spoopy.graphics.other.SpoopySwapChain)
class SpoopyShader implements SpoopyObject {
    private static var cachedShader:Map<String, String> = new Map<String, String>();

    public var name(default, null):String;

    @:noCompletion private var __shader:SpoopyNativeShader;
    @:noCompletion private var __uniformVertex:SpoopyUniformBuffer;
    @:noCompletion private var __uniformFragment:SpoopyUniformBuffer;
    @:noCompletion private var __device:SpoopySwapChain;

    public function new() {
        /*
        * Empty.
        */
    }

    public function bind():Void {
        __uniformVertex.apply();
        __uniformFragment.apply();
        __device.useShaderProgram(__shader);
    }

    public function unbind():Void {
        __device.useShaderProgram(null);
    }

    public function setInt(flag:ShaderType, name:String, value:Int):Void {
        getUniformShader(flag).setShaderUniform(this, name, DataPointer.fromInt(value), 2);
    }

    public function setIntArray(flag:ShaderType, name:String, value:Array<Int>):Void {
        var data32:Float32Array = new Float32Array(value);
        getUniformShader(flag).setShaderUniform(this, name, data32, Math.ceil(data32.byteLength * 0.0625));
    }

    public function setFloat(flag:ShaderType, name:String, value:Float):Void {
        getUniformShader(flag).setShaderUniform(this, name, DataPointer.fromFloat(value), 1);
    }

    public function setVector2(flag:ShaderType, name:String, value:Vector2):Void {
        var data32:Float32Array = new Float32Array([value.x, value.y]);
        getUniformShader(flag).setShaderUniform(this, name, data32, Math.ceil(data32.byteLength * 0.0625));
    }

    public function setVector3(flag:ShaderType, name:String, value:SpoopyPoint):Void {
        var data32:Float32Array = new Float32Array([value.x, value.y, value.z]);
        getUniformShader(flag).setShaderUniform(this, name, data32, Math.ceil(data32.byteLength * 0.0625));
    }

    public function setVector4(flag:ShaderType, name:String, value:Vector4):Void {
        var data32:Float32Array = new Float32Array([value.x, value.y, value.z, value.w]);
        getUniformShader(flag).setShaderUniform(this, name, data32, Math.ceil(data32.byteLength * 0.0625));
    }

    public function setMatrix4x4(flag:ShaderType, name:String, value:Matrix4):Void {
        getUniformShader(flag).setShaderUniform(this, name, value, 4);
    }

    public function destroy():Void {
        __uniformVertex = null;
        __uniformFragment = null;

        __device = null;
        __shader = null;
    }

    public function toString():String {
        return name;
    }

    @:allow(spoopy.frontend.storage.SpoopyShaderStorage)
    private function assignName(name:String):Void {
        this.name = name;
    }

    @:allow(spoopy.frontend.storage.SpoopyShaderStorage)
    private function bindDevice(device:SpoopySwapChain):Void {
        this.__device = device;
        __uniformVertex = new SpoopyUniformBuffer(this.__device);
        __uniformFragment = new SpoopyUniformBuffer(this.__device);
    }

    private function getUniformShader(flag:ShaderType):SpoopyUniformBuffer {
        switch(flag) {
            case FRAGMENT_SHADER:
                return __uniformFragment;
            default:
                return __uniformVertex;
        }
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
    private function createShader(vertex:String, fragment:String, cache:Bool = false):Void {
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

        __shader = new SpoopyNativeShader(name, __device);
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