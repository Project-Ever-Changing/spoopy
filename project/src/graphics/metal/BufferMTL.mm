#include "BufferMTL.h"

namespace lime {
    BufferMTL::BufferMTL(value device, size_t size, size_t bucketSize, BufferType type, BufferUsage usage)
            : Buffer(device, size, bucketSize, type, usage)
    {
        id<MTLDevice> mtlDevice = (id<MTLDevice>)val_data(device);

        if(DYNAMIC == usage) {
            NSMutableArray *mutableDynamicDataBuffers = [NSMutableArray arrayWithCapacity:bucketSize];

            for(int i = 0; i < bucketSize; i++) {
                id <MTLBuffer> dynamicDataBuffer = [mtlDevice newBufferWithLength:size options:storageMode];
                [mutableDynamicDataBuffers addObject:dynamicDataBuffer];
            }

            _dynamicDataBuffers = [mutableDynamicDataBuffers copy];

            _mtlBuffer = _dynamicDataBuffers[0];
        }else {
            _mtlBuffer = [mtlDevice newBufferWithLength:size options:storageMode];
        }
    }

    void BufferMTL::updateData(void* data, size_t size) {
        memcpy((uint8_t*)_mtlBuffer.contents, data, size);
        updateIndex();
    }

    void BufferMTL::updateSubData(void* data, size_t offset, size_t size) {
        memcpy((uint8_t*)_mtlBuffer.contents + offset, data, size);
        updateIndex();
    }

    void BufferMTL::beginFrame() {
        _indexUpdated = false;
    }

    void BufferMTL::updateIndex() {
        if (DYNAMIC == _usage && !_indexUpdated) {
            _currentFrameIndex = (_currentFrameIndex + 1) % _bucketSize;
            _mtlBuffer = _dynamicDataBuffers[_currentFrameIndex];
            _indexUpdated = true;
        }
    }

    id<MTLBuffer> BufferMTL::getMTLBuffer() const {
        return _mtlBuffer;
    }

    BufferMTL::~BufferMTL() {
        if(DYNAMIC == _usage) {
            for(id<MTLBuffer> buffer in _dynamicDataBuffers) {
                [buffer release];
            }

            [_dynamicDataBuffers release];
        }else {
            [_mtlBuffer release];
        }
    }

    Buffer* createBuffer(value device, int size, int bucketSize, int type, int usage) {
        return new BufferMTL(device, (size_t)size, (size_t)bucketSize, (BufferType)type, (BufferUsage)usage);
    }
}