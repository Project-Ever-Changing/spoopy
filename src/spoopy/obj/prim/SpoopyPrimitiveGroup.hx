package spoopy.obj.display;

import spoopy.obj.display.SpoopyDisplayObject;
import spoopy.util.sort.alg.*;

import lime.utils.Log;

#if (haxe_ver >= 4.2)
import Std.isOfType;
#else
import Std.is as isOfType;
#end


class SpoopyPrimitiveGroup<T:SpoopyPrimitive> implements SpoopyDisplayObject {
    /*
    * An array of all objects stored.
    */
    public var objects(default, null):Array<T>;

    /*
    * The length of objects array.
    */
    public var length(default, null):UInt = 0;

    /*
    * The sorting algorithm used to sort the `objects` array.
    */
    public var sortingAlgorithm(default, null):SortingAlgorithm;

    /*
    * The maximum size of the objects array. If `0` then it's unlimited.
    */
    public var size(default, set):UInt;

    public var active(default, set):Bool;
    public var visible(default, set):Bool;
    public var inScene(default, set):Bool;

    public function new(size:UInt = 0) {
        this.size = size;

        objects = [];
        sortingAlgorithm = Type.createInstance(SpoopyQuickSort, []);
    }

    public function clear():Void {
        if(objects != null) {
            var index:UInt = 0;
            var obj:T = null;

            while (index < length) {
                obj = objects[index++];

                if(obj != null) {
                    obj.clear();
                }
            }

            objects = null;
        }
    }

    public function update(elapsed:Float):Void {
        if(objects != null) {
            var index:UInt = 0;
            var obj:T = null;

            while (index < length) {
                obj = objects[index++];

                if(obj != null && obj.inScene && obj.active) {
                    obj.update(elapsed);
                }
            }

            objects = null;
        }
    }

    public function render() {
        if(objects != null) {
            var index:UInt = 0;
            var obj:T = null;

            while (index < length) {
                obj = objects[index++];

                if(obj != null && obj.inScene && obj.visible) {
                    obj.render();
                }
            }

            objects = null;
        }
    }

    public function getFirstEmpty():UInt {
        var index:UInt = 0;

        while(index < length) {
            if(objects[index++] == null) {
                return index;
            }
        }

        return -1;
    }

    public function add(obj:T):Void {
        if(obj == null) {
            Log.warn("Cannot add `null` object.");
            return;
        }

        if(objects.indexOf(obj) >= 0) {
            return;
        }

        var index:UInt = getFirstEmpty();

        if (index != -1) {
            objects[index] = obj;

            if (index >= length) {
                length = index + 1;
            }

            return;
        }

        if(size > 0 && length >= size) {
			return;
        }

        objects.push(obj);
        length++;
    }

    public function insert(index:UInt = 0, obj:T):Void {
        if(obj == null) {
            Log.warn("Cannot add `null` object.");
            return;
        }

        if(objects.indexOf(obj) >= 0) {
            return;
        }

        if(index < length && objects[index] == null) {
            objects[index] = obj;
            return;
        }

        if(size > 0 && length >= size) {
            return;
        }

        objects.insert(index, obj);
        length++;
    }

    /*
    * If you want to remove the object from the array entirely, use `splice` instead.
    */
    public function remove(obj:T, releaseObj:Bool = false):Void {
        if(obj == null) {
            return;
        }

        var index:Int = objects.indexOf(obj);

        if(index < 0) {
            return;
        }

        if(releaseObj) {
            obj.clear();
        }

        objects[index] = null;
    }

    /*
    * Completely remove object from array.
    */
    public function splice(obj:T, releaseObj:Bool = false):Void {
        if(obj == null) {
            return;
        }

        var index:Int = objects.indexOf(obj);

        if(index < 0) {
            return;
        }

        if(releaseObj) {
            obj.clear();
        }

        objects.splice(index, 1);
		length--;
    }

    public function sort(f:T->T->Int):Void {
        sortingAlgorithm.sort(objects, f);
    }

    public function implementSortingAlgorithm<A:SortingAlgorithm>(algorithm:Class<A>):Void {
        if(!isOfType(sortingAlgorithm, algorithm)) {
            sortingAlgorithm = Type.createInstance(algorithm, []);
        }
    }

    @:noCompletion function set_active(value:Bool):Bool {
        if(objects != null) {
            var index:UInt = 0;
            var obj:T = null;

            while (index < length) {
                obj = objects[index++];
                
                if(obj != null) {
                    obj.active = value;
                }
            }
        }

        return active = value;
    }

    @:noCompletion function set_visible(value:Bool):Bool {
        if(objects != null) {
            var index:UInt = 0;
            var obj:T = null;

            while (index < length) {
                obj = objects[index++];
                
                if(obj != null) {
                    obj.visible = value;
                }
            }
        }

        return visible = value;
    }

    @:noCompletion function set_inScene(value:Bool):Bool {
        if(objects != null) {
            var index:UInt = 0;
            var obj:T = null;

            while (index < length) {
                obj = objects[index++];
                
                if(obj != null) {
                    obj.inScene = value;
                }
            }
        }

        return inScene = value;
    }

    @:noCompletion function set_size(value:UInt):UInt {
        if (size == 0 || objects == null || size >= length) {
			return size = value;
        }

        var i:Int = size;
		var l:Int = length;

        var obj:T = null;

        while (i < l) {
            obj = objects[i++];

            if (obj != null) {
                obj.clear();
                objects.remove(obj);
            }
        }

        length = objects.length;
        return size = value;
    }

    public function toString():String {
        return objects.toString();
    }
}