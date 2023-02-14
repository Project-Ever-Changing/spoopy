package spoopy.util;

import spoopy.util.sort.alg.*;

@:enum abstract SortBy(Int) {
    var ASCENDING = -1;
	var DESCENDING = 1;
}

class SpoopyArrayTools {
    public static function sortWith<T, A:SortingAlgorithm>(array:Array<T>, f:T->T->Int, algorithm:Class<A>):Array<T> {
        return (cast Type.createInstance(algorithm, [])).sort(array, f);
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