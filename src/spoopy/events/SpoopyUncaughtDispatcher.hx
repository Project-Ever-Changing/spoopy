package spoopy.events;

import openfl.events.EventType;

class SpoopyUncaughtDispatcher extends SpoopyEventDispatcher {
    @:noCompletion private var __enabled:Bool;
    @:noCompletion private var __totalEvents:Array<String>;

    public function new() {
        super();
        
        __enabled = false;
    }

    public override function addEventListener<T>(eventName:String, eventType:EventType<T>, listener:T->Void, priority:Int = 0):Void {
        super.addEventListener(eventName, eventType, listener, priority);
        
        if(!__totalEvents.contains(eventName)) __totalEvents.push(eventName);
        if(__totalEvents.contains(eventName)) __enabled = true;
    }

    public override function removeEventListener<T>(eventName:String):Void {
        super.removeEventListener(eventName);
        
        if(__totalEvents.contains(eventName)) __totalEvents.remove(eventName);
        if(!__totalEvents.contains(eventName)) __enabled = false;
    }
}