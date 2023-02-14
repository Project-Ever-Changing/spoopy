package spoopy.util.sort.alg;

interface SortingAlgorithm {

    /*
    * Method of sorting being used.
    */
    function sort<T>(array:Array<T>, f:T->T->Int):Array<T>;
}