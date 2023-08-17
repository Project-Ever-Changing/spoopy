#pragma once

#include <system/CFFI.h>
#include <spoopy_assert.h>
#include <spoopy.h>

namespace lime { namespace spoopy {
    struct MemoryReader {
        MemoryReader();
        MemoryReader(const std::byte* data, uint32_t length);
        MemoryReader(value readStream);
        ~MemoryReader();

        void SetData(const std::byte* data, uint32_t length);
        void ReadBytes(std::byte* buffer, uint32_t bytes);
        void Close();

        uint32_t GetPosition() const;

        const std::byte* data;
        const std::byte* position;
        uint32_t length;
    };
}}