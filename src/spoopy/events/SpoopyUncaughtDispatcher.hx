package spoopy.events;

import openfl.events.EventType;

class SpoopyUncaughtDispatcher<K:String> extends SpoopyEventDispatcher<K> {
    @:noCompletion private var __enabled:Bool;
    @:noCompletion private var __totalEvents:Array<K>;

    public function new() {
        super();
        
        __enabled = false;
    }

    public override function addEventListener<T>(eventRef:K, eventType:EventType<T>, listener:T->Void, priority:Int = 0):Void {
        super.addEventListener(eventRef, eventType, listener, priority);
        
        if(!__totalEvents.contains(eventRef)) __totalEvents.push(eventRef);
        if(__totalEvents.contains(eventRef)) __enabled = true;
    }

    public override function removeEventListener<T>(eventRef:K):Void {
        super.removeEventListener(eventRef);
        
        if(__totalEvents.contains(eventRef)) __totalEvents.remove(eventRef);
        if(!__totalEvents.contains(eventRef)) __enabled = false;
    }
}