#pragma once

#if defined(HXCPP_ARM64) || defined(HXCPP_M64)
typedef unsigned long SP_UInt;
typedef long SP_Int;
#else
typedef unsigned int SP_UInt;
typedef int SP_Int;
#endif