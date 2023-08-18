#pragma once

#include <type_traits>

namespace std { // Introduced in C++17
    enum class byte : unsigned char {};

    template <class IntegerType> constexpr IntegerType to_integer(byte b) noexcept { // Conversion to integer
        static_assert(is_integral<IntegerType>::value, "Only integral types are allowed.");
        return static_cast<IntegerType>(b);
    }

    template <class IntegerType> constexpr byte& operator<<=(byte& b, IntegerType shift) noexcept { // Bitwise left shift assignment
        return b = byte(static_cast<unsigned int>(b) << shift);
    }

    template <class IntegerType> constexpr byte& operator>>=(byte& b, IntegerType shift) noexcept { // Bitwise right shift assignment
        return b = byte(static_cast<unsigned int>(b) >> shift);
    }

    template <class IntegerType> constexpr byte operator<<(byte b, IntegerType shift) noexcept { // Bitwise left shift
        return byte(static_cast<unsigned int>(b) << shift);
    }

    template <class IntegerType> constexpr byte operator>>(byte b, IntegerType shift) noexcept { // Bitwise right shift
        return byte(static_cast<unsigned int>(b) >> shift);
    }

    template <class IntegerType> constexpr bool operator==(byte b, IntegerType i) noexcept { // Bitwise equal to
        return static_cast<unsigned int>(b) == i;
    }

    template <class IntegerType> constexpr bool operator!=(byte b, IntegerType i) noexcept { // Bitwise not equal to
        return static_cast<unsigned int>(b) != i;
    }

    template <class IntegerType> constexpr bool operator>(byte b, IntegerType i) noexcept { // Bitwise greater than
        return static_cast<unsigned int>(b) > i;
    }

    template <class IntegerType> constexpr bool operator<(byte b, IntegerType i) noexcept { // Bitwise less than
        return static_cast<unsigned int>(b) < i;
    }

    template <class IntegerType> constexpr bool operator>=(byte b, IntegerType i) noexcept { // Bitwise greater than or equal to
        return static_cast<unsigned int>(b) >= i;
    }

    template <class IntegerType> constexpr bool operator<=(byte b, IntegerType i) noexcept { // Bitwise less than or equal to
        return static_cast<unsigned int>(b) <= i;
    }

    constexpr byte& operator|=(byte& l, byte r) noexcept { // Bitwise OR assignment
        return l = byte(static_cast<unsigned int>(l) | static_cast<unsigned int>(r));
    }

    constexpr byte& operator&=(byte& l, byte r) noexcept { // Bitwise AND assignment
        return l = byte(static_cast<unsigned int>(l) & static_cast<unsigned int>(r));
    }

    constexpr byte& operator^=(byte& l, byte r) noexcept { // Bitwise XOR assignment
        return l = byte(static_cast<unsigned int>(l) ^ static_cast<unsigned int>(r));
    }

    constexpr byte operator|(byte l, byte r) noexcept { // Bitwise OR
        return byte(static_cast<unsigned int>(l) | static_cast<unsigned int>(r));
    }

    constexpr byte operator&(byte l, byte r) noexcept { // Bitwise AND
        return byte(static_cast<unsigned int>(l) & static_cast<unsigned int>(r));
    }

    constexpr byte operator^(byte l, byte r) noexcept { // Bitwise XOR
        return byte(static_cast<unsigned int>(l) ^ static_cast<unsigned int>(r));
    }

    constexpr byte operator~(byte b) noexcept { // Bitwise NOT
        return byte(~static_cast<unsigned int>(b));
    }

    constexpr bool operator==(byte l, byte r) noexcept { // Bitwise equal to
        return static_cast<unsigned int>(l) == static_cast<unsigned int>(r);
    }

    constexpr bool operator!=(byte l, byte r) noexcept { // Bitwise not equal to
        return static_cast<unsigned int>(l) != static_cast<unsigned int>(r);
    }

    constexpr bool operator<(byte l, byte r) noexcept { // Bitwise less than
        return static_cast<unsigned int>(l) < static_cast<unsigned int>(r);
    }

    constexpr bool operator>(byte l, byte r) noexcept { // Bitwise greater than
        return static_cast<unsigned int>(l) > static_cast<unsigned int>(r);
    }

    constexpr bool operator<=(byte l, byte r) noexcept { // Bitwise less than or equal to
        return static_cast<unsigned int>(l) <= static_cast<unsigned int>(r);
    }

    constexpr bool operator>=(byte l, byte r) noexcept { // Bitwise greater than or equal to
        return static_cast<unsigned int>(l) >= static_cast<unsigned int>(r);
    }
}