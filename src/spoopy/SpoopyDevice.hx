package spoopy;

import spoopy.backend.DeviceGroup;

class SpoopyDevice {
    @:noCompletion var __manager:DeviceGroup;

    public function new() {
        __manager = new DeviceGroup();
    }
}