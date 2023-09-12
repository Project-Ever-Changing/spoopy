package spoopy.app;

import lime.system.System;
import lime.ui.Window;
import lime.ui.WindowAttributes;
import lime.app.Application;
import lime.utils.Log;

import spoopy.window.IWindowModule;

import haxe.ds.ObjectMap;

@:access(spoopy.window.IWindowModule)
class SpoopyApplication extends Application {
    /*
    * The maximum number of vertex layouts that can be defined.
    */
    public static var SPOOPY_CONFIG_MAX_VERTEX_LAYOUTS:UInt = 64;

    /*
    * This configuration parameter sets the maximum number of buffers that can be used in the graphics rendering pipeline.
    */
    public static var SPOOPY_CONFIG_MAX_LAYOUTS:UInt = (4<<10);

    /*
    * This configuration parameter sets the maximum number of textures that can be used in the graphics rendering pipeline.
    */
    public static var SPOOPY_CONFIG_MAX_UNIFORM_BUFFERS:UInt = 0x8;

    /*
    * Defines the maximum number of frames that can be in flight at once.
    */
    public static var SPOOPY_CONFIG_MAX_FRAME_LATENCY:UInt = 3;
    
    /*
	* A list of active Window module instances associated with this Application.
	*/
	public var windowModules(default, null):ObjectMap<Window, IWindowModule>;

    public static function getTimer():Int {
        return System.getTimer();
    }

    public function new() {
        super();

        windowModules = new ObjectMap<Window, IWindowModule>();
    }

    public function addWindowModule(module:IWindowModule, window:Window):Void {
        module.__registerWindowModule(window);
        windowModules.set(window, module);
    }

    @:noCompletion private override function __removeWindow(window:Window):Void {
        if(window != null && __windowByID.exists(window.id)) {
            if(__windows.length == 0) {
                #if !lime_doc_gen
				System.exit(0);
				#end
            }

            if(windowModules.exists(window)) {
                var getModule = windowModules.get(window);
                getModule.__unregisterWindowModule(window);
                windowModules.remove(window);
                getModule = null;
            }
        }

        super.__removeWindow(window);
    }
}