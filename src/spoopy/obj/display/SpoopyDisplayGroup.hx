package spoopy.obj.display;

import spoopy.obj.display.SpoopyDisplayObject;
import spoopy.util.sort.alg.SortingAlgorithm;

import lime.utils.Log;

class SpoopyDisplayGroup<T:SpoopyDisplayObject> implements SpoopyDisplayObject<T> {
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

    public function new(size:UInt = 0) {
        this.size = size;

        objects = [];
    }

    public function clear():Void {
        if(members != null) {
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
        if(members != null) {
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
        if(members != null) {
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
        if(Object == null) {
            Log.warn("Cannot add `null` object.");
            return;
        }

        if(objects.indexOf(obj) >= 0) {
            return;
        }

        var index:UInt = getFirstEmpty();

        if (index != -1) {
            members[index] = Object;

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
        if(Object == null) {
            Log.warn("Cannot add `null` object.");
            return;
        }

        if(objects.indexOf(obj) >= 0) {
            return;
        }

        if(position < length && objects[index] == null) {
            objects[index] = obj;
            return;
        }

        if(size > 0 && length >= size) {
            return;
        }

        objects.insert(obj);
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
}