package spoopy.frontend.storage;

import spoopy.graphics.SpoopyScene;
import spoopy.rendering.SpoopyShader;

import lime.utils.Log;

class SpoopyShaderStorage {

    /*
    * `lists` is an array of SpoopyShaders.
    */
    private var list:Array<SpoopyShader>;

    /*
    * `shaders` is a map of SpoopyShaders.
    */
    private var shaders:Map<String, SpoopyShader>;

    /*
    * `parent` is the memory allocation to the scene of the application.
    */
    public var parent(default, null):SpoopyScene;

    @:allow(spoopy.graphics.SpoopyScene) private function new(parent:SpoopyScene) {
        shaders = new Map<String, SpoopyShader>();
        list = new Array<SpoopyShader>();

        this.parent = parent;
    }

    /*
    * Adds a `SpoopyShader` object to the scene and returns it.
    *
    * @param name Name of the `SpoopyShader.`
    * @param shader The `SpoopyShader` object to add.
    * @return The `SpoopyShader` object that was added.
    */
    public function add(name:String, shader:SpoopyShader):SpoopyShader {
        shader.assignName(name);
        shader.bindDevice(parent);

        if(list.indexOf(shader) == -1)list.push(s);
        if(!shaders.exists(shader))shaders.set(name, s);
        return shader;
    }

    /*
    * Removes a `SpoopyShader` object from the scene and optionally releases its resources.
    *
    * @param name The name of the `SpoopyShader` object to remove.
    * @param destroy Whether to release the shader's resources after removing it.
    */
    public function removeByName(name:String, destroy:Bool = true):Void {
        if(!shaders.exists(name) || shaders.get(name) == null) {
            Log.warn("`SpoopyShader` not found in shader list");
            return;
        }

        var shader = shaders.get(name);
        var index = list.indexOf(shader);

        list.splice(index, 1);
        shaders.remove(name);

        if(destroy) {
            shader.destroy();
        }
    }

    /*
    * Removes a `SpoopyShader` object from the scene and optionally releases its resources.
    *
    * @param shader The `SpoopyShader` object to remove.
    * @param destroy Whether to release the shader's resources after removing it.
    */
    public function removeByObject(shader:SpoopyShader, destroy:Bool = true):Void {
        var name = shader.name;
        var index = list.indexOf(shader);

        list.splice(index, 1);
        shaders.remove(name);
        shader.unbind();

        if(destroy) {
            shader.destroy();
        }
    }

    /*
    * Creates the shader functions for a given name using the provided vertex and fragment shader sources,
    * and caches the compiled shaders if cache is true.
    * 
    * @param name The name of the shader to create.
    * @param vertex The source code for the vertex shader.
    * @param fragment The source code for the fragment shader.
    * @param cache If true, the compiled shaders will be cached for faster loading in subsequent runs.
    */
    public function createShaderFunctions(name:String, vertex:String, fragment:String, cache:Bool = false):Void {
        var shader = shaders.get(name);

        if(!shaders.exists(name) || shaders.get(name) == null) {
            Log.warn("`SpoopyShader` not found in shader list");
            return;
        }

        shader.createShader(vertex, fragment, cache);
        shader.bind();
    }

    /*
    * Retrieves a SpoopyShader with the specified name, either from the shaders map or from the list of SpoopyShaders.
    * If the shader is not found, a warning message is logged and null is returned.
    * 
    * @param name The name of the SpoopyShader to retrieve.
    * @return The SpoopyShader with the specified name, or null if not found.
    */
    public function get(name:String):SpoopyShader {
        var foundShader:SpoopyShader = null;

        if(shaders.exists(name)) {
            foundShader = shaders.get(name);
        }

        for(s in list) {
            if(s.name == name) {
                foundShader = s;
                break;
            }
        }

        if(foundShader == null) {
            Log.warn("Shader not found!");
        }

        return foundShader;
    }

    /*
    * Checks if a shader with the given name exists in the shaders map or list array.
    * 
    * @param name The name of the shader to check.
    * @return true if the shader exists, false otherwise.
    */
    public function exists(name:String):Bool {
        if(shaders.exists(name)) {
            return true;
        }

        for(s in list) {
            if(s.name == name) {
                return true;
            }
        }

        return false;
    }
}