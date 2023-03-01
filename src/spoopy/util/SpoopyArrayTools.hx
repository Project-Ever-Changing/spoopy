package spoopy.util;

import lime.utils.Float32Array;
import lime.utils.Float64Array;

import spoopy.util.SpoopyFloatBuffer;
import spoopy.util.sort.alg.*;

@:enum abstract SortBy(Int) {
    var ASCENDING = -1;
	var DESCENDING = 1;
}

class SpoopyArrayTools {
    public static function sortWith<T, A:SortingAlgorithm>(array:Array<T>, f:T->T->Int, algorithm:Class<A>):Array<T> {
        return (cast Type.createInstance(algorithm, [])).sort(array, f);
    }

    public static function equals<T>(a1:Array<T>, a2:Array<T>):Bool {
        if (a1.length != a2.length) {
            return false;
        }

        for (i in 0...a1.length) {
            if (a1[i] != a2[i]) {
                return false;
            }
        }

        return true;
    }

    public static function equalsLarge<T>(a1:Array<T>, a2:Array<T>):Bool {
        if (a1.length != a2.length) {
            return false;
        }

        var length = a1.length;
        var half = Std.int(length * 0.5);

        for(i in 0...half) {
            var j = a1.length - i;

            if (a1[i] != a2[i] || a1[j] != a2[j]) {
                return false;
            }
        }

        return true;
    }

    public static inline function byValues(sort:Int, a:Float, b:Float):Int {
        var result:Int = 0;

        if(a < b) {
            result = sort;
        }else if(a > b) {
            result = -sort;
        }

        return result;
    } 
}