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

    uint32_t MemoryReader::GetPosition() const {
        return static_cast<uint32_t>(position - data);
    }

    void MemoryReader::ReadBytes(std::byte* buffer, uint32_t bytes) {
        if(bytes > 0) {
            SP_ASSERT(buffer && length - GetPosition() >= bytes);
            memcpy(buffer, position, static_cast<size_t>(bytes));
            position += bytes;
        }
    }
}}