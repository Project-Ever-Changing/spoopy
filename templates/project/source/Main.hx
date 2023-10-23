package;

import spoopy.app.SpoopyApplication;

class Main extends SpoopyApplication {

    private var frameCount:Int = 0;

    public function new() {
        super();

        this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

        // Code Goes Here
    }

    public override function onWindowCreate():Void {
        super.onWindowCreate();

        // Code Goes Here
    }

    private function onEnterFrame(e:Event):Void {
        frameCount++;
    }
}