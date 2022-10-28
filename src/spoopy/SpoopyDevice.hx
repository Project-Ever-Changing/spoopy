package spoopy;

import spoopy.backend.GeneralPipeline;

class SpoopyDevice {
    @:noCompletion var __manager:GeneralPipeline;

    public function new() {
        __manager = new GeneralPipeline();
    }
}