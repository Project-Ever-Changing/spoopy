#define VMA_IMPLEMENTATION

// Check if the compiler is Clang
#ifdef __clang__

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"

#endif

#include "vk_mem_alloc.h"

// Revert the diagnostic state only if Clang is being used
#ifdef __clang__

#pragma clang diagnostic pop

#endif