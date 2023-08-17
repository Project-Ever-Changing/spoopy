#pragma once

#include <system/CFFI.h>
#include <spoopy.h>

namespace lime { namespace spoopy {
    struct MemoryReader {
        MemoryReader();
        MemoryReader(const std::byte* data, uint32_t length);
        MemoryReader(value readStream);
        ~MemoryReader();

        void SetData(const std::byte* data, uint32_t length);
        void Close();

        const std::byte* data;
        const std::byte* position;
        uint32_t length;
    };
}}