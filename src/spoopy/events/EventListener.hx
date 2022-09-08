package spoopy.events;

class EventListener {
    var __callback:Void->Void;

    public function match(callback:Void->Void) {
        return Reflect.compareMethods(this.__callback, callback);
    }

    public function addCallback(callback:Void->Void):Void {

    }
}