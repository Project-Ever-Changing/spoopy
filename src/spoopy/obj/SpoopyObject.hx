package spoopy.obj;

/*
* The central interface that serves as the foundation for the implementation of other objects within the project. 
*/
interface SpoopyObject {

    /*
    * Delete information that could potentially cause memory leaks.
    * AFTER THIS METHOD IS CALLED THE OBJECT BECOMES UNUSEABLE!!
    */
    function destroy():Void;

    /*
    * Return a string name of the object.
    */
    function toString():String;
}