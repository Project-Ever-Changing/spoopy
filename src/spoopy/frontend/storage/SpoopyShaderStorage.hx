package spoopy.frontend.storage;

import spoopy.graphics.SpoopyScene;
import spoopy.rendering.SpoopyShader;

class SpoopyShaderStorage {

    /*
    * `lists` is an array of SpoopyShaders.
    */
    public var list:Array<SpoopyShader>;

    /*
    * `shaders` is a map of SpoopyShaders.
    */
    public var shaders:Map<String, SpoopyShader>;

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
        shader.bindDevice(parent);

        if(list.indexOf(s) == -1)list.push(s);
        if(!shaders.exists(s))shaders.set(name, s);
        return s;
    }
}