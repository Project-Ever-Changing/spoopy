#pragma once

#include <system/CFFI.h>

#include <array>

namespace lime { namespace spoopy {
    struct SpoopyPoint {
        double x;
        double y;
        double z;

        SpoopyPoint();
        SpoopyPoint(double x, double y, double z);
        SpoopyPoint(value point);

        void setTo(double x, double y, double z);

        std::array<double, 3> toArray() const;
    };
}}