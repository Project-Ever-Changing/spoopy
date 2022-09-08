package spoopy.events;

@:allow(spoopy.events.EventHandler)
class EventListener {
    var __callback:Void->Void;

    public function new(callback:Void->Void) {
        this.__callback = callback;
    }

    public function match(callback:Void->Void) {
        return Reflect.compareMethods(this.__callback, callback);
    }

    private function execute():Void {
        if(__callback != null) {
            __callback();
        }
    }
}