package pipeline;

import backend.GraphicsPipline;
import backend.DevicesPipeline;

class SpoopyPipeline {
    @:noCompletion var __devices:DevicesPipeline;
    @:noCompletion var __graphics:GraphicsPipline;

    public function new() {
        __manager = new DevicesPipeline();
    }
}