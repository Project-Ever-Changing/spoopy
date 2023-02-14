package spoopy.math;

import spoopy.obj.geom.SpoopyPoint;

class SpoopyPointMath {

    /*
    * Add two points with eachother.
    * @return solution
    */
    public inline static function add(p1:SpoopyPoint, p2:SpoopyPoint):SpoopyPoint {
        return new SpoopyPoint(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z);
    }

    /*
    * Subtract two points with eachother.
    * @return solution
    */
    public inline static function subtract(p1:SpoopyPoint, p2:SpoopyPoint):SpoopyPoint {
        return new SpoopyPoint(p1.x - p2.x, p1.y - p2.y, p1.z - p2.z);
    }

    /*
    * Multiply two points with eachother.
    * @return solution
    */
    public inline static function multiply(p1:SpoopyPoint, p2:SpoopyPoint):SpoopyPoint {
        return new SpoopyPoint(p1.x * p2.x, p1.y * p2.y, p1.z * p2.z);
    }

    /*
    * Divide two points with eachother.
    * @return solution
    */
    public inline static function divide(p1:SpoopyPoint, p2:SpoopyPoint):SpoopyPoint {
        return new SpoopyPoint(p1.x / p2.x, p1.y / p2.y, p1.z / p2.z);
    }

    /*
    * Cross two points with eachother.
    * @return solution
    */
    public inline static function cross(p1:SpoopyPoint, p2:SpoopyPoint):SpoopyPoint {
        return new SpoopyPoint(p1.y * p2.z - p1.z * p2.y, p1.z * p2.x - p1.x * p2.z, p1.x * p2.y - p1.y * p2.x);
    }

    /*
    * Determine if two points have equal coordinates.
    * @return if equals
    */
    public inline static function equals(p1:SpoopyPoint, p2:SpoopyPoint):Bool {
        return p1.x == p2.x && p1.y == p2.y && p1.z == p2.z;
    }

    /*
    * Determine the dot product of two points.
    * @return dot produce.
    */
    public inline static function dot(p1:SpoopyPoint, p2:SpoopyPoint):Float {
		return p1.x * p2.x + p1.y * p2.y + p1.z * p2.z;
	}

    /*
    * Determine the length of two points.
    * @return length
    */
    public inline static function length(p1:SpoopyPoint, p2:SpoopyPoint):Float {
        return Math.sqrt(p1.x * p2.x + p1.y * p2.y + p1.z * p2.z);
    }
}