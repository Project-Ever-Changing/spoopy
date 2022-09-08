package spoopy.events;

@:allow(spoopy.events.EventHandler)
class EventListener {
    var __callback:Void->Void;

    public function match(callback:Void->Void) {
        return Reflect.compareMethods(this.__callback, callback);
    }

    private function addCallback(callback:Void->Void):Void {

    }
}