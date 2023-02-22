package spoopy.graphics;

import lime.ui.Window;

import spoopy.app.SpoopyApplication;
import spoopy.window.WindowEventManager;
import spoopy.backend.storage.SpoopyCameraStorage;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;
#else
import spoopy.graphics.opengl.SpoopySwapChain;
#end

class SpoopyScene extends SpoopySwapChain {
    public static var cameras:SpoopyCameraStorage;

    public function new(application:SpoopyApplication) {
        #if (spoopy_vulkan || spoopy_metal)
        super(application);
        #else
        super();
        #end

        cameras = new SpoopyCameraStorage();
    }
}