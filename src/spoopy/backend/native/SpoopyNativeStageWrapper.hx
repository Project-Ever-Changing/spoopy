package spoopy.backend.native;

import spoopy.utils.SpoopyDestroyable;
import spoopy.graphics.commands.SpoopyCommandManager;
import spoopy.graphics.SpoopyWindowContext;

/*
* This class serves as a frontend wrapper for the context stage inside the native context.
*/

class SpoopyNativeStageWrapper implements ISpoopyDestroyable {
    @:noCompletion private var __windowContext:SpoopyWindowContext;
    @:noCompletion private var __cmdBufferManager:SpoopyCommandManager<SpoopyWindowContext>;
    @:noCompletion private var __activeCmdBuffer:SpoopyCommandBuffer<SpoopyWindowContext>;

    public function new(windowContext:SpoopyWindowContext) {
        __windowContext = windowContext;

        __cmdBufferManager = new SpoopyCommandManager<SpoopyWindowContext>(__windowContext);
    }
}