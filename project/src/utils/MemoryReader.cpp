#include <utils/MemoryReader.h>

namespace lime { namespace spoopy {
    MemoryReader::MemoryReader():
        data(nullptr),
        position(nullptr),
        length(0) {}

    MemoryReader::MemoryReader(const std::byte* data, uint32_t length) {
        SetData(data, length);
    }

    MemoryReader::~MemoryReader() {
        Close();
    }

    void MemoryReader::Close() {
        data = nullptr;
        position = nullptr;
        length = 0;
    }

    void MemoryReader::SetData(const std::byte* data, uint32_t length) {
        this->data = data;
        this->position = data;
        this->length = length;
    }
}}