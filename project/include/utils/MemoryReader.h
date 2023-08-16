#pragma once

#include <system/CFFI.h>
#include <spoopy.h>

namespace lime { namespace spoopy {
    class MemoryReader {
        private:
            const std::byte* data;
            const std::byte* position;
            uint32_t length;

        public:
            MemoryReader();
            MemoryReader(const std::byte* data, uint32_t length);
            MemoryReader(value readStream);
            ~MemoryReader();

            void SetData(const std::byte* data, uint32_t length);
            void Close();
    };
}}