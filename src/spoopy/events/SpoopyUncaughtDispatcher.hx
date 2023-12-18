package spoopy.events;

import spoopy.events.SpoopyEvent;

class SpoopyUncaughtDispatcher extends SpoopyEventDispatcher {
    @:noCompletion private var __enabled:Bool;
    @:noCompletion private var __totalEvents:Array<String>;

    public function new() {
        super();
        
        __enabled = false;
    }

    public override function addEventListener<T>(eventName:String, eventType:EventType<T>, listener:T->Void, priority:Int = 0):Void {
        super.addEventListener(eventName, eventType, listener, priority);
        
        if(!__totalEvents.exists(eventName)) __totalEvents.push(eventName);
        if(__totalEvents.exists(eventName)) __enabled = true;
    }

    public override function removeEventListener<T>(eventName:String, eventType:EventType<T>, listener:T->Void):Void {
        super.removeEventListener(eventName, eventType, listener);
        
        if(__totalEvents.exists(eventName)) __totalEvents.remove(eventName);
        if(!__totalEvents.exists(eventName)) __enabled = false;
    }
}