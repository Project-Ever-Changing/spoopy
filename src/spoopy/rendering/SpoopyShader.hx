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

    /*
    * The data to be sent to the shader.
    */
    public var data(default, null):ArrayBufferView;

    @:noCompletion private var __shader:SpoopyNativeShader;

    public function new() {
        super();
    }

    public override function bind() {
        super.bind();   

        __device.useShaderProgram(__shader);
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
            var decompiledShader = SpoopyNativeShader.decompileSPV(rawShader);

            #if spoopy_debug
            Log.info('Shader file:\n\n${decompiledShader}');
            #end

            return decompiledShader;
        }else {
            Log.warn('The shader file "${__shader}" was not found!');
            return "";
        }
    }
}