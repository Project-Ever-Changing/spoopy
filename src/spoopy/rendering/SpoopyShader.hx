package spoopy.rendering;

import spoopy.graphics.other.SpoopySwapChain;
import spoopy.backend.native.SpoopyNativeShader;
import spoopy.rendering.interfaces.ShaderType;
import spoopy.frontend.storage.SpoopyShaderStorage;
import spoopy.obj.SpoopyObject;
import spoopy.obj.geom.SpoopyPoint;

import lime.math.Matrix4;
import lime.math.Vector4;
import lime.math.Vector2;

import lime.utils.Float32Array;
import lime.utils.ArrayBufferView;
import lime.utils.DataPointer;
import lime.utils.Assets;
import lime.utils.Log;

@:access(spoopy.graphics.other.SpoopySwapChain)
class SpoopyShader extends SpoopyShaderBasic  {

    /*
    * Uniform Sizes.
    */

    #if (haxe >= "4.0.0")
    public static final MAT3_SIZE:Int = 36;
    public static final MAT4X3_SIZE:Int = 48;
    public static final VEC3_SIZE:Int = 12;
    public static final VEC4_SIZE:Int = 16;
    public static final BMAT3_SIZE:Int = 9;
    public static final BMAT4X3_SIZE:Int = 12;
    public static final BVEC3_SIZE:Int = 3;
    public static final BVEC4_SIZE:Int = 4;
    #else
    @:final public static var MAT3_SIZE:Int = 36;
    @:final public static var MAT4X3_SIZE:Int = 48;
    @:final public static var VEC3_SIZE:Int = 12;
    @:final public static var VEC4_SIZE:Int = 16;
    @:final public static var BMAT3_SIZE:Int = 9;
    @:final public static var BMAT4X3_SIZE:Int = 12;
    @:final public static var BVEC3_SIZE:Int = 3;
    @:final public static var BVEC4_SIZE:Int = 4;
    #end


    private static var cachedShader:Map<String, String> = new Map<String, String>();

    @:noCompletion private var __shader:SpoopyNativeShader;

    /*
    * The data to be sent to the shader.
    */
    public var data(default, null):ArrayBufferView;

    public function new() {
        super();
    }

    public override function bind() {
        super.bind();   

        __device.useShaderProgram(__shader);
    }

    public function convertMat3toMat4x3(src:Float32Array, size:Int):Float32Array {
        var dst:Float32Array = new Float32Array(size);

        dst[3] = dst[7] = dst[11] = 0.0;
        dst[0] = src[0]; dst[1] = src[1]; dst[2] = src[2];
        dst[4] = src[3]; dst[5] = src[4]; dst[6] = src[5];
        dst[8] = src[6]; dst[9] = src[7]; dst[10] = src[8];

        return dst;
    }

    public function createShader(vertex:String, fragment:String, cache:Bool = false):Void {
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

    public override function destroy():Void {
        super.destroy();

        __shader.destroy();
        __shader = null;
    }

    private override function assignDevice(device:SpoopySwapChain):Void {
        super.assignDevice(device);
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