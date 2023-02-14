package spoopy.util.sort.alg;

class SpoopyHeapsSort implements SortingAlgorithm {
    public inline function sort<T>(array:Array<T>, f:T->T->Int):Array<T> {
        var n:Int = array.length;
        var i:Int = Std.int(n * 0.5 - 1);

        while(i >= 0) {
            heapify(array, f, n, i);
            i--;
        }

        i = n - 1;

        while(i >= 0) {
            var temp = array[0];
            array[0] = array[i];
            array[i] = temp;
            heapify(array, f, i, 0);

            i--;
        }

        return array;
    }

    private inline function heapify<T>(array:Array<T>, f:T->T->Int, n:Int, i:Int):Void {
        var largest:Int = i;

        var l:Int = 2 * i + 1;
        var r:Int = 2 * i + 2;

        if(l < n && f(array[l], array[largest]) == 1) {
            largest = l;
        }

        if(r < n && f(array[r], array[largest]) == 1) {
            largest = r;
        }

        if (largest != i) {
            var temp = array[i];
            array[i] = array[largest];
            array[largest] = temp;
            heapify(array, f, n, largest);
        }
    }
}