package spoopy.util.sort.alg;

class SpoopyInsertionSort implements SortingAlgorithm {
    public inline function sort<T>(array:Array<T>, f:T->T->Int):Array<T> {
        var n:Int = array.length;

        for(i in 1...n) {
            var key:T = array[i];
            var j = i - 1;

            while(j >= 0 && f(array[j], key) == 1) {
                array[j + 1] = array[j];
                j = j - 1;
            }

            array[j + 1] = key;
        }

        return array;
    }
}