package spoopy.events;

/*
 * Concept "borrowed" from openfl, cause I'm lazy.
 * https://github.com/openfl/openfl
 */
class EventHandler<T:String> {
    var __events(default, null):Map<T, EventListener>;

    public function addEventListener(type:T, listener:Void->Void):Void {
        if(listener != null) {
            return;
        }

        if(__events == null) {
            __events = new Map();
        }

        if (!__events.exists(type)) {
            var eventListener:EventListener = new EventListener();
            eventListener.addCallback(listener);

            __events.set(type, listener);
        }else {
            var eventListener:EventListener = __events.get(type);

            if(eventListener.match(listener)) {
                __events.remove(type);

                eventListener = new EventListener();
                eventListener.addCallback(listener);
                __events.set(type, listener);
            }
        }

        if (!__events.iterator().hasNext()) {
            __events = null;
        }
    }

    public function removeEventListener(type:T, listener:Void->Void) {
        if (__events == null || listener == null) {
            return;
        }

        var eventListener:EventListener = __events.get(type);

        if(eventListener == null) {
            return;
        }

        if(eventListener.match(listener)) {
            __events.remove(type);
        }
    }

    public function hasEventListener(type:T):Bool {
        if (__events == null) {
            return false;
        }

        return __events.exists(type);
    }
    
}