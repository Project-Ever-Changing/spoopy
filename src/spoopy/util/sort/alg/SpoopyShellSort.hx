package spoopy.util.sort.alg;

class SpoopyShellSort implements SortingAlgorithm {
    public inline function sort<T>(array:Array<T>, f:T->T->Int):Array<T> {
        var n:Int = array.length;
        var gap:Int = Std.int(n * 0.5);

        while(gap > 0) {
            for(i in gap...n) {
                var temp:T = array[i];
                var j:Int = i;

                while(j >= gap && f(array[j - gap], temp) == 1) {
                    array[j] = array[j - gap];
                    j -= gap;
                }

                array[j] = temp;
            }

            gap = Std.int(gap * 0.5);
        }

        return array;
    }
}