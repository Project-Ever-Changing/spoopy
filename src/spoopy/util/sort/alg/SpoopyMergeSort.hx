package spoopy.util.sort.alg;

class SpoopyMergeSort implements SortingAlgorithm {
    public inline function sort<T>(array:Array<T>, f:T->T->Int):Array<T> {
        if(array.length <= 1) {
            return array;
        }

        var mid:Int = Std.int(array.length * 0.5);
        var left:Array<T> = array.slice(0, mid);
        var right:Array<T> = array.slice(mid);

        left = sort(left, f);
        right = sort(right, f);

        return merge(left, right, f);
    }

    private inline function merge<T>(left:Array<T>, right:Array<T>, f:T->T->Int):Array<T> {
        var result:Array<T> = [];

        var leftIndex:UInt = 0;
        var rightIndex:UInt = 0;

        while (leftIndex < left.length && rightIndex < right.length) {
            if(f(left[leftIndex], right[rightIndex]) == -1) {
                result.push(left[leftIndex++]);
            }else {
                result.push(right[rightIndex++]);
            }
        }

        while(leftIndex < left.length) result.push(left[leftIndex++]);
        while(rightIndex < right.length) result.push(right[rightIndex++]);

        return result;
    }
}