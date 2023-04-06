package spoopy.frontend.storage;

import spoopy.graphics.SpoopyScene;
import spoopy.obj.SpoopyCamera;

import lime.utils.Log;

class SpoopyCameraStorage {

    /*
    * `lists` is an array of SpoopyCameras.
    */
    public var list(default, null):Array<SpoopyCamera>;

    /*
    * `viewpoints` is used to define different viewpoints or perspectives in a 3D scene.
    */
    public var viewpoints(default, null):Array<SpoopyCamera>;

    /*
    * `parent` is the parent scene.
    */
    public var parent(default, null):SpoopyScene;

    @:allow(spoopy.graphics.SpoopyScene) private function new(parent:SpoopyScene) {
        viewpoints = new Array<SpoopyCamera>();
        list = new Array<SpoopyCamera>();

        this.parent = parent;
    }

    /*
    * Adds a `SpoopyCamera` object to the scene and returns it.
    *
    * @param cam The `SpoopyCamera` object to add.
    * @param viewport Whether to display the camera viewport on screen.
    * @return The `SpoopyCamera` object that was added.
    */
    public function add<T:SpoopyCamera>(cam:T, viewport:Bool = true):T {
        #if (haxe >= "4.0.0")
        if(list.contains(cam)) return cam;
        #else
        if(list.indexOf(cam) != -1) return cam;
        #end

        #if (spoopy_vulkan || spoopy_metal)
        cam.device = parent;
        #end

        list.push(cam);
        if(viewport)viewpoints.push(cam);
        return cam;
    }

    /*
    * Removes a `SpoopyCamera` object from the scene and optionally releases its resources.
    *
    * @param cam The `SpoopyCamera` object to remove.
    * @param destroy Whether to release the camera's resources after removing it.
    */
    public function remove(cam:SpoopyCamera, destroy:Bool = true):Void {
        var index:Int = list.indexOf(cam);

        if(cam != null && index != -1) {
            list.splice(index, 1);
            viewpoints.remove(cam);
        }else {
            Log.warn("`SpoopyCamera` not found in camera list");
            return;
        }

        if(destroy) {
            cam.destroy();
        }
    }

    /*
    * Sets a `SpoopyCamera` object as the active viewport for rendering.
    * 
    * @param cam The `SpoopyCamera` object to set as the viewport.
    * @param value If false, @param cam will no longer be able to render constantly.
    */
    public function setAsViewport(cam:SpoopyCamera, value:Bool):Void {
        var indexList:Int = list.indexOf(cam);
        var indexViewpoints:Int = viewpoints.indexOf(cam);

        if(indexList == -1) {
            Log.warn("The camera is not part of the scene!");
            return;
        }

        if(value && indexViewpoints == -1) {
            viewpoints.push(cam);
        }else if(!value) {
            viewpoints.splice(indexViewpoints, 1);
        }
    }

    /*
    * Resets the camera list by removing all cameras, then adds a new `SpoopyCamera` object to the list if `newCam` is not specified.
    * @param newCam An optional `SpoopyCamera` object to set as the new camera.
    */
    public function reset(?newCam:SpoopyCamera):Void {
        while(list.length > 0)remove(list[0]);

        if(newCam == null) {
            newCam = new SpoopyCamera();
        }

        add(newCam);
    }

    @:allow(spoopy.graphics.SpoopyScene) inline function render():Void {
        for(cam in viewpoints) {
            if((cam != null) && cam.inScene && cam.visible) {
                cam.render();
            }
        }
    }

    @:allow(spoopy.graphics.SpoopyScene) inline function update(elapsed:Float):Void {
        for(cam in viewpoints) {
            if((cam != null) && cam.inScene && cam.active) {
                cam.update(elapsed);
            }
        }
    }
}