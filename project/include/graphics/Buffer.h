#pragma once

#include <system/CFFIPointer.h>

namespace lime {
    enum BufferType {
        VERTEX = 0x010,
        INDEX = 0x020,
        UNIFORM = 0x040
    };

    enum BufferUsage {
        STATIC = 0x0010,
        DYNAMIC = 0x0020
    };

    class Buffer {
        public:
            Buffer(value device, size_t size, size_t bucketSize, BufferType type, BufferUsage usage)
                    : _usage(usage)
                    , _type(type)
                    , _size(size)
                    , _bucketSize(bucketSize)
            {}

            virtual ~Buffer() {}

            virtual void updateData(void* data, size_t size) = 0;
            virtual void updateSubData(void* data, size_t offset, size_t size) = 0;
            virtual void beginFrame() = 0;

            size_t getSize() const {
                return _size;
            }
        protected:
            BufferUsage _usage;
            BufferType _type;
            size_t _bucketSize;
            size_t _size;
    };

    Buffer* createBuffer(value device, int size, int bucketSize, int type, int usage);
}