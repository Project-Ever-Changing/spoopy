#include <math/SpoopyPoint.h>

namespace lime { namespace spoopy {
    static int id_x;
    static int id_y;
    static int id_z;

    static bool init = false;

    SpoopyPoint::SpoopyPoint() {
        setTo(0, 0, 0);
    }

    SpoopyPoint::SpoopyPoint(double x, double y, double z) {
        setTo(x, y, z);
    }

    SpoopyPoint::SpoopyPoint(value point) {
        if(!init) {
            id_x = val_id("x");
			id_y = val_id("y");
            id_z = val_id("z");

            init = true;
        }

        x = val_number(val_field(point, id_x));
        y = val_number(val_field(point, id_y));
        z = val_number(val_field(point, id_z));
    }

    void SpoopyPoint::setTo(double x, double y, double z) {
        this -> x = x;
        this -> y = y;
        this -> z = z;
    }

    std::array<double, 3> SpoopyPoint::toArray() const {
        return {this -> x, this -> y, this -> z};
    }
}}