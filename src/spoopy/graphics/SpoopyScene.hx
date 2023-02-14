package spoopy.graphics;

import lime.ui.Window;

import spoopy.app.SpoopyApplication;
import spoopy.window.WindowEventManager;

class SpoopyScene #if (spoopy_vulkan || spoopy_metal) extends SpoopySwapChain #else extends WindowEventManager #end {
    public function new(application:SpoopyApplication) {
        #if (spoopy_vulkan || spoopy_metal)
        super(application);
        #else
        super();
        #end
    }
}