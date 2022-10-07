package spoopy;

import spoopy.backend.DeviceManager;
import spoopy.backend.DeviceManager;

class SpoopyDevice {
    @:noCompletion var __manager:DeviceManager;

    public function new() {
        __manager = new DeviceManager();
    }
}