package spoopy;

import spoopy.backend.DevicesPipeline;

class SpoopyPipeline {
    @:noCompletion var __manager:DevicesPipeline;

    public function new() {
        __manager = new DevicesPipeline();
    }
}