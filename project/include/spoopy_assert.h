#pragma once

#include <iostream>
#include <cstdlib>

#if defined(DISABLED_ASSERT)
#define SP_ASSERT(expr) ((void)0)
#else
#define SP_ASSERT(expr) \
    if (!(expr)) { \
        std::cerr << "Assertion failed: " << #expr \
                  << ", file " << __FILE__ \
                  << ", line " << __LINE__ << std::endl; \
        std::abort(); \
    }

#endif