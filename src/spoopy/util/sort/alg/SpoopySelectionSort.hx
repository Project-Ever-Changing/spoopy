package spoopy.util.sort.alg;

class SpoopySelectionSort implements SortingAlgorithm {
    public inline function sort<T>(array:Array<T>, f:T->T->Int):Array<T> {
        var n:Int = array.length;

        for(i in 0...n-1) {
            var minIndex:Int = i;

            for(j in i+1...n-1) {
                if(f(array[j], array[minIndex]) == -1) {
                    minIndex = j;
                }
            }

            var temp = array[minIndex];
            array[minIndex] = array[i];
            array[i] = temp;
        }

        return array;
    }
}