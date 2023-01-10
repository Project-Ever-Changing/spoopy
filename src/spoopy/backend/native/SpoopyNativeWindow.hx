package spoopy.backend.native;

import spoopy.backend.SpoopyCFFI;

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
	private var surface:SpoopyNativeSurface;

    public function new(parent:Window) {
        this.parent = parent;
        this.cursor = DEFAULT;

        this.displayMode = new DisplayMode(0, 0, 0, 0);

        var attributes:WindowAttributes = parent.__attributes;
        var contextAttributes = Reflect.hasField(attributes, "context") ? attributes.context : {};
        var title = Reflect.hasField(attributes, "title") ? attributes.title : "Spoopy Application";
        var flag = 0;

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

		if (Reflect.hasField(attributes, "allowHighDPI") && attributes.allowHighDPI) flags |= cast SDL_WindowFlags.WINDOW_FLAG_ALLOW_HIGHDPI;
		if (Reflect.hasField(attributes, "alwaysOnTop") && attributes.alwaysOnTop) flags |= cast SDL_WindowFlags.WINDOW_FLAG_ALWAYS_ON_TOP;
		if (Reflect.hasField(attributes, "borderless") && attributes.borderless) flags |= cast SDL_WindowFlags.WINDOW_FLAG_BORDERLESS;
		if (Reflect.hasField(attributes, "fullscreen") && attributes.fullscreen) flags |= cast SDL_WindowFlags.WINDOW_FLAG_FULLSCREEN;
		if (Reflect.hasField(attributes, "hidden") && attributes.hidden) flags |= cast SDL_WindowFlags.WINDOW_FLAG_HIDDEN;
		if (Reflect.hasField(attributes, "maximized") && attributes.maximized) flags |= cast SDL_WindowFlags.WINDOW_FLAG_MAXIMIZED;
		if (Reflect.hasField(attributes, "minimized") && attributes.minimized) flags |= cast SDL_WindowFlags.WINDOW_FLAG_MINIMIZED;
		if (Reflect.hasField(attributes, "resizable") && attributes.resizable) flags |= cast SDL_WindowFlags.WINDOW_FLAG_RESIZABLE;

        flags |= SDL_WindowFlags.WINDOW_FLAG_VULKAN;

        var width = Reflect.hasField(attributes, "width") ? attributes.width : #if desktop 800 #else 0 #end;
		var height = Reflect.hasField(attributes, "height") ? attributes.height : #if desktop 600 #else 0 #end;

        #if (!macro && lime_cffi)
        handle = SpoopyCFFI.spoopy_create_window(width, height, flags, title);
		surface = new SpoopyNativeSurface(parent.application, this);

        if(handle != null) {
            parent.__width = width;
            parent.__height = height;

            parent.__x = SpoopyCFFI.spoopy_window_get_x(handle);
            parent.__y = SpoopyCFFI.spoopy_window_get_y(handle);

            parent.__hidden = (Reflect.hasField(attributes, "hidden") && attributes.hidden);
            parent.id = SpoopyCFFI.spoopy_window_get_id(handle);
        }

		parent.__scale = SpoopyCFFI.spoopy_window_get_scale(handle);
        #end
    }

	public function alert(message:String, title:String):Void {
		
	}
}

@:enum private abstract SDL_WindowFlags(Int) {
	var WINDOW_FLAG_FULLSCREEN:SDL_WindowFlags = 0x00000001;
	var WINDOW_FLAG_BORDERLESS:SDL_WindowFlags = 0x00000002;
	var WINDOW_FLAG_RESIZABLE:SDL_WindowFlags = 0x00000004;
	var WINDOW_FLAG_HARDWARE:SDL_WindowFlags = 0x00000008;
	var WINDOW_FLAG_VSYNC:SDL_WindowFlags = 0x00000010;
	var WINDOW_FLAG_HW_AA:SDL_WindowFlags = 0x00000020;
	var WINDOW_FLAG_HW_AA_HIRES:SDL_WindowFlags = 0x00000060;
	var WINDOW_FLAG_ALLOW_SHADERS:SDL_WindowFlags = 0x00000080;
	var WINDOW_FLAG_REQUIRE_SHADER:SDL_WindowFlags = 0x00000100;
	var WINDOW_FLAG_DEPTH_BUFFER:SDL_WindowFlags = 0x00000200;
	var WINDOW_FLAG_STENCIL_BUFFER:SDL_WindowFlags = 0x00000400;
	var WINDOW_FLAG_ALLOW_HIGHDPI:SDL_WindowFlags = 0x00000800;
	var WINDOW_FLAG_HIDDEN:SDL_WindowFlags = 0x00001000;
	var WINDOW_FLAG_MINIMIZED:SDL_WindowFlags = 0x00002000;
	var WINDOW_FLAG_MAXIMIZED:SDL_WindowFlags = 0x00004000;
	var WINDOW_FLAG_ALWAYS_ON_TOP:SDL_WindowFlags = 0x00008000;
	var WINDOW_FLAG_COLOR_DEPTH_32_BIT:SDL_WindowFlags = 0x00010000;
    var WINDOW_FLAG_VULKAN:SDL_WindowFlags = 0x10000000;
    var WINDOW_FLAG_METAL:SDL_WindowFlags = 0x20000000;
}