package spoopy.backend;

import lime._internal.backend.native.NativeWindow;
import lime.ui.WindowAttributes;
import lime.system.DisplayMode;
import lime.ui.MouseCursor;
import lime.ui.Window;

@:access(lime._internal.backend.native.NativeWindow)
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

		if (Reflect.hasField(attributes, "allowHighDPI") && attributes.allowHighDPI) flags |= cast WindowFlags.WINDOW_FLAG_ALLOW_HIGHDPI;
		if (Reflect.hasField(attributes, "alwaysOnTop") && attributes.alwaysOnTop) flags |= cast WindowFlags.WINDOW_FLAG_ALWAYS_ON_TOP;
		if (Reflect.hasField(attributes, "borderless") && attributes.borderless) flags |= cast WindowFlags.WINDOW_FLAG_BORDERLESS;
		if (Reflect.hasField(attributes, "fullscreen") && attributes.fullscreen) flags |= cast WindowFlags.WINDOW_FLAG_FULLSCREEN;
		if (Reflect.hasField(attributes, "hidden") && attributes.hidden) flags |= cast WindowFlags.WINDOW_FLAG_HIDDEN;
		if (Reflect.hasField(attributes, "maximized") && attributes.maximized) flags |= cast WindowFlags.WINDOW_FLAG_MAXIMIZED;
		if (Reflect.hasField(attributes, "minimized") && attributes.minimized) flags |= cast WindowFlags.WINDOW_FLAG_MINIMIZED;
		if (Reflect.hasField(attributes, "resizable") && attributes.resizable) flags |= cast WindowFlags.WINDOW_FLAG_RESIZABLE;
    }
}