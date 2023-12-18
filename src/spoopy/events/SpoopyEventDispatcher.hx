package spoopy.events;

import openfl.events.EventType;

class SpoopyEventDispatcher {
    @:noCompletion private var __eventNameMap:Map<String, Array<String>>;
    @:noCompletion private var __eventListeners:Map<String, Listener>;

    public function new() {
        __eventNameMap = new Map<String, Array<String>>();
        __eventListeners = new Map<String, Listener>();
    }

    public function addEventListener<T>(eventName:String, eventType:EventType<T>, listener:T->Void, priority:Int = 0):Void {
        if(listener == null) return;

        if(!__eventNameMap.exists(eventType)) {
            __eventNameMap.set(eventType, []);
        }

        var __listener = new Listener(eventType, priority, listener);

        if(__eventListeners.exists(eventName)) {
            var eventType = __eventListeners.get(eventName).eventType;
            __eventNameMap.get(eventType).remove(eventName);
        }

        __eventListeners.set(eventName, __listener);
        __addEventListenerByPriority(eventName, __eventNameMap.get(eventType), priority);
    }

    public function removeEventListener(eventName:String):Void {
        if(!__eventListeners.exists(eventName)) return;

        var listener = __eventListeners.get(eventName);
        var eventNames = __eventNameMap.get(listener.eventType);
        eventNames.remove(eventName);
        __eventListeners.remove(eventName);
    }

    public function hasEventListener(eventType:String):Bool {
        if(!__eventNameMap.exists(eventType)) return false;
        return __eventNameMap.get(eventType).length > 0;
    }

    @:noCompletion private function __addEventListenerByPriority(eventName:String, list:Array<String>, priority:Int):Void {
        var numElements:Int = list.length;
		var addAtPosition:Int = numElements;

        for (i in 0...numElements) {
            var listener = __eventListeners.get(list[i]);

            if(listener.priority < priority) {
                addAtPosition = i;
                break;
            }
        }

        list.insert(addAtPosition, eventName);
    }

    @:noCompletion private function __dispatch(event:SpoopyEvent):Bool {
        if(!hasEventListener(event.type)) return false;

        var eventNames = __eventNameMap.get(event.type);

        for(name in eventNames) {
            var listener = __eventListeners.get(name);
            if(listener == null) continue;
            listener.callback(event);
        }
        
        return true;
    }
}

private class Listener {
    public var priority:Int;
    public var listener:Dynamic->Void;
    public var eventType:String;

    public function new(eventType:String, priority:Int, listener:Dynamic->Void) {
        this.eventType = eventType;
        this.priority = priority;
        this.listener = listener;
    }
}