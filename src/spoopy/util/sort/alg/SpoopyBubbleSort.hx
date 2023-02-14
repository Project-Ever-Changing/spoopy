package spoopy.util.sort.alg;

class SpoopyBubbleSort implements SortingAlgorithm {
    public inline function sort<T>(array:Array<T>, f:T->T->Int):Array<T> {
        var n:Int = array.length;

        var temp:T;

        for(i in 0...n - 1) {
            for(j in 0...n - i - 1) {
                if(f(array[j], array[j + 1]) == 1) {
                    temp = array[j];
                    array[j] = array[j + 1];
                    array[j + 1] = temp;
                }
            }
        }

        return array;
    }
}