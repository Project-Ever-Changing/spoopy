package spoopy.events;

import openfl.events.EventType;
import lime.utils.ObjectPool;

/*
* TODO: Add proper documentation
*/
@:allow(spoopy.events.SpoopyEventDispatcher)
@:allow(spoopy.backend.native.SpoopyNativeEngine)
@:allow(spoopy.app.SpoopyEngine)
class SpoopyEvent #if openfl extends Event #end {

    /*
    * The `ENTER_DRAW_FRAME` constant defines the value of the `type` property
    * of an `enterDrawFrame` event object.
    */
    public static inline var ENTER_DRAW_FRAME:EventType<SpoopyEvent> = "enterDrawFrame";

    /*
    * The `ENTER_UPDATE_FRAME` constant defines the value of the `type` property
    * of an `enterUpdateFrame` event object.
    */
    public static inline var ENTER_UPDATE_FRAME:EventType<SpoopyEvent> = "enterUpdateFrame";

	@:noCompletion private static var __pool:ObjectPool<SpoopyEvent> = new ObjectPool<SpoopyEvent>(function() {
		return new SpoopyEvent(null);
	}, function(event) {
		event.__preventThrowing = false;
	});


	public var type(default, null):String;

	@:noCompletion private var __preventThrowing:Bool;

    public function new(type:EventType<SpoopyEvent>) {
        this.type = type;
		this.__preventThrowing = false;
    }

	public function preventThrowing():Void {
		this.__preventThrowing = true;
	}

	public function IsThrowingPrevented():Bool {
		return this.__preventThrowing;
	}
}