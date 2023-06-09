#pragma once

#include <cstdint>

namespace lime { namespace spoopy {
    template<typename T> struct Vector2T {
        T x;
        T y;

        Vector2T(const T &value): x(value), y(value) {}
        Vector2T(const T &x, const T &y): x(x), y(y) {}
        Vector2T(Vector2T<T> &vector): x(vector.x), y(vector.y) {}

        void SetTo(const T &x, const T &y) {
            this -> x = x;
            this -> y = y;
        }
    };

    typedef Vector2T<int8_t> Vector2T_8;
    typedef Vector2T<uint8_t> Vector2T_u8;

    typedef Vector2T<int16_t> Vector2T_16;
    typedef Vector2T<uint16_t> Vector2T_u16;

    typedef Vector2T<int32_t> Vector2T_32;
    typedef Vector2T<uint32_t> Vector2T_u32;
}}