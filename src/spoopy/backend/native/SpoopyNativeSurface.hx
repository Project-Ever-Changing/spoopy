package spoopy.backend.native;

import spoopy.backend.SpoopyCFFI;

import lime.app.Application;

class SpoopyNativeSurface {
    public var handle:Dynamic;

    private var handle_instance:Dynamic;
    private var handle_physical:Dynamic;
    private var handle_logical:Dynamic;

    public function new(application:Application, window:SpoopyNativeWindow) {
        if(window == null) {
            return;
        }

        var name:String = application.meta.get("name");
        var version:Array<Int> = recursivelyGetVersionFromString(application.meta.get("version"));

        handle_instance = SpoopyCFFI.spoopy_create_instance_device(window.handle, name, version[0], version[1], version[2]);
        handle_physical = SpoopyCFFI.spoopy_create_physical_device(handle_instance);
        handle_logical = SpoopyCFFI.spoopy_create_logical_device(handle_instance, handle_physical);

        handle = SpoopyCFFI.spoopy_create_surface(handle_instance, handle_physical, handle_logical, window.handle);
    }

    private function recursivelyGetVersionFromString(version:String):Array<Int> {
        var v:Array<Int> = version.split(".");

        if(v.length < 3) {
            return recursivelyGetVersionFromString(version + ".0");
        }

        return v;
    }
}