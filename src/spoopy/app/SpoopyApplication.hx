package spoopy.app;

import spoopy.SpoopyEngine;
import lime.app.Application;

class SpoopyApplication extends Application {
    public function new() {
        super();

        SpoopyEngine.init();
    }
}