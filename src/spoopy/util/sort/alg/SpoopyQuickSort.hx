package spoopy.util.sort.alg;

class SpoopyQuickSort implements SortingAlgorithm {
    public inline function sort<T>(array:Array<T>, f:T->T->Int):Array<T> {
        quickSort(array, f, 0, array.length - 1);
        return array;
    }

    private inline function quickSort<T>(array:Array<T>, f:T->T->Int, low:Int, high:Int):Void {
        if(low < high) {
            var pivotIndex:Int = partition(array, f, low, high);

            quickSort(array, f, low, pivotIndex - 1);
            quickSort(array, f, pivotIndex + 1, high);
        }
    }

    private inline function partition<T>(array:Array<T>, f:T->T->Int, low:Int, high:Int):Int {
        var pivot:T = array[high];
        var i:Int = low - 1;

        for(j in low...high) {
            if(f(array[j], pivot) == -1) {
                i++;
                
                swap(array, i, j);
            }
        }

        swap(array, i + 1, high);
        return i + 1;
    }

    private inline function swap<T>(array:Array<T>, i:Int, j:Int):Void {
        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
}