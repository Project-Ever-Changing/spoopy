package spoopy.backend;

import lime.ui.WindowAttributes;
import lime.system.DisplayMode;
import lime.ui.MouseCursor;
import lime.ui.Window;

@:access(lime.system.DisplayMode)
@:access(lime.ui.Window)
class SpoopyNativeWindow {
    public var handle:Dynamic;

    private var parent:Window;
    private var cursor:MouseCursor;
    private var displayMode:DisplayMode;

    public function new(parent:Window) {
        this.parent = parent;
        this.cursor = DEFAULT;

        this.displayMode = new DisplayMode(0, 0, 0, 0);

        var attributes:WindowAttributes = parent.__attributes;
        var contextAttributes = Reflect.hasField(attributes, "context") ? attributes.context : {};
        var title = Reflect.hasField(attributes, "title") ? attributes.title : "Spoopy Application";
        var flags = 0;

        if (!Reflect.hasField(contextAttributes, "antialiasing")) contextAttributes.antialiasing = 0;
		if (!Reflect.hasField(contextAttributes, "background")) contextAttributes.background = 0;
		if (!Reflect.hasField(contextAttributes, "colorDepth")) contextAttributes.colorDepth = 24;
		if (!Reflect.hasField(contextAttributes, "depth")) contextAttributes.depth = true;
		if (!Reflect.hasField(contextAttributes, "hardware")) contextAttributes.hardware = true;
		if (!Reflect.hasField(contextAttributes, "stencil")) contextAttributes.stencil = true;
		if (!Reflect.hasField(contextAttributes, "vsync")) contextAttributes.vsync = false;

        #if (cairo || (!lime_opengl && !lime_opengles))
		contextAttributes.type = CAIRO;
		#end

        if (Reflect.hasField(contextAttributes, "type") && contextAttributes.type == CAIRO) contextAttributes.hardware = false;

		if (Reflect.hasField(attributes, "allowHighDPI") && attributes.allowHighDPI) flags |= cast WindowFlags.WINDOW_FLAG_ALLOW_HIGHDPI;
		if (Reflect.hasField(attributes, "alwaysOnTop") && attributes.alwaysOnTop) flags |= cast WindowFlags.WINDOW_FLAG_ALWAYS_ON_TOP;
		if (Reflect.hasField(attributes, "borderless") && attributes.borderless) flags |= cast WindowFlags.WINDOW_FLAG_BORDERLESS;
		if (Reflect.hasField(attributes, "fullscreen") && attributes.fullscreen) flags |= cast WindowFlags.WINDOW_FLAG_FULLSCREEN;
		if (Reflect.hasField(attributes, "hidden") && attributes.hidden) flags |= cast WindowFlags.WINDOW_FLAG_HIDDEN;
		if (Reflect.hasField(attributes, "maximized") && attributes.maximized) flags |= cast WindowFlags.WINDOW_FLAG_MAXIMIZED;
		if (Reflect.hasField(attributes, "minimized") && attributes.minimized) flags |= cast WindowFlags.WINDOW_FLAG_MINIMIZED;
		if (Reflect.hasField(attributes, "resizable") && attributes.resizable) flags |= cast WindowFlags.WINDOW_FLAG_RESIZABLE;

        if (contextAttributes.antialiasing >= 4) {
            flags |= cast WindowFlags.WINDOW_FLAG_HW_AA_HIRES;
        }else if (contextAttributes.antialiasing >= 2) {
            flags |= cast WindowFlags.WINDOW_FLAG_HW_AA;
        }

        if (contextAttributes.colorDepth == 32) flags |= cast WindowFlags.WINDOW_FLAG_COLOR_DEPTH_32_BIT;
		if (contextAttributes.depth) flags |= cast WindowFlags.WINDOW_FLAG_DEPTH_BUFFER;
		if (contextAttributes.hardware) flags |= cast WindowFlags.WINDOW_FLAG_HARDWARE;
		if (contextAttributes.stencil) flags |= cast WindowFlags.WINDOW_FLAG_STENCIL_BUFFER;
		if (contextAttributes.vsync) flags |= cast WindowFlags.WINDOW_FLAG_VSYNC;

        var width:Null<Int> = Reflect.hasField(attributes, "width") ? attributes.width : #if desktop 800 #else 0 #end;
		var height:Null<Int> = Reflect.hasField(attributes, "height") ? attributes.height : #if desktop 600 #else 0 #end;

        #if (!macro && lime_cffi)
        
        #end
    }
}

@:enum private abstract WindowFlags(Int) {
	var WINDOW_FLAG_FULLSCREEN = 0x00000001;
	var WINDOW_FLAG_BORDERLESS = 0x00000002;
	var WINDOW_FLAG_RESIZABLE = 0x00000004;
	var WINDOW_FLAG_HARDWARE = 0x00000008;
	var WINDOW_FLAG_VSYNC = 0x00000010;
	var WINDOW_FLAG_HW_AA = 0x00000020;
	var WINDOW_FLAG_HW_AA_HIRES = 0x00000060;
	var WINDOW_FLAG_ALLOW_SHADERS = 0x00000080;
	var WINDOW_FLAG_REQUIRE_SHADERS = 0x00000100;
	var WINDOW_FLAG_DEPTH_BUFFER = 0x00000200;
	var WINDOW_FLAG_STENCIL_BUFFER = 0x00000400;
	var WINDOW_FLAG_ALLOW_HIGHDPI = 0x00000800;
	var WINDOW_FLAG_HIDDEN = 0x00001000;
	var WINDOW_FLAG_MINIMIZED = 0x00002000;
	var WINDOW_FLAG_MAXIMIZED = 0x00004000;
	var WINDOW_FLAG_ALWAYS_ON_TOP = 0x00008000;
	var WINDOW_FLAG_COLOR_DEPTH_32_BIT = 0x00010000;
}