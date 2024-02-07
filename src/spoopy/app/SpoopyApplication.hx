package spoopy.app;

import lime.system.System;
import lime.ui.Window;
import lime.app.Application;
import spoopy.window.IWindowModule;
import spoopy.io.SpoopyU64;
import haxe.ds.ObjectMap;
import haxe.io.Bytes;

@:access(spoopy.window.IWindowModule)
class SpoopyApplication extends Application {

    /*
	* A list of active Window module instances associated with this Application.
	*/
	public var windowModules(default, null):ObjectMap<Window, IWindowModule>;


    public static function getTimer():Int {
        return System.getTimer();
    }

    #if (!cpp || cppia)
    public static function malloc8(value:SpoopyU64):Bytes {
        var bytes:Bytes = Bytes.alloc(8);

        bytes.setInt32(0, value.low);
        bytes.setInt32(4, value.high);

        return bytes;
    }
    #end

    public function new() {
        super();

        windowModules = new ObjectMap<Window, IWindowModule>();
    }

    public function addWindowModule(module:IWindowModule, window:Window):Void {
        module.__registerWindowModule(window);
        windowModules.set(window, module);
    }

    // Unlike Lime, this engine will clean up after itself when the application exits.
    public override function onModuleExit(code:Int):Void {
        super.onModuleExit(code);

        for(module in modules) {
            removeModule(module);
        }
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
