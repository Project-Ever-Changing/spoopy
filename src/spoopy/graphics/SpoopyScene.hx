package spoopy.graphics;

import lime.ui.Window;

import spoopy.app.SpoopyApplication;
import spoopy.window.WindowEventManager;
import spoopy.frontend.storage.SpoopyCameraStorage;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;
#else
import spoopy.graphics.opengl.SpoopySwapChain;
#end

class SpoopyScene extends SpoopySwapChain {
    public var cameras(default, null):SpoopyCameraStorage;

    public function new(application:SpoopyApplication) {
        #if (spoopy_vulkan || spoopy_metal)
        super(application);
        #else
        super();
        #end

        cameras = new SpoopyCameraStorage(this);
    }
}