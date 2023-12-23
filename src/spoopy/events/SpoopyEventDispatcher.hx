package spoopy.events;

import spoopy.utils.SpoopyLogger;
import openfl.events.EventType;

import haxe.ds.ObjectMap;
import haxe.ds.StringMap;

class SpoopyEventDispatcher<K> {
    @:noCompletion private var __eventNameMap:ObjectMap<String, Array<K>>;
    @:noCompletion private var __eventListeners:StringMap<Listener>;

    public function new() {
        __eventNameMap = new ObjectMap<String, Array<K>>();
        __eventListeners = new StringMap<Listener>();
    }

    public function addEventListener<T>(eventRef:K, eventType:EventType<T>, listener:T->Void, priority:Int = 0):Void {
        if(listener == null) return;

        if(!__eventNameMap.exists(eventType)) {
            __eventNameMap.set(eventType, new Array<K>());
        }

        var __listener = new Listener(eventType, priority, listener);

        if(__eventListeners.exists(eventRef)) {
            SpoopyLogger.warn("Event listener for event " + eventRef + " already exists. Overwriting...");

            var eventType = __eventListeners.get(eventRef).eventType;
            __eventNameMap.get(eventType).remove(eventRef);
        }

        __eventListeners.set(eventRef, __listener);
        __addEventListenerByPriority(eventRef, __eventNameMap.get(eventType), priority);
    }

    public function removeEventListener(eventRef:K):Void {
        if(!__eventListeners.exists(eventRef)) return;

        var listener = __eventListeners.get(eventRef);
        var eventRefs = __eventNameMap.get(listener.eventType);
        eventRefs.remove(eventRef);
        __eventListeners.remove(eventRef);
    }

    public function hasEventListener(eventType:String):Bool {
        if(!__eventNameMap.exists(eventType)) return false;
        return __eventNameMap.get(eventType).length > 0;
    }

    @:noCompletion private function __addEventListenerByPriority(eventRef:K, list:Array<K>, priority:Int):Void {
        var numElements:Int = list.length;
		var addAtPosition:Int = numElements;

        for (i in 0...numElements) {
            var listener = __eventListeners.get(list[i]);

            if(listener.priority < priority) {
                addAtPosition = i;
                break;
            }
        }

        list.insert(addAtPosition, eventRef);
    }

    @:noCompletion private function __dispatch(event:SpoopyEvent):Bool {
        if(!hasEventListener(event.type)) return false;

        var eventRefs = __eventNameMap.get(event.type);

        for(ref in eventRefs) {
            var listener = __eventListeners.get(ref);
            if(listener == null) continue;
            listener.listener(event);
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