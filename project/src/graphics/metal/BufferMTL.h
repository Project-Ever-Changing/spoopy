#pragma once

#include <graphics/Buffer.h>
#import <Metal/Metal.h>

namespace lime {
    static MTLStorageMode storageMode = MTLResourceStorageModeShared;

    enum METAL_RESOURCE_STORAGE_MODE {
        METAL_STORAGE_SHARED = 0x00000000,
        METAL_STORAGE_GPU_ONLY = 0x00000002,
        METAL_STORAGE_MANAGED = 0x00000004
    };

    class BufferMTL: public Buffer {
        public:
            BufferMTL(value device, size_t size, size_t bucketSize, BufferType type, BufferUsage usage);
            ~BufferMTL();

            virtual void updateData(void* data, size_t size);
            virtual void updateSubData(void* data, size_t offset, size_t size);
            virtual void usingDefaultStoredData(bool needDefaultStoredData) {};

            virtual void beginFrame();

            id<MTLBuffer> getMTLBuffer() const;
        private:
            void updateIndex();

            id<MTLBuffer> _mtlBuffer;
            NSMutableArray* _dynamicDataBuffers;
            int _currentFrameIndex;
            bool _indexUpdated;
    };
}